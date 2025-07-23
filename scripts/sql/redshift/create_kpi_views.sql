/* ==========================================================
   KPI Views for NYC311 Star Schema
   Author : Yared Asefa
   Date   : 2025-07-23
   Description: Creates reusable views for BI KPIs
   ========================================================== */

-- 1. Total requests
CREATE OR REPLACE VIEW vw_kpi_total_requests AS
SELECT COUNT(*) AS total_requests
FROM fact_service_request;

-- 2. Average resolution time (closed only)
CREATE OR REPLACE VIEW vw_kpi_avg_resolution_days AS
SELECT ROUND(AVG(resolution_time_days), 2) AS avg_resolution_days
FROM fact_service_request
WHERE is_closed;

-- 3. Percent of requests still open
CREATE OR REPLACE VIEW vw_kpi_percent_open AS
SELECT ROUND(
    100.0 * SUM(CASE WHEN is_closed THEN 0 ELSE 1 END)::NUMERIC
    / COUNT(*),
    2
) AS pct_open
FROM fact_service_request;

-- 4. Top 10 complaint types
CREATE OR REPLACE VIEW vw_kpi_top10_complaints AS
SELECT dc.complaint_type,
       COUNT(*) AS total
FROM fact_service_request f
JOIN dim_complaint_type dc USING (complaint_type_key)
GROUP BY dc.complaint_type
ORDER BY total DESC
LIMIT 10;

-- 5. Avg resolution by borough
CREATE OR REPLACE VIEW vw_kpi_resolution_by_borough AS
SELECT dl.borough,
       ROUND(AVG(resolution_time_days), 2) AS avg_resolution_days
FROM fact_service_request f
JOIN dim_location dl USING (location_key)
WHERE is_closed
GROUP BY dl.borough
ORDER BY avg_resolution_days DESC;

-- 6. Requests per month
CREATE OR REPLACE VIEW vw_kpi_requests_per_month AS
SELECT dd.year,
       dd.month,
       COUNT(*) AS total_requests
FROM fact_service_request f
JOIN dim_date dd USING (date_key)
GROUP BY dd.year, dd.month
ORDER BY dd.year, dd.month;