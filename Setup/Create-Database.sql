drop database if exists CBS;
create database CBS;
use CBS;

DROP TABLE IF EXISTS EMPLOYEE;
DROP TABLE IF EXISTS ADDRESS;
DROP TABLE IF EXISTS BUS;
DROP TABLE IF EXISTS CARD;
DROP TABLE IF EXISTS TAPS;
DROP TABLE IF EXISTS FARE_TIER;
DROP TABLE IF EXISTS BUS_STOP;
DROP TABLE IF EXISTS ROUTE;
DROP TABLE IF EXISTS VISITS;
DROP TABLE IF EXISTS SCHEDULED;

CREATE TABLE EMPLOYEE (
    ssn INT(9) NOT NULL UNIQUE,
    Fname VARCHAR(15) NOT NULL,
    Minit VARCHAR(2) DEFAULT NULL,
    Lname VARCHAR(15) NOT NULL,
    startDate DATE,
    supervisor INT(9) DEFAULT NULL,
    PRIMARY KEY (ssn),
    FOREIGN KEY (supervisor)
        REFERENCES EMPLOYEE (ssn) ON DELETE SET NULL -- ON UPDATE CASCADE
);

CREATE TABLE ADDRESS (
    E_ssn INT(9) NOT NULL UNIQUE,
    street VARCHAR(20) NOT NULL,
    city VARCHAR(30) NOT NULL,
    state CHAR(2) NOT NULL,
    zip CHAR(5) NOT NULL,
    PRIMARY KEY (E_ssn),
    CONSTRAINT address_ssn FOREIGN KEY (E_ssn)
        REFERENCES EMPLOYEE (ssn) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ValidStates CHECK(state IN('AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS',
                     'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY',
                     'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV',
                     'WI', 'WY', 'DC'))
);

CREATE TABLE BUS (
    busID INT(5) NOT NULL,
    capacity INT(3) DEFAULT 1,
    manufactured_date DATE,
    E_driver INT(9) UNIQUE DEFAULT NULL,
    PRIMARY KEY (busID),
    FOREIGN KEY (E_driver)
        REFERENCES EMPLOYEE (ssn) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE TABLE FARE_TIER (
    tier INT(2) NOT NULL,
    cost FLOAT(4 , 2 ) NOT NULL,
    fareName VARCHAR(9) DEFAULT NULL,
    PRIMARY KEY (tier)
);
CREATE TABLE CARD (
    cardNum INT(9) AUTO_INCREMENT NOT NULL,
    balance FLOAT(6,2) DEFAULT 0,
    expiry_date DATE,
    F_fare INT(2) NOT NULL DEFAULT 5,
    PRIMARY KEY (cardNum),
    CONSTRAINT card_fare FOREIGN KEY (F_fare)
        REFERENCES FARE_TIER (tier) ON DELETE RESTRICT  ON UPDATE CASCADE
);
ALTER TABLE CARD AUTO_INCREMENT = 100000000;
CREATE TABLE TAPS (
    B_busID INT(5) NOT NULL,
    C_cardNum INT(9) NOT NULL,
    time_stamp DATETIME NOT NULL,
    PRIMARY KEY (B_busID , C_cardNum , time_stamp),
    CONSTRAINT tap_bus FOREIGN KEY (B_busID)
        REFERENCES BUS (busID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT tap_card FOREIGN KEY (C_cardNum)
        REFERENCES CARD (cardNum) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE BUS_STOP (
    stopID INT(6) NOT NULL,
    street1 VARCHAR(30) NOT NULL,
    street2 VARCHAR(30) DEFAULT NULL,
    PRIMARY KEY (stopID)
);
CREATE TABLE ROUTE (
    routeID INT(3) NOT NULL,
    routeName VARCHAR(20) NOT NULL,
    S_firstStop INT(6) NOT NULL,
    S_lastStop INT(6) NOT NULL,
    KEY (routeName),
    PRIMARY KEY (routeID, routeName),
    CONSTRAINT route_firstStop FOREIGN KEY (S_firstStop)
        REFERENCES BUS_STOP (stopID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT route_lastStop FOREIGN KEY (S_lastStop)
        REFERENCES BUS_STOP (stopID) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE VISITS (
    R_routeID INT(3) NOT NULL,
    R_routeName VARCHAR(20) NOT NULL,
    S_stopID INT(6) NOT NULL,
    typeOfDay VARCHAR(10) NOT NULL DEFAULT 'Weekday',
    arrivalTime TIME NOT NULL,
    departTime TIME NOT NULL,
    PRIMARY KEY (R_routeID, S_stopID, typeOfDay),
CONSTRAINT visit_routeID FOREIGN KEY (R_routeID)
        REFERENCES ROUTE (routeID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT visit_routeName FOREIGN KEY (R_routeName)
        REFERENCES ROUTE (routeName) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT visit_stopID FOREIGN KEY (S_stopID)
        REFERENCES BUS_STOP (stopID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT dayTypes CHECK(typeOfDay IN('Weekday', 'Weekend', 'Holiday', 'Snow'))
);
CREATE TABLE SCHEDULED (
    R_routeID INT(3) NOT NULL,
    R_routeName VARCHAR(20) NOT NULL,
    B_busID INT(5),
    timeStart DATETIME,
    timeEnd DATETIME,
    PRIMARY KEY (R_routeID, R_routeName, B_busID),
    CONSTRAINT scheduled_routeID FOREIGN KEY (R_routeID)
        REFERENCES ROUTE (routeID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT scheduled_routeName FOREIGN KEY (R_routeName)
        REFERENCES ROUTE (routeName) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT scheduled_busID FOREIGN KEY (B_busID)
        REFERENCES BUS (busID) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO FARE_TIER (tier, cost, fareName)
VALUES (1, 1, 'Veteran');

INSERT INTO FARE_TIER (tier, cost, fareName)
VALUES (2, 1, 'Disabled');

INSERT INTO FARE_TIER (tier, cost, fareName)
VALUES (3, 1.5, 'Student');

INSERT INTO FARE_TIER (tier, cost, fareName)
VALUES (4, 1.5, 'Child');

INSERT INTO FARE_TIER (tier, cost, fareName)
VALUES (5, 2.75, 'Adult');

INSERT INTO FARE_TIER (tier, cost, fareName)
VALUES (6, 1, 'Senior');

