-- CHAPTER 1 - INTRODUCTION TO PL/SQL 
-- Integration with SQL
DECLARE 
	1_book_count INTEGER;
BEGIN
	SELECT COUNT(*)
	INTO 1_book_count
	FROM  books
	WHERE author LIKE '%FEUERSTEIN, STEVEN%';
	
	DBMS_OUPUT.PUT_LINE (
		'Steven has written (or co-written) ' ||
		1_book_count ||
		' books.');
	-- Oh, and I changed my name, so...
	UPDATE books 
		SET author = REPLACE (author, 'STEVEN', 'STEPHEN')
		WHERE author LIKE '%FEUERSTEIN, STEVEN%';
END;



--CHAPTER 2 - CREATING AND RUNNING SQL CODE 
--Set the serveroutput on
SET SERVEROUTPUT ON
BEGIN 
  DBMS_OUTPUT.PUT_LINE('Hey look, Ma!');
END;
/
























-- Script that contains an anonymous PL/SQL block
CONNECT ap/ap;	-- Connects to a database as the specified user

SET SERVEROUTPUT ON;	-- Enables printing to SQL Developer's Script Output window or to the SQL *Plus command line

--Begin an anonymous PL/SQL block 
DECLARE	
	sum_balance_due_var NUMBER(9, 2);
BEGIN 
	SELECT SUM(invoice_total - payment_total - credit_total)
	INTO sum_balance_due_var
	FROM invoices
	WHERE vendor_id = 95;
	
	IF sum_balance_due_var > 0 THEN
		DBMS_OUTPUT.PUT_LINE('Balance due: $' || ROUND(sum_balance_due_var, 2));	-- Prints the specified string followed by a line break
	ELSE
		DBMS_OUTPUT.PUT_LINE('Balance paid in full');
	END IF;
	
EXCEPTION
	WHEN OTHERS THEN 
		DBMS_OUTPUT.PUT_LINE('An error occured in the script');
END;
/
-- End an anonymous PL/SQL block

-- HOW TO DECLARE AND USE VARIABLES
-- SQL script that uses variables
CONNECT ap/ap;

SET SERVEROUTPUT ON;

DECLARE
	max_invoice_total	invoices.invoice_total%TYPE;	-- Use same data type as iinvoice_total in the invoices table
	min_invoice_total	invoices.invoice_total%TYPE;	-- Use same data type as iinvoice_total in the invoices table
	percent_difference	NUMBER;
	count_invoice_id	NUMBER
	vendor_id_var		NUMBER := 95;
BEGIN
	SELECT MAX(invoice_total), MIN(invoice_total), COUNT(invoice_id)
	INTO max_invoice_total, min_invoice_total, count_invoice_id
	FROM invoices WHERE vendor_id = vendor_id_var;
	
	percent_difference := (max_invoice_total - min_invoice_total) / min_invoice_total * 100;
	
	DBMS_OUTPUT.PUT_LINE('Maximum invoice: $' || max_invoice_total);
	DBMS_OUTPUT.PUT_LINE('Minimum invoice: $' || min_invoice_total);
	DBMS_OUTPUT.PUT_LINE('Percent difference: %' || ROUND(percent_difference, 2));
	DBMS_OUTPUT.PUT_LINE('Number of invoices: ' || count_invoice_id);
END;
/

-- HOW TO CODE IF STATEMENTS
-- Script that uses an IF statement
CONNECT ap/ap;

SET SERVEROUTPUT ON;

DECLARE
	first_invoice_due_date DATE;
BEGIN 
	SELECT MIN(invoice_due_date)
	INTO first_invoice_due_date
	FROM invoices
	WHERE invoice_total - payment_total - credit_total > 0;
	
	IF first_invoice_due_date < SYSDATE() THEN
		DBMS_OUTPUT.PUT_LINE('Outstanding invoices overdue!');
	ELSIF first_invoice_due_date =  SYSDATE() THEN 
		DBMS_OUTPUT.PUT_LINE('Outstanding invoices are due today!');
	ELSE 
		DBMS_OUTPUT.PUT_LINE('No invoices are overdue!');
	END IF;
END;
/

-- HOW TO CODE CASE STATEMENTS 
-- Script that uses a Simple CASE statement 
CONNECT ap/ap;

SET SERVEROUTPUT ON;

DECLARE
	terms_id_var NUMBER;
BEGIN
	SELECT terms_id 
	INTO term_id_var
	FROM invoices WHERE invoice_id = 4;
	
	CASE terms_id_var 
		WHEN 1 THEN 
			DBMS_OUTPUT.PUT_LINE('Net due 10 days');
		WHEN 2 THEN 
			DBMS_OUTPUT.PUT_LINE('Net due 20 days');
		WHEN 3 THEN 
			DBMS_OUTPUT.PUT_LINE('Net due 30 days');
		ELSE
			DBMS_OUTPUT.PUT_LINE('Net due more than 30 days');
	END CASE;
END;
/

-- HOW TO CODE LOOPS 
-- A FOR loop
FOR i IN 1..3 LOOP
	DBMS_OUTPUT.PUT_LINE('i: ' || i);
END LOOP;

-- A WHILE Loop
i := 1;
WHILE i < 4 LOOP 
	DBMS_OUTPUT.PUT_LINE('i: ' || i);
	i := i + 1;
