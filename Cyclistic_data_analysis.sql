-- Cyclistic Data Analysis
-- Study Period: Sep 2025 - Aug 2026

-- Analysis 1 — Member vs Casual overall usage
SELECT
  member_casual,
  COUNT(*) AS ride_count,
  ROUND(
    COUNT(*) * 100.0 /
    SUM(COUNT(*)) OVER (),
    2
  ) AS ride_percentage
FROM
  `capstone-project-509409.cyclistic_tripdata_combined.cyclistic_12_month_analysis`
GROUP BY
  member_casual
ORDER BY
  ride_count DESC;
-- Conclusion: Members account for almost two-thirds of all rides, while casual riders account for about one-third.


-- Analysis 2 — Average and median ride length
SELECT
  member_casual,
  COUNT(*) AS ride_count,
  ROUND(AVG(ride_length_min), 2) AS average_ride_length_min,
  ROUND(APPROX_QUANTILES(ride_length_min, 100)[OFFSET(50)], 2) AS median_ride_length_min
FROM
  `capstone-project-509409.cyclistic_tripdata_combined.cyclistic_12_month_analysis`
GROUP BY
  member_casual
ORDER BY
  member_casual;
-- Conclusion: Casual average ride is about 49% longer than member average and same type of pattern median shows.


-- Analysis 3 — Weekday vs Weekend
SELECT
  member_casual,
  weekday_weekend,
  COUNT(*) AS ride_count,
  ROUND(
    COUNT(*) * 100.0 /
    SUM(COUNT(*)) OVER (PARTITION BY member_casual),
    2
  ) AS percentage
FROM
  `capstone-project-509409.cyclistic_tripdata_combined.cyclistic_12_month_analysis`
GROUP BY
  member_casual,
  weekday_weekend
ORDER BY
  member_casual,
  weekday_weekend;
-- Conclusion: Casual riders have relatively more weekend usage — 37.25%.


-- Analysis 4 — Which days of the week?
SELECT
  member_casual,
  day_of_week,
  COUNT(*) AS ride_count,
  ROUND(
    COUNT(*) * 100.0 /
    SUM(COUNT(*)) OVER (PARTITION BY member_casual),
    2
  ) AS percentage
FROM
  `capstone-project-509409.cyclistic_tripdata_combined.cyclistic_12_month_analysis`
GROUP BY
  member_casual,
  day_of_week
ORDER BY
  member_casual,
  CASE day_of_week
    WHEN 'Sunday' THEN 1
    WHEN 'Monday' THEN 2
    WHEN 'Tuesday' THEN 3
    WHEN 'Wednesday' THEN 4
    WHEN 'Thursday' THEN 5
    WHEN 'Friday' THEN 6
    WHEN 'Saturday' THEN 7
  END;
-- Conclusion: casual riders have a stronger weekend pattern, while member rides are distributed more heavily across the middle of the working week.


-- Analysis 5 — Hourly usage
SELECT
  member_casual,
  hour,
  COUNT(*) AS ride_count,
  ROUND(
    COUNT(*) * 100.0 /
    SUM(COUNT(*)) OVER (PARTITION BY member_casual),
    2
  ) AS percentage
FROM
  `capstone-project-509409.cyclistic_tripdata_combined.cyclistic_12_month_analysis`
GROUP BY
  member_casual,
  hour
ORDER BY
  member_casual,
  hour;
-- Conclusion: Member rides show stronger concentration during morning and evening peak hours, while casual rides build more gradually through the day and are more concentrated in the afternoon and evening.


-- Analysis 6 - Bike type
SELECT
  member_casual,
  rideable_type,
  COUNT(*) AS ride_count,
  ROUND(
    COUNT(*) * 100.0 /
    SUM(COUNT(*)) OVER (PARTITION BY member_casual),
    2
  ) AS percentage
FROM
  `capstone-project-509409.cyclistic_tripdata_combined.cyclistic_12_month_analysis`
GROUP BY
  member_casual,
  rideable_type
ORDER BY
  member_casual,
  ride_count DESC;
-- Conclusion: Electric bikes are the dominant bike type for both groups, but casual riders have a higher proportion of electric-bike usage, while members have a relatively higher proportion of classic-bike usage.


-- Analysis 7 - Monthly usage by rider type
WITH monthly_rides AS (
  SELECT
    EXTRACT(YEAR FROM TIMESTAMP(started_at)) AS year,
    month,
    month_name,
    member_casual,
    COUNT(*) AS ride_count
  FROM
    `capstone-project-509409.cyclistic_tripdata_combined.cyclistic_12_month_analysis`
  GROUP BY
    year,
    month,
    month_name,
    member_casual
)

SELECT
  year,
  month,
  month_name,
  member_casual,
  ride_count,
  ROUND(
    ride_count * 100.0 /
    SUM(ride_count) OVER (
      PARTITION BY year, month
    ),
    2
  ) AS percentage_of_monthly_rides
FROM monthly_rides
ORDER BY
  year,
  month,
  member_casual;
-- Conclusion: Casual riders' share of monthly rides rises from 17.92% in January to 41.13% in July. In contrast, members account for the largest share during winter, reaching 82.08% in January. This suggests that casual usage is more seasonally concentrated than member usage.


