DELETE FROM VISITS;
DELETE FROM ROUTE;
DELETE FROM BUS_STOP;

INSERT INTO BUS_STOP
	(stopId, street1, street2)
VALUES
	(100001, '1st Street', NULL),
	(100002, '2nd Street', NULL),
	(100003, '3rd Street', NULL),
	(100004, '4th Street', NULL),
	(100005, '5th Street', NULL),
	(100006, '6th Street', NULL),
	(100007, '7th Street', NULL),
	(100008, '8th Street', NULL);

INSERT INTO ROUTE
	(routeID, routeName, S_firstStop, S_lastStop)
VALUES
	(101, 'Redmond', 100001, 100006),
	(102, 'Bellevue', 100007, 100008);

INSERT INTO VISITS
	(R_routeId, R_routeName, S_stopID, typeOfDay, arrivalTime, departTime)
VALUES
	(101, 'Redmond', 100001, 'Weekday', '12:00:00', '12:00:01'),
	(101, 'Redmond', 100002, 'Weekday', '12:00:05', '12:00:06'),
	(101, 'Redmond', 100003, 'Weekday', '12:00:10', '12:00:11'),
	(101, 'Redmond', 100004, 'Weekday', '12:00:15', '12:00:16'),
	(101, 'Redmond', 100005, 'Weekend', '12:00:00', '12:00:05'),
	(101, 'Redmond', 100006, 'Weekend', '12:00:10', '12:00:15'),
	(102, 'Bellevue', 100007, 'Weekday', '12:00:00', '12:00:01'),
	(102, 'Bellevue', 100008, 'Weekday', '12:00:05', '12:00:06');
	

SELECT v.arrivalTime, v.S_stopID
FROM VISITS v, ROUTE r
where v.R_routeID = r.routeID
	AND r.routeID = 101
	AND r.routeName = 'Redmond'
	AND v.typeOfDay = 'Weekday'
ORDER BY v.arrivalTime ASC;

DELETE FROM VISITS;
DELETE FROM ROUTE;
DELETE FROM BUS_STOP;