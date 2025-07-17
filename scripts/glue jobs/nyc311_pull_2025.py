import os
import time
import pandas as pd
from sodapy import Socrata

# ─────────────────────────────────────────────
#  CONFIG
# ─────────────────────────────────────────────
DATA_ENDPOINT = "data.cityofnewyork.us"
DATASET_ID   = "erm2-nwe9"
APP_TOKEN    = "uFT6pQQ6MZD9lZALp7ftcpzih"           # ⇒ put your SODA App Token here

# Date range – Jan 1 → Jun 30 2025 (inclusive)
START_DATE = "2025-01-01T00:00:00"
END_DATE   = "2025-06-30T23:59:59"
soql_where = f"created_date between '{START_DATE}' and '{END_DATE}'"

# Essential columns (BI-ready slice)
COLUMNS_NEEDED = [
    "unique_key", "created_date", "closed_date",
    "agency", "agency_name",
    "complaint_type", "descriptor", "status",
    "resolution_description",
    "borough", "city", "community_board", "incident_zip",
    "latitude", "longitude",
    "location_type", "address_type"
]

# Socrata client
client = Socrata(DATA_ENDPOINT, APP_TOKEN, timeout=60)

# Batch parameters
BATCH_SIZE = 100_000
SELECT_CLAUSE = ",".join(COLUMNS_NEEDED)

# ─────────────────────────────────────────────
#  HELPERS
# ─────────────────────────────────────────────
def fetch_batch(offset: int, limit: int, max_retries=3) -> pd.DataFrame:
    """Fetch a batch with retry support."""
    attempt = 0
    while attempt < max_retries:
        try:
            results = client.get(
                DATASET_ID,
                select=SELECT_CLAUSE,
                where=soql_where,
                limit=limit,
                offset=offset
            )
            return pd.DataFrame.from_records(results)
        except Exception as e:
            attempt += 1
            print(f"⚠️ Retry {attempt}/{max_retries} after error: {e}")
            time.sleep(3)

    raise Exception(f"❌ Failed after {max_retries} retries at offset {offset}.")

# ─────────────────────────────────────────────
#  MAIN
# ─────────────────────────────────────────────
def main():
    # Row count for this date slice
    count_res = client.get(DATASET_ID, select="COUNT(*)", where=soql_where)
    total_rows = int(count_res[0]["COUNT"]) if count_res else 0
    print(f"Total rows to fetch: {total_rows:,}")

    if total_rows == 0:
        print("No records found for the given date range.")
        return

    # Fetch paged CSVs
    for offset in range(0, total_rows, BATCH_SIZE):
        batch_no  = offset // BATCH_SIZE + 1
        filename  = f"nyc311_2025H1_{offset}_{offset + BATCH_SIZE - 1}.csv"

        if os.path.exists(filename):
            print(f"[skip] {filename} already exists.")
            continue

        print(f"[{batch_no}] Pulling rows {offset}–{offset + BATCH_SIZE - 1} …")
        df = fetch_batch(offset, BATCH_SIZE)

        if not df.empty:
            df.to_csv(filename, index=False)
            print(f"    → saved {len(df):,} rows to {filename}")
        else:
            print("    (no data returned)")
        time.sleep(1)                      # gentle-sleep to respect rate limits

    # Combine all batch CSVs
    print("\nCombining batches …")
    files = [
        f for f in os.listdir(".")
        if f.startswith("nyc311_2025H1_") and f.endswith(".csv")
    ]
    files.sort(key=lambda x: int(x.split("_")[2]))   # sort by offset

    if not files:
        print("No batch files found. Exiting.")
        return

    df_all = pd.concat((pd.read_csv(f) for f in files), ignore_index=True)
    df_all.to_csv("nyc311_2025H1_all.csv", index=False)
    print(f"✅ Combined {len(files)} files → {len(df_all):,} total rows.")
    print(f"   Output: {os.path.abspath('nyc311_2025H1_all.csv')}")

if __name__ == "__main__":
    main()