END LOOP;

-- A Simple Loop 
i := 1;
LOOP 
	DBMS_OUTPUT.PUT_LINE('i: ' || i);
	i := i + 1;
	EXIT WHEN i >= 4;
END LOOP;

-- HOW TO USE A CURSOR 
CONNECT ap/ap;
SET SERVEROUTPUT ON;

DECLARE 
	CURSOR invoices_cursor IS
		SELECT invoice_id, invoice_total - credit_total > 0;
		
		invoice_row invoices%ROWTYPE;

BEGIN
	FOR invoice_row IN invoices_cursor LOOP
		IF (invoice_row.invoice_total > 1000) THEN
		UPDATE invoices
		SET credit_total = credit_total + (invoice_total * .1)
		WHERE invoice_id = invoice_row.invoice_id;
		
		DBMS_OUTPUT.PUT_LINE('1 row updated where invoice_id = ' || invoice_row.invoice_id);
		END IF;
	END LOOP;
END;
/

-- HOW TO USE COLLECTIONS 
-- Script that uses a varray
DECLARE 
	TYPE names_array 	IS VARRAY(3) OF VARCHAR2(25);
	names_array		 	names_array := names_array(NULL, NULL, NULL);
BEGIN 
	names(1) := 'John';
	names(2) := 'Jane';
	names(3) := 'Joel';
	
	FOR i IN 1..names.COUNT LOOP
		DBMS_OUTPUT.PUT_LINE('Name ' || i || ': ' || names(i));
	END LOOP;
END;
/

-- Script that uses a nested table 
DECLARE
	TYPE names_table			IS TABLE OF VARCHAR2(25);
	names						names_table := names_table(NULL, NULL, NULL);
BEGIN 
	names(1) := 'John';
	names(2) := 'Jane';
	names(3) := 'Joel';
	
	For i in 1..names.COUNT LOOP
		DBMS_OUTPUT.PUT_LINE('Name ' || i || ': ' || names(i));
	END LOOP;
END;
/

-- Script that uses an associative array
DECLARE
	TYPE names_table			IS TABLE OF VARCHAR2(25)
								INDEX BY BINARY_INTEGER
	names						names_table;
BEGIN 
	names(76) := 'John';
	names(100) := 'Jane';
	names(123) := 'Joel';
	
	FOR i IN names.FIRST..names.LAST LOOP
		IF names.EXISTS(i) THEN 
			DBMS_OUTPUT.PUT_LINE('Name ' || i || ': ' || names(i));
		END IF;
	END LOOP;
END;
/

-- Script that uses a BULK COLLECTION clause to fill a colleciton
DECLARE	
	TYPE names-table	IS TABLE OF VARCHAR2(40);
	vendor_names		names_table;
BEGIN 
	SELECT vendor_names
	BULK COLLECT INTO vendor_names
	FROM vendors
	WHERE rownum < 4 
	ORDER BY vendor_id;
	
	FOR i IN 1..vendor_names.COUNT LOOP
		DBMS_OUTPUT.PUT_LINE('Vendor name ' || i || ': ' || vendor_names(i));
	END LOOP;
END;
/

-- HOW TO HANDLE COLLECTIONS 
-- Script that uses the EXCEPTION block to handle exceptions
CONNECT ap/ap;

SET SERVEROUTPUT ON;

BEGIN
	INSERT INTO general_ledger_accounts VALUES (130, 'Cash');
	
	DBMS_OUTPUT.PUT_LINE('1 row inserted.');
EXCEPTION
	WHEN DUP_VAL_ON_INDEX THEN
		DBMS_OUTPUT.PUT_LINE('You attempted to insert a duplicate value.');
		
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('An unexpected exception occurred.');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- HOW TO DROP DATABASE OBJECTS WITHOUT DISPLAYING ERRORS
-- Script that will display an error if the object doesn't already exist
CONNECT ap/ap;
DROP TABLE test1;
CREATE TABLE test1 (test_id NUMBER);

-- Script that will execute correctly without displaying an error 
CONNECT ap/ap;

BEGIN
	EXECUTE IMMEDIATE 'DROP TABLE test1';
EXCEPTION 
	WHEN OTHERS THEN
		NULL;
END;
/

CREATE TABLE test1 (test_id NUMBER);

-- HOW TO USE BIND AND SUBSTITUTION VARIABLES 
-- Script that uses bind variables
CONNECT ap/ap;
SET SERVEROUTPUT ON;

-- Use the VARIABLE keyword to declare a bind variables
VARIABLE invoice_id_value NUMBER;

-- Use a PL/SQL block to set the value of a bind variable to the value that's entered for a substitution value 
BEGIN 
	:invoice_id_value := &invoice_id;
END;
/

-- Use a bind variable in a SELECT statement
SELECT invoice_id, invoice_number
FROM invoices 
WHERE invoice_id = :invoice_id_value;

--Use a bind variable in another PL/SQL block
BEGIN
	DBMS_OUTPUT.PUT_LINE('invoice_id_value: ' || :invoice_id_value);
END;
/

-- HOW TO USE DYNAMIC SQL 
-- Dynamic SQL that updates the terms ID for the specified invoice
CONNECT ap/ap;

