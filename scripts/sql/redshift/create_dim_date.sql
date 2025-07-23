-- Create dim_date table
CREATE TABLE IF NOT EXISTS dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    year INT,
    month INT,
    day INT,
    weekday INT,
    month_name VARCHAR(20),
    day_name VARCHAR(20)
);
