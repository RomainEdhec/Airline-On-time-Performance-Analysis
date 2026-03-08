#1 Delayed flight rate among all flights which were not cancelled or diverted

SELECT
  ROUND(100.0 * SUM(CASE WHEN arr_delay >= 15 THEN 1 ELSE 0 END)
    / COUNT(*), 2) AS delayed_flight_rate
FROM fact_flights
WHERE cancelled = false
  AND diverted = false
  AND arr_delay IS NOT NULL;

#2 Delayed flight rate per airline

SELECT c.carrier_code, 
       ROUND(100.0 * SUM(CASE WHEN ff.arr_delay >= 15 THEN 1 ELSE 0 END)/ COUNT(*), 2) AS delayed_flight_rate,
	   COUNT(*) AS total_flights
FROM fact_flights ff
JOIN dim_carrier c
ON c.carrier_id = ff.carrier_id
WHERE ff.cancelled = false AND ff.diverted = false AND ff.arr_delay IS NOT NULL
GROUP BY c.carrier_code
ORDER BY delayed_flight_rate DESC;

#3 Proportion of each cause in the delays for each airline

SELECT
  c.carrier_code,
  ROUND(100.0 * SUM(COALESCE(ff.carrier_delay,0)) / NULLIF(SUM(ff.arr_delay),0), 2) AS pct_due_to_carrier,
  ROUND(100.0 * SUM(COALESCE(ff.weather_delay,0)) / NULLIF(SUM(ff.arr_delay),0), 2) AS pct_due_to_weather,
  ROUND(100.0 * SUM(COALESCE(ff.nas_delay,0)) / NULLIF(SUM(ff.arr_delay),0), 2)     AS pct_due_to_nas,
  ROUND(100.0 * SUM(COALESCE(ff.late_aircraft_delay,0)) / NULLIF(SUM(ff.arr_delay),0), 2) AS pct_due_to_late_aircraft,
  ROUND(100.0 * (SUM(ff.arr_delay) - 
  (SUM(COALESCE(ff.carrier_delay,0)) + SUM(COALESCE(ff.weather_delay,0)) + SUM(COALESCE(ff.nas_delay,0)) + SUM(COALESCE(ff.late_aircraft_delay,0)))
    ) / NULLIF(SUM(ff.arr_delay),0), 2) AS pct_unattributed
FROM fact_flights ff
JOIN dim_carrier c ON c.carrier_id = ff.carrier_id
WHERE ff.cancelled = false
  AND ff.diverted = false
  AND ff.arr_delay >= 15
GROUP BY c.carrier_code
ORDER BY pct_due_to_carrier DESC;


#4 Average arrival delay for every carrier on all flights

SELECT
  c.carrier_code,
  ROUND(AVG(ff.arr_delay)::numeric, 2) AS avg_arrival_delay_min,
  ROUND(AVG(ff.dep_delay)::numeric, 2) AS avg_departure_delay_min
FROM fact_flights ff
JOIN dim_carrier c ON c.carrier_id = ff.carrier_id
WHERE ff.cancelled = false
  AND ff.diverted = false
  AND ff.arr_delay IS NOT NULL
  AND ff.dep_delay IS NOT NULL
GROUP BY c.carrier_code
ORDER BY avg_arrival_delay_min DESC;


#5 Proportion of delay due to carrier, weather, nas and aircraft among delayed flights (>15min) compared to the average of the market for the three carriers with the most average delay

SELECT
  c.carrier_code,

  ROUND(100.0 * SUM(COALESCE(ff.carrier_delay,0)) / NULLIF(SUM(ff.arr_delay),0), 2) AS carrier_pct,
  g.global_carrier_pct,

  ROUND(100.0 * SUM(COALESCE(ff.weather_delay,0)) / NULLIF(SUM(ff.arr_delay),0), 2) AS weather_pct,
  g.global_weather_pct,

  ROUND(100.0 * SUM(COALESCE(ff.nas_delay,0)) / NULLIF(SUM(ff.arr_delay),0), 2) AS nas_pct,
  g.global_nas_pct,

  ROUND(100.0 * SUM(COALESCE(ff.late_aircraft_delay,0)) / NULLIF(SUM(ff.arr_delay),0), 2) AS late_aircraft_pct,
  g.global_late_aircraft_pct