DECLARE
	invoice_id_var NUMBER;
	terms_id_var NUMBER;
	dynamic_sql VARCHAR2(400);
BEGIN 
	invoice_id_var := &invoice_id;
	terms_id_var := &terms_id;
	
	dynamic_sql := 'UPDATE invoices ' || 
	               'SET terms_id = ' || terms_id_var || ' ' ||
				   'WHERE invoice_id = ' || invoice_id_var;
				   
	EXECUTE IMMEDIATE dynamic_sql;
END;
/

-- HOW TO RUN A SCRIPT FROM A COMMAND LINE
-- The code for the create_ar.sql script 
SPOOL create_ar.log

PROMPT Creating AR user...
PROMPT 

CONNECT system/system 
BEGIN
	EXECUTE IMMEDIATE 'DROP USER ar CASCADE';
EXCEPTION
	WHEN OTHERS THEN
		NULL;
END;
/
CREATE USER ar IDENTIFIED BY ar DEFAULT TABLESPACE users;
GRANT ALL PRIVILEGES TO ar;

PROMPT Creating AR tables...
PROMPT 

CONNECT ar/ar;
CREATE TABLE customers
(
	customer_id				NUMBER			NOT NULL,
	customer_first_name		VARCHAR2(50)	NOT NULL,
	customer_last_name		VARCHAR2(50)	NOT NULL,
	CONSTRAINT customers_pk
		PRIMARY KEY (customer_id)
);
INSERT INTO customers VALUES (1, 'Jack', 'Samson');
INSERT INTO customers VALUES (2, 'Joan', 'Redding');
INSERT INTO customers VALUES (3, 'Jim', 'Abbot');

SPOOL OFF;

PROMPT Check create_ar.log for details...
PROMPT

EXIT;

--HOW TO WORK WITH TRANSACTIONS 
--Script that contains three INSERT statements that are codes as a transaction 
CONNECT ap/ap;
SET SERVER OUTPUT ON;

BEGIN
	INSERT INTO invoices
	VALUES (115, 34, 'ZXA-080', '30-AUG-06',
	        14092.59, 0, 0, 3. '30-SEP-06', NULL);
		
	INSERT INTO invoice_line_items
	VALUES (115, 1, 160, 4447.23, 'HW upgrade');
	
	INSERT INTO invoice_line_items
	VALUES 9115, 2, 167, 9645.36, 'OS upgrade');
	
	COMMIT;	--commits the changes to the database
	DBMS_OUTPUT.PUT_LINE('The transaction was committed.');
EXCEPTION 
	WHEN OTHERS THEN  --error has occurred after commit
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE('The transaction was rolled back.');
END;
/

--HOW TO WORK WITH SAVE POINTS
--Script that uses save points
INSERT INTO invoices
VALUES (9115, 34, 'ZXA-080', '30-AUG-08'
		14092.59,0, 0, 3, '30-SEP-08', NULL);
		
SAVEPOINT before_line_item1;  --savepoint identifies a save point before insert statement

INSERT INTO invoice_line_items
VALUES (115, 1, 160, 4447.23, 'HW upgrade');

SAVEPOINT before_line_item2;

INSERT INTO invoice_line_items
VALUES (115, 2, 167, 9645.36, 'OS upgrade');

ROLLBACK TO SAVEPOINT before_line_item2;
ROLLBACK TO SAVEPOINT before_line_item1;
ROLLBACK TO SAVEPOINT before_invoice;

COMMIT;

--HOW TO WORK WITH CONCURRENCY AND LOCKING
--Two transactions that retrieve and then modify the data in the same row

--Transaction A 
UPDATE invoices 
SET credit_total = credit_total + 100 
WHERE invoice_id = 6;
--the SELECT statement in Transaction B won't show the updated data
--the UPDATE statement in Transaction B will wait for A to finish
COMMIT;
--the SELECT statement in Transaction B will show the updated data
--the UPDATE statement in Transaction B will execute immediately

--Transaction B
 --Use a second instance of SQL Developer to execute these statements!
SELECT invoice_id, credit_total
FROM invoices
WHERE invoice_id = 6;

UPDATE invoices
SET credit_total = credit_total + 200
WHERE  invoice_id = 6;
COMMIT;

--HOW TO SET THE TRANSACTION ISOLATION LEVEL
--Syntax of the SET TRANSACTION ISOLATION LEVEL statement 
SET TRANSACTION ISOLATION LEVEL {READ COMMITTED|SERIALIZABLE}

--Statement that sets the transaction isolation level to SERIALIZABLE 
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

--Statement that sets the transaction isolation level to Oracle's default
SET TRANSACTION ISLOATION LEVEL READ COMMITTED;

--HOW TO PREVENT DEADLOCKS
--UPDATE statements that illustrate deadlocking
--Transaction A 
UPDATE savings SET balance = balance - :transfer_amount;
UPDATE checking SET balance = balance + :transfer_amount;

--Transaction A (possible deadlock)
UPDATE checking SET balance = balance - :transfer_amount;
UPDATE savings SET balance = balance + :transfer_amount;
COMMIT;

--Transaction B (prevents deadlock)
UPDATE savings SET balance = balance + :transfer_amount;
UPDATE checking SET balance = balance - :transfer_amount;
COMMIT;

