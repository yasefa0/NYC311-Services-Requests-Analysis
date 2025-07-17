# NYC311 Business Intelligence Project

This project analyzes NYC 311 Service Request data using AWS tools to build a scalable BI pipeline.

## Project Goals
- ETL 2025 NYC311 data using AWS Glue
- Stage in Redshift with fact/dim schemas
- Build dashboards in QuickSight

## Data Sources
- NYC Open Data Portal: [311 Service Requests from 2010 to Present](https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2010-to-Present/erm2-nwe9)
- Data pulled via SODA API for: `2025-01-01` to `2025-06-30`  
- Raw files saved to:  
  `s3://nyc311-bi-project-data/raw/311_service_requests/year=2025/`

## Stack
- **ETL**: Python + AWS Glue
- **Warehouse**: Amazon Redshift
- **Dashboards**: Amazon QuickSight
- **Scripting**: Pandas, SQL

## Status
✅ Extracted & staged 1.7M 311 records for 2025  
🟡 Next: Define schema + load into Redshift  