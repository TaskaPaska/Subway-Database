
-- Adding the record_ts columns, checking if the addition was successful for each table.


ALTER TABLE subway.train
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

SELECT * FROM subway.train WHERE record_ts IS NULL;

ALTER TABLE subway.train_schedule
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

SELECT * FROM subway.train_schedule WHERE record_ts IS NULL;

ALTER TABLE subway.promotion
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

SELECT * FROM subway.promotion WHERE record_ts IS NULL;

ALTER TABLE subway.ticket
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

SELECT * FROM subway.ticket WHERE record_ts IS NULL;

ALTER TABLE subway.transaction_table
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

SELECT * FROM subway.transaction_table WHERE record_ts IS NULL;

ALTER TABLE subway.line
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

SELECT * FROM subway.line WHERE record_ts IS NULL;

ALTER TABLE subway.station
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

SELECT * FROM subway.station WHERE record_ts IS NULL;

ALTER TABLE subway.line_station
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

SELECT * FROM subway.line_station WHERE record_ts IS NULL;

ALTER TABLE subway.object_maintenance
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

SELECT * FROM subway.object_maintenance WHERE record_ts IS NULL;

ALTER TABLE subway.maintenance_type
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

SELECT * FROM subway.maintenance_type WHERE record_ts IS NULL;

ALTER TABLE subway.track
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

SELECT * FROM subway.track WHERE record_ts IS NULL;

ALTER TABLE subway.tunnel
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

SELECT * FROM subway.tunnel WHERE record_ts IS NULL;