--HOW TO CODE STORED PROCEDURES
--Script that creates a stored procedure that updates a table
CREATE OR REPLACE PROCEDURE update_invoices_credit_total  --Creates the stored procedure if it doesn't exist and replaces it if it does exist 
(
	--Parameters for stored procedure(passes values to stored procedure)
	invoice_number_param	VARCHAR2,
	credit_total_param		NUMBER
)
AS
BEGIN
	UPDATE invoices
	SET credit_total = credit_total_param
	WHERE invoice_number = invoice_number_param;
	
	COMMIT;
EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
END;
/

--Statement that calls a stored procedure
CALL update_invoices_credit_total('367447', 300);

--Script that calls a stored procedure
BEGIN
	update_invoices_credit_total('367447', 300);
END;
/

--Script that passes parameters by name
BEGIN
	update_invoices_credit_total
	(
		credit_total_param => 300, -- => is an assoication operator (not greater than or equal)
		invoice_number_param => '367447'
	);
END;
/

--HOW TO CODE INPUT AND OUTPUT PARAMETERS
--Stored procedure that uses input and output parameters 
CREATE OR REPLACE PROCEDURE update_invoices_credit_total
(
	invoice_number_param	IN VARCHAR2,
	credit_total_param		IN NUMBER,
	update_count			OUT INTEGER
)
AS
BEGIN 
	UPDATE invoices
	SET credit_total = credit_total_param
	WHERE invoice_number = invoice_number_param;
	
	SELECT COUNT(*)
	INTO update_count
	FROM invoices
	WHERE invoice_number = invoice_number_param;
	
	COMMIT;
EXCEPTION 
	WHEN OTHERS THEN
	SELECT 0
	INTO update_count
	FROM dual;
	ROLLBACK;
END;
/

--Script that calls the stored procedure and uses the output parameter 
SET SERVEROUTPUT ON;
DECLARE 
	row_count	INTEGER;
BEGIN 
	update_invoices_credit_total('367447', 200, row_count);
	DBMS_OUTPUT.PUT_LINE('row_count: ' || row_count);
END;
/

--HOW TO CODE OPTIONAL PARAMETERS 
--A CREATE PROCEDURE statement that uses an optional parameter
CREATE OR REPLACE PROCEDURE update_invoices_credit_total
(
	invoice_number_param	VARCHAR2,
	credit_total_param		NUMBER DEFAULT 100 
)
AS 
BEGIN
	UPDATE invoices
	SET credit_total = credit_total_param
	WHERE invoice_number = invoice_number_param;
	
	COMMIT;
EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
	END;
/

--A statement that calls the stored procedure 
CALL update_invoices_credit_total('367447', 200);

--Another statement that calls the stored procedure 
CALL update_invoices_credit_total('367447');

--HOW TO RAISE ERRORS
--Stored procedure that raised a predefined exception
CREATE OR REPLACE PROCEDURE update_invoices_credit_total
(
	invoice_number_param	VARCHAR2,
	credit_total_param		NUMBER
)
AS
BEGIN 
	IF credit_total_param < 0 THEN 
		RAISE VALUE_ERROR;
	END IF;
	
	UPDATE invoices
	SET credit_total = credit_total_param
	WHERE invoice_number = invoice_number_param;
	
	COMMIT;
END;
/

--A statement that calls the procedure
SET SERVEROUTPUT ON;

BEGIN
	update_invoices_credit_total('367447', -100);
EXCEPTION 
	WHEN VALUE_ERROR THEN 
		DBMS_OUTPUT.PUT_LINE('A VALUE_ERROR occurred.');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('an unknown exception occurred.');
END;
/
--Response from the system will be...A VALUE_ERROR occurred

--Statement that raises an application error
RAISE_APPLICATION_ERROR(-20001, 'Credit total may not be negative.');

--Script that catches an application error
BEGIN 
	update_invoices_credit_total('367447', 100);
EXCEPTION
	WHEN VALUE_ERROR THEN
		DBMS_OUTPUT.PUT_LINE('A VALUE_ERROR occurred.');
	WHEN OTHERS THEN 
		DBMS_OUTPUT.PUT_LINE('An unknown exception occurred.');
END;
/
--Response from the system...An unknown exception occurred

--A STORED PROCEDURE THAT INSERTS A ROW 
--A stored procedure that validates the data in a new invoice_number
CREATE OR REPLACE PROCUEDURE insert_invoice
(
	vendor_id_param			invoices.vendor_id%TYPE,
	invoice_number_param	invoices.invoice_number%TYPE,
	invoice_date_param		invoices.invoice_date%TYPE, 
	invoice_total_param		invoices.invoice_total%TYPE,
	payment_total_param		invoices.payment_total&TYPE DEFAULT 0,
	credit_total_param		invoices.credit_total%TYPE DEFAULT 0,
	terms_id_param			invoices.terms_id%TYPE DEFAULT NULL,
	invoice_due_date_param	invoices.invoice_due_date%TYPE DEFAULT NULL,
	payment_date_param		invoices.payment_date%TYPE DEFAULT NULL
)
AS
	invoice_id_var			invoices.invoice_id%TYPE;
	terms_id_var			invoices.terms_id%TYPE;
	invoice_due_date_var	invoices.invoice_date%TYPE;
	terms_due_days_var		INTEGER;