FROM fact_flights ff
JOIN dim_carrier c ON c.carrier_id = ff.carrier_id

CROSS JOIN (
  SELECT
    ROUND(100.0 * SUM(COALESCE(carrier_delay,0)) / NULLIF(SUM(arr_delay),0), 2) AS global_carrier_pct,
    ROUND(100.0 * SUM(COALESCE(weather_delay,0)) / NULLIF(SUM(arr_delay),0), 2) AS global_weather_pct,
    ROUND(100.0 * SUM(COALESCE(nas_delay,0))     / NULLIF(SUM(arr_delay),0), 2) AS global_nas_pct,
    ROUND(100.0 * SUM(COALESCE(late_aircraft_delay,0)) / NULLIF(SUM(arr_delay),0), 2) AS global_late_aircraft_pct
  FROM fact_flights
  WHERE cancelled = false
    AND diverted = false
    AND arr_delay >= 15
) g

WHERE ff.cancelled = false
  AND ff.diverted = false
  AND ff.arr_delay >= 15
  AND c.carrier_code IN ('AA','UA','MQ')

GROUP BY c.carrier_code,
         g.global_carrier_pct, g.global_weather_pct, g.global_nas_pct, g.global_late_aircraft_pct
ORDER BY c.carrier_code;

#6 Delayed flight rate per month for the same three airlines

SELECT d.month,
       c.carrier_code,
       ROUND(100.0 * SUM(CASE WHEN ff.arr_delay >= 15 THEN 1 ELSE 0 END)/COUNT(*), 2) AS delayed_flight_rate
FROM fact_flights ff
JOIN dim_date d
ON d.date_id = ff.date_id
JOIN dim_carrier c
ON c.carrier_id = ff.carrier_id
WHERE ff.arr_delay IS NOT NULL AND
      ff.cancelled = false AND
	  ff.diverted = false AND
	  carrier_code IN ('AA', 'MQ', 'UA')
GROUP BY d.month, carrier_code
ORDER BY d.month, c.carrier_code

#7 Total flights per origin aeroport for each airline

SELECT c.carrier_code, 
       a.airport_code,
	   COUNT(*) AS total_flights
	   
FROM dim_carrier c
JOIN fact_flights ff
ON c.carrier_id = ff.carrier_id
JOIN dim_airport a
ON a.airport_id = ff.origin_airport_id
WHERE ff.cancelled = false AND
      ff.diverted = false AND
	  c.carrier_code IN ('AA', 'MQ', 'UA')
GROUP BY c.carrier_code, a.airport_code
HAVING COUNT(*) >= 1000
ORDER BY total_flights DESC;


#8 Flight delay rate in each origin aeroport for those three same airlines

SELECT c.carrier_code, 
       a.airport_code,
	   COUNT(*) AS total_flights,
	   ROUND(100.0 * SUM(CASE WHEN arr_delay >= 15 THEN 1 ELSE 0 END) / COUNT(fact_flight_id), 2) AS flight_delay_rate
FROM dim_carrier c
JOIN fact_flights ff
ON c.carrier_id = ff.carrier_id
JOIN dim_airport a
ON a.airport_id = ff.origin_airport_id
WHERE ff.cancelled = false AND
      ff.diverted = false AND
	  ff.arr_delay IS NOT NULL AND
	  c.carrier_code IN ('AA', 'MQ', 'UA')
GROUP BY c.carrier_code, a.airport_code
HAVING COUNT(*) >= 5000
ORDER BY flight_delay_rate DESC, total_flights DESC;

