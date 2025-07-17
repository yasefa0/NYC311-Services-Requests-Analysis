CREATE TABLE staging_311_requests (
    unique_key BIGINT,
    created_date TIMESTAMP,
    closed_date TIMESTAMP,
    agency VARCHAR(20),
    agency_name VARCHAR(100),
    complaint_type VARCHAR(100),
    descriptor VARCHAR(100),
    location_type VARCHAR(100),
    incident_zip VARCHAR(10),
    borough VARCHAR(50),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    location VARCHAR(200)
);