BEGIN
	IF invoice_total_param < 0 THEN
		RAISE VALUE_ERROR;
	END IF;
	
	SELECT invoice_id_seq.NEXTVAL INTO invoice_id_var FROM dual;
	
	IF terms_id_param IS NULL THEN
		SELECT default_terms_id 
		INTO terms_id_var
		FROM vendors
		WHERE vendor_id = vendor_id_param;
	ELSE
		terms_id_var := terms_id_param;
	END IF;
	
	IF invoice_due_date_param IS NULL THEN 
		SELECT terms_due_days 
		INTO terms_due_days_var
		FROM terms 
		WHERE terms_id = terms_id_var;
		invoice_due_date_var := invoice_date_param + terms_due_days_var;
	ELSE 
		invoice_due_date_var := invoice_due_date_param;
	END IF;
	
	INSERT INTO invoices
	VALUES (invoice_id_var, vendor_id_param, invoice_number_param, invoice_date_param, invoice_total_param, payment_total_param,
		    credit_total_param, terms_id_param, invoice_due_date_param, payment_date_param);
			
END;
/

--Statement that calls the stored procedure with all the paramenters
CALL insert_invoice(34, 'ZXA-080', '30-AUG-08', 14092.59,
					0, 0, 3, '30-SEP-08', NULL);
					
--STORED PROCEDURE THAT DROPS A TABLE
--A stored procedure that drops a table
CREATE OR REPLACE PROCEDURE drop_table
(
	table_name VARCHAR2
)
AS
BEGIN
	EXECUTE IMMEDIATE 'DROP TABLE ' || table_name; --This is the line of code that drops the table
EXCEPTION 
	WHEN OTHERS THEN --Exception means do not do anything
		NULL;
END;
/

--Statement that calls the stored procedure 
CALL drop_table('test1');

--HOW TO DROP A STORED PROCEDURE 
CREATE PROCEDURE clear_invoices_credit_total
(
	invoice_number_param		VARCHAR2
)
AS 
BEGIN
	UPDATE invoices
	SET credit_total = 0
	WHERE invoice_number = invoice_number_param;
	
	COMMIT;
END;
/

--Statement that drops a stored procedure 
DROP PROCEDURE clear_invoices_credit_total

--HOW TO CODE USER DEFINED FUNCTIONS
--Function that returns the vendor ID that matches a vendor's name
CREATE OR REPLACE FUNCTION get_vendor_id
(
	vendor_name_param	VARCHAR2	--parameter of function 
)
RETURN NUMBER 
AS	--Begin coding SQL 
	vendor_id_var	NUMBER;
BEGIN 
	SELECT vendor_id
	INTO vendor_id_var
	FROM vendors
	WHERE vendor_name = vendor_name_param;
	
	RETURN vendor_id_var;
END;
/

--SELECT statement that uses the function
SELECT invoice_number, invoice_total 
FROM invoices
WHERE vendor_id = get_vendor_id('IBM')

--Function that calculates balance due 
CREATE OR REPLACE FUNCTION get_balance_due 
(
	invoice_id_param NUMBER
)
RETURN NUMBER
AS 
	balance_due_var NUMBER;
BEGIN 
	SELECT invoice_total - payment_total - credit_total AS balance_due_var
	INTO balance_due_var
	FROM invoices
	WHERE invoice_id = invoice_id_param;
	
	RETURN balance_due_var;
END;
/

--Statement that calls the function 
SELECT vendor_id, invoice_number, get_balance_due(invoice_id) AS balance_due 
FROM invoices
WHERE vendor_id = 37;

--HOW TO DROP A FUNCTION
--Statement that creates a function
CREATE FUNCTION get_sum_balance_due
(
	vendor_id_param NUMBER
)
RETURN NUMBER
AS
	sum_balance_due_var	NUMBER;
BEGIN
	SELECT SUM(get_balance_due(invoice_id)) AS sum_balance due
	INTO sum_balance_due_var
	FROM invoices
	WHERE vendor_id = vendor_id_param;
	
	RETURN sum_balance_due_var;
END;
/

--Statement that calls the function
SELECT vendor_id, invoice_number, get_balance_due(invoice_id) AS balance_due, get_sum_balance_due(vendor_id) AS sum_balance_due_var
FROM invoices
WHERE vendor_id = 37;

--Statement that drops a function
DROP FUNCTION get_sum_balance_due;

--HOW TO WORK WITH PACKAGES 
--Code that defines the specification for a package named murach
CREATE OR REPLACE PACKAGE murach AS

	PROCEDURE update_invoices_credit_total
	(invoice_number_param VARCHAR2, credit_total_param NUMBER);
	
	FUNCTION get_vendor_id
	(vendor_name_param VARCHAR2)
	RETURN NUMBER;
	
END murach;

--Code the defines the body for a package named murach 
CREATE OR REPLACE PACKAGE BODY murach AS 

	PROCEDURE update_invoices_credit_total
	(
		invoice_number_param	VARCHAR2,
		credit_total_param		NUMBER
	)
	AS
	BEGIN 
		UPDATE invoices
		SET credit_total = credit_total_param
		WHERE invoice_number = invoice_number_param;
		
		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
	END;
	
	FUNCTION get_vendor_id
	(vendor_name_param VARCHAR2)
	RETURN NUMBER
	AS
		vendor_id_var	NUMBER;
	BEGIN
		SELECT vendor_id
		INTO vendor_id_var 
		FROM vendors
		WHERE vendor_name = vendor_name_param;
		
		RETURN vendor_id_var;
	END;
	
