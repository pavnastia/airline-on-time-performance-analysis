--1. What is inside the table?

-- View the first 10 rows
SELECT *
FROM `bigquery-samples.airline_ontime_data.flights`
LIMIT 10

-- Data types of the table columns
SELECT column_name, data_type
FROM `bigquery-samples.airline_ontime_data.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'flights'
ORDER BY ordinal_position

SELECT
  -- Total number of rows / flights
  COUNT(*) AS total_flights,

  -- MIN/MAX work correctly with text if dates are stored in YYYY-MM-DD format
  MIN(date) AS min_date,
  MAX(date) AS max_date,

  -- Number of unique airlines
  COUNT(DISTINCT airline) AS unique_airlines
FROM `bigquery-samples.airline_ontime_data.flights`


-- 2. What are the unique values?
-- The number of unique
SELECT
  COUNT(DISTINCT airline) AS unique_airlines,
  COUNT(DISTINCT airline_code) AS unique_airline_codes,
  COUNT(DISTINCT departure_airport) AS unique_departure_airports,
  COUNT(DISTINCT arrival_airport) AS unique_arrival_airports,
  COUNT(DISTINCT departure_state) AS unique_departure_states,
  COUNT(DISTINCT arrival_state) AS unique_arrival_states
FROM `bigquery-samples.airline_ontime_data.flights`;

SELECT DISTINCT
  airline,
  airline_code
FROM `bigquery-samples.airline_ontime_data.flights`
ORDER BY airline;

--The highest number of flights
SELECT
  airline,
  airline_code,
  COUNT(*) AS total_flights
FROM `bigquery-samples.airline_ontime_data.flights`
GROUP BY airline, airline_code
ORDER BY total_flights DESC
LIMIT 5;

-- The most popular departure airports
SELECT
  departure_airport,
  departure_state,
  COUNT(*) AS total_departures
FROM `bigquery-samples.airline_ontime_data.flights`
GROUP BY departure_airport, departure_state
ORDER BY total_departures DESC
LIMIT 5;

--The most popular arrival airports
SELECT
  arrival_airport,
  arrival_state,
  COUNT(*) AS total_arrivals
FROM `bigquery-samples.airline_ontime_data.flights`
GROUP BY arrival_airport, arrival_state
ORDER BY total_arrivals DESC
LIMIT 5;

--The most frequent routes
SELECT
  departure_airport,
  arrival_airport,
  COUNT(*) AS total_flights
FROM `bigquery-samples.airline_ontime_data.flights`
GROUP BY departure_airport, arrival_airport
ORDER BY total_flights DESC
LIMIT 10;

--The number of flights
SELECT
  SUBSTR(date, 1, 4) AS year,
  COUNT(*) AS total_flights
FROM `bigquery-samples.airline_ontime_data.flights`
GROUP BY year
ORDER BY year;

--3. Nulls and Duplicates
-- Missing values
SELECT
  COUNT(*) AS total_rows,

  COUNTIF(date IS NULL) AS null_date,
  COUNTIF(airline IS NULL) AS null_airline,
  COUNTIF(airline_code IS NULL) AS null_airline_code,

  COUNTIF(departure_airport IS NULL) AS null_departure_airport,
  COUNTIF(departure_state IS NULL) AS null_departure_state,
  COUNTIF(arrival_airport IS NULL) AS null_arrival_airport,
  COUNTIF(arrival_state IS NULL) AS null_arrival_state,

  COUNTIF(departure_schedule IS NULL) AS null_departure_schedule,
  COUNTIF(departure_actual IS NULL) AS null_departure_actual,
  COUNTIF(departure_delay IS NULL) AS null_departure_delay,

  COUNTIF(arrival_schedule IS NULL) AS null_arrival_schedule,
  COUNTIF(arrival_actual IS NULL) AS null_arrival_actual,
  COUNTIF(arrival_delay IS NULL) AS null_arrival_delay
FROM `bigquery-samples.airline_ontime_data.flights`;

SELECT
  date,
  airline,
  airline_code,
  departure_airport,
  arrival_airport,
  departure_schedule,
  departure_actual,
  departure_delay,
  arrival_schedule,
  arrival_actual,
  arrival_delay
FROM `bigquery-samples.airline_ontime_data.flights`
WHERE departure_delay IS NULL
   OR arrival_delay IS NULL
LIMIT 100;

WITH full_duplicates AS (
  SELECT
    date,
    airline,
    airline_code,
    departure_airport,
    departure_state,
    departure_lat,
    departure_lon,
    arrival_airport,
    arrival_state,
    arrival_lat,
    arrival_lon,
    departure_schedule,
    departure_actual,
    departure_delay,
    arrival_schedule,
    arrival_actual,
    arrival_delay,
    COUNT(*) AS row_count
  FROM `bigquery-samples.airline_ontime_data.flights`
  GROUP BY
    date,
    airline,
    airline_code,
    departure_airport,
    departure_state,
    departure_lat,
    departure_lon,
    arrival_airport,
    arrival_state,
    arrival_lat,
    arrival_lon,
    departure_schedule,
    departure_actual,
    departure_delay,
    arrival_schedule,
    arrival_actual,
    arrival_delay
  HAVING COUNT(*) > 1
)

SELECT
  COUNT(*) AS duplicate_groups,
  SUM(row_count) AS rows_in_duplicate_groups,
  SUM(row_count - 1) AS duplicate_rows
FROM full_duplicates;

--4. Time Range: What Period Does the Data Cover?
--The minimum and maximum dates
SELECT
  MIN(date) AS first_report_date,
  MAX(date) AS last_report_date,
  DATE_DIFF(MAX(date), MIN(date), DAY) AS days_diff
FROM `test.marketing_ads`;

--The share of flights by year
SELECT
  EXTRACT(YEAR FROM DATE(date)) AS year,
  COUNT(*) AS total_flights,
  ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 2) AS flights_percent
FROM `bigquery-samples.airline_ontime_data.flights`
GROUP BY year
ORDER BY year;

-- The share of flights by month
SELECT
  EXTRACT(MONTH FROM DATE(date)) AS month,
  COUNT(*) AS total_flights,
  ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 2) AS flights_percent
FROM `bigquery-samples.airline_ontime_data.flights`
GROUP BY month
ORDER BY month;

--The distribution of flights by day of the week
SELECT
  FORMAT_DATE('%A', DATE(date)) AS day_of_week,
  COUNT(*) AS total_flights,
  ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 2) AS flights_percent
FROM `bigquery-samples.airline_ontime_data.flights`
GROUP BY day_of_week
ORDER BY total_flights DESC;

--The share of delayed arrivals by year
SELECT
  EXTRACT(YEAR FROM DATE(date)) AS year,
  COUNT(*) AS total_flights,
  COUNTIF(arrival_delay > 0) AS delayed_arrivals,
  ROUND(COUNTIF(arrival_delay > 0) / COUNT(*) * 100, 2) AS delayed_arrival_percent
FROM `bigquery-samples.airline_ontime_data.flights`
GROUP BY year
ORDER BY year;

--5. Numerical Field Validation
--Departure and arrival delays
SELECT
  MIN(departure_delay) AS min_departure_delay,
  MAX(departure_delay) AS max_departure_delay,
  ROUND(AVG(departure_delay), 2) AS avg_departure_delay,

  MIN(arrival_delay) AS min_arrival_delay,
  MAX(arrival_delay) AS max_arrival_delay,
  ROUND(AVG(arrival_delay), 2) AS avg_arrival_delay
FROM `bigquery-samples.airline_ontime_data.flights`;

--Arrival delays into categories
SELECT
  CASE
    WHEN arrival_delay < 0 THEN 'Arrived early'
    WHEN arrival_delay = 0 THEN 'On time'
    WHEN arrival_delay BETWEEN 1 AND 15 THEN 'Delay 1-15 min'
    WHEN arrival_delay BETWEEN 16 AND 60 THEN 'Delay 16-60 min'
    WHEN arrival_delay > 60 THEN 'Delay over 60 min'
  END AS delay_category,
  COUNT(*) AS total_flights,
  ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 2) AS flights_percent
FROM `bigquery-samples.airline_ontime_data.flights`
GROUP BY delay_category
ORDER BY total_flights DESC;

--Extremely Large Delays
SELECT
  date,
  airline,
  airline_code,
  departure_airport,
  arrival_airport,
  departure_delay,
  arrival_delay
FROM `bigquery-samples.airline_ontime_data.flights`
WHERE departure_delay > 1000
   OR arrival_delay > 1000
ORDER BY GREATEST(departure_delay, arrival_delay) DESC
LIMIT 10;

--Departure and Arrival Times
SELECT
  MIN(departure_schedule) AS min_departure_schedule,
  MAX(departure_schedule) AS max_departure_schedule,
  MIN(departure_actual) AS min_departure_actual,
  MAX(departure_actual) AS max_departure_actual,

  MIN(arrival_schedule) AS min_arrival_schedule,
  MAX(arrival_schedule) AS max_arrival_schedule,
  MIN(arrival_actual) AS min_arrival_actual,
  MAX(arrival_actual) AS max_arrival_actual
FROM `bigquery-samples.airline_ontime_data.flights`;

--Invalid Time Formats
SELECT
  COUNTIF(
    departure_schedule IS NOT NULL
    AND (DIV(departure_schedule, 100) > 23 OR MOD(departure_schedule, 100) > 59)
  ) AS invalid_departure_schedule,

  COUNTIF(
    departure_actual IS NOT NULL
    AND (DIV(departure_actual, 100) > 23 OR MOD(departure_actual, 100) > 59)
  ) AS invalid_departure_actual,

  COUNTIF(
    arrival_schedule IS NOT NULL
    AND (DIV(arrival_schedule, 100) > 23 OR MOD(arrival_schedule, 100) > 59)
  ) AS invalid_arrival_schedule,

  COUNTIF(
    arrival_actual IS NOT NULL
    AND (DIV(arrival_actual, 100) > 23 OR MOD(arrival_actual, 100) > 59)
  ) AS invalid_arrival_actual
FROM `bigquery-samples.airline_ontime_data.flights`;

--Airport Coordinates
SELECT
  COUNTIF(departure_lat < -90 OR departure_lat > 90) AS invalid_departure_lat,
  COUNTIF(departure_lon < -180 OR departure_lon > 180) AS invalid_departure_lon,
  COUNTIF(arrival_lat < -90 OR arrival_lat > 90) AS invalid_arrival_lat,
  COUNTIF(arrival_lon < -180 OR arrival_lon > 180) AS invalid_arrival_lon
FROM `bigquery-samples.airline_ontime_data.flights`;
