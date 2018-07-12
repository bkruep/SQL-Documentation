--SELECTS ALL THE ROWS FROM THE COUNTRY TABLE, SELECTED IN ORDER BY NAME 
SELECT * FROM COUNTRY ORDER BY Name;

--SELECTS THE NAME AND LIFE EXPECTANCY ROWS OF THE COUNTRY TABLE, ORDERED BY NAME, AND SETS THE LIFEEXPECTANCY COLUMN NAME TO 'LIFE EXPECTANCY'
SELECT NAME, LIFEEXPECTANCE AS 'LIFE EXPECTANCY' FROM COUNTRY ORDER BY NAME;

--SELECT STATEMENT THAT RETURNS AN ADDITION
SELECT 1 + 2;

--COUNTS THE ROWS IN A TABLE
SELECT COUNT(*) FROM COUNTRY;

--SELECTS SPECIFIC COLUMNS IN A TABLE FOR ONLY COUNTRIES IN EUROPE AND SETS THE LIMIT OF ROWS RETURNED TO 5
SELECT NAME, CONTINENT, REGION, FROM COUNTRY WHERE CONTINENT = 'EUROPE' LIMIT 5;

--SELECTS ALL THE COLUMNS IN THE COUNTRY CODE BUT LIMIT TO 5 ROWS
SELECT * FROM COUNTRY ORDER BY CODE LIMIT 5;

--SELECTS SPECIFIC ROWS AND RENAMES COLUMN HEADERS FROM COUNTRY TABLE...ORDER IS BY CODE WITH THE MAX LIMIT OF 5
SELECT  NAME COUNTRY, CODE ISO, REGION, POPULATION POP FROM COUNTRY ORDER BY CODE LIMIT 5;

--CALCULATES NUMBER OF ROWS IN A TABLE
SELECT COUNT(*) FROM COUNTRY;

--ANOTHER EXAMPLE OF THE COUNT 
SELECT COUNT(*) FROM COUNTRY WHERE POPULATION > 1000000 AND CONTINENT = 'EUROPE';

--INSERT statement into the CUSTOMERS table
INSERT INTO CUSTOMER(name, address, city, state, zip) VALUES ('Fred Flintstone', '123 Cobblestone Way', 'Bedrock', 'CA', '91234');

--UPDATE statement...Updates the 5th record
UPDATE Customer SET Address = '123 Music Avenue', zip = NULL WHERE id = 5; 

--DELETE statement...Deleted the 4th record
DELETE FROM Customer WHERE id = 4;

--Creating tables
Create TABLE test (
	a INTEGER,
	b TEXT
);
INSERT INTO test VALUES (1, 'a');
INSERT INTO test VALUES (2, 'b');
INSERT INTO test VALUES (3, 'c');

--Deleting a table with DROP TABLE
Create TABLE test (a TEXT, b TEXT);
INSERT INTO test VALUES ('one', 'two');
DROP TABLE IF EXISTS test; 

--Insert rows in a table
CREATE TABLE test (a INTEGER, b TEXT, c TEXT);
INSERT INTO test VALUES(1, 'This', 'Right here!');
--or....Inserts all rows from the item table
INSERT INTO test (a, b, c) SELECT id, name, description FROM item;

--Deleting rows from a table
DELETE FROM test WHERE A=3;

--Testing NULL where a = NULL
SELECT * FROM test WHERE a IS NULL

--Testing NULL where a does not equal NULL
SELECT * FROM test WHERE a IS NOT NULL

--Create a table with no NULL values for a or b 
CREATE TABLE test (
	a INTEGER NOT NULL,
	b TEXT NOT NULL,
	c TEXT
);
INSERT INTO test VALUES (1, 'this', 'that');

--Creates a table with 'a' being unqieue and 'c' having a default value of panda 
CREATE TABLE test (a TEST UNIQUE, b TEXT, c TEXT DEFAULT 'panda');
INSERT INTO test (a, b) VALUES ('one', 'two');

--Changing a schema with ALTER 
CREATE TABLE test (a TEXT, b TEXT, c TEXT);
INSERT INTO test VALUES ('one', 'two', 'three');
INSERT INTO test VALUES ('two', 'three', 'four');
INSERT INTO test VALUES ('three', 'four', 'five');
ALTER TABLE test ADD d TEXT DEFAULT 'panda';
DROP TABLE test;