END murach;
/

--Statement that calls a procedure that's stored in a package
CALL murach.update_invoices_credit_total('367447', 200);

--SELECT statement that calls a function that's stored in a package 
SELECT invoice_number, invoice_total
FROM invoices
WHERE vendor_id = murach.get_vendor_id('IBM');

--Statement that drops the specification and body for a package 
DROP package murach;

--Statement that drops only the body for a package
DROP PACKAGE BODY murach;

--HOW TO WORK WITH TRIGGERS
--A CREATE TRIGGER statement that corrects mixed-case state names
CREATE OR REPLACE TRIGGER vendors_before_update_state
BEFORE INSERT OR UPDATE OF vendor_state
ON vendors
FOR EACH ROW 
WHEN (NEW.vendor_state != UPPER(NEW.vendor_state))	--means making sure code is not null
BEGIN 
	:NEW.vendor_state := UPPER(:NEW.vendor_state);	--Makes state coes always upper case
END;
/

--UPDATE statement that fires the trigger
UPDATE vendors
SET vendor_state = 'wi'
WHERE vendor_id = 1;

--SELECT statement that shows the new row
SELECT vendor_name, vendor_state
FROM vendors
WHERE vendor_id = 1;

--Trigger that validates line item amounts when updating the invoice total 
CREATE OR REPLACE TRIGGER invoices_before_update_total
BEFORE UPDATE OF invoice_total
ON invoices_before_update_total
FOR EACH ROW
DECLARE
	sum_line_item_amount NUMBER;
BEGIN
	SELECT SUM(line_item_amt)
	INTO sum_line_item_amount
	FROM invoice_line_items
	WHERE invoice_id = :new.invoice_id;
	
	IF sum_line_item_amoutn != :new.invoice_total THEN 
		RAISE_APPLICATION_ERROR(-200001,
			'Line item total must match invoice total.');
	END IF;
END;
/

--UPDATE statement that fires the trigger
UPDATE invoices
SET invoice_total = 600
WHERE invoice_id = 100;

--Response from the system...ORA-20001: Line item total must match invoice total 

--HOW TO USE A TRIGGER TO WORK WITH A SEQUENCE 
--A trigger that sets the next primary key value for a row 
CREATE OR REPLACE TRIGGER invoices_before_insert
BEFORE INSERT ON invoices	--runs before a value is inserted 
FOR EACH ROW 
WHEN (NEW.invoice_id IS NULL)	--only adds a next value if the value is 0
BEGIN
	SELECT invoice_id_seq.NEXTVAL 
	INTO :new.invoice_id
	FROM dual;
END;
/

--INSERT statement that fires the trigger
INSERT INTO invoices
(vendor_id, invoice_number, invoice_date, invoice_total, terms_id, invoice_due_date)
VALUES 
(34, 'ZXA-080', '30-AUG-08', 14092.59, 3, '30-SEP-08');

--SELECT statement that retrieves the row that was inserted
SELECT *
FROM invoices 
WHERE invoice_number = 'ZXA-080';

--HOW TO CREATE AN AFTER TRIGGER FOR A TABLE 
--Statement that creates an audit table for actions on the invoices table
CREATE TABLE invoices_audit 
(
	vendor_id			NUMBER 			NOT NULL,
	invoice_number		VARCHAR2(50)	NOT NULL,
	invoice_total		NUMBER			NOT NULL,
	action_type			VARCHAR2(50)	NOT NULL,
	action_date			DATE			NOT NULL 
);

--An AFTER trigger that inserts rows into the audit table 
CREATE OR REPLACE TRIGGER invoices_after_dml 
AFTER INSERT OR UPDATE OR DELETE
ON invoices 
FOR EACH ROW
BEGIN 
	IF INSERTING THEN
		INSERT INTO invoices_audit VALUES 
		(:new_vendor_id, :new.invoice_number, :new.invoice_total, 'INSERTED', SYSDATE);
	ELSIF UPDATING THEN 
		INSERT INTO invoices_audit VALUES 
		(:old.vendor_id, :old.invoice_num ber, :old.invoice_total, 'UPDATED', SYSDATE);
	ELSIF DELETING THEN 
		INSERT INTO invoices_audit VALUES 
		(:old.vendor_id, :old.invoice_number, :old.invoice_total, 'DELETED', SYSDATE);
	END IF;
END;
/

--INSERT statement that causes the trigger to fires
INSERT INTO invoices VALUES 
(115, 34, 'ZXA-080', '30-AUG-08', 14092.59, 0, 0, 3, '30-SEP-08', NULL);

--DELETE statement that causes the trigger to fire 
DELETE FROM invoices WHERE invoice_number = 'ZXA-080';

--SELECT statement that retrieves the rows in the audit table 
SELECT *
FROM invoices_deleted;

--HOW TO USE AN INSTEAD OF TRIGGER FOR A VIEW 
--Statement that creates a view 
CREATE OR REPLACE VIEW ibm_invoices 
AS 
SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE vendor_id = 34; 

