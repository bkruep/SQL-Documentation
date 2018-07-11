--Code blocks 
DECLARE 
	v_jobcode VARCHAR2(3) := 'ACC';
BEGIN
	UPDATE jobs
	SET maxrate = 25 
	WHERE jobcode = v_jobcode;
END;



--LESSON 2: VARIABLES AND CONSTANTS 
--Declarea a numeric variable(v_cost), which accepts a max of five digits, with two decimal places:
v_cost NUMBER(5, 2);

--The following declares v_quantity as a number with three possible digits and assigns an initial value of 8 
v_quantity NUMBER(3) := 8;

--Use the default keyword to assign the initial value, as shown with the v_firstname variable
v_firstname VARCHAR2(10) DEFAULT 'Sandy';

--Boolean variables, like v_flag, can be very useful when testing a program
v_flag BOOLEAN := TRUE;

--Instead of initializing a variable with a literal value, you could assign the value of a system function
v_startdate DATE := SYSDATE;

--You can use expressions, including mathematical operators or SQL functions, to assign an initial value
v_reviewdate DATE := SYSDATE + 30;

--You can use the value of one variable to calculate the value of another variable 
v_startdate DATE := SYSDATE;
v_reviewdate DATE := v_startdate + 30;

--Declares the variable v_quantity as NOT NULL and assigns it an initial value of 8 
v_quantity NUMBER(3) NOT NULL := 8;

--Declares c_minwage as a constant and assigns it the value of 5.15
c_minwage CONSTANT NUMBER(3,2) := 5.15;

--Declares the variable v_message and then assigns it a value (Hello World) in the executable section:
DECLARE 
	v_message VARCHAR2(25);
BEGIN 
	v_message := 'Hello world';
	DBMS_OUTPUT.PUT_LINE(v_message);
END;

--The following statement uses Oracle's concatenation operator to combine the string 'My message is:' with the value stored in v_message:
DBMS_OUTPUT.PUT_LINE('My message is: ' || v_message);

--Write a simple program that displays your first and last names to the screen
DECLARE 
--declares and initializes variables for first and last names 
  v_firstname VARCHAR2(20) := 'Sandy';
  v_lastname VARCHAR2(20) := 'Turner';
BEGIN 
--displays first and last name values on the screen 
  DBMS_OUTPUT.PUT_LINE(v_firstname || ' ' || v_lastname);
 END;
 
--Write a program that calculates the total price of a purchase, based on a sale price of $10 and a constant tax rate of 7.5%.  
--Display the sale price, amount of tax, and total price to the screen 
DECLARE 
--declares variables for item price, total purchase price, and tax amount 
  v_item_price   NUMBER(7, 2);
  v_tax_amt      NUMBER(7, 2);
  v_total_purch  NUMBER(7, 2);
--declares constant for tax rate 
  c_tax_rate     CONSTANT NUMBER(5, 3) := .075;
BEGIN 
  v_item_price := 10;
  v_tax_amt := v_item_price * c_tax_rate;			--calculates tax amount 
  v_total_purch := v_item_price + v_tax_amt;        --calculates total price 
--displays sale price, tax amount, and total price 
  DBMS_OUTPUT.PUT_LINE('Sale price:  $' || v_item_price);
  DBMS_OUTPUT.PUT_LINE('Tax:         $' || v_tax_amt);
  DBMS_OUTPUT.PUT_LINE('Total price: $' || v_total_purch);
END;
 
 
 
--LESSON 3: SELECTING AND MANUPULATING DATA
--INTO clause allows you to transfer data from database into PL/SQL variables 
DECLARE	
	--declares variable for member ID, firstname, and membership date
	v_memid members.mem_id%TYPE := 'AC135';
	v_fname members.firstname%TYPE;
	v_memdate members.memdate%TYPE;
BEGIN
	--retrieves data for member AC135 from members table 
	SELECT firstname, memdate 
	INTO v_fname, v_memdate
	FROM members 
	WHERE mem_id = v_memid;
	--displays selected data and reformats date
	DBMS_OUTPUT.PUT_LINE(v_fname || ' joined on ' || TO_CHAR(v_memdate, 'MONTH DD, YYYY'));
END;

--Write a procedure to select and display the membership dues for the student members (with the membership code ST)
DECLARE
	v_memcode memtype.memcode%TYPE := 'ST';
	v_dues    memtype.dues%TYPE;
BEGIN
	SELECT dues 
	INTO v_dues
	WHERE memcode = v_memcode;
	DBMS_OUTPUT.PUT_LINE(v_memcode || ' dues: $' || v_dues);
END;

--Queries MEMBERS table and retrieves the first and last membership dates 
DECLARE
	v_firstdate members.memdate%TYPE;
	v_lastdate  members.memdate%TYPE;
