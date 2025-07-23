-- COPY NYC311 2025H1 records into Redshift raw_311 table
-- Author: Yared Asefa
-- Date: 2025-07-22
-- Description: Loads CSV data from S3 using IAM role and proper formatting
COPY raw_311
FROM 's3://nyc311-bi-project-data/raw/311_service_requests/year=2025/nyc311_2025H1_all.csv'
IAM_ROLE 'arn:aws:iam::980921732933:role/nyc311-redshift-role'
FORMAT AS CSV
IGNOREHEADER 1
TIMEFORMAT 'auto'
REGION 'us-west-2'
QUOTE '"'
DELIMITER ','
TRUNCATECOLUMNS
BLANKSASNULL
EMPTYASNULL
MAXERROR 100;