--An INSTEAD OF INSERT trigger for a view 
CREATE OR REPLACE TRIGGER ibm_invoices_instead_of_insert
INSTEAD OF INSERT 
ON ibm_invoices
BEGIN 
	INSERT INTO invoices VALUES 
	(invoice_id_seq.NEXTVAL, 34, :new.invoice_number, :new.invoice_date,
	:new.invoice_total, 0, 0, 3, :new.invoice_date + 30, NULL);
END;
/

--HOW TO USE A TRIGGER TO WORK WILL DDL STATEMENTS
--A trigger that works with DDL statements
CREATE OR REPLACE TRIGGER ap_before_create_drop
BEFORE CREATE OR DROP ON ap.SCHEMA
BEGIN 
	RAISE_APPLICATION_ERROR(-20001, 'You cannot create or drop an object in the AP schema');
END;
/

--CREATE table statement that fires the trigger
CREATE TABLE ap.test1(test_id NUMBER);

--HOW TO ENABLE, DISABLE, RENAME, AND DROP A TRIGGER
--Statements that disable and enable a trigger
ALTER TRIGGER ap_before_create DISABLE;
CREATE TABLE test1 (test_id NUMBER);
DROP TABLE test1;
ALTER TRIGGER ap_before_create ENABLE;

--Statements that disable and enable all triggers for a table
ALTER TABLE invoices DISABLE ALL TRIGGERS;
ALTER TABLE invoices ENABLE ALL TRIGGERS;

--Statement that renames a trigger
ALTER TRIGGER invoices_before_update_total; 
RENAME TO invoices_before_update_inv_tot;

--Statement that drops a trigger 
DROP TRIGGER ap_before_create;

--HOW TO CODE A COMPOUND TRIGGER 
--Compound trigger
CREATE OR REPLACE TRIGGER invoices_compound_update
FOR UPDATE OF invoice_total, credit_total
ON invoices
COMPOUND TRIGGER 
	test_value NUMBER := 1;
	
	BEFORE STATEMENT IS 
	BEGIN
		DBMS_OUPUT.PUT_LINE('before statement: ' || test_value);
	END BEFORE STATEMENT;
	
	BEFORE EACH ROW IS
	BEGIN
		DBMS_OUPUT.PUT_LINE('before row: ' || test_value);
	END BEFORE EACH ROW;
	
	AFTER EACH ROW IS
	BEGIN
		DBMS_OUPUT.PUT_LINE('after row: ' || test_value);
	END AFTER EACH ROW;
	
	AFTER STATEMENT IS 
	BEGIN
		DBMS_OUPUT.PUT_LINE('after statement: ' || test_value);
	END AFTER STATEMENT;
END;
/

--Script that fires the trigger
SET SERVEROUTPUT ON;

UPDATE invoices 
SET credit_total = 0
WHERE invoice_id = 100;

--AN INTRODUCTION TO TIME ZONE NAMES
--How to view time zone names
SELECT *
FROM v$timezone_names

--How to view the default session time zone
SELECT SESSIONTIMEZONE 
FROM dual 

--How to view the default database time zone
SELECT DBTIMEZONE 
FROM dual 

--HOW TO CHANGE THE DEFAULT DATE FORMAT	
--Statement that changes the date format for the session
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-RR HH:MI AM'

--INSERT statement after the date format has been changed
INSERT INTO date_sample VALUES (7, '02-mar-08 09:02 AM')

--SELECT statement after the data format has been changed
SELECT *
FROM date_sample

--Statements that use keywords to change the time zone for the session
ALTER SESSION SET TIME_ZONE = LOCAL
ALTER SESSION SET TIME_ZONE = DBTIMEZONE

--Statements that change the time zone for the session
ALTER SESSION SET TIME_ZONE = -06:00
ALTER SESSION SET TIME_ZONE = 'MST'
ALTER SESSION SET TIME_ZONE = 'US/Mountain'

--HOW TO WORK WITH THE TIMPSTAMP TYPE
--Table that uses the TIMESTAMP type
CREATE TABLE downloads
(
	download_id			NUMBER		PRIMARY KEY,
	download_timestamp	TIMESTAMP(6)
);

--Script that inserts three TIMESTAMP values into a table
INSERT INTO downloads
VALUES (1, TIMESTAMP '2008-08-15 16:20l47.123456');

INSERT INTO downloads
VALUES (2, TIMESTAMP '2008-08-15 16:20:47.1234567');

INSERT INTO downloads
VALUES 93, CURRENT_TIMESTAMP(6));

COMMIT;

--Statement that retrieves the TIMESTAMP values 
SELECT *
FROM downloads;

--Default format for specifying a TIMESTAMP literal
TIMESTAMP 'YYYY-MM-DD HH24:MI:SS.FF9'

--Default format for returned TIMESTAMP values
DD-MON-RR HH.MI.SS.FF9 AM 

--HOW TO WORK WITH THE TIMESTAMP WITH LOCAL TIME ZONE TYPE 
--Table that uses the TIMESTAMP WITH LOCAL TIME ZONE type 
CREATE TABLE downloads_ltz
(
	download_id				NUMBER								PRIMARY KEY,
	download_timestamp		TIMESTAMP WITH LOCAL TIME ZONE
);