--Creating an ID column
CREATE TABLE test (
	id INTEGER PRIMARY KEY,
	a INTEGER,
	b TEXT
)
INSERT INTO test (a, b) VALUES (10, 'a');
INSERT INTO test (a, b) VALUES (11, 'b');
INSERT INTO test (a, b) VALUES (12, 'c');

--Find countries with a population less than 100000 or UNKNWON and order from greatest to least
SELECT Name, Continent, Population FROM Country WHERE Population < 10000 OR Population IS NULL ORDER BY Population DESC;

--Finds countries that have 'island' in their name 
SELECT Name, Continent, Population FROM Country WHERE Name LIKE '%island%' ORDER BY Name;

--Finds countries that have 'island' at the end of their name 
SELECT Name, Continent, Population FROM Country WHERE Name LIKE '%island' ORDER BY Name;

--Finds countries that have 'a' as the second character in the country name  
SELECT Name, Continent, Population FROM Country WHERE Name LIKE '_a%' ORDER BY Name;

--Finds countries that have 'a' as the second character in the country name  
SELECT Name, Continent, Population FROM Country WHERE Continent IN ('Europe', 'Asia') ORDER BY Name;

--SELECT DISTINCT - DISTINCT removes duplicates
SELECT DISTINCT Continent FROM Country;
CREATE TABLE test (a INT, b INT);
INSERT INTO test VALUES (1, 1);
INSERT INTO test VALUES (2, 1);
INSERT INTO test VALUES (3, 1);
INSERT INTO test VALUES (4, 1);
INSERT INTO test VALUES (5, 1);
INSERT INTO test VALUES (1, 2);
INSERT INTO test VALUES (1, 2);
INSERT INTO test VALUES (1, 2);
INSERT INTO test VALUES (1, 2);
INSERT INTO test VALUES (1, 2);
--Search just the first six rows
SELECT DISTINCT a, b FROM test;

--Sorting ORDER BY in reverse order--Order by Name within the Continent
Select Name, Continent, Region FROM Country ORDER BY Continent DESC, Name;

--Conditional Expression 
CREATE TABLE booltest (a INTEGER, b INTEGER);
INSERT INTO booltest VALUES (1, 0);
SELECT * FROM booltest;
SELECT 
	CASE WHEN a THEN 'true' ELSE 'false' END as boolA,
	CASE WHEN b THEN 'TRUE' else 'false' END as BOOLb
	FROM booltest
;

--JOIN clause
SELECT * FROM left;
SELECT * FROM right;
SELECT l.description AS left, r.description AS rgiht
	FROM left AS l 
	JOIN right AS record
		ON l.id = r.id;

--SIMPLE JOIN 
SELECT c.name AS Cust, i.name AS Item, s.price AS Price
	FROM customer AS c
	JOIN sale AS s ON s.customer_id = c.id
	JOIN item AS i ON s.item_id = i.id
	ORDER BY Cust, Item
;

--LEFT JOIN...LEFT JOIN TAKES ALL ROWS FROM THE LEFT TABLE PLUS THE ROWS FROM THE RIGHT TABLE THAT ARE JOINED WITH THE LEFT TABLE 
INSERT INTO customer (name) VALUES ('Jane Smith');
SELECT c.name AS Cust, i.name AS Item, s.price AS Price
	FROM customer AS c
	LEFT JOIN sale AS s ON s.customer_id = c.id
	LEFT JOIN item AS i ON s.item_id = i.id
	ORDER BY Cust, Item

--Finding the length of a string 
SELECT LENGTH('string');
SELECT Name, LENGTH(Name) AS Len FROM City ORDER BY Len DESC, Name;

--Selecting part of string...starts with the 6 position
SELECT SUBSTR('this string', 6);
--First number is the position and the second number is how many characters to use
SLEECT released, 
		SUBSTR(released, 1, 4) AS year,
		SUBSTR(released, 6, 2) AS month,
		SUBSTR(released, 9, 2) AS day,
		FROM album
	ORDER BY released

--Removing spaces with TRIM 
SELECT TRIM'   string   ';
--Removes spaces from just the left side
SELECT LTRIM'   string   ';
--Removes spaces from just the right side
SELECT RTRIM'   string   ';
--Can trim characters such as periods
SELECT TRIM('...string...', '.');

--Making strings uppercase and lowercase...convers the string to all upper or lower case (lower in the example below)
SELECT LOWER('StRiNg') = LOWER('string');

--Finding the type of a value...TYPEOF returns real in case below
SELECT TYPEOF(1 + 1.0);

