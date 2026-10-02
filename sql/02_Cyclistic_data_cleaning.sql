-- Cleaning September 2025 Cyclistic data
-- Rules:
-- 1. Include rides that started during September 2025
-- 2. Exclude rides with duration <= 0 seconds
-- 3. Exclude rides longer than 24 hours
-- 4. Calculate ride duration in seconds and minutes


-- Creating cleaned table with two new columns duration_seconds and ride_length_min
CREATE TABLE
  `capstone-project-509409.cyclistic_tripdata_cleaned.2025_09_clean` As

WITH ride_data AS (
  SELECT
    *,
    
    TIMESTAMP_DIFF(
      TIMESTAMP(ended_at),
      TIMESTAMP(started_at),
      SECOND
    ) AS duration_seconds

  FROM `capstone-project-509409.Cyclistic_tripdata.2025_09`
)

SELECT
  *,
  
  duration_seconds / 60.0 AS ride_length_min

FROM ride_data

WHERE
  TIMESTAMP(started_at) >= TIMESTAMP('2025-09-01')
  AND TIMESTAMP(started_at) < TIMESTAMP('2025-10-01')
  AND duration_seconds > 0
  AND duration_seconds <= 86400;


-- Doing quality checks of newly cleaned table 
SELECT
  COUNT(*) AS cleaned_rows,
  MIN(TIMESTAMP(started_at)) AS earliest_start,
  MAX(TIMESTAMP(started_at)) AS latest_start,
  MIN(duration_seconds) AS minimum_duration_seconds,
  MAX(duration_seconds) AS maximum_duration_seconds,
  AVG(ride_length_min) AS average_ride_length_min
FROM `capstone-project-509409.cyclistic_tripdata_cleaned.2025_09_clean`;

SELECT
  member_casual,
  COUNT(*) AS ride_count
FROM `capstone-project-509409.cyclistic_tripdata_cleaned.2025_09_clean`
GROUP BY member_casual
ORDER BY ride_count DESC;

-- Table passed in quality checks
-- Performed same steps with every months data