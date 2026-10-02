-- Cyclistic Analysis Preparation
-- September 2025
-- Adds date/time variables needed for behavioral analysis

CREATE TABLE
  `capstone-project-509409.cyclistic_tripdata_analysis.2025_09_analysis` AS

SELECT
  *,
  
  EXTRACT(MONTH FROM TIMESTAMP(started_at)) AS month,

  FORMAT_DATE(
    '%B',
    DATE(TIMESTAMP(started_at))
  ) AS month_name,

  EXTRACT(DAYOFWEEK FROM TIMESTAMP(started_at)) AS day_of_week_num,

  FORMAT_DATE(
    '%A',
    DATE(TIMESTAMP(started_at))
  ) AS day_of_week,

  EXTRACT(HOUR FROM TIMESTAMP(started_at)) AS hour,

  CASE
    WHEN EXTRACT(DAYOFWEEK FROM TIMESTAMP(started_at)) IN (1, 7)
      THEN 'Weekend'
    ELSE 'Weekday'
  END AS weekday_weekend

FROM
  `capstone-project-509409.cyclistic_tripdata_cleaned.2025_09_clean`;

-- Got all the variables needed for analysis
-- Performed same steps with every months data
-- Combined all 12 months of Cyclistic analysis-ready data
-- Study period: September 2025 - August 2026

CREATE TABLE
  `capstone-project-509409.cyclistic_tripdata_combined.cyclistic_12_month_analysis` AS

SELECT * FROM
  `capstone-project-509409.cyclistic_tripdata_analysis.2025_09_analysis`

UNION ALL
SELECT * FROM
  `capstone-project-509409.cyclistic_tripdata_analysis.2025_10_analysis`

UNION ALL
SELECT * FROM
  `capstone-project-509409.cyclistic_tripdata_analysis.2025_11_analysis`

UNION ALL
SELECT * FROM
  `capstone-project-509409.cyclistic_tripdata_analysis.2025_12_analysis`

UNION ALL
SELECT * FROM
  `capstone-project-509409.cyclistic_tripdata_analysis.2026_01_analysis`

UNION ALL
SELECT * FROM
  `capstone-project-509409.cyclistic_tripdata_analysis.2026_02_analysis`

UNION ALL
SELECT * FROM
  `capstone-project-509409.cyclistic_tripdata_analysis.2026_03_analysis`

UNION ALL
SELECT * FROM
  `capstone-project-509409.cyclistic_tripdata_analysis.2026_04_analysis`

UNION ALL
SELECT * FROM
  `capstone-project-509409.cyclistic_tripdata_analysis.2026_05_analysis`

UNION ALL
SELECT * FROM
  `capstone-project-509409.cyclistic_tripdata_analysis.2026_06_analysis`

UNION ALL
SELECT * FROM
  `capstone-project-509409.cyclistic_tripdata_analysis.2026_07_analysis`

UNION ALL
SELECT * FROM
  `capstone-project-509409.cyclistic_tripdata_analysis.2026_08_analysis`;


-- Checking total rows in the final dataset created
SELECT COUNT(*) AS total_rows
FROM `capstone-project-509409.cyclistic_tripdata_combined.cyclistic_12_month_analysis`;


-- Final validation of the 12-month combined Cyclistic dataset

WITH combined AS (
  SELECT *
  FROM `capstone-project-509409.cyclistic_tripdata_combined.cyclistic_12_month_analysis`
)

SELECT
  -- Overall
  COUNT(*) AS total_rows,
  COUNT(DISTINCT ride_id) AS unique_ride_ids,

  -- Date range
  MIN(TIMESTAMP(started_at)) AS earliest_start,
  MAX(TIMESTAMP(started_at)) AS latest_start,

  -- Rider type
  COUNTIF(member_casual = 'member') AS member_rides,
  COUNTIF(member_casual = 'casual') AS casual_rides,

  -- Data quality
  COUNTIF(ride_id IS NULL) AS missing_ride_id,
  COUNTIF(started_at IS NULL) AS missing_started_at,
  COUNTIF(ended_at IS NULL) AS missing_ended_at,
  COUNTIF(member_casual IS NULL) AS missing_rider_type,

  -- Duration quality
  MIN(duration_seconds) AS minimum_duration_seconds,
  MAX(duration_seconds) AS maximum_duration_seconds,
  COUNTIF(duration_seconds <= 0) AS invalid_duration_rows,
  COUNTIF(duration_seconds > 86400) AS over_24_hour_rows
FROM combined;


SELECT
  month,
  month_name,
  COUNT(*) AS ride_count
FROM `capstone-project-509409.cyclistic_tripdata_combined.cyclistic_12_month_analysis`
GROUP BY month, month_name
ORDER BY
  CASE
    WHEN month >= 9 THEN month
    ELSE month + 12
  END;