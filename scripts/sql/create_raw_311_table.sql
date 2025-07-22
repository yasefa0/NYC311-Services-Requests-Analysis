-- Create raw_311 table in Amazon Redshift
-- Author: Yared Asefa
-- Date: 2025-07-22
-- Description:
--   Defines the schema for raw NYC 311 service request data loaded from S3.
--   This is the initial staging table used for further transformation into
--   dimensional and fact tables during the ETL process.
CREATE TABLE raw_311 (
    unique_key BIGINT,
    created_date TIMESTAMP,
    closed_date TIMESTAMP,
    agency VARCHAR(100),
    agency_name VARCHAR(255),
    complaint_type VARCHAR(255),
    descriptor VARCHAR(255),
    status VARCHAR(50),
    resolution_description VARCHAR(500),
    borough VARCHAR(50),
    city VARCHAR(100),
    community_board VARCHAR(100),
    incident_zip VARCHAR(50),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    location_type VARCHAR(100),
    address_type VARCHAR(50)
);