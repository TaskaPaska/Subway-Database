-- Inserting 2-3 sample data rows into each table.

INSERT INTO subway.line (line_name, required_trains, required_employees)
SELECT line_name, required_trains, required_employees
FROM (SELECT 'Liberty Square' AS line_name, 20 AS required_trains, 10 AS required_employees
	  UNION ALL
      SELECT 'Station Square', 20, 11
) AS new_lines
WHERE NOT EXISTS (
    SELECT 1 FROM subway.line WHERE new_lines.line_name = subway.line.line_name
);



INSERT INTO subway.train (line_id, headcode, model, manufacturer, status)
SELECT line_id, headcode, model, manufacturer, status
FROM (
	SELECT 1 AS line_id, '1A01' AS headcode, 'HO Scale' AS model, 'Transmashholding (TMH)' AS manufacturer, 'Active' AS status
	UNION ALL 
	SELECT 2, '3Q04', 'HO Scale', 'Transmashholding (TMH)', 'Active'
) AS new_trains
WHERE NOT EXISTS (
    SELECT 1 FROM subway.train WHERE subway.train.headcode = new_trains.headcode
);



INSERT INTO subway.station (line_id, station_name, station_lat, station_lon, capacity)
SELECT line_id, station_name, station_lat, station_lon, capacity
FROM (
	SELECT (SELECT line_id FROM subway.line WHERE line_name = 'Liberty Square') AS line_id, 
		    'Grand Central' AS station_name, 
		    40.6892 AS station_lat, 
		    -74.0445 AS station_lon, 
		    200 AS capacity
	UNION ALL 
	SELECT (SELECT line_id FROM subway.line WHERE line_name = 'Liberty Square'), 
	        'National Theatre', 
	        42.1234, 
	        -72.0473, 
	        200
	UNION ALL 
	SELECT (SELECT line_id FROM subway.line WHERE line_name = 'Liberty Square'),
		    'Riverfront Station', 
		    43.1234, 
		    -70.0938, 
		    200
) AS new_stations
WHERE NOT EXISTS (
	SELECT 1 FROM subway.station WHERE UPPER(subway.station.station_name) = UPPER(new_stations.station_name)
);



INSERT INTO subway.line_station (line_id, station_id, sequence_number)
SELECT line_id, station_id, sequence_number
FROM (
	SELECT (SELECT line_id FROM subway.line WHERE line_name = 'Liberty Square') AS line_id, 
		   (SELECT station_id FROM subway.station WHERE station_name = 'Grand Central') AS station_id, 
		    1 AS sequence_number
	
	UNION ALL 
	SELECT (SELECT line_id FROM subway.line WHERE line_name = 'Liberty Square'), 
		   (SELECT station_id FROM subway.station WHERE station_name = 'National Theatre'),
		    2
	UNION ALL 
	SELECT (SELECT line_id FROM subway.line WHERE line_name = 'Liberty Square'), 
		   (SELECT station_id FROM subway.station WHERE station_name = 'Riverfront Station'),
		    3
) AS new_line_station
WHERE NOT EXISTS (
	SELECT 1 
	FROM subway.line_station 
	WHERE new_line_station.line_id = subway.line_station.line_id
	AND new_line_station.station_id = subway.line_station.station_id
	AND new_line_station.sequence_number = subway.line_station.sequence_number
);



INSERT INTO subway.train_schedule (train_id, station_id, arrival_datetime, departure_datetime, line_station_id)
SELECT train_id, station_id, arrival_datetime, departure_datetime, line_station_id
FROM (
SELECT (SELECT train_id FROM subway.train WHERE headcode = '1A01') AS train_id, 
	   (SELECT station_id FROM subway.station WHERE station_name = 'Riverfront Station') AS station_id, 
	   '2023-12-18 09:00:00'::timestamp AS arrival_datetime, 
	   '2023-12-18 09:30:00'::timestamp AS departure_datetime,
	   2 AS line_station_id
UNION ALL 
SELECT (SELECT train_id FROM subway.train WHERE headcode = '3Q04'), 
	   (SELECT station_id FROM subway.station WHERE station_name = 'Grand Central'), 
	   '2023-12-18 08:00:00'::timestamp, 
	   '2023-12-18 08:30:00'::timestamp, 
	   1
) AS new_train_schedule
WHERE NOT EXISTS (
    SELECT 1 FROM subway.train_schedule
    WHERE subway.train_schedule.train_id = new_train_schedule.train_id
    AND subway.train_schedule.station_id = new_train_schedule.station_id
    AND subway.train_schedule.arrival_datetime = new_train_schedule.arrival_datetime
    AND subway.train_schedule.departure_datetime = new_train_schedule.departure_datetime
    AND subway.train_schedule.line_station_id = new_train_schedule.line_station_id
);



INSERT INTO subway.promotion (promotion_name, start_date, end_date, discount_amount)
SELECT promotion_name, start_date, end_date, discount_amount 
FROM (
	SELECT 'Summer Sale' AS promotion_name, DATE '2023-06-01' AS start_date, DATE '2023-06-30' AS end_date, 15.00 AS discount_amount
	UNION ALL
	SELECT 'Holiday Discount', DATE '2023-12-15', DATE '2023-12-31', 10.00
) AS new_promotion
WHERE NOT EXISTS (
    SELECT 1 FROM subway.promotion 
    WHERE subway.promotion.promotion_name = new_promotion.promotion_name
    AND subway.promotion.start_date = new_promotion.start_date
    AND subway.promotion.end_date = new_promotion.end_date
);



