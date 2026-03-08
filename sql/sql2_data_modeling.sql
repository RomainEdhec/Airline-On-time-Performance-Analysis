#Creation of a first table for the date

CREATE TABLE dim_date(date_id SERIAL PRIMARY KEY, 
                      full_date DATE NOT NULL UNIQUE,
                      year SMALLINT,
                      month SMALLINT,
                      day SMALLINT,
                      day_of_week SMALLINT);

INSERT INTO dim_date(full_date, year, month, day, day_of_week)
SELECT DISTINCT make_date(flight_year, flight_month, day_of_month),
                flight_year,
		flight_month,
		day_of_month,
		day_of_week
FROM clean_data;

#Route table

CREATE TABLE dim_route(route_id SERIAL PRIMARY KEY,
                       origin TEXT NOT NULL, 
                       dest TEXT NOT NULL,
                       UNIQUE(origin, dest));

INSERT INTO dim_route(origin, dest)
SELECT DISTINCT origin, dest
FROM clean_data
WHERE origin IS NOT NULL AND dest IS NOT NULL;

#Airport table

CREATE TABLE dim_airport(airport_id SERIAL PRIMARY KEY,
                         airport_code CHAR(3) NOT NULL UNIQUE);


INSERT INTO dim_airport(airport_code)
SELECT DISTINCT origin
FROM clean_data
WHERE origin IS NOT NULL

UNION 

SELECT DISTINCT dest
FROM clean_data
WHERE dest IS NOT NULL;

#Carrier table

CREATE TABLE dim_carrier(carrier_id SERIAL PRIMARY KEY, 
                         carrier_code CHAR(3) NOT NULL UNIQUE);

INSERT INTO dim_carrier(carrier_code)
SELECT DISTINCT unique_carrier
FROM clean_data
WHERE unique_carrier IS NOT NULL;

#Fact flights table

CREATE TABLE fact_flights(fact_flight_id BIGSERIAL PRIMARY KEY,
                          date_id INT NOT NULL REFERENCES dim_date(date_id),
						  carrier_id INT NOT NULL REFERENCES dim_carrier(carrier_id),
						  origin_airport_id INT NOT NULL REFERENCES dim_airport(airport_id),
						  dest_airport_id INT NOT NULL REFERENCES dim_airport(airport_id),
						  dep_time INT,
						  crs_dep_time INT,
						  arr_time INT,
						  crs_arr_time INT,
						  actual_elapsed_time INT,
						  crs_elapsed_time INT,
						  air_time INT,
						  dep_delay INT,
						  arr_delay INT,
						  distance INT,
						  taxi_in INT,
						  taxi_out INT,
						  cancelled BOOLEAN,
						  diverted BOOLEAN,
						  carrier_delay INT,
						  weather_delay INT,
						  nas_delay INT,
						  late_aircraft_delay INT,
						  flight_num INT,
						  tail_num TEXT,
						  cancellation_code TEXT);


INSERT INTO fact_flights(date_id, 
                         carrier_id,
						 origin_airport_id,
						 dest_airport_id,
						 dep_time,
						 crs_dep_time,
						 arr_time,
						 crs_arr_time,
						 actual_elapsed_time,
						 crs_elapsed_time,
						 air_time,
						 dep_delay,
						 arr_delay,
						 distance,
						 taxi_in,
						 taxi_out,
						 cancelled,
						 diverted,
						 carrier_delay,
						 weather_delay,
						 nas_delay,
						 late_aircraft_delay,
						 flight_num,
						 tail_num,
						 cancellation_code)

SELECT d.date_id, 
       c.carrier_id,
	   ao.airport_id AS origin_airport_id,
	   ad.airport_id AS dest_airport_id,

	   cd.dep_time, cd.crs_dep_time, cd.arr_time, cd.crs_arr_time,
	   cd.actual_elapsed_time, cd.crs_elapsed_time, cd.air_time, 
	   cd.dep_delay, cd.arr_delay, cd.distance, cd.taxi_in, cd.taxi_out,
	   cd.cancelled, cd.diverted, cd.carrier_delay, cd.weather_delay,
	   cd.nas_delay, cd.late_aircraft_delay, cd.flight_num, cd.tail_num,
	   cd.cancellation_code
	   
	   

FROM clean_data cd

JOIN dim_date d
ON d.full_date = make_date(cd.flight_year, cd.flight_month, cd.day_of_month)
JOIN dim_carrier c
ON c.carrier_code = cd.unique_carrier
JOIN dim_airport ao
ON ao.airport_code = cd.origin
JOIN dim_airport ad
ON ad.airport_code = cd.dest;

#Indexes to make the queries smoother

CREATE INDEX idx_fact_date    ON fact_flights(date_id);
CREATE INDEX idx_fact_carrier ON fact_flights(carrier_id);
CREATE INDEX idx_fact_origin  ON fact_flights(origin_airport_id);
CREATE INDEX idx_fact_dest    ON fact_flights(dest_airport_id);