BEGIN 
	SELECT min(memdate, max(memdate)
	INTO v_firstdate, v_lastdate 
	FROM members;
	DBMS_OUTPUT.PUT_LINE('First membership: ' || v_firstdate);
	DBMS_OUTPUT.PUT_LINE('Most recent membership: ' || v_lastdate);
END;

--Inserts a new row into the memtype table 
BEGIN
	INSERT INTO memtype (memcode, mem_descrip, dues)
	VALUES ('DN', 'DONOR', 0);
END;	

--Use variables to specify values for a new row 
DECLARE
	v_memcode memtype.memcode%TYPE     := 'AR';
	v_descrip memtype.mem_descrip%TYPE := 'ARTIST';
	v_dues    memtype.dues%TYPE        := 10.95;
BEGIN
	INSERT INTO memtype (memcode, memdescrip, dues)
	VALUES (v_memcode, v_descrip, v_dues)
END;
	
--OR allows you to input the data 
 DECLARE
	v_memcode memtype.memcode%TYPE     := '&p_memcode';
	v_descrip memtype.mem_descrip%TYPE := '&p_mem_descrip';
	v_dues    memtype.dues%TYPE        := &p_dues;
BEGIN
	INSERT INTO memtype (memcode, memdescrip, dues)
	VALUES (v_memcode, v_descrip, v_dues)
END;

--Update data that raises membership dues of adult and family members by 10%
DECLARE
	v_increase NUMBER (5,2) := .1;
BEGIN
	UPDATE memtype 
	SET    dues = dues * (1 + v_increase)
	WHERE  memcode IN ('AD', 'FM');
END;

--Delete statement to delete all senior (SR) members from the MEMBERS table:
DECLARE 
	v_memcode members.memcode%TYPE := 'SR';
BEGIN 
	DELETE FROM members
	WHERE memcode = v_memcode;
	DBMS_OUTPUT.PUT_LINE('Rows deleted: ' || SQL%ROWCOUNT);	--Shows the count of the number of rows deleted
END;

--Using the EMPLOYEE table, write a PL/SQL block to display the first name, last name, and job code for employee A1465
DECLARE
	v_empid			employee.empid%TYPE := 'A1465';
	v_firstname     employee.firstname%TYPE;
	v_lastname      employee.lastname%TYPE;
	v_jobcode       employee.jobcode%TYPE;
BEGIN
	SELECT firstname, lastname, jobcode 
	INTO v_firstname, v_lastname, v_jobcode 
	FROM employee
	WHERE empid = v_empid;
	DBMS_OUTPUT.PUT_LINE(v_firstname || ' ' || v_lastname || ' is a ' || v_jobcode);
END;

--Write a procedure to insert a new job into the JOBS table, using the data provided in the exercise 
DECLARE
	v_jobcode jobs.jobcode%TYPE := 'INT';
	v_jobdesc jobs.jobdesc%TYPE := 'INTERN';
	v_class   jobs.class%TYPE   := 'NON-EXEMPT';
	v_minrate jobs.minrate%TYPE := 5.75;
	v_maxrate jobs.maxrate%TYPE := 9.75;
BEGIN 
	INSERT INTO jobs (jobcode, jobdesc, class, minrate, maxrate)
	VALUES (v_jobcode, v_jobdesc, v_class, v_minrate, v_maxrate);
	COMMIT;
END;

--Write a procedure to update the JOBS table according to the following conditions:
	--Increase the maximum salaries for all EXEMPT jobs by 5%
	--Increase the maximum salaries for all NON-EXEMPT jobs by 8%
	DECLARE 
		v_exempt_inc NUMBER(5,2) := .05;
		v_nonex_inc  NUMBER(5,2) := .08;
	BEGIN 
		--increase maxrate for exempt jobs by 5%
		SAVEPOINT a;
		UPDATE jobs
		SET    maxrate = maxrate * (1 + v_exempt_inc)
		WHERE  class = 'EXEMPT';
		--increases maxrate for non-exempt jobs by 8%
		SAVEPOINT b;
		UPDATE    jobs
		SET       maxrate = maxrate * (1 + v_nonex_inc)
		WHERE     class = 'NON-EXEMPT';
		

		
--LESSON 4: WRITING IF STATEMENTS
--IF, IF-ELSIF, and NULL statement
DECLARE 
	v_num1 PLS_INTEGER := &p_num1;
	v_num2 PLS_INTEGER := &p_num2;
BEGIN 
	IF v_num1 > v_num2 THEN 
		DBMS_OUTPUT.PUT_LINE('Number 1 is greater than Number 2');
		ELSIF v_num2 > v_num1 THEN
			DBMS_OUTPUT.PUT_LINE('Number 2 is greater than Number 1');
		ELSIF v_num1 = v_num2 THEN 
			DBMS_OUTPUT.PUT_LINE('The numbers are equal');
		ELSIF v_num1 IS NULL OR v_num2 IS NULL THEN 
			DBMS_OUTPUT.PUT_LINE('You must enter two numbers');
	END IF;
	DBMS_OUTPUT.PUT_LINE('Thank you')
END;

--Using Oracle to make decisions 
--Ask user to enter a member ID and determine a membership "level" and discount, based on the member's original membership date
DECLARE
	v_memlevel	VARCHAR2(10);
	v_discount  NUMBER(5,2);
	v_memid		members.mem_id%TYPE := UPPER('&p_member_id');
	v_memdate   members.memdate%TYPE;
	v_flag      BOOLEAN;
BEGIN
	--Selects membership date based on ID entered by user 
	SELECT memdate
	INTO v_memdate
	FROM members
	WHERE mem_id = v_memid
	
	--v_flag is true if memdate is before Jan 1, 1998
	v_flag := v_memdate < '01-JAN-00';
	
	--Determines membership level and discount based on memdate
	IF v_flag THEN 
	   v_memlevel := 'GOLD';
	   v_discount := .1; 
	ELSE 
	   v_memlevel := 'WHITE';
       v_discount := 0;
	END IF;
	
	--Displays membership level and discount 
	DBMS_OUTPUT.PUT_LINE('Membership level: ' || v_memlevel);
	DBMS_OUTPUT.PUT_LINE('Membership discount: ' || v_discount * 100 || '%');
END;

--Set up a procedure that requests the user's age and then determines whether the person is old enough to drive 
DECLARE 
	v_age PLS_INTEGER := &p_age;
BEGIN 
	IF v_age >= 16 THEN 
		DBMS_OUTPUT.PUT_LINE('You are old enough to drive a car.');
	ELSIF v_age = 15 THEN 
		DBMS_OUTPUT.PUT_LINE('You can get a learner permit.');
	ELSE 
		DBMS_OUTPUT.PUT_LINE('You are only " || v_age');
		DBMS_OUTPUT.PUT_LINE('You must wait " || (16 - v_age') || ' years to drive.');
  
