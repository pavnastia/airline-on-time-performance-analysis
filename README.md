# Airline On-Time Performance Analysis

## Project Overview

This project analyzes airline on-time performance using a public BigQuery dataset: `bigquery-samples.airline_ontime_data.flights`.

The dataset contains 70 588 485 flight records and includes information about flight dates, airlines, departure and arrival airports, U.S. states, airport coordinates, scheduled and actual departure/arrival times, and flight delays measured in minutes.

The main goal of this project is to practice SQL and BigQuery skills while exploring flight delay patterns, data quality, time-based trends, and key categorical dimensions such as airlines, airports, routes, and years.

## Documentation

Detailed project documentation is available in Notion in two languages:

- [Documentation in Ukrainian](https://app.notion.com/p/Airline-On-Time-Performance-Analysis-UA-361fe3d5200480509b01f8a9c52341cc?source=copy_link)
- [Documentation in English](https://app.notion.com/p/Airline-On-Time-Performance-Analysis-ENG-380fe3d520048051a112c246a4b52363?source=copy_link)

## Tools Used

- Google BigQuery
- SQL
- GitHub
- Notion

## Dataset

- Source: Google BigQuery public dataset
- Table: `bigquery-samples.airline_ontime_data.flights`
- Total records: 70 588 485
- Date range: 2002-01-01 to 2012-12-31
- Unique airlines: 24

## Analysis Steps

### 1. Dataset Structure

I reviewed the table structure, column names, data types, and the meaning of each field.

### 2. Categorical Value Analysis

I analyzed airlines, airline codes, airports, states, and routes.

Key findings:

- The dataset contains 24 unique airlines.
- There are 347 unique departure airports and 344 unique arrival airports.
- The most active airline by number of flights is WN.
- The most active airports include ATL, ORD, DFW, LAX, and DEN.

### 3. Data Quality Check

I checked missing values, duplicate records, and the completeness of key delay-related columns.

Key findings:

- Most key columns do not contain missing values.
- `departure_delay` and `arrival_delay` are fully populated.
- Only a very small number of missing values were found in time-related columns.
- The dataset contains 107 groups of complete duplicates.

### 4. Time Range Analysis

I analyzed the distribution of flights by year, month, and day of the week.

Key findings:

- The dataset covers 11 years, from 2002 to 2012.
- The highest number of flights was recorded in 2007.
- Monthly flight distribution is relatively balanced.
- The highest number of flights occurs on Friday.
- The lowest number of flights occurs on Saturday.
- The highest share of delayed arrivals was in 2007, and the lowest was in 2012.

### 5. Numerical Field Validation

I checked delay values, time fields, and airport coordinates.

Key findings:

- The average departure delay is 8.39 minutes.
- The average arrival delay is 6.05 minutes.
- Most flights arrived earlier than scheduled.
- Some flights have extremely large delays.
- Some time fields contain invalid `HHMM` values.
- Airport coordinates are within valid geographic ranges.

## Main Insights

The dataset is suitable for further airline delay analysis. It has a large number of records, a clear time range, and mostly complete key fields.

The analysis showed that delay patterns vary by year, and extreme delays may influence average metrics. For more accurate conclusions, it would be useful to compare average and median delays, analyze delay categories, and investigate outliers separately.

## Possible Next Steps

- Analyze average delays by airline
- Compare delays by airport
- Identify the most delayed routes
- Analyze seasonal delay patterns
- Compare weekdays and weekends
- Build visualizations or a dashboard