--Integer division and remainders
SELECT CAST(1, AS REAL) / 2;
--OR
SELECT 1 / 2;
--Division with the remainders
SELECT 17 / 5, 17 % 5;

--ROUNDING NUMBERS....Rounds the third digit in the example below 
SELECT ROUND(2.55555, 3);

--Date and time related functions
SELECT DATETIME('now');
--Can return just the time or just the date
SELECT TIME('now');
SELECT DATE('now');
--Adds 1 day to the current date and time 
SELECT DATETIME('now', '+1 day');
--Subtract 1 month from the current date and time 
SELECT DATETIME('now', '-1 month');
--Can do any kind of calculation
SELECT DATETIME('now', '+3 hours', '+27 minutes', '-1 day', '+3 years');

--HOW AGGREGATES WORK
Select Region (COUNT(*)
	FROM Country 
	GROUP BY Region 
	ORDER BY ROUND DESC, Region;

--Another Example 
SELECT a.title as Album, COUNT(t.track_number) as Tracks
	FROM track as t 
	JOIN album as a 
		ON a.id = t.album_id
	GROUP BY a.id
	HAVING Tracks >= 10 --Works on aggregate date; WHERE is on non-aggregate data
	ORDER BY Tracks DESC, Album 

--Counts the rows with a population
SELECT COUNT(Population) FROM Country;

--Shows the region and the average population of each region 
SELECT Region, AVG(Population) FROM Country GROUP BY Region;

--Show the minimum and maximum population for each region 
SELECT Region, MIN(Population), MAX(Population) FROM Country GROUP BY Region;

--Show the SUM aggregate function
SELECT Region, SUM(Population) FROM Country GROUP BY Region;

--Distinct in aggregate function
SELECT COUNT(DISTINCT HeadOfState) FROM Country;

--ROLLBACK statement;
--restores the statement without committing

--TRIGGERS
--Updating a table with a trigger
CREATE TRIGGER newWidgetSale AFTER INSERT ON widgetSale
	BEGIN
		UPDATE widgetCustomer SET last_order_id = NEW.id WHERE widgetCustomer.id = NEW.customer_id;
	END;
	
--Prevent automatic updates with a trigger
CREATE TRIGGER updateWidgeSale BEFORE UPDATE ON widgetSale
	BEGIN 
		SELECT RAISE(ROLLBACK, 'cannot update table "widgetSale"') FROM widgetSale
			WHERE id = NEW.id and reconciled = 1;
	END;
	
--Automating timestamps with triggers 
CREATE TRIGGER stampSale AFTER INSERT ON widgetSale 
	BEGIN 
		UPDATE widgetSale SET stamp = DATETIME('now') WHERE id = NEW.id;
		UPDATE widgetCustomer SET last_order_id = NEW.id, stamp = DATETIME('now')
			WHERE widgetCustomer.id = New.customer_id;
		INSERT INTO widgetLog (stamp, event, username, tablename, table_id)
			VALUES (DATETIME('now'), 'INSERT', 'TRIGGER', 'widgetSale', NEW.id);

--SUBSELECTS AND VIEWS 
--Creating a simple subselect
SELECT co.Name, ss.CCode FROM (
	SELECT SUBSTR(a, 1, 2) AS State, SUBSTR(a, 3) AS SCode,
		SUBSTR(b, 1, 2) AS Country, SUBSTR(B, 3) AS CCode 
	FROM t
	) AS ss 
	JOIN Country AS co 
		ON co.Code2 = ss.Country;
		
--Searching within a result set 
SELECT * FROM album WHERE id IN (
	SELECT DISTINCT album_id FROM track WHERE duration <= 90
);
--Another example
SELECT a.title AS album, a.artist, t.track_number AS sql, t.tile, t.duration AS secs
	FROM album AS a 
	JOIN track AS table
		ON t.album_id = a.id
	WHERE a.id IN (SELECT DISTINCT album_id FROM track WHERE duration <= 90)
	ORDER BY a.title, t.track_number
;

--Creating a view - views are select statement stored in datebase that are frequently used
CREATE VIEW trackView AS 
	SELECT id, album_id, title, track_number, duration / 60 AS m, duration % 60 AS s FROM track;
SELECT * FROM trackView;

--Using view as if it were the original SELECT statement 
SELECT a.title AS album, a.artist, t.track_number AS seq, t.itle, t.m, t.sale
	FROM album AS address
	JOIN trackView AS table
		ON t.album_id = a.id
	ORDER BY a.title, t.track_number;