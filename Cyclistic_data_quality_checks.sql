-- CYCLISTIC DATA QUALITY CHECKS
-- Dataset: September 2025


-- 1. Inspecting sample records
SELECT *
FROM `capstone-project-509409.Cyclistic_tripdata.2025_09`
LIMIT 10;


-- 2. Checking total number of records
SELECT COUNT(*) AS total_rows
FROM `capstone-project-509409.Cyclistic_tripdata.2025_09`;


-- 3. Checking member vs casual riders
SELECT
  member_casual,
  COUNT(*) AS ride_count
FROM `capstone-project-509409.Cyclistic_tripdata.2025_09`
GROUP BY member_casual
ORDER BY ride_count DESC;


-- 4. Checking missing values
SELECT
  COUNT(*) AS total_rows,
  COUNT(ride_id) AS ride_id_present,
  COUNT(started_at) AS started_at_present,
  COUNT(ended_at) AS ended_at_present,
  COUNT(member_casual) AS rider_type_present
FROM `capstone-project-509409.Cyclistic_tripdata.2025_09`;


-- 5. checking if there is any duplicate ride_ids
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT ride_id) AS unique_ride_ids
FROM `capstone-project-509409.Cyclistic_tripdata.2025_09`;


-- 6. checking ride duration min, max and average
SELECT
  MIN(TIMESTAMP_DIFF(
    TIMESTAMP(ended_at),
    TIMESTAMP(started_at),
    MINUTE
  )) AS minimum_duration,
  
  MAX(TIMESTAMP_DIFF(
    TIMESTAMP(ended_at),
    TIMESTAMP(started_at),
    MINUTE
  )) AS maximum_duration,

  AVG(TIMESTAMP_DIFF(
    TIMESTAMP(ended_at),
    TIMESTAMP(started_at),
    MINUTE
  )) AS average_duration
FROM `capstone-project-509409.Cyclistic_tripdata.2025_09`;


-- 7. counting rides with abnormal duration
SELECT
  COUNTIF(
    TIMESTAMP_DIFF(
      TIMESTAMP(ended_at),
      TIMESTAMP(started_at),
      MINUTE
    ) <= 0
  ) AS zero_or_negative_duration,

  COUNTIF(
    TIMESTAMP_DIFF(
      TIMESTAMP(ended_at),
      TIMESTAMP(started_at),
      MINUTE
    ) > 1440
  ) AS over_24_hours
FROM `capstone-project-509409.Cyclistic_tripdata.2025_09`;


-- 8. Checking ride duration at second-level precision
-- Purpose: distinguish true zero-duration rides from rides shorter than one minute.
SELECT
  COUNTIF(
    TIMESTAMP_DIFF(
      TIMESTAMP(ended_at),
      TIMESTAMP(started_at),
      SECOND
    ) < 0
  ) AS negative_duration,

  COUNTIF(
    TIMESTAMP_DIFF(
      TIMESTAMP(ended_at),
      TIMESTAMP(started_at),
      SECOND
    ) = 0
  ) AS exactly_zero_seconds,

  COUNTIF(
    TIMESTAMP_DIFF(
      TIMESTAMP(ended_at),
      TIMESTAMP(started_at),
      SECOND
    ) BETWEEN 1 AND 59
  ) AS under_one_minute,

  COUNTIF(
    TIMESTAMP_DIFF(
      TIMESTAMP(ended_at),
      TIMESTAMP(started_at),
      SECOND
    ) BETWEEN 60 AND 599
  ) AS one_to_ten_minutes
FROM `capstone-project-509409.Cyclistic_tripdata.2025_09`;


-- 9. Investigating rides exceeding 24 hours
-- Purpose: identify unusually long rides before deciding whether they should be excluded from analysis.
SELECT
  COUNT(*) AS rides_over_24_hours,
  MIN(
    TIMESTAMP_DIFF(
      TIMESTAMP(ended_at),
      TIMESTAMP(started_at),
      MINUTE
    )
  ) AS minimum_over_24_hours,
  MAX(
    TIMESTAMP_DIFF(
      TIMESTAMP(ended_at),
      TIMESTAMP(started_at),
      MINUTE
    )
  ) AS maximum_duration
FROM `capstone-project-509409.Cyclistic_tripdata.2025_09`
WHERE TIMESTAMP_DIFF(
        TIMESTAMP(ended_at),
        TIMESTAMP(started_at),
        MINUTE
      ) > 1440;

SELECT
  ride_id,
  started_at,
  ended_at,
  TIMESTAMP_DIFF(
    TIMESTAMP(ended_at),
    TIMESTAMP(started_at),
    MINUTE
  ) AS ride_duration_min,
  member_casual,
  rideable_type
FROM `capstone-project-509409.Cyclistic_tripdata.2025_09`
WHERE TIMESTAMP_DIFF(
        TIMESTAMP(ended_at),
        TIMESTAMP(started_at),
        MINUTE
      ) > 1440
ORDER BY ride_duration_min DESC
LIMIT 20;


-- 10. checking dates
SELECT
  MIN(TIMESTAMP(started_at)) AS earliest_start,
  MAX(TIMESTAMP(started_at)) AS latest_start,
  MIN(TIMESTAMP(ended_at)) AS earliest_end,
  MAX(TIMESTAMP(ended_at)) AS latest_end
FROM `capstone-project-509409.Cyclistic_tripdata.2025_09`;


-- 11. investigating rides started on 30 august
SELECT
  ride_id,
  started_at,
  ended_at,
  TIMESTAMP_DIFF(
    TIMESTAMP(ended_at),
    TIMESTAMP(started_at),
    MINUTE
  ) AS ride_duration_min,
  member_casual,
  rideable_type
FROM `capstone-project-509409.Cyclistic_tripdata.2025_09`
WHERE TIMESTAMP(started_at) < TIMESTAMP('2025-09-01')
ORDER BY started_at;


-- 12. checking for october ending rides
SELECT
  COUNT(*) AS rides_ending_after_september
FROM `capstone-project-509409.Cyclistic_tripdata.2025_09`
WHERE TIMESTAMP(ended_at) >= TIMESTAMP('2025-10-01');


-- 13. checking station data and coordinates
SELECT
  COUNT(*) AS total_rows,

  COUNT(start_station_name) AS start_station_name_present,
  COUNT(end_station_name) AS end_station_name_present,

  COUNT(start_station_id) AS start_station_id_present,
  COUNT(end_station_id) AS end_station_id_present,

  COUNT(start_lat) AS start_lat_present,
  COUNT(start_lng) AS start_lng_present,
  COUNT(end_lat) AS end_lat_present,
  COUNT(end_lng) AS end_lng_present
FROM `capstone-project-509409.Cyclistic_tripdata.2025_09`;


-- 14. Checking for impossible coordinates
SELECT
  MIN(start_lat) AS min_start_lat,
  MAX(start_lat) AS max_start_lat,
  MIN(start_lng) AS min_start_lng,
  MAX(start_lng) AS max_start_lng,
  MIN(end_lat) AS min_end_lat,
  MAX(end_lat) AS max_end_lat,
  MIN(end_lng) AS min_end_lng,
  MAX(end_lng) AS max_end_lng
FROM `capstone-project-509409.Cyclistic_tripdata.2025_09`;

-- After doing data quality checks and after investigating anomalies
-- I concluded that we need to clean data by:
-- removing ride durations < 0 seconds and durations > 24 hours
-- removing started_at before 1st september and after 30th september