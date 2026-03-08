#Creation of the first table with all the columns to import our data

CREATE TABLE raw_data(flight_year TEXT,
flight_month TEXT,
day_of_month TEXT,
day_of_week TEXT,
dep_time TEXT,
crs_dep_time TEXT,
arr_time TEXT,
crs_arr_time TEXT,
unique_carrier TEXT,
flight_num TEXT,
tail_num TEXT,
actual_elapsed_time TEXT,
crs_elapsed_time TEXT,
air_time TEXT,
arr_delay TEXT,
dep_delay TEXT,
origin TEXT,
dest TEXT,
distance TEXT,
taxi_in TEXT,
taxi_out TEXT,
cancelled TEXT,
cancellation_code TEXT,
diverted TEXT,
carrier_delay TEXT,
weather_delay TEXT,
nas_delay TEXT,
security_delay TEXT,
late_aircraft_delay TEXT);

#Creation of a new table giving the right variable data types and replacing empty cell or NA by NULL

CREATE TABLE clean_data AS
SELECT
  NULLIF(NULLIF(UPPER(flight_year),''),'NA')::INT AS flight_year,
  NULLIF(NULLIF(UPPER(flight_month),''), 'NA')::INT AS flight_month,
  NULLIF(NULLIF(UPPER(day_of_month),''), 'NA')::INT AS day_of_month,
  NULLIF(NULLIF(UPPER(day_of_week),''), 'NA')::INT AS day_of_week,

  NULLIF(NULLIF(UPPER(dep_time),''), 'NA')::INT AS dep_time,
  NULLIF(NULLIF(UPPER(crs_dep_time),''), 'NA')::INT AS crs_dep_time,
  NULLIF(NULLIF(UPPER(arr_time),''), 'NA')::INT AS arr_time,
  NULLIF(NULLIF(UPPER(crs_arr_time),''), 'NA')::INT AS crs_arr_time,

  NULLIF(NULLIF(UPPER(unique_carrier),''),'NA') AS unique_carrier,
  NULLIF(NULLIF(UPPER(flight_num),''), 'NA')::INT AS flight_num,
  NULLIF(NULLIF(UPPER(tail_num),''), 'NA') AS tail_num,

  NULLIF(NULLIF(UPPER(actual_elapsed_time),''), 'NA')::INT AS actual_elapsed_time,
  NULLIF(NULLIF(UPPER(crs_elapsed_time),''), 'NA')::INT AS crs_elapsed_time,
  NULLIF(NULLIF(UPPER(air_time),''), 'NA')::INT AS air_time,

  NULLIF(NULLIF(UPPER(arr_delay),''), 'NA')::INT AS arr_delay,
  NULLIF(NULLIF(UPPER(dep_delay),''), 'NA')::INT AS dep_delay,

  NULLIF(NULLIF(UPPER(origin),''), 'NA') AS origin,
  NULLIF(NULLIF(UPPER(dest),''), 'NA') AS dest,
  NULLIF(NULLIF(UPPER(distance),''), 'NA')::INT AS distance,

  NULLIF(NULLIF(UPPER(taxi_in),''), 'NA')::INT AS taxi_in,
  NULLIF(NULLIF(UPPER(taxi_out),''), 'NA')::INT AS taxi_out,

  (NULLIF(NULLIF(UPPER(cancelled),''), 'NA')::INT = 1) AS cancelled,
  NULLIF(NULLIF(UPPER(cancellation_code),''), 'NA') AS cancellation_code,
  (NULLIF(NULLIF(UPPER(diverted),''), 'NA')::INT = 1) AS diverted,

  NULLIF(NULLIF(UPPER(carrier_delay),''), 'NA')::INT AS carrier_delay,
  NULLIF(NULLIF(UPPER(weather_delay),''), 'NA')::INT AS weather_delay,
  NULLIF(NULLIF(UPPER(nas_delay),''), 'NA')::INT AS nas_delay,
  NULLIF(NULLIF(UPPER(late_aircraft_delay),''), 'NA')::INT AS late_aircraft_delay

FROM raw_data;