DROP DATABASE IF EXISTS subway;
CREATE DATABASE subway;
DROP SCHEMA IF EXISTS subway CASCADE;
CREATE SCHEMA subway;


-- Creating tables.

DROP TABLE IF EXISTS subway.line CASCADE;
CREATE TABLE subway.line (
	line_id SERIAL PRIMARY KEY,
	line_name VARCHAR(50) UNIQUE,
	required_trains INT CHECK (required_trains >= 0), -- inserted measured value that cannot be negative
	required_employees INT CHECK (required_employees >= 0) -- inserted measured value that cannot be negative 
);

DROP TABLE IF EXISTS subway.train CASCADE;
CREATE TABLE subway.train (
    train_id SERIAL PRIMARY KEY,
    line_id INT REFERENCES subway.line(line_id),
    headcode VARCHAR(50) UNIQUE,
    model VARCHAR(50),
    manufacturer VARCHAR(50),
    status VARCHAR(20) CHECK (status IN ('Active', 'Inactive', 'Maintenance')) -- inserted value that can only be a specific value
);

DROP TABLE IF EXISTS subway.station CASCADE;
CREATE TABLE subway.station (
    station_id SERIAL PRIMARY KEY,
    line_id INT REFERENCES subway.line(line_id),
    station_name VARCHAR(50) UNIQUE,
    station_lat DECIMAL(10, 6) CHECK (station_lat >= -90 AND station_lat <= 90), -- latitude IS ALWAYS BETWEEN -90 AND 90
    station_lon DECIMAL(10, 6) CHECK (station_lon >= -180 AND station_lon <= 180), -- FOR longitude its -180 AND 180
    capacity INT CHECK (capacity >= 0) -- cannot be negative 
);

DROP TABLE IF EXISTS subway.line_station CASCADE;
CREATE TABLE subway.line_station (
	line_station_id SERIAL PRIMARY KEY,
	line_id INT REFERENCES subway.line(line_id),
	station_id INT REFERENCES subway.station(station_id),
	sequence_number INT NOT NULL, -- Can not be NULL 
	UNIQUE (line_id, station_id, sequence_number) -- Each station has only one sequence number in a single line.
);

DROP TABLE IF EXISTS subway.train_schedule CASCADE;
CREATE TABLE subway.train_schedule (
    train_schedule_id SERIAL PRIMARY KEY,
    train_id INT REFERENCES subway.train(train_id),
    station_id INT REFERENCES subway.station(station_id),
    arrival_datetime TIMESTAMP,
    departure_datetime TIMESTAMP,
    line_station_id INT REFERENCES subway.line_station(line_station_id)
);

DROP TABLE IF EXISTS subway.promotion CASCADE;
CREATE TABLE subway.promotion (
    promotion_id SERIAL PRIMARY KEY,
    promotion_name VARCHAR(50) UNIQUE,
    start_date DATE CHECK (start_date > DATE '2000-01-01'), -- Inserted dates must be greater than January 1, 2000
    end_date DATE CHECK (end_date > DATE '2000-01-01'),
    discount_amount DECIMAL (10,2) NOT NULL,
    CONSTRAINT valid_date_range CHECK (start_date <= end_date)
);

DROP TABLE IF EXISTS subway.ticket CASCADE;
CREATE TABLE subway.ticket (
    ticket_id SERIAL PRIMARY KEY,
    ticket_type VARCHAR(50) UNIQUE,
    price DECIMAL(10, 2) CHECK (price >= 0)
);

DROP TABLE IF EXISTS subway.transaction_table CASCADE;
CREATE TABLE subway.transaction_table (
    transaction_id SERIAL PRIMARY KEY,
    ticket_id INT REFERENCES subway.ticket(ticket_id),
    promotion_id INT REFERENCES subway.promotion(promotion_id),
    station_id INT REFERENCES subway.station(station_id),
    quantity INT CHECK (quantity > 0), -- Quantity can NOT be negative
    purchase_datetime TIMESTAMP,
    total_price DECIMAL(10, 2)
);

DROP TABLE IF EXISTS subway.maintenance_type CASCADE;
CREATE TABLE subway.maintenance_type (
    maintenance_id SERIAL PRIMARY KEY,
    maintenance_type VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(100)
);

DROP TABLE IF EXISTS subway.tunnel CASCADE;
CREATE TABLE subway.tunnel (
    tunnel_id SERIAL PRIMARY KEY,
    start_station_id INT REFERENCES subway.station(station_id),
    end_station_id INT REFERENCES subway.station(station_id)
);

DROP TABLE IF EXISTS subway.track CASCADE;
CREATE TABLE subway.track (
    track_id SERIAL PRIMARY KEY,
    start_station_id INT REFERENCES subway.station(station_id),
    end_station_id INT REFERENCES subway.station(station_id),
    direction VARCHAR(10) CHECK (direction IN ('north', 'south', 'east', 'west')) -- direction has TO be one OF the four pre-determined values
);

DROP TABLE IF EXISTS subway.object_maintenance CASCADE;
CREATE TABLE subway.object_maintenance (
    object_maintenance_id SERIAL PRIMARY KEY,
    maintenance_id INT REFERENCES subway.maintenance_type(maintenance_id) NOT NULL,
    train_id INT REFERENCES subway.train(train_id),
    track_id INT REFERENCES subway.track(track_id),
    station_id INT REFERENCES subway.station(station_id),
    tunnel_id INT REFERENCES subway.tunnel(tunnel_id),
    start_date DATE,
    end_date DATE,
    cost DECIMAL(10, 2) DEFAULT 0.0,
    description VARCHAR(100),
    CHECK (
        CASE WHEN train_id IS NOT NULL THEN 1 ELSE 0 END +
        CASE WHEN track_id IS NOT NULL THEN 1 ELSE 0 END +
        CASE WHEN station_id IS NOT NULL THEN 1 ELSE 0 END +
        CASE WHEN tunnel_id IS NOT NULL THEN 1 ELSE 0 END = 1
    ) -- Only one of the IDs should be NOT NULL, as each maintenance record here relates to a single object
);