INSERT INTO subway.ticket (ticket_type, price)
SELECT ticket_type, price
FROM (
SELECT 'Standard' AS ticket_type, 50.00 AS price
UNION ALL
SELECT 'Premium', 100.00
) AS new_ticket
WHERE NOT EXISTS (
    SELECT 1 FROM subway.ticket WHERE subway.ticket.ticket_type = new_ticket.ticket_type 
    						      AND subway.ticket.price = new_ticket.price
);


INSERT INTO subway.transaction_table (ticket_id, promotion_id, station_id, quantity, purchase_datetime, total_price)
SELECT *
FROM (
    SELECT 
        t.ticket_id,
        p.promotion_id,
        (SELECT station_id FROM subway.station WHERE station_name = 'Grand Central') AS station_id,
        3 AS quantity,
        CURRENT_TIMESTAMP AS purchase_datetime,
        t.price * 3 * (1 - p.discount_amount / 100.0) AS total_price
    FROM 
        subway.ticket t
    JOIN 
        subway.promotion p ON t.ticket_id = p.promotion_id
) AS new_transaction
WHERE NOT EXISTS (
    SELECT 1 
    FROM subway.transaction_table tt 
    WHERE tt.ticket_id = new_transaction.ticket_id 
    AND tt.promotion_id = new_transaction.promotion_id 
    AND tt.station_id = new_transaction.station_id 
    AND tt.quantity = new_transaction.quantity
)
LIMIT 2;



INSERT INTO subway.maintenance_type (maintenance_type, description)
SELECT maintenance_type, description
FROM (
    SELECT 'Emergency' AS maintenance_type, 'The object required emergency maintenance works.' AS description
    UNION ALL
    SELECT 'Routine Yearly', 'Mandatory routine yearly maintenance work.'
) AS new_maintenance_types
WHERE NOT EXISTS (
    SELECT 1 FROM subway.maintenance_type mt
    WHERE mt.maintenance_type = new_maintenance_types.maintenance_type
      AND mt.description = new_maintenance_types.description
);



INSERT INTO subway.tunnel (start_station_id, end_station_id)
SELECT start_station_id, end_station_id
FROM (
    SELECT (SELECT station_id FROM subway.station WHERE station_name = 'Grand Central') AS start_station_id, 
    	   (SELECT station_id FROM subway.station WHERE station_name = 'National Theatre') AS end_station_id
    UNION ALL
    SELECT (SELECT station_id FROM subway.station WHERE station_name = 'National Theatre'),
    	   (SELECT station_id FROM subway.station WHERE station_name = 'Riverfront Station')
) AS new_tunnels
WHERE NOT EXISTS (
    SELECT 1 FROM subway.tunnel t
    WHERE (t.start_station_id, t.end_station_id) = (new_tunnels.start_station_id, new_tunnels.end_station_id)
);



INSERT INTO subway.track (start_station_id, end_station_id, direction)
SELECT start_station_id, end_station_id, direction
FROM (
    SELECT 1 AS start_station_id, 2 AS end_station_id, 'north' AS direction
    UNION ALL
    SELECT 2, 3, 'south'
) AS new_tracks
WHERE NOT EXISTS (
    SELECT 1 FROM subway.track t
    WHERE t.start_station_id = new_tracks.start_station_id
      AND t.end_station_id = new_tracks.end_station_id
      AND t.direction = new_tracks.direction
);



INSERT INTO subway.object_maintenance (maintenance_id, train_id, track_id, station_id, tunnel_id, start_date, end_date, cost, description)
SELECT maintenance_id, 
       train_id, 
       track_id, 
       station_id, 
       tunnel_id, 
       start_date, 
       end_date, 
       cost, 
       description
FROM (
    SELECT (SELECT maintenance_id FROM subway.maintenance_type WHERE maintenance_type = 'Emergency') AS maintenance_id, 
           NULL::INT AS train_id, -- Casted these NULLS explicitly as INTs, as after UNION it was associated with TEXT 
           NULL::INT AS track_id, 
           (SELECT station_id FROM subway.station WHERE station_name = 'Grand Central') AS station_id, 
           NULL::INT AS tunnel_id, 
           DATE '2023-12-01' AS start_date, 
           DATE '2023-12-10' AS end_date, 
           100.00 AS cost, 
           NULL AS description
    UNION ALL
    SELECT (SELECT maintenance_id FROM subway.maintenance_type WHERE maintenance_type = 'Emergency'), 
           NULL::INT, 
           NULL::INT, 
           (SELECT station_id FROM subway.station WHERE station_name = 'National Theatre') AS station_id,  
           NULL::INT, 
           DATE '2023-12-15', 
           DATE '2023-12-25', 
           150.00, 
           NULL
) AS new_maintenance
WHERE NOT EXISTS (
    SELECT 1 FROM subway.object_maintenance om
    WHERE om.maintenance_id = new_maintenance.maintenance_id
      AND om.station_id = new_maintenance.station_id
      AND om.start_date = new_maintenance.start_date
      AND om.end_date = new_maintenance.end_date
);
