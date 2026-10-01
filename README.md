# Cyclistic Bike-Share Analysis

## Annual Members vs Casual Riders

### Project Overview

This project analyzes Cyclistic bike-share usage patterns to understand how **annual members and casual riders use the service differently**.

The analysis covers **12 months of Cyclistic trip data from September 2025 to August 2026**, containing more than **6.1 million rides**.

The project follows a complete data analyst workflow:

**Raw Data → Data Cleaning → SQL Analysis → Insights → Tableau Dashboard → Recommendations**

---

## Business Question

> **How do annual members and casual riders use Cyclistic bikes differently?**

The objective is to identify behavioral differences between the two rider groups and use those insights to suggest opportunities for increasing annual memberships.

---

## Dataset

**Analysis Period:** September 2025 – August 2026

**Total Rides Analyzed:** 6,107,959

The dataset contains information such as:

- Ride ID
- Rideable type
- Start and end timestamps
- Start and end stations
- Start and end coordinates
- Rider type
  - Member
  - Casual

Raw trip data is not included in this repository because of its size.

---

## Tools Used

| Tool | Purpose |
|---|---|
| **Google BigQuery** | Data cleaning, transformation and SQL analysis |
| **SQL** | Data exploration and behavioral analysis |
| **Tableau Public** | Interactive dashboard and visualization |
| **Excel / CSV** | Data handling and export |
| **PowerPoint** | Findings and recommendations presentation |
| **GitHub** | Project documentation and portfolio |

---

# Project Workflow

## 1. Data Cleaning

The raw monthly datasets were loaded into BigQuery and cleaned before analysis.

The cleaning process included:

- Checking row counts
- Checking duplicate ride IDs
- Checking missing values
- Calculating ride duration
- Removing zero or negative ride durations
- Removing rides longer than 24 hours
- Standardizing date-related fields
- Creating month and month-name fields
- Creating weekday/weekend classification
- Creating hourly ride fields
- Combining all 12 months into one analysis dataset

The final cleaned dataset contained:

**6,107,959 unique rides**

---

# 2. Exploratory Data Analysis

The analysis compared members and casual riders across several dimensions:

### Rider Type

- Total rides
- Share of total rides
- Average ride duration
- Median ride duration

### Time

- Monthly ride volume
- Day of week
- Weekday vs weekend
- Hour of day

### Bike Type

- Electric bikes
- Classic bikes

### Stations

- Most popular start stations
- Most popular end stations

---

# Key Findings

## 1. Members generate the majority of rides

| Rider Type | Rides | Share |
|---|---:|---:|
| Members | 3,953,074 | 64.72% |
| Casual | 2,154,885 | 35.28% |
| **Total** | **6,107,959** | **100%** |

Annual members account for nearly two-thirds of all rides.

---

## 2. Casual riders take longer rides

| Rider Type | Average Ride | Median Ride |
|---|---:|---:|
| Member | 11.95 min | 8.55 min |
| Casual | 17.76 min | 10.83 min |

Casual riders have substantially longer average ride durations than members.

This suggests that casual usage is more oriented toward longer or recreational trips, while member usage is more consistent with shorter, repeated trips.

---

## 3. Members are more concentrated on weekdays

### Member rides

- Weekday: **76.66%**
- Weekend: **23.34%**

### Casual rides

- Weekday: **62.75%**
- Weekend: **37.25%**

Casual riders have a considerably larger weekend share compared with members.

---

## 4. Different weekly usage patterns

The most common day for:

- **Casual riders:** Saturday — 21.14%
- **Members:** Wednesday — 15.98%

This indicates a difference between the weekly usage patterns of the two groups.

---

## 5. Both groups use electric bikes heavily

### Casual riders

- Electric: **73.74%**
- Classic: **26.26%**

### Members

- Electric: **68.07%**
- Classic: **31.93%**

Electric bikes represent the majority of rides for both rider groups.

---

## 6. Strong seasonal variation

Casual riders represent a smaller share of rides during the winter months and a much larger share during warmer months.

The casual share ranged from approximately:

- **17.92% in January**
- **41.13% in July**

This suggests that casual usage is more seasonal than member usage.

---

## 7. Station behavior differs

Casual riders frequently use stations associated with waterfront and attraction areas.

Examples include:

- Navy Pier
- DuSable Lake Shore Dr & Monroe St
- Michigan Ave & Oak St

Member usage is more concentrated around downtown street locations such as:

- Canal St & Madison St
- State St & Chicago Ave

This provides additional evidence of different usage patterns between the two rider groups.

---

# Tableau Dashboard

The final Tableau dashboard provides an executive overview of Cyclistic usage.

The dashboard includes:

- Total rides KPI
- Member rides KPI
- Casual rides KPI
- Average ride duration
- Monthly ride trend
- Member vs casual ride share
- Average duration by rider type
- Rider comparison table
- Average duration by month
- Interactive filters
- Key takeaways

### Dashboard Preview


```markdown
![Cyclistic Dashboard](dashboard/cyclistic_dashboard.png)