--Script that inserts four TIMESTAMP WITH LOCAL TIME ZONE values 
INSERT INTO downloads_ltz
VALUES (1, TIMESTAMP '2008-08-15 16:20:47.123456 PST');

INSERT INTO downloads_ltz 
VALUES (2, TIMESTAMP '2008-08-15 16:20:47.123456 EST');

INSERT INTO downloads_ltz
VALUES (3, TIMESTAMP '2008-08-15 16:20:47.123456 -7:00');

INSERT INTO downloads_ltz
VALUES (4, CURRENT_TIMESTAMP);

COMMIT;

--Statement that retrieves the TIMESTAMP values
SELECT *
FROM downloads_ltz;

--HOW TO WORK WITH THE TIMESTAMP WITH TIME ZONE TYPE 
--Table that uses the TIMESTAMP WITH TIME ZONE type 
CREATE TABLE downloads_tz
(
	download_id				NUMBER						PRIMARY KEY,
	download_timestamp		TIMESTAMP WITH TIME ZONE	
);

--Script that inserts TIMESTAMP WITH TIME ZONE values 
INSERT INTO downloads_tz
VALUES (1, TIMESTAMP '2008-08-15 16:20:47.123456789 PST');

INSERT INTO downloads_tz
VALUES (2, TIMESTAMP '2008-08-15 16:20:47.123456 US/Pacific');

INSERT INTO downloads_tz 
VALUES (3, TIMESTAMP '2008-08-15 16:20:47.123456 -7:00');

INSERT INTO downloads_tz 
VALUES (4, TIMESTAMP '2008-08-15 16:20:47.123456 EST');

INSERT INTO downloads_tz 
VALUES(5, CURRENT_TIMESTAMP);

COMMIT;

--Statement that retrieves the TIMESTAMP values
SELECT *
FROM downloads_tz 

--How to convert a string to a TIMESTAMP value 
SELECT TO_TIMESTAMP('15-AUG-08 4:20:47.123456 PM')
FROM dual;

SELECT TO_TIMESTAMP('2008-08-15 4:20:47.123456 PM', 'YYYY-MM-DD HH:MI:SS.FF6 AM')
FROM dual;

--How to convert a string to a TIMESTAMP WITH TIME ZONE value 
SELECT TO_TIMESTAMP_TZ ('15-AUG-08 4:20:47.123456 PM PST')
FROM dual;

SELECT TO_TIMESTAMP_TZ ('2008-08-15 16:20:47.123 PST', 'YYYY-MM-DD HH24:MI:SS.F6 TZR')
FROM dual;

--SELECT statement that formats a timestamp
SELECT TO_CHAR (CURRENT_TIMESTAMP, 'DD-MON-RR HH:MI:SS.FF9 AM TZR')
AS time_zone_test
FROM dual;

--Another SELECT statement that formats a timestamp
SELECT TO_CHAR(transaction_timestamp, 'DD-MON-RR HH:MI:SS.FF A, TZD')
AS download_timestamp
FROM timestamp_tz_sample;

--Table that uses the INTERVAL YEAR TO MONTH type 
CREATE TABLE interval_ym_sample
{
	interval_id					NUMBER						PRIMARY KEY,
	interval_value				INTERVAL YEAR(3) TO MONTH 
}

--Script that inserts INTERVAL values
INSERT INTO interval_ym_sample
VALUES (1, INTERVAL '1' YEAR);

INSERT INTO interval_ym_sample
VALUES (2, INTERVAL '3' MONTH);

INSERT INTO interval_ym_sample
VALUES (3, INTERVAL '15' MONTH);

INSERT INTO inverval_ym_sample
VALUES (4, INTERVAL '1-3' YEAR TO MONTH);

INSERT INTO interval_ym_sample
VALUES (5, INTERVAL '-1-3' YEAR TO MONTH);

INSERT INTO interval_ym_sample
VALUES (6, INTERVAL '100' YEAR(3));

COMMIT;

--Statement that retrieves INTERVAL values 
SELECT *
FROM interval_ym_sample

--HOW TO WORK WITH THE INTERVAL DAY TO SECOND type 
--Table that uses the INTERVAL DAY TO SECOND type 
CREATE TABLE interval_ds_sample
(
	interval_id				NUMBER					PRIMARY KEY,
	interval_value			INTERVAL DAY(3) TO SECOND(2)
);

--Script that inserts INTERVAL values
INSERT INTO interval_ds_sample
VALUES(1, INTERVAL '1' DAY);

INSERT INTO interval_ds_sample
VALUES (2, INTERVAL '4' HOUR);

INSERT INTO interval_ds_sample
VALUES (3, INTERVAL '20' MINUTE);

INSERT INTO interval_ds_sample
VALUES (4, INTERVAL '31' SECOND);

INSERT INTO interval_ds_sample
VALUES (5, INTERVAL '31.45' SECOND);

INSERT INTO interval_ds_sample
VALUES (6, INTERVAL '1 4:20:31.45' DAY TO SECOND);

INSERT INTO interval_ds_sample
VALUES (7, INTERVAL '-1 4:20:31.45' DAY TO SECOND);

INSERT INTO interval_ds_sample
VALUES (8, INTERVAL '100 4:20:31.45' DAY(3) TO SECOND);

COMMIT;

--Statement that retrieves INTERVAL values
SELECT *
FROM interval_ds_sample