--Write a procedure that calculates a raise percentage based on an employee's score on a performance review.
--Ask the user to input the evaluation score; then display the raise based on that score.
--If the user enters an invalid score (anything other than 1, 2, or 3), display the following message: Enter 1, 2, or 3 as the rating 
DECLARE
	v_empid         employee.empid%TYPE := UPPER('&p_empid');
	v_eval_rating	NUMBER(1) := &p_eval_rating;
	v_raise			NUMBER(5,2);

BEGIN 
	IF v_eval_rating = 3 THEN 
		v_raise := .05;
	ELSIF v_eval_rating = 2 THEN 
		v_raise := .03; 
	ELSIF v_eval_rating = 1 THEN 
		v_raise := 0;
	END IF;
	
	IF v_raise IS NULL THEN 
		DBMS_OUTPUT.PUT_LINE('Enter 1, 2, or 3 as the rating.');
	ELSE 
		DBMS_OUTPUT.PUT_LINE('Your raise is ' || (v_raise * 100) || '%');
		UPDATE employee
		SET hourrrate= hourrate * (1 + v_raise)
		WHERE empid = v_empid;
	END IF;
END;

--Write an anonymous PL/SQL block that determines overtime eligibility for museum employees.
--Create substitution variables to get user input for employee ID and hours worked.
--Then determine overtime eligibility for the employee whose ID you entered, based on the factors outlined in the exercise.
--As part of the procedure, display a message stating whether the employee is eligible for overtime 
DECLARE 
	v_empid			employee.empid%TYPE := UPPER('&p_empid');
	v_weekly_hours	NUMBER(5,2)			:= &p_weekly_hours;
	v_class         jobs.class%TYPE;
	v_hourrate      employee.hourrate%TYPE;
	v_weekly_pay	NUMBER(7,2);
BEGIN
	SELECT class, hourrate 
	INTO v_class, v_hourrate
	FROM employee e, job j 
	WHERE e.jobcode = j.jobcode
	AND empid = v_empid; 
	
	IF v_class = 'NON-EXEMPT' AND v_weekly_hours > 40 THEN 
		DBMS_OUTPUT.PUT_LINE('You are eligible for overtime pay.');
		v_weekly_pay := (40 * v_hourrate) + ((v_weekly_hours - 40) * (v_hourrate * 1.5));
	ELSE 
		DBMS_OUTPUT.PUT_LINE('You are not eligible for overtime pay.');
		v_weekly_pay := 40 * v_hourrate;
	END IF;
	DBMS_OUTPUT.PUT_LINE('Weekly pay: $' || v_weekly_pay);
  END;
  
 
 
 --LESSON 5: Using CASE statements and expressions 
 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  