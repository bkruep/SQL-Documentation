--SQL:
	--Language to operate databases
	--Stores, manipulates, and retrieves data stored in a relational database

	--Commands
		--CREATE
			--Creates a new table, view of a table, or other object in the database.
		--ALTER
			--Modifies an existing database object, such as a table.
		--DROP
			--Deleted an entire table, a view of a table or other objects in the database.
		--SELECT
			--Retrieves certain records from one or more tables.
		--INSERT
			--Creates a record.
		--UPDATE
			--Modifies records.
		--DELETE
			--Deletes records.
		--GRANT
			--Gives a privilege to user.
		--REVOKE
			--Takes back privileges granted from user.

	--Constraints
		--NOT NULL
			--Ensures that a column cannot have a NULL value.
			--The following SQL query creates a new table called CUSTOMERS and adds five columns, three of which, are ID, NAME, AND AGE to not accept NULLs
				CREATE TABLE CUSTOMERS(
					ID   INT             NOT NULL,
					NAME VARCHAR (20)    NOT NULL,
					AGE  INT             NOT NULL,
					ADDRESS CHAR (25),
					SALARY DECIMAL (18, 2),
					PRIMARY KEY(ID)
				);
			--If CUSTOMERS table has already been created, then to add a NOT NULL constraint to the SALARY column in Oracle and MySQL
				ALTER TABLE CUSTOMERS 
					MODIFY SALARY DECIMAL (18, 2) NOT NULL;
		--DEFAULT
			--Provides a default value for a column when none is specified.
			--SQL creates a new table called CUSTOMERS and adds five columns.
			--The SALARY column is set to 5000.00 by default, so in case the INSERT INTO statement does not provide va value for this column, the default would be set to 5000.00
				CREATE TABLE CUSTOMERS(
					ID   INT             NOT NULL,
					NAME VARCHAR (20)    NOT NULL,
					AGE  INT             NOT NULL,
					ADDRESS CHAR (25),
					SALARY DECIMAL (18, 2) DEFAULT 5000.00,
					PRIMARY KEY(ID)
				);
			--If the CUSTOMERS table has already been created, then to add a DEFAULT constraint to the SALARY column.
				MODIFY SALARY DECIMAL (18, 2) DEFAULT 5000.00
			To drop a DEFAULT constraint:
				AFTER TABLE CUSTOMERS	
					ALTER COLUMN SALARY DROP DEFAULT
		--UNIQUE
			--Ensures that all the values in a column are different; Prevents two records from having identical values in a column.
			--SQL creates a new table called CUSTOMERS and adds five columns.
			--Age is sent to UNIQUE so that you cannot have two records with the same age:
			CREATE TABLE CUSTOMERS(
					ID   INT             NOT NULL,
					NAME VARCHAR (20)    NOT NULL,
					AGE  INT             NOT NULL UNIQUE,
					ADDRESS CHAR (25),
					SALARY DECIMAL (18, 2),
					PRIMARY KEY(ID)
				);
			--If the CUSTOMERS table has already been created then add a UNIQUE constraint to the AGE column
				ALTER TABLE CUSTOMERS
					MODIFY AGE INT NOT NULL UNIQUE;
			--You can also use the following syntax, which supports naming the constraint in multiple columns as well
				ALTER TABLE CUSTOMERS 
					ADD CONSTRAINT myUniqueConstraint UNIQUE(AGE, SALARY);
			--To drop a UNIQUE constraint
				ALTER TABLE CUSTOMERS
					DROP CONSTRAINT myUniqueConstraint;
		--PRIMARY KEY
			--Uniquely identifies each row/record in a database table and must have unique values.
			--One table can only have one primary key.  Cannot have two records having the same value of the primary key.
			--Primary key in a CUSTOMERS table 
				CREATE TABLE CUSTOMERS(
					ID   INT             NOT NULL,
					NAME VARCHAR (20)    NOT NULL,
					AGE  INT             NOT NULL,
					ADDRESS CHAR(25),
					SALARY DECIMAL (18, 2),
					PRIMARY KEY(ID)
				);
			--To create a PRIMARY KEY constraint on the "ID" column when the CUSTOMERS table already exists
				ALTER TABLE CUSTOMER ADD PRIMARY KEY (ID);
			--For defining a PRIMARY KEY constraint on multiple columns
				CREATE TABLE CUSTOMERS(
					ID   INT             NOT NULL,
					NAME VARCHAR (20)    NOT NULL,
					AGE  INT             NOT NULL,
					ADDRESS CHAR (25),
					SALARY DECIMAL (18, 2),
					PRIMARY KEY(ID, NAME)
			--To create a PRIMARY KEY constraint on the "ID" and "NAMES" columns when CUSTOMERS table already exists
				ALTER TABLE CUSTOMERS 
					ADD CONSTRAINT PK_CUSTID PRIMARY KEY (ID, NAME);
			--Delete the PRIMARY KEY 
				ALTER TABLE CUSTOMERS DROP PRIMARY KEY;
		--FOREIGN KEY
			--Uniquely identifies a row/record in any other database table.
			--Consider the structure of the following two tables.
				--CUSTOMERS table
					CREATE TABLE CUSTOMERS(
						ID   INT             NOT NULL,
						NAME VARCHAR (20)    NOT NULL,
						AGE  INT             NOT NULL,
						ADDRESS CHAR (25),
						SALARY DECIMAL (18, 2),
						PRIMARY KEY(ID)
					);
				--ORDERS table 
					CREATE TABLE ORDERS(
						ID   INT             NOT NULL,
						DATE DATETIME,
						AGE  INT             NOT NULL,
						ADDRESS CHAR (25),
						SALARY DECIMAL (18, 2),
						PRIMARY KEY(ID)
					);
				--If the ORDERS table has already been created and the foreign key has not yet been set
					ADD FOREIGN KEY (Customer_ID) REFERENCES CUSTOMERS (ID);
				--To drop a FOREIGN KEY constraint 
					ALTER TABLE ORDERS 
						DROP FOREIGN KEY;
		--CHECK
			--Ensures that all values in a column satisfy certain requirements.
			--If condition evaluates to false, the record violates the constraint and isn't enetered in the table .
			--The following progream creates a new table called CUSTOMERS, adds five columns, and adds a CHECK with AGE column so no customers are below 18
				CREATE TABLE CUSTOMERS(
					ID   INT             NOT NULL,
					NAME VARCHAR (20)    NOT NULL,
					AGE  INT             NOT NULL CHECK (AGE >= 18),
					ADDRESS CHAR (25),
					SALARY DECIMAL (18, 2),
					PRIMARY KEY(ID)
				);
			--If the CUSTOMERS table has already been created
				ALTER TABLE CUSTOMERS
					MODIFY AGE INT NOT NULL CHECK (AGE >= 18);
			--You can name the constraint in multiple columns as well
				ALTER TABLE CUSTOMERS
					ADD CONSTRAINT myCheckConstraint CHECK(AGE >= 18)
			--To drop a CHECK constraint
				ALTER TABLE CUSTOMERS 
					DROP CONSTRAINT myCheckConstraint;
		--INDEX
			--Used to create and retrieve data from the database very quickly
			--SQL syntax creates a new table called CUSTOMERS and adds five columns in it
				CREATE TABLE CUSTOMERS(
					ID   INT             NOT NULL,
					NAME VARCHAR (20)    NOT NULL,
					AGE  INT             NOT NULL,
					ADDRESS CHAR (25),
					SALARY DECIMAL (18, 2),
					PRIMARY KEY(ID)
				);
			--Create an index on a single or multiple columns
				CREATE INDEX index_name
					ON table_name (column1, column2...);
			--To create an INDEX on the AGE column, to optimize the search on customers for a specific age
				CREATE INDEX idx_age
					ON CUSTOMERS (AGE);
			--To drop an INDEX constraint
				ALTER TABLE CUSTOMERS 
					DROP INDEX idx_age;		
					
	--SQL Logical Operators
		--AND operator is used to compare a value to all values in another value set
			SELECT * FROM CUSTOMERS WHERE AGE >= 25 AND SALARY >= 6500;
		--OR operator is used to combine mulyiple conditions in an SQL statement's WHERE clause
			SELECT * FROM CUSTOMERS WHERE AGE >= 25 OR SALARY >= 6500;
		--IS NULL operator is used to compare a value with a NULL value 
			SELECT * FROM CUSTOMERS WHERE AGE IS NOT NULL;
		--LIKE operator is used to compare a value to similar values using wildcard operators
			SELECT * FROM CUSTOMERS WHERE NAME LIKE 'Ko%';
		--IN operator is used to compare a value to a list of literal values that have been specified
			SELECT * FROM CUSTOMERS WHERE AGE IN (25, 27);
		--BETWEEN operator is used to search for values that are within a set of values, given the minimum value and the maximum value
			SELECT * FROM CUSTOMERS WHERE AGE BETWEEN 25 AND 27;
		--EXISTS operator is used to search for the presence of a row in a specified table that meets a certain criterion
			SELECT AGE FROM CUSTOMERS WHERE EXISTS (SELECT AGE FROM CUSTOMERS WHERE SALARY > 6500);
		--ALL operator is used to compare a value to all values in another value set 
			SELECT * FROM CUSTOMERS WHERE AGE > ALL (SELECT AGE FROM CUSTOMERS WHERE SALARY > 6500;
		--ANY operator is used to compare a value to any applicable value in the list as per the condition 
			SELECT * FROM CUSTOMERS WHERE AGE > ANY (SELECT AGE FROM CUSTOMERS WHERE SALARY > 6500);
			
	--Date Expressions return current system date and time values
		SELECT CURRENT_TIMESTAMP;
		SELECT GETDATE();;
		
	--CREATE DATABASE
		--The SQL CREATE DATABASE statement is used to create a new SQL database
			--The basic syntax of this CREATE DATABASE statement
				CREATE DATABASE DatabaseName;
			--If you want to create a new database <testDB>
				CREATE DATABASE testDB;
			--Once a database is created, you can check it in the list of databases
				SHOW DATABASES
	
	--DROP\DELETE DATABASE
		--The SQL DROP DATABASE statement is used to drop an existing database in SQL schema 
			--The basic syntax of DROP DATABASE statement
				DROP DATABASE DatabaseName;
			--If you want to delete an existing database <testDB>
				DROP DATABASE testDB;
			
	--SELECT Database, USE Statement
		--The SQL USE statement is used to select any existing database in the SQL schema 
			--The basic syntax of the USE statement		
				USE DatabaseName;
				
	--CREATE Table 
		--SQL CREATE TABLE statement us used to create a new table 
		--Creates a CUSTOMERS table with an ID as a primary key and NOT NULL are the constraints showing these fields cannot be NULL when creating records in this table
			CREATE TABLE CUSTOMERS(
				ID   INT             NOT NULL,
				NAME VARCHAR (20)    NOT NULL,
				AGE  INT             NOT NULL,
				ADDRESS CHAR (25),
				SALARY DECIMAL (18, 2),
				PRIMARY KEY(ID)
			);
		--You can verify if your table has been created successfully by using the DESC command
			DESC CUSTOMERS;

	--DROP or DELETE Table 
		--SQL DROP TABLE statement is used to remove a table definition and all the data, indexes, triggers, constraints, and permission specifications for that table 
			--Basic syntax of the DROP TABLE statement
				DROP TABLE table_name 
	
	--INSERT 
		--The SQL INSERT INTO statement is used to add new rows of data to a table in the database 
			--SQL INSERT INTO syntax
				INSERT INTO TABLE_NAME VALUES (value1, value2, value3...valueN);
			--The following statements would create six records in the CUSTOMERS table 
				INSERT INTO CUSTOMERS (ID, NAME, AGE, ADDRESS, SALARY)
				VALUES (1, 'Ramesh', 32, 'Ahmedabad', 2000.00);
				INSERT INTO CUSTOMERS (ID, NAME, AGE, ADDRESS, SALARY)
				VALUES (2, 'Khilan', 25, 'Dehli', 1500.00);
				INSERT INTO CUSTOMERS (ID,NAME,AGE,ADDRESS,SALARY)
				VALUES (3, 'kaushik', 23, 'Kota', 2000.00 );
				INSERT INTO CUSTOMERS (ID,NAME,AGE,ADDRESS,SALARY)
				VALUES (4, 'Chaitali', 25, 'Mumbai', 6500.00 );
				INSERT INTO CUSTOMERS (ID,NAME,AGE,ADDRESS,SALARY)
				VALUES (5, 'Hardik', 27, 'Bhopal', 8500.00 );
				INSERT INTO CUSTOMERS (ID,NAME,AGE,ADDRESS,SALARY)
				VALUES (6, 'Komal', 22, 'MP', 4500.00 );
			--You can create a record in the Customers table by using this syntax
				INSERT INTO CUSTOMERS
				VALUES (7, 'Muffy', 24, 'Indore', 10000.00);
				
	--SELECT 
		--The SQL SELECT statement is used to fetch the data from a database table which returns this data in the form of a result table
			--The following code is an example, which would fetch the ID, Name and Salary fields of the customers available in CUSTOMERS table 
				SELECT ID, NAME, SALARY FROM CUSTOMERS;
			--If you want to getch all the fields of the CUSTOMERS table
				SELECT * FROM CUSTOMERS;
				
	--WHERE Clause 
		--The SQL WHERE clause is used to specify a condition while fetching the data from a single table or by joining with multiple tables. 
		--If the condition is satisfied, then only it returns a specific value from the table.
		--You should use the WHERE clause to filter the records and fetching only the necessary records
			--The following code is an example which would fetch the ID, Name and Salary fields from the CUSTOMERS table, where the salary is greater than 2000
				SELECT ID, NAME, SALARY 
				FROM CUSTOMERS
				WHERE SALARY > 2000;
			--The following query would fetch the ID, Name and Salary fields from the CUSTOMERS table for a customer with the name Hardik
				SELECT ID, NAME, SALARY
				FROM CUSTOMERS 
				WHERE NAME = 'Hardik';
	
	--AND and OR Clauses
		--The SQL AND & OR operators are used to combine multiple conditions to narrow data in an SQL statement.
			--AND Operator allows the existance of multiple conditions in an SQL statement's WHERE clause.
				--The following example would fetch the ID, Name and Salary fields from the CUSTOMERS table, where the salary is greater than 2000 and the age is less than 25 years 
					SELECT ID, NAME, SALARY
					FROM CUSTOMERS
					WHERE SALARY > 2000 AND AGE < 25; 
			--OR Operator is used to combine multiple conditions in an SQL statement's WHERE clause 
				--The following code block has a query, which would fetch the UD, Name, and Salary fields from the CUSTOMERS table, where the salary is greater than 2000 OR the age is less than 25 years
					SELECT ID, NAME, SALARY 
					FROM CUSTOMERS
					WHERE SALARY > 2000 OR age < 25;
					
	--UPDATE Query
		--The SQL UPDATE Query is used to modify the existing rows in a table.
		--You can use the WHERE clause with the UPDATE query to update the selected rows, otherwise all the rows will be affected.
			--The following query will update the ADDRESS for a customer whose ID number is 6 
				UPDATE CUSTOMERS
				SET ADDRESS = 'Pune'
				WHERE ID = 6;
			--If you want to modify all the ADDRESS and tthe SALARY column values in the Customer table
				UPDATE CUSTOMERS
				SET ADDRESS ='Pune', SALARY = 1000;
				
	--DELETE Query 
		--The SQL DELETE Query is used to delete the existing records from a table
		--Can use the WHERE clause with a DELETE query to delect the selected rows, otherwise all the records would be deleted
			--The following code has a query, which will DELETE a customer, whose ID is 6
				DELETE FROM CUSTOMERS
				WHERE ID = 6;
			--If you want to DELETE all the records from the CUSTOMERS table, you do not need to use the WHERE clause 
				DELETE FROM CUSTOMERS;
	
	--LIKE Clause 
		--The SQL LIKE clause is used to compare a value to similar values using wildcard operators
		--There are two wildcards used in conjunction with the LIKE operator
			--The percent sign (%)
			--The underscore (_)
		--The percent sign represents zero, one or multiple characters.
		--The underscore represents a single numbe or characters 
			--Finds all values that start with 200
				WHERE SALARY LIKE '200%'
			--Finds any values that have 200 in any position
				WHERE SALARY LIKE '%200%'
			--Finds any values that have 00 in the second and third positions 
				WHERE SALARY LIKE '_00%'
			--Finds any values that start with 2 and are at least 3 characters in length 
				WHERE SALARY LIKE '2_%_%'
			--Finds any values that end with 2
				WHERE SALARY LIKE '%2'
			--Finds any values that have a 2 in the second position and end with a 3
				WHERE SALARY LIKE '_2%3'
			--Finds any values in a five-digit number that start with 2 and end with 3
				WHERE SALARY LIKE '2___3'
			--Display all the records from the CUSTOMERS table where the SALARY starts with 200
				SELECT * FROM CUSTOMERS WHERE SALARY LIKE '200%';
				
	--TOP, LIMIT, or ROWNUM Clause 
		--The SQL TOP clause is used to fetch a TOP N number or X percent records from a table
			--The following query is an example on the SQL server, which would fetch the top 3 records from the CUSTOMERS table 
				SELECT TOP 3 * FROM CUSTOMERS;
			--If you are using MySQL server, then here is an equivalent example 
				SELECT * FROM CUSTOMERS
				LIMIT 3;
			--If you are using an Oracle server, then the following code block has an equivalent example
				SELECT * FROM CUSTOMERS
				WHERE ROWNUM <= 3;
				
	--ORDER BY Clause 
		--The SQL ORDER BY clause is used to sort that data in ascending or descending order, based on one or more columns
		--Some databases sort the query results in an ascending order by default
			--The following code block has an example, which would sort the result in ascending order by the NAME and the SALARY 
				SELECT * FROM CUSTOMERS 
				ORDER BY NAME, SALARY 
			--The following code block has an example, which would sort the result in the descending order by NAME
				SELECT * FROM CUSTOMERS
				ORDER BY NAME DESC;
				
	--GROUP BY Clause
		--The SQL GROUP BY clause is used in collaboration with the SELECT statement to arrange identical data into groups
		--This GROUP BY clause follows the WHERE clause in a SELECT statement and precedes the ORDER BY clause 
			--If you want to know the total amount of the salary on each customer, then the GROUP BY query would be as follows:
				SELECT NAME, SUM(SALARY) FROM CUSTOMERS
				GROUP BY NAME;
			--If you want to know the total amount of salary on each customer, then the GROUP BY query would be as follows
				SELECT NAME, SUM(SALARY) FROM CUSTOMERS
				GROUP BY NAME;
				
	--DISTINCT keyword 
		--Used in conjunction with the SELECT statement to eliminate all the duplicate records and fetching only unique records
			SELECT DISTINCT SALARY FROM CUSTOMERS
			ORDER BY SALARY;
			
	--SORTING Results
		--SQL ORDER BY clause is used to sort the data in ascending or descenting order, based on one or more columns
			--The following example sorts the results in an ascending order by NAME and SALARY 
				SELECT * FROM CUSTOMERS
				ORDER BY NAME, SALARY;
			--The following code block has an example, which would sort the result in a descending order by NAME 
				SELECT * FROM CUSTOEMRS
				ORDER BY NAME DESC;
			--To fetch the rows with their own preferred order, the SELECT query would be used as follows
			--WHEN clause selects which order to return the query
				SELECT * FROM CUSTOMERS 
				ORDER BY (CASE ADDRESS 
					WHEN 'DELHI' THEN 1
					WEHN 'BHOPAL' THEN 2
					WHEN 'KOTA' THEN 3
					WHEN 'AHMADABAD' THEN 4
					WHEN 'MP' THEN 5
					ELSE 100 END) ASC, ADDRESS DESC
					
	--SQL Contraints
		--Constraints are the rules forced on the data columns of a table
		--Used to limit the type of data that can go into a table and ensures the accuracy and reliability of data in the database
			--Dropping Constraints 
				--Any constraint that you have defined can be dropped using the ALTER TABLE command with the DROP CONSTRAINT option 
				--To drop the primary key contraint in the EMPLOYEES table 
					ALTER TABLE EMPLOYEES DROP CONSTRAINT EMPLOYEES_PK;
				--To drop the krimary key constraint for a table in Oracle 
					ALTER TABLE EMPLOYEES DROP PRIMARY KEY;
					
	--Using Joins
		--SQL Joins clause is used to combine records from two or more tables in a database
			--To join two tables in a SELECT statement
				SELECT ID, NAME, AGE, AMOUNT
				FROM CUSTOMERS, ORDERS
				WHERE CUSTOMERS.ID = ORDERS.CUSTOMER_ID;
		--INNER JOIN 
			--Returns row where there is a match in both tables 
			--Creates a new result table by combining column values of two tables based upon the join-predidcate.
			--The query compares each row of table1 with each row of table2 to find all pairs of rows which satisfy the join-predicate
			--When the join-predicate is satisfied, column values for each matched pair of rows of A and B and combined into a result row
				SELECT ID, NAME, AMOUNT, DATE
				FROM CUSTOMERS
				INNER JOIN ORDERS
				ON CUSTOMERS.ID = ORDERS.CUSTOMER_ID;
		--LEFT JOIN
			--Returns all rows from the left table, even if there are no matches in the right table 
			--Left join returns all the values from the left table, plus matched values from the right table or NULL in case of no matching join predicate
				SELECT ID, NAME, AMOUNT, DATE
				FROM CUSTOMERS 
				LEFT JOIN ORDERS
				ON CUSTOMERS.ID = ORDERS.CUSTOMER_ID;
		--RIGHT JOIN 	
			--Returns all rows from the right tbale, even if there are no matches in the left table 		
			--Right join returns all the values from the right table, plus matched values from the left table or NULL in case of no matching join predicate 
				SELECT ID, NAME, AMOUNT, DATE
				FROM CUSTOMERS 
				RIGHT JOIN ORDERS 
				ON CUSTOMERS.ID = ORDERS.CUSTOMER_ID;
		--FULL JOIN (UNION)	
			--Returns rows when there is  match in one of the tables 
			--SQL FULL JOIN combines the results of both left and right outer joins 
			--The joined table will contain all records from both the tables and fill in NULLs for missing matches on either side 
				SELECT ID, NAME, AMOUNT, DATE
				FROM CUSTOMERS 
				FULL JOIN ORDERS 
				ON CUSTOMERS.ID = ORDERS.CUSTOMER_ID;
		--SELF JOIN 
			--Used to join a table to itself as if the table were two tables, temporarily renaming at least one table in the SQL statement
				SELECT a.ID, b.NAME, a.SALARY
				FROM CUSTOMERS a, CUSTOMERS b 
				WHERE a.SALARY < b.SALARY;
		--CARTESIAN JOIN 
			--Returns the Cartesian product of the sets of records from two or more joined tables 
			--Equates to an inner join where the join-condition always evaluates to either True or where the join-condition is absent from the statement
				SELECT ID, NAME, AMOUNT, DATE
				FROM CUSTOMERS, ORDERS;
	
	--SQL UNIONS CLAUSE
		--The SQL UNION clause/operator is used to combine the results of two or more SELECT statements without returning any duplicate rows 
		--To use this UNION clause, each SELECT statement must have:
			--The same number of columns selected
			--The name number of column expressions
			--The same data type and have them in the same order 
				SELECT ID, NAME, AMOUNT, DATE 
					FROM CUSTOMERS 
					LEFT JOIN ORDERS 
					ON CUSTOMERS.ID = ORDERS.CUSTOMER_ID
				UNION 
				SELECT ID, NAME, AMOUNT, DATE
					FROM CUSTOMERS 
					RIGHT JOIN ORDERS 
					ON CUSTOMERS.ID = ORDERS.CUSTOMER_ID;
		--UNION ALL Clause 
			--Used to combine the results of two SELECT statements including duplicate rows 
			--Same rules that apply to the UNION clause will apply to the UNION ALL operator
				SELECT ID, NAME, AMOUNT, DATE 
					FROM CUSTOMERS 
					LEFT JOIN ORDERS 
					ON CUSTOMERS.ID = ORDERS.CUSTOMER_ID
				UNION ALL 
				SELECT ID, NAME, AMOUNT, DATE
					FROM CUSTOMERS 
					RIGHT JOIN ORDERS 
					ON CUSTOMERS.ID = ORDERS.CUSTOMER_ID;	
		--SQL INTERSECT Clause 
			--Combines two SELECT statements, but returns rows only from the first SLEECT statement that are identifcal to a row in the second SELECT statement
				SELECT ID, NAME, AMOUNT, DATE 
					FROM CUSTOMERS 
					LEFT JOIN ORDERS 
					ON CUSTOMERS.ID = ORDERS.CUSTOMER_ID
				INTERSECT 
				SELECT ID, NAME, AMOUNT, DATE
					FROM CUSTOMERS 
					RIGHT JOIN ORDERS 
					ON CUSTOMERS.ID = ORDERS.CUSTOMER_ID;
		--SQL EXCEPT Clause 
			--Combines two SELECT statements and returns rows from the first SELECT statement that are not returned by the second SELECT statement
			--EXCEPT returns only rows, which are not available in the second SELECT statement 
				SELECT ID, NAME, AMOUNT, DATE 
					FROM CUSTOMERS 
					LEFT JOIN ORDERS 
					ON CUSTOMERS.ID = ORDERS.CUSTOMER_ID
				EXCEPT 
				SELECT ID, NAME, AMOUNT, DATE
					FROM CUSTOMERS 
					RIGHT JOIN ORDERS 
					ON CUSTOMERS.ID = ORDERS.CUSTOMER_ID;
					
	--SQL NULL VALUES 
		--SQL NULL is the term used to reoresent a missing value
		--NULL value in a table is a value in a field that appears to be blank; field with a NULL value is a field with no value
		--NOT NULL signifies that column should always accept an explicit value of the given data type
		--You must use the IS NULL or IS NOT NULL operators to check for a NULL value 
		--Usage of the IS NOT NULL operator 
			SELECT ID, NAME, AGE, ADDRESS, SALARY
			FROM CUSTOMERS
			WHERE SALARY IS NOT NULL;
		--Usage of the IS NULL operator 
			SELECT ID, NAME, AGE, ADDRESS, SALARY
			FROM CUSTOMERS
			WHERE SALARY IS NULL;
	
	--Alias Syntax 
		--You can rename a table or a column temporarily by giving another name known as Alias.
		--The use of table aliases is to rename a table in a specific SQL statement.
		--The renaming is a temporary change and the actual table name does not change in the database.
		--The column aliases are used to rename a table's columns for the purpose of a particular SQL query.
			--The following acode block shows the usage of a table alias:
				SELECT C.ID, C.NAME, C.AGE, O.AMOUNT
				FROM CUSTOMERS AS C, ORDERS AS 0
				WHERE C.ID=0.CUSTOMER_ID;
			--Following is the usage of a column alias
				SELECT ID AS CUSTOMER_ID, NAME AS CUSTOMER_NAME
				FROM CUSTOMERS
				WHERE SALARY IS NOT NULL;
					
	--Indexes 
		--Indexes are special lookuo table that the database search engine can use to speed up date retrieval; a pointer to data in a table.
		--An index in a database is very similar to an index in the back of a book.
		--An index helps to speed up SELECT queries and WHERE clauses, but it slows down data input, with the UPDATE and the INSERT statements
		--Indexes can be created or dropped with no effect on the data.
		--Creating an index involves the CREATE INDEX statement, which allows you to name the index, specify the table and which column or columns to index, and to indicate whether the index is in an ascending or descending order.
		--Indexes can also be unique, like the UNIQUE constrainty, in that the index precents duplicate entries in the column or combination of columns on which there is an index 
			--CREATE INDEX command
				--The basic syntax of a CREATE INDEX
					CREATE INDEX index_name ON table_name;
				--Single-Column Indexes 
					--A single-column index is created based on only one table column 
						CREATE INDEX index_name 
						ON table_name (column_name);
				--Unique Indexes 
					--Unique indexes are used not only for performance, but also for data integrity
					--A unique index does not allow any duplicated values to be inserted into the table
						CREATE UNIQUE INDEX index_name 
						ON table_name(column_name);
				--Composite Indexes 
					--A composite index is an index on two or more columns of a table.
						CREATE INDEX index_name 
						ON table_name (column1, column2);
					--Should there be only one column used, a single-column index should be the choice.
					--Should there be two or more columns that are frequently used in the WHERE clause as filters, the composite index would be the best choice 
				--Implicit Indexes 
					--Implicit indexes are indexes that are automatically created by the database server when an object is created.
					--Indexes are automatically created for primary key contraints and unique constratins.
				--DROP INDEX Command 
					--An index can be dropped using SQL DROP command
						DROP INDEX index_name;
		--When should indexes be avoided?
			--Indexes should not be used to small tables
			--Tables that have frequent, large batch updates or insert operations
			--Indexes should not be used on columns that contain a high number of NULL values
			--Columns that are frequently manipulated should not be indexed 
					
	--ALTER TABLE 
		--The SQL ALTER TABLE command is used to add, delete or modify columns in an existing table.
		--You should also use the ALTER TABLE command to add a New Column in an existing table
			ALTER TABLE table_name ADD column_name datatype;
		--The basic syntax of an ALTER TABLE command to DROP COLUMN in an existing table 
			ALTER TABLE table_name DROP COLUMN column_name;
		--The basic syntax of an ALTER TABLE command to change the DATA TYPE of a column in a table:
			ALTER TABLE table_name MODIFY COLUMN column_name datatype;
		--The basic syntax of an ALTER TABLE command to add a NOT NULL constraint to a column in a table:
			ALTER TABLE table_name MODIFY column_name datatype NOT NULL;
		--The basic syntax of ALTER TABLE to ADD UNIQUE CONSTRAINT to a table:
			ALTER TABLE table_name 
			ADD CONSTRAINT MyUnqiueConstraint UNIQUE(column1, column2...);
		--The basic syntax of an ALTER TABLE command to ADD CHECK CONSTRAINT 
			ALTER TABLE table_name
			ADD CONSTRAINT MyIniqueConstraint CHECK (CONDITION);
		--The basic syntax of an ALTER TABLE command to ADD PRIMARY KEY constraint to a table:
			ADD TABLE table_name 
			ADD CONSTRAINT MyPrimaryKey PRIMARY KEY (column1, column2...);
		--The basic syntax of an ALTER TABLE command to DROP CONSTRAINT from a table 
			ALTER TABLE table_name
			DROP CONSTRAINT MyUniqueConstraint
		--The basic syntax of an ALTER TABLE command to DROP PRIMARY KEY constraint from a table 
			ALTER TABLE table_name
			DROP CONSTRAINT MyPrimaryKey;
		--Following is the example to ADD a New Column to an existing table 
			ALTER TABLE CUSTOMERS ADD SEX char(1);
		--Following is the example to DROP sex column from an existing table 
			ALTER TABLE CUSTOMERS DROP SEX;
	--TRUNCATE TABLE				
		--The SQL TRUNCATE TABLE command is used to delete complete data from an existing table 
		--You can also use DROP TABLE command to delete complete table but it would remove complete table structures from the database and you would need to re-create this table once again if wish to store some data
			--The basic syntax of a TRUNCATE TABLE command
				TRUNCATE TABLE table_name;
			--Another example of the Truncate command
				TRUNCATE TABLE CUSTOMERS;
			--Now, the CUSTOMERS table is truncated and the output from SELECT statement will be an empty set
				SELECT * FROM CUSTOMERS;
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
	






	