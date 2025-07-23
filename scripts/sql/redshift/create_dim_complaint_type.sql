-- Create and populate dim_complaint_type
CREATE TABLE IF NOT EXISTS dim_complaint_type (
    complaint_type_key INT IDENTITY(1,1),
    complaint_type VARCHAR(255),
    descriptor VARCHAR(255),
    agency VARCHAR(100),
    agency_name VARCHAR(255),
    PRIMARY KEY(complaint_type_key)
);

INSERT INTO dim_complaint_type (complaint_type, descriptor, agency, agency_name)
SELECT DISTINCT
    complaint_type, descriptor, agency, agency_name
FROM vw_raw_311_deduped
WHERE complaint_type IS NOT NULL;
