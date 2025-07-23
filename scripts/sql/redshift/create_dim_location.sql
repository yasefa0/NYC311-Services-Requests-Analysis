-- Create and populate dim_location
CREATE TABLE IF NOT EXISTS dim_location (
    location_key INT IDENTITY(1,1),
    borough VARCHAR(50),
    city VARCHAR(100),
    incident_zip VARCHAR(50),
    community_board VARCHAR(100),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    PRIMARY KEY(location_key)
);

INSERT INTO dim_location (borough, city, incident_zip, community_board, latitude, longitude)
SELECT DISTINCT
    borough, city, incident_zip, community_board, latitude, longitude
FROM vw_raw_311_deduped
WHERE latitude IS NOT NULL AND longitude IS NOT NULL;
