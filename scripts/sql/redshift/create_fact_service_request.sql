-- Create and populate fact_service_request
CREATE TABLE IF NOT EXISTS fact_service_request (
    request_id BIGINT PRIMARY KEY,
    date_key INT,
    location_key INT,
    complaint_type_key INT,
    status VARCHAR(50),
    resolution_time_days FLOAT,
    has_location BOOLEAN,
    is_closed BOOLEAN,
    FOREIGN KEY(date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY(location_key) REFERENCES dim_location(location_key),
    FOREIGN KEY(complaint_type_key) REFERENCES dim_complaint_type(complaint_type_key)
);

INSERT INTO fact_service_request (
    request_id,
    date_key,
    location_key,
    complaint_type_key,
    status,
    resolution_time_days,
    has_location,
    is_closed
)
SELECT
    r.unique_key AS request_id,
    TO_NUMBER(TO_CHAR(r.created_date, 'YYYYMMDD'), '99999999') AS date_key,
    dl.location_key,
    dc.complaint_type_key,
    r.status,
    DATEDIFF(day, r.created_date, r.closed_date) AS resolution_time_days,
    CASE WHEN r.latitude IS NOT NULL AND r.longitude IS NOT NULL THEN TRUE ELSE FALSE END AS has_location,
    CASE WHEN r.closed_date IS NOT NULL THEN TRUE ELSE FALSE END AS is_closed
FROM vw_raw_311_deduped r
JOIN dim_location dl
  ON r.borough = dl.borough AND r.city = dl.city AND r.incident_zip = dl.incident_zip
     AND r.community_board = dl.community_board AND r.latitude = dl.latitude AND r.longitude = dl.longitude
JOIN dim_complaint_type dc
  ON r.complaint_type = dc.complaint_type AND r.descriptor = dc.descriptor
     AND r.agency = dc.agency AND r.agency_name = dc.agency_name;