-- Analysis 8 - Comparing average ride duration by month
SELECT
  month,
  month_name,
  member_casual,
  COUNT(*) AS ride_count,
  ROUND(AVG(ride_length_min), 2) AS average_ride_length_min
FROM
  `capstone-project-509409.cyclistic_tripdata_combined.cyclistic_12_month_analysis`
GROUP BY
  month,
  month_name,
  member_casual
ORDER BY
  CASE
    WHEN month >= 9 THEN month
    ELSE month + 12
  END,
  member_casual;
-- Conclusion: Casual riders have longer average ride durations than annual members in every month of the study. The difference is largest in May (6.83 minutes) and smallest in December (1.05 minutes), suggesting that the duration gap varies across the year.


-- Analysis 9 — Top 10 starting stations by rider type
WITH station_rides AS (
  SELECT
    member_casual,
    start_station_name,
    COUNT(*) AS ride_count
  FROM
    `capstone-project-509409.cyclistic_tripdata_combined.cyclistic_12_month_analysis`
  WHERE
    start_station_name IS NOT NULL
  GROUP BY
    member_casual,
    start_station_name
),

ranked_stations AS (
  SELECT
    member_casual,
    start_station_name,
    ride_count,
    ROW_NUMBER() OVER (
      PARTITION BY member_casual
      ORDER BY ride_count DESC
    ) AS station_rank
  FROM station_rides
)

SELECT
  member_casual,
  station_rank,
  start_station_name,
  ride_count
FROM ranked_stations
WHERE station_rank <= 10
ORDER BY member_casual, station_rank;
-- Conclusion: Casual riders starting rides are concentrated at Navy Pier and several waterfront and attraction-area stations, while members top starting stations are more distributed across downtown locations. This suggests that the two rider groups have different geographic usage patterns, although station counts alone cannot establish riders trip purposes.


-- Analysis 10 - Comparing top stations by percentage within each rider group
WITH station_rides AS (
  SELECT
    member_casual,
    start_station_name,
    COUNT(*) AS ride_count
  FROM
    `capstone-project-509409.cyclistic_tripdata_combined.cyclistic_12_month_analysis`
  WHERE
    start_station_name IS NOT NULL
  GROUP BY
    member_casual,
    start_station_name
),

station_shares AS (
  SELECT
    member_casual,
    start_station_name,
    ride_count,
    ROUND(
      ride_count * 100.0 /
      SUM(ride_count) OVER (PARTITION BY member_casual),
      2
    ) AS percentage
  FROM station_rides
),

ranked_stations AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY member_casual
      ORDER BY ride_count DESC
    ) AS station_rank
  FROM station_shares
)

SELECT
  member_casual,
  station_rank,
  start_station_name,
  ride_count,
  percentage
FROM ranked_stations
WHERE station_rank <= 10
ORDER BY member_casual, station_rank;
-- Conclusion: Casual riders' top starting stations are concentrated around waterfront and attraction areas, while members' top stations are concentrated around central Chicago streets and corridors.


-- Analysis 11 - Analyzing top ending stations 
WITH station_rides AS (
  SELECT
    member_casual,
    end_station_name,
    COUNT(*) AS ride_count
  FROM
    `capstone-project-509409.cyclistic_tripdata_combined.cyclistic_12_month_analysis`
  WHERE
    end_station_name IS NOT NULL
  GROUP BY
    member_casual,
    end_station_name
),
station_shares AS (
  SELECT
    member_casual,
    end_station_name,
    ride_count,
    ROUND(
      ride_count * 100.0 /
      SUM(ride_count) OVER (PARTITION BY member_casual),
      2
    ) AS percentage
  FROM station_rides
),
ranked_stations AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY member_casual
      ORDER BY ride_count DESC
    ) AS station_rank
  FROM station_shares
)
SELECT
  member_casual,
  station_rank,
  end_station_name,
  ride_count,
  percentage
FROM ranked_stations
WHERE station_rank <= 10
ORDER BY member_casual, station_rank;
-- Conclusion: The analysis of the top 10 ending stations revealed that Navy Pier was the most frequently used ending station among casual riders, recording 52,565 rides (3.25%). Among annual members, State Street & Chicago Avenue ranked first, with 22,654 rides (0.72%). Casual riders' top ending stations included several waterfront and attraction-area locations, while members' top stations were concentrated around central Chicago streets. The overlap between the most frequently used starting and ending stations indicates that several locations are popular across both trip origins and destinations.


-- Key Takeaways -- 
-- 1. Rider distribution - Members account for 64.72% of rides.
-- 2. Ride duration - Casual rides average 17.76 minutes, compared with 11.95 minutes for members.
-- 3. Weekday/weekend - 37.25% of casual rides occur on weekends, compared with 23.34% of member rides.
-- 4. Day of week - Casual rides peak on Saturday; member rides peak on Wednesday.
-- 5. Hourly usage - Both groups peak at 5 PM; members also show a strong morning peak.
-- 6. Bike type - Electric bikes account for 73.74% of casual rides and 68.07% of member rides.
-- 7. Monthly trends - Casual rider share peaks at 41.13% in July and falls to 17.92% in January.
-- 8. Starting stations - Navy Pier leads casual rides; Canal Street & Madison Street leads member rides.
-- 9. Ending stations - Navy Pier leads casual rides; State Street & Chicago Avenue leads member rides.
