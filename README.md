# Airline-On-time-Performance-Analysis
Airline On-Time Performance Analysis (2009)
1. Introduction

This project analyzes U.S. airline on-time performance data for the year 2009. 

The objective is to understand delay patterns, identify underperforming airlines, examine the severity of delays, and investigate the structural causes behind these delays.

The analysis focuses on flight-level data and applies a structured analytical approach using PostgreSQL. A relational star schema was implemented to separate dimensions (date, carrier, airport) from the central fact table (flights).

A significant delay is defined as:

Arrival delay greater than or equal to 15 minutes.

Cancelled and diverted flights were excluded from most performance indicators to ensure consistent and meaningful comparisons.

2. Dataset Overview

The dataset contains flight-level records including:

Flight year, month, and day

Airline carrier code

Origin and destination airport codes

Scheduled and actual departure/arrival times

Departure and arrival delay (in minutes)

Cancellation and diversion indicators

Delay causes:

Carrier delay

Weather delay

NAS (National Airspace System) delay

Late aircraft delay

The analysis covers the first four months of 2009 (January to April).

3. Data Model

A star schema was implemented:

fact_flights (central fact table)

dim_date

dim_carrier

dim_airport

This structure ensures:

Clean separation between measures and descriptive attributes

Efficient analytical queries

Scalability for future extensions (e.g., additional years)

4. Key Performance Indicators (KPIs)

4.1 Global Delay Rate
Global percentage of flights delayed by 15 minutes or more:

25.21%

Approximately one out of four flights experienced a significant arrival delay.

4.2 Delay Rate by Airline

Top three airlines by delay rate:

AA: 32.37%

UA: 29.77%

MQ: 29.12%

These airlines consistently rank highest in terms of delay frequency.

4.3 Average Arrival Delay

Average arrival delay in minutes:

AA: 16.07 minutes

UA: 14.35 minutes

MQ: 13.94 minutes

These three airlines not only have higher delay frequency, but also experience more severe delays on average.

4.4 Delay Causes Breakdown

Global distribution of delay minutes:

Carrier delay: 28.18%

NAS delay: 28.90%

Late aircraft delay: 37.52%

Weather delay: 5.26%

Key observations:

Late aircraft delay is the dominant cause system-wide.

AA’s share of carrier-related delay (28.33%) is almost identical to the global average, suggesting its issues are not purely internal.

UA shows a particularly high share of late aircraft delays (~44.78%), indicating strong delay propagation effects.

Weather has a limited overall impact.

4.5 Monthly Evolution (Seasonality)

Global delay rates by month:

January: 24.57%

February: 27.45%

March: 25.54%

April: 20.43%

There is a clear seasonal pattern with a peak in February and significant improvement in April.

Although AA, UA, and MQ follow the same seasonal trend, they remain consistently above the global average, suggesting structural performance gaps beyond seasonal effects.

4.6 Origin Airport Analysis

Top origin airports by delay rate and volume show that:

Chicago O’Hare (ORD) is a major driver of delays across AA, UA, and MQ.

High delay rates at ORD significantly affect overall airline performance.

AA is strongly exposed to high-delay hubs such as ORD and LGA.

This indicates that performance issues are partly structural and related to network exposure rather than purely airline-specific inefficiencies.

5. Main Conclusions

Approximately 25% of flights experience significant arrival delays.

AA, UA, and MQ consistently show higher delay frequency and severity.

Delay causes are multi-factorial:

Late aircraft propagation plays a dominant role.

Carrier-related delays are substantial but not abnormally high compared to system averages.

Seasonality affects all airlines similarly.

Major hubs, especially ORD, significantly influence airline performance.

Overall, delay patterns appear driven by a combination of:

Network structure

Hub congestion

Delay propagation

Seasonal environmental factors
