-- NYC311 Redshift Data Exploration Queries
-- Author: Yared Asefa
-- Date: 2025-07-22
-- Description:
--   Initial data profiling of raw_311 table to assess quality, structure, and value distributions
--   Used to inform dimensional modeling and ETL strategy

------------------------------------------------------------
-- 1. Row & Column Summary
------------------------------------------------------------
-- Total row count
SELECT COUNT(*) AS total_rows FROM raw_311;

-- Distinct values
SELECT 
  COUNT(DISTINCT unique_key) AS distinct_keys,
  COUNT(DISTINCT complaint_type) AS distinct_complaints,
  COUNT(DISTINCT borough) AS distinct_boroughs
FROM raw_311;

------------------------------------------------------------
-- 2. Null Value Check
------------------------------------------------------------
SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN created_date IS NULL THEN 1 ELSE 0 END) AS null_created_date,
  SUM(CASE WHEN closed_date IS NULL THEN 1 ELSE 0 END) AS null_closed_date,
  SUM(CASE WHEN descriptor IS NULL THEN 1 ELSE 0 END) AS null_descriptor,
  SUM(CASE WHEN resolution_description IS NULL THEN 1 ELSE 0 END) AS null_resolution,
  SUM(CASE WHEN latitude IS NULL OR longitude IS NULL THEN 1 ELSE 0 END) AS null_location
FROM raw_311;

------------------------------------------------------------
-- 3. Top Complaint Types
------------------------------------------------------------
SELECT complaint_type, COUNT(*) AS total
FROM raw_311
GROUP BY complaint_type
ORDER BY total DESC
LIMIT 10;

------------------------------------------------------------
-- 4. Complaints by Borough
------------------------------------------------------------
SELECT borough, COUNT(*) AS total
FROM raw_311
GROUP BY borough
ORDER BY total DESC;

------------------------------------------------------------
-- 5. Monthly Complaint Distribution
------------------------------------------------------------
SELECT 
  DATE_TRUNC('month', created_date) AS month,
  COUNT(*) AS total
FROM raw_311
GROUP BY month
ORDER BY month;

------------------------------------------------------------
-- 6. Optional: Check for Duplicate unique_key
------------------------------------------------------------
SELECT unique_key, COUNT(*) 
FROM raw_311 
GROUP BY unique_key 
HAVING COUNT(*) > 1;