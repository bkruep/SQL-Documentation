--The NOT query
SELECT * 
FROM Customers
WHERE city = 'San Jose'
OR NOT rating > 200;

--Between query includes .10 and .12 
SELECT *
FROM SalesPeople
WHERE comm BETWEEN .10 AND .12;
		
--All SalesPeople with commissions between .10 and .12 but not .10 or .12
SELECT *
FROM SalesPeople
WHERE (comm BETWEEN .10 AND .12)
AND NOT comm IN (.10, .12)
			
--Selects all customers whose names fall in a certain alphabetical range
SELECT *
FROM Customers
WHERE cname BETWEEN 'A' AND 'G';
		
--LIKE OPERATOR
--Find all the customers whose name begin with GETBND
SELECT *
FROM Customers	
WHERE cname LIKE 'G%'
		
--Runs possible matches if you don't know how to spell a name
SELECT *
FROM SalesPeople
WHERE sname LIKE 'P_ _ l%'
		
--NULL OPERATOR
--Find all records in our Customers table with NULL values in the city column
SELECT *
FROM Customers
WHERE CITY IS NULL
		
--Show results for city not being in London or San Jose
SELECT *
FROM SalesPeople
WHERE city NOT IN ('London', 'San Jose')

--Find the SUM of all of our purchases from the Orders table
SELECT SUM(amt)
FROM Orders
	
--Find the average amount of an order 
SELECT AVG(amt)
FROM Orders
	
--Count the number of salespeople currently listing orders in the Orders table
SELECT COUNT (DISTINCT snum)
FROM Orders
	
--Count the number of nonNULL rating fields in the Customers table including repeats
SELECT COUNT (ALL rating)
FROM Customers
	
--Find the current balance by adding the Order amount to the prior balance
SELECT MAX(blnc + amt)
FROM Orders
	
--You could do a separate query for each, selecting the MAX amt from the orders table for each snum value
--Group by let you put it in one command
SELECT snum, MAX(amt)
FROM Orders
GROUP BY snum 
		
--Group the orders by date within salesperson and apply the MAX function to each group
SELECT snum, odate, MAX(amt)
FROM Orders
GROUP BY snum, odate
		
--The HAVING clause defines criteria used to eliminate certain groups from the output, just as the WHERE clause does for the individual rows
SELECT snum, odate, MAX(amt)
FROM Orders
GROUP BY snum, odate,
HAVING MAX(amt) > 3000.00
			
--The HAVING clause must reference only aggregates and fields chosen by GROUP BY 
SELECT snum, MAX(amt)
FROM Orders
WHERE odate = 10/03/1990
GROUP BY snum
			
--Largest orders for Serres and Rifkin
SELECT snum, MAX(amt)
FROM Orders
GROUP BY snum
HAVING snum IN (1002, 1007)
					
--Write a query that counts all orders for October 3
SELECT COUNT (*)
From Orders
WHERE odate = 10/03/1990
		
--Write a query that counts the number of different nonNULL city values in the Customers table
SELECT COUNT (DISTINCT city)
FROM Customers
	
--Write a query that selects each customer's smallest order
SELECT cnum, MIN(amt)
FROM Orders
GROUP BY cnum
		
--Write a query that selects the first customer in alphabetical order whose name begins with G 
SELECT MIN (cname)
FROM Customers	
WHERE cname LIKE 'G%'
GROUP BY cname
			
--Write a query that selects the highest rating in each city
SELECT city, MAX(rating)
FROM Customers
GROUP BY city
		
--Write a query that counts the number of salespeople registering orders for each day
--(If a salesperson has more than one order on a given day, he or she should be counted only once)
SELECT odate, COUNT (DISTINCT onum)
FROM Orders
GROUP BY odate

--Present your salesperson's commission as percentages rather than decimal points
SELECT snum, sname, city, comm * 100
FROM SalesPeople
	
--You can refine the previous example by marking the commissions as percentages with the percent sign
--This enables you to put such items as symbols and comments in the output
SELECT snum, sname, city, '%', comm * 100
FROM SalesPeople
	
--Generate output for a report that indicates the number of orders for each day
SELECT 'For', odate, ', there are ', COUNT (DISTINCT onum), 'orders'
FROM Orders
GROUP BY odate
		
--Order table arranged by customer number
SELECT *
FROM Orders
ORDER BY cnum DESC
		
--Order the table by another column, amt, within the cnum ordering
SELECT *
FROM Orders
ORDER BY cnum DESC, amt DESC
	
--Ordering aggregate groups
SELECT snum, odate, MAX(amt)
FROM Orders
GROUP BY snum, odate
ORDER BY snum
			
--Ordering output by column number
SELECT sname, comm
FROM SalesPeople
ORDER BY 2 DESC
		
--Counts the orders of each of our SalesPeople, and outputs the results in descending order
SELECT snum, COUNT (DISTINCT onum)
FROM Orders
GROUP BY snum
ORDER BY 2 DESC
						
--Assume each SalesPerson has a 12% commission
--Write a query on the Orders table that will produce the order number, salesperson number, and the amount of the salesperson's commission for that order
SELECT onum, snum, amt * .12
FROM Orders
	
--Write a query on the Customers table that will find the highest rating in each city
--Put the output in this form...
--"For the city (city), the highest rating is: (rating).
SELECT 'For the city ', city, ', the highest rating is: ', MAX(rating)
FROM Customers
ORDER BY rating DESC
		
--Write a query that totals the orders for each day and places the rest in descending order
SELECT odate, SUM(amt)
FROM Orders
GROUP BY odate	
ORDER BY 2 DESC

--Making a join
--Suppose you want to match your SalesPeople to your customers according to what city they liven in, 
--so you would see all the combinations of SalesPeople and Customers who share a city
--You would need to take each salesperson and search the customers table for all customers in the same city
SELECT Customers.cname, SalesPeople.sname, SalesPeople.city
FROM SalesPeople, Customers
WHERE SalesPeople.city = Customers.city
		
--A common use of the join is to extract data in terms of this relationship
--To show the names of all customers match with the salespeople serving them
SELECT Customers.cname, SalesPeople.sname
FROM Customers, SalesPeople
WHERE SalesPeople.snum = Customers.snum
		
--Equijoins are joins that are predicted based on equalities
--Equijoins are probably the most common sort of join, but there are others
SELECT sname, cname
FROM SalesPeople, Customers
WHERE sname < cname
AND rating < 200
			
--Joins of more than two tables
--You can also construct queries joining more than two tables
--Suppose we wanted to find all orders by customers not located in the same cities as their SalesPeople
SELECT onum, cname, Orders.cnum, Orders.snum
FROM SalesPeople, Customers, Orders
WHERE Customers.city <> SalesPeople.city
AND Orders.cnum = SalesPeople.snum
AND Orders.snum = Customers.cnum
				
--Write a query that list each order number followed by the name of the customer who made the order
SELECT onum, cname
FROM Orders, Customers
WHERE Customers.cnum = Orders.cnum
		
--Write a query that gives the names of both the salesperson and customer for each order after the order number
SELECT onum, sname, cname
FROM Orders, SalesPeople, Customers
WHERE SalesPeople.snum = Orders.snum
AND Customers.cnum = Orders.cnum
			
--Write a query that produces all customers serviced by SalesPeople with a commission above 12%
--Output the customer's name, salesperson's name, and the salesperson's rate of commission
SELECT cname, sname, comm
FROM Customers, SalesPeople
WHERE Customers.cnum = SalesPeople.snum
AND comm > .12
			
--Write a query that calculates the amount of the salesperson's commissions on each day by a customer with a rating above 100
SELECT onum, amt * comm
FROM Orders, Customers, SalesPeople
WHERE Customers.cnum = Orders.cnum
AND SalesPeople.snum = Orders.snum
AND rating > 100

--Eliminating Redundancy
SELECT first.cname, second.cname, first.rating
FROM Customers.first, Customers.second
WHERE first.rating = second.rating
AND first.cname < second.cname;
      
--Checking for errors
SELECT first.onum, first.cnum, first.snum, second.onum, second.onum, second.snum
FROM Orders.first, Orders.second
WHERE first.cnum = second.cnum
AND first.snum <> second.snum;
              
--Complex join
--Finds all the combinations of customers with the three rating values
SELECT a.cnum, b.cnum, c.cnum
FROM Customers a, Customers b, Customers c
WHERE a.rating = 100
AND b.rating = 200
AND c.rating = 300;
        
--Finds all customers located in cities where salesperson Serres has customers
SELECT b.cnum, b.cname
FROM Customers a, Customers b
WHERE a.snum = 1002 
AND b.city = a.city;
      
--The following query joins the Customer table to itself to find all pairs of
--customers served by a single person
--At the same time, it joins the customer to the Salespeople table to name 
--that salesperson
SELECT sname, SalesPeople.snum, first.cname, second.cname
FROM Customers first, Customers second, SalesPeople
WHERE first.snum = second.snum
AND SalesPeople.snum = first.snum
AND first.cnum < second.cnum;
      
--Write a query that produces all pairs of salespeople who are living in the 
--same city.  
--Exclude combinations of salespeople with themselves as well as duplicate
--rows with the order reversed.
SELECT first.name, second.sname
FROM SalesPeople first, SalesPeople second
WHERE first.city = second.city
AND first.sname < second.sname

--Write a query that produces all pairs of orders by a given customer, names
--that customer, and eliminates duplicates, as above.
SELECT cname, first.onum, second.onum
FROM Orders first, Orders second, Customers
WHERE first.cnum = second.cnum
AND first.cnum = Customers.cnum
AND first.onum < second.onum

--Write a query that produces the names and cities of all customers with 
--the same rating as Hoffman,
--Write the query using Hoffman's cnum rather than his rating, so that it 
--would still be usable if his rating changed.
SELECT a.cname, a.city
FROM Customers a, Customers b 
WHERE a.rating = b.rating
AND b.cnum = 2001

--The inner query generates values that are tested in the predicate of the outer query
--Suppose we know the name but not the snum of salesperson Motika and wanted to extract all her orders from the Orders table
SELECT *
FROM Orders
WHERE snum =
	(SELECT snum
	FROM SalesPeople
	WHERE sname = 'Motika')
					
--You can use DISTINCT to force a subquery to generate a single values
--Suppose we wanted to find all orders credited to the same salesperson who services Hoffman (cnum = 20001)
SELECT *
FROM Orders
WHERE snum =
	(SELECT DISTINCT snum
	FROM Orders
	WHERE cnum = 2001)
					
--Any query using a single aggregate function without a GROUP BY clause will select a single value for use in the main predicate 
--To see all orders that are grater than the average for October 4
SELECT *
FROM Orders
WHERE amt >
	(SELECT AVG (amt)
	FROM Orders
	WHERE odate = 10/04/1990)
					
--Using subqueries that product multiple rows with IN 
--Finds all orders attributed to salespeople in London
SELECT *
FROM Orders
WHERE snum IN 
	(SELECT snum
	FROM SalesPeople
	WHERE city = 'London')
					
--Commission of all salespeople servicing customers in London
SELECT comm
FROM SalesPeople
WHERE cnum IN
	(SELECT snum
	FROM Customers
	WHERE CITY = 'London')
					
--Using expressions in subqueries
--Finds all customers whose cnum is 1000 and above the snum of Serres
SELECT *
FROM Customers 
WHERE cnum = 
	(SELECT snum + 1000	
	FROM SalesPeople
	WHERE sname = 'Serres')
					
--Subqueries IN HAVING
--These subqueries can use their own aggregate functions as long as they do not produce multiple values of use GROUP BY or HAVING themselves
SELECT rating, COUNT (Distinct cnum)
FROM Customers
GROUP BY rating
HAVING rating > 
	(SELECT AVG (rating)
	FROM Customers
	WHERE city = 'San Jose');
						
--Write a query that uses a subquery to obtain all orders fro the customer named Cisneros.
--Assume you do not know the customer number.
SELECT *
FROM Orders
WHERE cnum = 
	(SELECT cnum 
	FROM Customers
	WHERE cname = 'Cisneros')
					
--Write a query that produces the names and ratings of all customers who have above-average orders
SELECT DISTINCT cname, rating
FROM Customers, Orders
WHERE amt >
	(SELECT AVG (amt)
	FROM Orders)
	AND Orders.cnum = Customers.cnum
					
--Write a query that selects the total amount in orders for each salesperson for whom this total is greater than the amount of the largest order in the table
SELECT snum, SUM (amt)
FROM Orders
GROUP BY snum
HAVING SUM (amt) >
	(SELECT MAX (amt)
	FROM Orders)

--Form a correlated subquery
--Finds all customers with orders on October 3,
--outer and inner are just aliases like a and b
SELECT *
FROM Customers outer
WHERE 10/03/1990 IN 
	(SELECT odate
	FROM Orders inner
	WHERE outer.cnum = inner.cnum)
					
--To see all the names and numbers of all salespeople who had more than one customer
SELECT snum, sname
FROM SalesPeople main
WHERE 1 < 
	(SELECT COUNT (*)
	FROM Customers
	WHERE snum = main.snum)
					
--Correlating a table with itself
--You can use correlated subqueries based on the same table as the main query.
--This enables you to extract certain complex forms of derived information
--Find all orders with above average amounts for their customers
SELECT *
FROM Orders a 
WHERE amt > 
	(SELECT AVG (amt)
	FROM Orders b 
	WHERE b.cnum = a.cnum)
					
--Write a SELECT command using a correlated subquery that selects the names and numbers of all customers
--with ratings equal to the maximum for the city
SELECT cnum, cname
FROM Customers a
WHERE rating =
	(SELECT MAX (rating)
	FROM Customers b
	WHERE inner.city = outer.city
					
--Write a query that select all salespeople (by name and number) who have customers in their cities who 
--they do not service, one using a join and one a correlated subquery
SELECT snum, sname
FROM SalesPeople a 
WHERE city IN
	(SELECT city
	FROM Customers inner
	WHERE inner.snum <> main.snum)

--EXISTS is an operator that produces true or false values
--Takes a subquery as an argument and evaluates to true if it produces any output or false if it down not
--Extracts some data from the Customers table if and only if one of more of the customers 
--in the Customers table are located in San Jose
SELECT cnum, cname, city
FROM Customers
WHERE EXISTS
	(SELECT *
	FROM Customers
	WHERE city = 'San Jose')
					
--Using EXISTS with correlated subqueries 
--This enables you to use EXISTS as a true predicate, one that generates different answers for each row
--of the table referenced in the main query
--To output salespeople who have multiple customers
SELECT DISTINCT snum
FROM Customers an
WHERE EXISTS
	(SELECT *
	FROM Customers inner
	WHERE inner.snum = outer.snum
	AND inner.cnum <> outer.cnum)
						
--Combining EXISTS and JOINS
--Might be useful for us to output more information about these salespeople than their numbers
SELECT DISTINCT first.snum, sname, first.city
FROM SalesPeople first, Customers second
WHERE EXISTS
	(SELECT *
	FROM Customers third
	WHERE second.snum = third.snum
	AND second.cnum <> third.cnum)
AND first.snum = second.snum
			
--USING NOT EXISTS
--Find all SalesPeople with only one customer would be to reverse our previous example
SELECT DISTINCT snum
FROM Customers a 
WHERE NOT EXISTS
	(SELECT *
	FROM Customers b 
	WHERE inner.snum = outer.snum
	AND inner.cnum <> outer.cnum)
						
--Extracts the rows of all salespeople who have customers with more than one current order
SELECT *
FROM SalesPeople first 
WHERE EXISTS	
	(SELECT *
	FROM Customers second
	WHERE first.snum = second.snum
	AND 1 <
		(SELECT COUNT (*)
		FROM Orders
		WHERE ORDERS.cnum = second.cnum))
									
--Write a query that uses the EXISTS operator to extract all salespeople who have customers with a rating of 200
SELECT *
FROM SalesPeople first
WHERE EXISTS 
	(SELECT *
	FROM Customers second
	WHERE first.snum = second.snum
	AND rating = 300)

--Write a query using the EXISTS operator that selects all salespeople with customers located in their cities who are not assigned to them
SELECT *
FROM SalesPeople a 
WHERE EXISTS
	(SELECT *
	FROM Customers b 
	WHERE b.city = a.city
	AND a.snum <> b.snum)

--Write a query that extracts from the Customers table every customer assigned to a salesperson who currently had at least one other customer
--with Orders in the Orders table
SELECT *
FROM Customers a 
WHERE EXISTS
	(SELECT *
	FROM Orders b 
	WHERE a.snum = b.snum
	AND a.cnum <> b.cnum)

--Salespeople with customers located in their cities
SELECT *
FROM Salespeople
WHERE city = ANY
	(SELECT city
	FROM Customers)
				
--Could also use the IN operator to construct the previous query
SELECT *
FROM SalesPeople 
WHERE city IN 
	(SELECT city
	FROM Customers)
				
--Any operator can use other relational operators besides equals which makes comparisons beyond capabilities of IN
--Finds all salespeople for whom their customers that follow them in alphabetic order
SELECT *
FROM SalesPeople
WHERE sname < ANY
	(SELECT cname
	FROM Customers)
				
--With ALL, the predicate is true if every value selected by the subquery satisfies the condition in the predicate of the outer query
--Customers whose rating are higher than every customer in Paris
SELECT *
FROM Customers
WHERE rating > ALL
	(SELECT rating
	FROM Customers
	WHERE city = 'Rome')
					
--SELECTS all ratings where rating is not in either of San Jose's ratings
SELECT *
FROM Customers
WHERE rating <> ALL
	(SELECT rating
	FROM Customers
	WHERE city = 'San Jose')
					
--Using Count in place of exists
--EXISTS and NOT EXISTS can be circumvented by executing the same subqueries with COUNT(*) in the subquery's SELECT clause
--If more than zero rows of output are counted, it is equivalent of EXISTS, otherwise it is the same as NOT EXISTS
SELECT *
FROM Customers a 
WHERE 1 >
	(SELECT COUNT (*)
	FROM Customers b
	WHERE a.rating <= b.rating 
	AND b.city = 'Rome')
						
--Write a query that selects all customers whose ratings are equal to or greater than ANY of Serres'.
SELECT *
FROM Customers
WHERE rating >= ANY
	(SELECT rating
	FROM Customers
	WHERE snum = 1002)
					
--Write a query using ANY or ALL that will find all salespeople who have no customers located in their city 
SELECT *
FROM SalesPeople
WHERE city <> ALL
	(SELECT city
	FROM Customers)

--Write a query that selects all orders for amounts greater than any (in the usual sense) for the customers in London
SELECT *
FROM Orders
WHERE amt > ALL
	(SELECT amt
	FROM Orders a, Customers b 
	WHERE a.cnum = b.cnum
	AND b.city = 'London')

--Uniting multiple queries as one
--UNION clause merges the the output of two or more SQL queries into a single set of rows and columns
--To have all salespeople and customers located in London output as a single body
SELECT snum, sname
FROM SalesPeople
WHERE city = 'London'
UNION
SELECT cnum, cname
FROM Customers
WHERE city = 'London'
		
--Union will automatically eliminate duplicate rows from the output
SELECT snum, city
FROM Customers
UNION
SELECT snum, city 
FROM SalesPeople
	
--Using strings and expressions with UNION
--Make a report of which salespeople produce the largest and smallest orders on each date
--We could unite the two queries, inserting text to distinguish the two cases
--Unions have no names in the columns so when you order by it must always be with a number
SELECT a.snum, sname, onum, 'Highest on', odate
FROM SalesPeople a, Orders b 
WHERE a.snum = b.snum 
AND b.amt = 
	(SELECT MAX (amt)
	FROM Orders c 
	WHERE c.odate = b.odate 
UNION 
SELECT a.snum, sname, onum, 'Lowest on', odate
FROM SalesPeople a, Orders b 
WHERE a.snum = b.snum
AND b.amt = 
	(SELECT MIN (amt)
	FROM Orders c 
	WHERE c.odate = b.odate)
ORDER BY 3

--Outer JOIN
--An operation that is frequently useful is a union of two queries in which the second selects the rows excluded by the first.
--Most often you will do this so as not to exclude rows that failed to satisfy the predicate when joining tables
--Find list of all salespeople and indicate those who do not have customers in their cities as well as those who do.
SELECT SalesPeople.snum, sname, cname, comm
FROM SalesPeople, Customers
WHERE SalesPeople.city = Customers.city 
UNION
SELECT snum, sname, 'NO MATCH ', comm
FROM SalesPeople
WHERE NOT city = ANY
	(SELECT city 
	FROM Customers)
ORDER BY 2 DESC 

--Query that appends strings to the selected fields, indicating whether or not a given salesperson was matched to a customer in his city
SELECT a.snum, sname, a.city, 'MATCHED'
FROM SalesPeople a, Customers b 
WHERE a.city = b.city
UNION 
SELECT a.snum, sname, city, 'NO MATCH'
FROM SalesPeople 
WHERE NOT city = ANY 
	(SELECT city 
	FROM Customers)
ORDER BY 2 DESC 

--The previous example was not a full outer join because it includes only the unmatched fields from one of the joined tables
--A complete outer join would include all customers who do and do not have salespeople in their cities 
SELECT snum, city, 'SALESPERSON-MATCHED'
FROM SalesPeople
WHERE city = ANY 
	(SELECT city 
	FROM Customers)
UNION 
SELECT snum, city, 'SALESPERSON-NO MATCH'
FROM SalesPeople
WHERE NOT city = ANY 
	(SELECT city 
	FROM Customers))
UNION 
SELECT cnum, city 'CUSTOMER-MATCHED'
FROM Customers
WHERE city = ANY 
	(SELECT city 
	FROM SalesPeople)
UNION
SELECT cnum, city, 'CUSTOMER-NO MATCH'
FROM Customers
WHERE NOT city = ANY 
	(SELECT city 
				FROM SalesPeople)
ORDER BY 2 DESC 

--Create a union of two queries that show the names, cities, and ratings of all customers.
--Those with a rating of 200 or greater will also have the words 'High Rating', while the others will have the words 'Low Rating'
SELECT cname, city, rating, 'High Rating'
FROM Customers	
WHERE rating >= 200 
UNION 
SELECT cname, city, rating, 'Low Rating'
FROM Customers 
WHERE rating < 200

--Write a command that produces the name and number of each salesperson and each customer with more than one current order.
--Put the results in alphabetical order.
SELECT cnum, cname 
FROM Customers a 
WHERE 1 < 
	(SELECT COUNT (*)
	FROM Orders b 
	WHERE a.cnum = b.cnum)
UNION 
SELECT snum, sname 
FROM SalesPeople a 
WHERE 1 < 
	(SELECT COUNT (*) 
	FROM Orders b 
	WHERE a.snum = b.snum)
ORDER BY 2  

--Form a union of three queries.
--Have the first select the snums of all salespeople in San Jose;
--the second. the cnums of all customers in San Jose;
--and the third the onums of all orders on October 3.
--Retain duplicates between the last two queries but eliminate any redundancies between wither of them and the first 
SELECT snum 
FROM SalesPeople 
WHERE city = 'San Jose'
UNION 
(SELECT cnum 
FROM Customers 
WHERE city = 'San Jose'
UNION ALL 
SELECT onum 
FROM Orders
WHERE ordate = 10/03/1990)

--ENTERING VALUES
--All rows in SQL are entered using the update command INSERT 
--To enter a row into a Salespeople table
INSERT INTO SalesPeople
VALUES (1001, 'Peel', 'London', .12)
	
--INSERTING NULLS
--If you have to enter a NULL, your do it just as you would a value
--Suppose you did not yet have a city field for Ms. Peel
--you could insert her row with a NULL in that field as follows
INSERT INTO SalesPeople 
VALUES (1001, 'Peel', NULL, .12)
	
--NAMING COLUMNS FOR INSERT
--Specify the columns you wish to insert a value into by name
--Allows you to insert into them in any order
--Suppose you are taking values for the customers table from a printed report, which puts them in the order: city, cname, and cnum
INSERT INTO Customers(city, cname, cnum)
VALUES ('London', 'Hoffman', 2001)
	
--INSERTING RESULTS OF A QUERY
--You can also use the INSERT command to take or derive values from one table and place them in another by using it with a query.
--Replace the VALUES clause with an appropriate query 
--Takes all the values of one query and puts them into another table as long as the table has been created
INSERT INTO Londonstaff 
SELECT *
FROM SalesPeople
WHERE city = 'London'
			
--Suppose that you decide to build a new table called Daytotals which keeps track of the total dollar amount ordered each day.
--You are going to enter this data independently from the Orders table, but have to full Daytotals with info already present in Orders.
--Use the INSERT statement to calculate and enter the values
INSERT INTO Daytotals (date, total)
SELECT odate, SUM(amt)
FROM Orders
GROUP BY odate

--REMOVING ROWS FROM TABLES
--You can remove rows from a table with the update command DELETE but can only delete entire rows
--To remove all the contents of SalesPeople
DELETE FROM SalesPeople

--Usually you want to delete just some specific rows from a table
--To remove salesperson Axelrod from the table
DELETE FROM SalesPeople
WHERE snum = 1003 
	
--DELETE a group of rows
DELETE FROM SalesPeople 
WHERE city = 'London'
	
--CHANGING FIELD VALUES
--UPDATE clause names the table affected and a SET clause that indicates the changes to be made to certain columns 
--To change all customers' ratings to 200 
UPDATE Customers 
SET rating = 200 
	
--UPDATING ONLY CERTAIN ROWS
--You do not always want to set all rows of a table to a single value, so UPDATE, like DELETE can take a predicate
--Peform the same change above on all customers of salesperson Peel 
UPDATE Customers 
SET rating = 200
WHERE snum = 1001 
		
--UPDATE WITH MULTIPLE COLUMNS 
--SET clause can accept any number of column assignments, separated by commas
--Suppose Motika had resigned, and we wanted to resign her number to a new salesperson
UPDATE SalesPeople
SET sname = 'Gibson', city = 'Boston', comm = .10 
WHERE snum = 1004 
		
--USING EXPRESSIONS IN UPDATE
--It is possible to use scaler expressions in the SET clause of the UPDATE command
--Suppose you decide to double the commission of all your salespeople 
UPDATE SalesPeople 
SET comm = comm * 2 
	
--Whenever you refer to an existing column value in the SET clause, 
--the value produced will be that of the current row before any changes are made by UPDATE
--You can combine features to double the commission of all salespeople in London 
UPDATE SalesPeople
SET comm - comm * 2 
WHERE city = 'London'
		
--UPDATING TO NULL VALUES
--SET clause can enter NULLs just as it does values without using any special syntax
--If you wanted to set all ratings for customers in London to NULL 
UPDATE Customers
SET rating = NULL 
WHERE city = 'London' 
		
--Write a command that puts the following values, in their given order, into the SalesPeople table: city-San Jose, 
--name-Blanco, comm-NULL, cnum-1100.
INSERT INTO SalesPeople(city, cname, comm, cnum)
VALUES('San Jose', 'Blanco', NULL, 1100)

--Write a command that removes all orders from customer Clemens from the Orders table
DELETE FROM Orders WHERE cnum = 2006

--Write a command that increases the rating of all customers in Rome by 100 
UPDATE Customers 
SET rating = rating + 100
WHERE city = 'Rome'

--Salesperson Serres has left the company.
--Assign her customers to Motika.
UPDATE Customers
SET snum = 1004 
WHERE snum = 1002

--USING SUBQUERIES WITH INSERT
 --You can use a subquery to add to the SJpeople table all salespeople who have customers in San Jose
INSERT INTO SJpeople 
SELECT *
FROM SalesPeople
WHERE snum = ANY 
	(SELECT snum 
	FROM Customers
	WHERE city = 'San Jose')
						
--USING SUBQUERIES BUILT ON OUTER QUERY TABLES 
--Suppose we have a table called Samecity in which we store salespeople with customers in their home cities
SELECT INTO Samecity 
SELECT * 
FROM SalesPeople outer 
WHERE city IN 
	(SELECT city 
	FROM Customers inner 
	WHERE inner.snum = outer.snum)
						
--Suppose you have a bonus for the salesperson who had the largest bonus every day.
--You keep track of these in a table in a table call Bonus, which contains the snums of the salespeople as well as the dates and amounts of the max orders.
--You could fill this table with the information currently in the Orders table 
INSERT INTO Bonus 
SELECT snum, odate, amt 
FROM Orders a 
WHERE amt = 
	(SELECT MAX (amt)
	FROM Orders b 
	WHERE a.odate = b.odate)
						
--USING SUBQUERIES WITH DELETE 
--If we just closed our London office, we could use the following query to remove all customers assigned to salespeople in London 		
DELETE 
FROM Customers
WHERE snum = ANY 
	(SELECT snum 
	FROM SalesPeople
	WHERE city = 'London')
					
--Finds all the ratings for each salesperson's customers and deletes the salesperson if 100 is among them
DELETE FROM SalesPeople
WHERE 100 IN 
	(SELECT rating 
	FROM Customers
	WHERE SalesPeople.snum = Customers.snum)
				
--Ordinary correlated subqueries - subqueries correlated with a table referenced in an outer query (rather than DELETE) are also perfectly usable
--You could find the lowest order for each day and delete the salespeople who produced it
DELETE FROM SalesPeople
WHERE snum IN 
	(SELECT snum 
	FROM Orders a  
	WHERE amt = 
		(SELECT MIN(amt)
		FROM Orders b 
		WHERE a.odate = b.odate)
							
--USING SUBQUERIES WITH UPDATE 
--UPDATE uses subqueries in the same way as DELETE
--You can use correlated subqueries of with of the forms usable with DELETE.
--With a correlated subquery on the table being updated, you can raise the commission of all salespeople who have been assigned at least 2 customers
UPDATE SalesPeople
SET comm = comm + .01
WHERE 2 < = 
	SELECT COUNT(cnum)
	FROM Customers
	WHERE Customers.snum = SalesPeople.snum)
					
--Reduces the commission of the SalesPeople who produced the smallest orders, rather than dropping them from the table
UPDATE SalesPeople 
SET comm = comm - .01
WHERE snum IN 
	(SELECT snum 
	FROM Orders a 
	WHERE amt = 
		(SELECT MIN (amt)
		FROM Orders b 
		WHERE a.odate = b.odate))

--Syntax to create a table
CREATE TABLE <table name>
	(<column name>	<data type>(<size>))

--Create the SalesPeople table
CREATE TABLE SalesPeople
	(snum	integer,
	sname	char(10),
	city	char(10),
	comm	decimal)
	
--An index is an ordered list of the contents of a column or group of columns in a table 
--When you create an index on a field, your database stores an approximately ordered list of all values of that field in its memory space
--Syntax to create and index 
CREATE INDEX <index name> ON <table name>(<column name>

--If the Customers table is going to be most frequently referred to by salespeople inquiring about their own clients
CREATE INDEX Clientgroup ON Customers(snum)

--If you want to eliminate an index, you have to name it
--The destruction of the index does not affect the content of the field
DROP INDEX <index name>

--ALTER TABLE changes the definition of an existing table and usually adds columns to a table
--Sometimes can delete columns or change sizes
--Syntax to alter table
ALTER TABLE <table name> ADD < column name> <data type> <size>

--DROPPING A TABLE 
--You must own a table in order to drop it
--SQL requires that you empty a table before you eliminate it from the database
--Syntax to remove the definition of your table from the system once it is empty
DROP TABLE <table name>

--Write a CREATE TABLE statement that would produce our Customers table
CREATE TABLE Customers 
	(cnum	integer,
	cname	char(10),
	city	char(10),
	rating	integer,
	snum	integer)

--Write a command that will enable a user to pull orders grouped by date out of the Orders table quickly 
CREATE INDEX DateSearch ON Orders(odate)

--Create an index that would permit each salesperson to retrieve his or her orders grouped by date quickly 
CREATE INDEX MyDate ON Orders(snum, odate)

--Let us suppose that each salesperson is to have only one customer of a given rating and that this is currently the case.
--Enter a command that enforces it.
CREATE UNIQUE INDEX Combination ON Customers(snum, rating)

--Declaring CONSTRAINTS
--Syntax
CREATE TABLE <table_name>
	(<column_name> <data_type> <column_constraint>)
	
--Using constraints to exclude nulls
--Create table SalesPerson by not allowing NULLS in the snum or sname column 
CREATE TABLE SalesPeople
	(snum	integer NOT NULL,
	sname	char(10) NOT NULL,
	city	char(10),
	comm	decimal)

--Unique as column constraint 
--Unique makes sure all the values entered into a column are different
--Unique will reject any attempt to introduce a value in one row that is already present in another
--Can only be applied to fields that have been declared NOT NULL
CREATE TABLE SalesPeople 
	(snum	integer NOT NULL UNIQUE,
	sname	char(10) NOT NULL UNIQUE,
	city	char(10),
	comm	decimal)
	
--UNIQUE as a table constraint 
--Declaring a group of fields unique differs from declaring the individual fields unique in that it is the combination of values
--Each combination of customer number and salesperson number in the Customers table should be unique 
CREATE TABLE Customers 
	(cnum	integer NOT NULL,
	cname	char(10) NOT NULL,
	city	char(10),
	rating	integer,
	snum	integer NOT NULL,
	UNIQUE 	(cnum, snum))
	
--Design a table to keep track of the total orders per day per salesperson 
--Each row would represent a total of any number of orders, rather than an individual orders
CREATE TABLE SalesTotal 
	(snum	integer NOT NULL,
	odate	date NOT NULL,
	totamt	decimal,
	UNIQUE	(snum, odate)
	
--Here is how you would put the above data into the table
INSERT INTO SalesTotal 
	SELECT snum, odate, SUM(amt) 
	FROM Orders
	GROUP BY snum, odate 
			
--Primary Key Constraint 
--Primary keys cannot allow NULL VALUES
--Any field used as a Primary Key constraint must already be declared NOT NULL
CREATE TABLE SalesPeople
	(snum	integer NOT NULL PRIMARY KEY,
	sname 	char(10) NOT NULL UNIQUE,
	city	char(10),
	comm	decimal)
	
--Primary keys of more than one field
--Primary key can also apply to multiple fields
--If a primary key is a name and you have first and last names stored in two different fields, we can combine the first and last name to be unique 
CREATE TABLE NameField
	(firstname	char(10) NOT NULL,
	lastname	char(10) NOT NULL,
	city 		char(10),
	PRIMARY KEY	(firstname, lastname)
	
--CHECKING FIELD VALUES
--Allows you to define a condition that a value entered into the table has to satisfy before it can be accepted
--Makes sure commission is less than 1 
CREATE TABLE SalesPeople 
	(snum	integer NOT NULL UNIQUE,
	sname 	char(10) NOT NULL UNIQUE,
	city	char(10),
	comm	decimal CHECK(comm < 1))
	
--Using check to predetermine valid input values 
--Suppose the only cities in which we had sales offices were London, Barcelona, San Jose, and New York
--As long as we know that all of our salespeople will be operating from one of these offices, there is no need to allow other values to be entered 
CREATE TABLE SalesPeople 
	(snum	integer NOT NULL UNIQUE 
	sname	char(10) NOT NULL UNIQUE 
	city 	char(10) CHECK
	(city IN ('London', 'New York', 'San Jose', 'Barcelona')),
	comm	decimal CHECK(comm < 1))
	
--If you were using a system that cannot remove constraints, you would have to CREATE a new table and transfer the information from the old table to it whenever you need to change a constraint 
CREATE TABLE Orders
	(onum 	integer NOT NULL UNIQUE,
	amt		decimal,
	odate	date NOT NULL,
	cnum	integer NOT NULL,
	snum	integer NOT NULL)
	
--Declaring odate to be of the CHAR type
CREATE TABLE Orders
	(onum	integer NOT NULL UNIQUE,
	amt		decimal,
	odate	char(10) NOT NULL CHECK (odate LIKE '_ _/_ _/_ _ _ _'),
	cnum	integer NOT NULL,
	snum 	integer NOT NULL)
	
--Check conditions based on multiple fields 
--Suppose that commission of .15 and above were permitted only for salespeople in Barcelona 
CREATE TABLE SalesPeople 
	(snum	integer NOT NULL UNIQUE,
	sname 	char(10) NOT NULL UNIQUE,
	city 	char(10),
	comm	decimal, 
	CHECK 	(comm < .15 OR city = 'Barcelona'))
	
--Assigning default values 
--DEFAULT value assignments are defined in the CREATE TABLE command in the same way as column constraints
--DEFAULT values do not limit the values you can enter but specify what happens if you do not enter any 
--Suppose you are running the New York office of your company and the vast majority of your salespeople are based in New York
--You might decide to define New York as the default city value for your SalesPeople table 
CREATE TABLE SalesPeople 
	(snum	integer NOT NULL UNIQUE,
	sname	char(10) NOT NULL UNIQUE, 
	city	char(10) DEFAULT = 'New York',
	comm	decimal CHECK(comm < 1))

--Create the Orders table so that all onum values as well as all combinations of cnum and snum are different from one another, and so that NULL values are excluded from the date field
CREATE TABLE Orders
	(onum	integer NOT NULL PRIMARY KEY,
	amt		decimal,
	odate	date NOT NULL,
	cnum	integer NOT NULL,
	snum 	integer NOT NULL,
	UNIQUE	(snum, cnum))

--Create the SalesPeople table so that the default commission is 10% with no NULLS permitted, snum is the primary key, and all names fall alphabetically between A and M, inclusive.
CREATE TABLE SalesPeople 
	(snum	integer NOT NULL PRIMARY KEY,
	sname 	char(15) CHECK(sname BETWEEN 'AA' AND 'MZ'),
	city	char(15),
	comm	decimal NOT NULL DEFAULT = .10)

--Create the Orders table, making sure that the onum is greater than the cnum, and the cnum is greater than the snum.
--Allow no NULLS in any of these THREE fields 
CREATE TABLE Orders
	(onum	integer NOT NULL,
	amt 	decimal,
	odate	date,
	cnum	integer NOT NULL,
	snum 	integer NOT NULL,
	CHECK	((cnum > snum) AND (onum > cnum)))

--Syntax of the FOREIGN KEY table constraint
FOREIGN KEY <column list> REFERENCES <pktable>
[<column list>]

--Customers table with snum defined as a foreign key referencing the SalesPeople table 
CREATE TABLE Customers	
	(cnum		integer NOT NULL PRIMARY KEY,
	cname		char(10),
	city		char(10),
	snum		integer,
	FOREIGN KEY snum REFERENCES SalesPeople
	(snum))
	
--FOREIGN KEY AS A COLUMN CONSTRAINT 
--The column-constraint version of the FOREIGN KEY constraint is also called the REFERENCES constraint because it does not actually contain the words FOREIGN KEY 
--It simply uses the word REFERENCES, and then names the parent key 
CREATE TABLE Customers	
	(cnum	integer NOT NULL PRIMARY KEY,
	cname	char(10),
	city	char(10),
	snum	integer REFERENCES SalesPeople(snum))
	
--OMITTING PRIMARY-KEY COLUMN LISTS
--If we had placed the PRIMARY KEY  constraint on the snum field in the SalesPeople table, we could use it as a foreign key in the Customers table
CREATE TABLE Customers	
	(cnum	integer NOT NULL PRIMARY KEY,
	cname	char(10),
	city	char(10),
	snum	integer REFERENCES SalesPeople)
	
--WHAT HAPPENS WHEN YOU PREFORM UPDATE COMMANDS
--Let's assume that all of the foreign keys built into our sample tables are declared and enforced with FOREIGN KEY constraints 
CREATE TABLE SalesPeople
	(snum	integer NOT NULL PRIMARY KEY,
	sname	char(10) NOT NULL,
	city	char(10),
	comm	decimal)
CREATE TABLE Customers 
	(cnum	integer NOT NULL PRIMARY KEY,
	cname	char(10) NOT NULL,
	city 	char(10),
	rating	integer,
	snum 	integer,
	FOREIGN KEY (snum) REFERENCES SalesPeople
	UNIQUE(cnum, snum))
CREATE TABLE Orders 
	(onum	integer NOT NULL PRIMARY KEY,
	amt		decimal,
	odate	date NOT NULL,
	cnum	integer NOT NULL,
	snum	integer NOT NULL,
	FOREIGN KEY (cnum, snum) REFERENCES CUSTOMERS (cnum, snum)
	
--Suppose you have reason to change the snum field of the SalesPeople table on occasion, perhaps when the SalesPeople change divisions
--When you change a salesperson's number, you want him to keep all of his customers
--If he is leaving the company, however, you do not want to remove his customers when you remove him from the database
--Instead, you want to make sure you assign them to someone else
--To achieve this, you could specify an UPDATE effect of CASCADES, and a DELETE effect of RESTRICTED
CREATE TABLE CUSTOMERS
	(cnum	integer NOT NULL PRIMARY KEY,
	cname	char(10) NOT NULL,
	city 	char(10),
	rating 	integer,
	snum	integer REFERENCES SalesPeople
	UPDATE OF SalesPeople CASCADES,
	DELETE OF SalesPeople RESTRICTED)
	
--Perhaps when salespeople leave the company their current orders are not credited to anyone
--You want to cancel all orders automatically for customers whose accounts you remove
--Changes of salesperson or customer number can simply be passed along
CREATE TABLE Orders
	(onum	integer NOT NULL PRIMARY KEY,
	amt		decimal,
	odate 	date NOT NULL,
	cnum	integer NOT NULL REFERENCES Customers,
	snum	integer REFERENCES SalesPeople,
	UPDATE OF Customers CASCADES,
	DELETE OF CUSTOMERS CASCADES,
	UPDATE OF SalesPeople CASCADES,
	DELETE OF SalesPeople NULLS)
	
--FOREIGN KEYS THAT REFER BACK TO THEIR OWN TABLES 
--Suppose we had an Employees table with a field called "manager"
--This field contains the employee number of each employee's manager
--Since the manager is also an employee, he or she will be present in this table
--Create a table declaring empno as the primary key, and manager as the foreign key referencing it 
CREATE TABLE Employees
	(empno	integer NOT NULL PRIMARY KEY,
	name 	char(10) NOT NULL UNIQUE,
	manager	integer REFERENCES Employees)
	
--Suppose our SalesPeople table had an additional field that referenced the Customers table, so that each tabled referred to the other
CREATE TABLE SalesPeople
	(snum	integer NOT NULL PRIMARY KEY,
	sname	char(10) NOT NULL,
	city	char(10),
	comm	decimal,
	cnum	integer REFERENCES Customers)
CREATE TABLE Customers 
	(cnum	integer NOT NULL PRIMARY KEY,
	cname	char(10) NOT NULL,
	city	char(10),
	rating	integer,
	cnum	integer REFERENCES SalesPeople)
	
--Create a table called Cityorders.
--This will contain the same onum, amt, and snum fields as the Orders table, and the same cnum and city fields as the Customers table, 
--so that each customer's order will be entered into this table along with his or her city
--All of the fields in Cityorders will be constrained to match the Customers and Orders tables
--Assume the parent keys in these tables already have the proper constraints 
CREATE TABLE Cityorders
	(onum	integer NOT NULL PRIMARY KEY,
	amt		decimal,
	cnum	integer,
	snum	integer,
	city	char(15),
	FOREIGN KEY (onum, amt, snum) REFERENCES Orders(onum, amt, sum),
	FOREIGN KEY (cnum, city) REFERENCES (cnum, city))

--Here is an advanced problem
--Redefine the Orders table as follows: add a new column called prev, which will identify the onum of the previous order for the current customer
--Implement this with a foreign key referring to the Orders table itself
--The foreign key should refer as well to the cnum of the customer, providing a definite enforced link between the current order and the one referenced
CREATE TABLE Orders
	(onum 	integer NOT NULL,
	amt 	decimal,
	odate	date,
	cnum 	integer NOT NULL,
	snum	integer,
	prev	integer,
	UNIQUE (cnum, onum),
	FOREIGN KEY (cnum, prev) REFERENCES Orders (cnum, onum))

--You define views with the CREATE VIEW command
CREATE VIEW Londonstaff
AS SELECT * 
FROM SalesPeople
WHERE city = 'London'
			
--The view above can now be queried above as...
SELECT * 
FROM Londonstaff
	
--If you wanted your salespeople to be able to look at the SalesPeople table, but not see each other's commissionss
CREATE VIEW Salesown 
AS SELECT snum, sname, city 
FROM SalesPeople
		
--Suppose each day you have to keep track of the number of customers ordering, the number of salespeople taking orders, the average amount ordered, and the total amount ordered.
CREATE VIEW TotalForDay
AS SELECT odate, COUNT(DISTINCT cnum), COUNT(DISTINCT snum), COUNT(onum), AVG(amt), SUM(amt) 
FROM Orders
GROUP BY odate 
			
--Now you can see all this information with a simple query
SELECT *
FROM TotalForDay
	
--VIEWS AND JOINS
--Because almost any valid SQL query can be used in a view, they can distill information from any number of base tables, or other views.
--We can define a view that shows, for each order, the salesperson and customer by name
CREATE VIEW NameOrders 
AS SELECT onum, amt, a.snum, sname, cname
FROM Orders a, Customers b, SalesPeople can
WHERE a.cnum = b.cnum 
AND a.snum = c.snum
				
--Now you can SELECT all orders by customer or by salesperson or you can see this information for any order
--To see all of salesperson Rifkin's orders
SELECT * 
FROM NameOrders
WHERE sname = 'Rifkin'
		
--You can also join views from other tables, either base tables or views, so that you can see all of Axelrod's orders and her commission on each one 
SELECT a.sname, cname, amt * comm 
FROM NameOrders a, SalesPeople b 
WHERE a.snum = 'Axelrod' 
AND b.snum = a.snum 
			
--VIEWS AND SUBQUERIES
--Perhaps your company provides a bonus for the salesperson who has the customer with the highest order on any given date
CREATE VIEW EliteSalesForce 
AS SELECT b.odate, a.snum, a.sname 
FROM SalesPeople a, Orders b 
WHERE a.snum = b.snum 
AND b.amt = 
	(SELECT MAX(amt)
	FROM Orders c 
	WHERE c.odate = b.odate)
							
--If the bonus will go only to salespeople when they have had the highest order at least ten times, you might track them in another view 
CREATE VIEW Bonus 
AS SELECT DISTINCT snum, sname 
FROM EliteSalesForce a 
WHERE 10 < = 
	(SELECT COUNT(*)
	FROM EliteSalesForce b 
	WHERE a.snum = b.snum)
						
--Extracting from this table the salespeople who will receive bonuses is simply a matter of entering the following
SELECT * 
from Bonus 
	
--DROPPING VIEWS SYNTAX
DROP VIEW <view name>

--Create a view that shows all of the customers who have the highest ratings
CREATE VIEW HighRatings 
AS SELECT * 
FROM Customers 
WHERE rating = 
	(SELECT MAX(rating)
	FROM Customers)

--Create a view that shows the number of salespeople in each city 
CREATE VIEW CityNumber
AS SELECT city, COUNT(DISTINCT snum)
FROM SalesPeople 
GROUP BY city

--Create a view that shows the average and total orders for each salesperson after his or her name.
--Assume all names are unique
CREATE VIEW NameOrders 
AS SELECT sname, AVG(amt), SUM(amt)
FROM SalesPeople, Orders 
WHERE SalesPeople.snum = Orders.snum
GROUP BY sname 

--Create a view that shows each salesperson with multiple customers
CREATE VIEW MultiCustomers 
AS SELECT *
FROM SalesPeople a 
WHERE 1 < 
	(SELECT COUNT(*)
	FROM Customers b 
	WHERE a.snum = b.snum)

--A view consists of the result of a query, but when you update a view, you are updating a series of query results
--But the update is to affect the values in the table on which the query was made, and thereby change the output of the query 
--Shows all the matches of customers with salespeople such that there is at least one customer in custcity served by a salesperson in salescity 
CREATE VIEW CityMatch(custcity, salescity)
AS SELECT DISTINCT a.city, b.city	
FROM Customers a, SalesPeople b 
WHERE a.snum = b.snum
			
--Read only view because of the presence of an aggregate function and GROUP BY 
CREATE VIEW DateOrders (odate, ocount)
AS SELECT odate, COUNT(*) 
FROM Orders
GROUP BY odate 
			
--Updatable view 
CREATE VIEW LondonCust
AS SELECT *
FROM Customers
WHERE city = 'London'
			
--This is a read-only view because of the expression "comm * 100."
--The recording and renaming of the fields is permissible, however.
--Some programs would allow deletions on this view or updates on the snum and sname columns
CREATE VIEW SJSales(name, number, percentage)
AS SELECT sname, snum, comm * 100 
FROM SalesPeople 
WHERE city = 'San Jose'

--This is read-only view in ANSI because of the subquery
CREATE VIEW SalesOnThird
AS SELECT * 
FROM SalesPeople
WHERE snum IN 
	(SELECT snum 
	FROM Orders
	WHERE odate =  10/03/1990)
						
--This is updatable
CREATE VIEW SomeOrders 
AS SELECT snum, onum, cnum 
FROM Orders
WHERE odate IN (10/03/1990, 10/05/1990)
			
--CHECKING THE VALUES PLACED IN VIEWS
--Another issue involving updates of views is that you can enter values that get "swallowed" in the underlying table
--This is an updatable view
--It restricts your access to the table to certain rows and columns 
CREATE VIEW HighRatings 
AS SELECT cnum, rating,
FROM Customers 
WHERE rating = 300
			
--This row would be inserted, through the HighRatings view, into the Customers table.
--Once there, it will disappear from view as its rating value is not 200
INSERT INTO HighRatings
VALUES(2018, 200) 
	
--You can check against modifications of this sort by including WITH CHECK OPTION in the definition of the view and it would have rejected the view
CREATE VIEW HighRatings 
AS SELECT cnum, rating 
FROM Customers 
WHERE rating = 300
WITH CHECK OPTION 
				
--Create a view of the SalesPeople table called Commissions
--This view will include only the snum and comm fields
--Through this view, someone could enter or change commissions, but only to values between .10 and .20 
CREATE VIEW Commissions 
	AS SELECT snum, comm 
		FROM SalesPeople 
			WHERE comm BETWEEN .10 AND .20 
				WITH CHECK OPTION

--Some SQL implementations have a built-in constant representing the current date, sometimes called "CURDATE".
--The word CURDATE can therefore be used in a SQL statement, and be replaced by the current date when the value is accessed by commands such as SELECT or INSERT
--We will use a view of the Orders table called EntryOrders to insert rows into the Orders table
--Create the Orders table, so that CURDATE is automatically inserted for odate if no value is given
--Then create the EntryOrders view so that no values can be given 
 CREATE TABLE Orders 
	(onum	integer NOT NULL PRIMARY KEY,
	amt		decimal,
	odate	date DEFAULT VALUE = CURDATE,
	snum	integer,
	cnum 	integer)
	
--Let us say that user Diane owns the Customers table and wants to let user Adrian perform queries on it
GRANT SELECT ON Customers to Adrian 

--If Adrian owned the SalesPeople table, he could allow Diane to enter rows into it 
GRANT INSERT ON SalesPeople to Diane 

--Stephen could grant SELECT and INSERT on the Orders table to Adrian 
GRANT SELECT, INSERT ON Orders TO Adrian 

--or to both Adrian and Diane 
GRANT SELECT, INSERT ON Orders TO Adrian, Diane 

--Allows Diane to alter the values in any or all of the columns of the SalesPeople table
GRANT UPDATE ON SalesPeople TO Diane

--Allows Diane to update only certain columns
GRANT UPDATE(city, comm) ON SalesPeople to Diane 

--When you grant the REFERENCES privilege to another user, he or she can create foreign keys that reference columns of your table as parent keys
--Diane can grant Stephen the right to use the Customers table as a parent-key table 
GRANT REFERENCES(cname, cnum) ON Customers TO Stephen

--You can omit the column list and thereby allow all of your columns to be usable as parent keys
--Adrian could grant Diane the right to do this
GRANT REFERENCES ON SalesPeople to Diane 

--USING ALL AND PUBLIC ARGUMENTS
--ALL is used in place of the privilege names in the GRANT command to give the grantee all of the privileges on the table 
--Diane could give Stephen the entire set of privileges on the Customers table
GRANT ALL ON Customer TO Stephen 

--PUBLIC is a similar sort of catch-all argument, but for users rather than privileges
--When you grant privileges to the public, all users automatically receive them
--To allow any user to look at the Orders table 
GRANT SELECT ON Orders TO PUBLIC 

--GRANTING WITH THE GRANT OPTION 
--Sometimes, the creator of the table wants other users to be able to grant privileges on that table 
--If Diane wanted Adrian to have the right to grant the SELECT privilege on the Customers table to other users,
--she would give him the SELECT privilege and use the WITH GRANT OPTION 
GRANT SELECT ON Customers TO Adrian WITH GRANT OPTION 

--Adrian would then have the right to give the SELECT privilege to third parties 
GRANT SELECT ON Diane.Customers TO Stephen WITH GRANT OPTION 

--TAKING PRIVILEGES AWAY 
--Syntax of the REVOKE command is patterned after GRANT, but with the reverse meaning 
--To take away Adrian's INSERT privilege on Orders
REVOKE INSERT ON Orders FROM Adrian 

--Lists of privileges and users are acceptable just as for GRANT
REVOKE INSERT, DELETE ON Customers FROM Adrian, Stephen 

--LIMITING THE SELECT PRIVILEGE TO CERTAIN COLUMNS 
--Suppose you wanted to give user Claire the ability to see only the snum and sname columns of the SalesPeople table 
CREATE VIEW ClairesView 
AS SELECT snum, sname 
FROM SalesPeople
		
--Grants Claire the SELECT privilege on the view but not the table itself
GRANT SELECT ON ClairesView TO Claire 

--LIMITING PRIVILEGES TO CERTAIN ROW
--To grant the user Adrian the UPDATE privilege on all Customers located in London
CREATE VIEW LondonCust 
AS SELECT *
FROM Customers 
WHERE city = 'London' 
WITH CHECK OPTION
				
--You could then grant the UPDATE privilege TO Adrian 
GRANT UPDATE ON LondonCust TO Adrian 

--GRANTING ACCESS ONLY TO DERIVED DATA 
--You can create a view that gives the counts, averages, and totals for the orders on each order date
CREATE VIEW DateTotals
AS SELECT odate, COUNT(*), SUM(amt), AVG(amt)
FROM Orders 
GROUP BY odate 
			
--Now you give user Diane SELECT on the DateTotals view
GRANT SELECT ON DateTotals TO Diane 

--USING VIEWS AS AN ALTERNATIVE TO CONSTRAINTS 
--Suppose you wanted to make sure that all city values in the SalesPeople table were in one of the cities where your company currently had an office
--You could place a CHECK constraint on the city column directly, but this may be difficult to change later if your company opens more office
--An alternative is to create a view that excludes incorrect city values 
CREATE VIEW CurCities 
AS SELECT *
FROM SalesPeople 
WHERE city IN ('London', 'Rome', 'San Jose', 'Berlin')
WITH CHECK OPTION
				
--RESOURCE is the right to create base tables
--Grants the privilege to create tables to the user Rodriguez 
GRANT RESOURCE TO Rodriguez

--CREATING AND DESTROYING USERS 
--CONNECT consists of the right to log on and the right to create views and synonyms
--IDENTIFIED BY indicates a password to be entered
--Allows a user to logon by the user name Thelonius and the password Redwagon
GRANT CONNECT TO Thelonius IDENTIFIED BY Redwagon

--Give Janet the right to change the ratings of the customers 
GRANT UPDATE(rating) ON Customers TO Janet 

--Give Stephen the right to give other users the right to query the Orders table
GRANT SELECT ON Orders TO Stephen WITH GRANT OPTION 

--Take the INSERT privilege on SalesPeople away from Claire and all users to whom she has granted it 
REVOKE INSERT ON SalesPeople FROM Claire 

--Grant jerry the right to insert or update the Customers table while keeping his possible rating values in the range of 100 to 500
--Step 1:
CREATE VIEW JerrysView
AS SELECT *
FROM Customers	
WHERE rating BETWEEN 100 AND 500
WITH CHECK OPTION

--Step 2:
GRANT INSERT, UPDATE ON JerrysView TO Jerry 				

--Allow Janet to query the Customers table, but restrict her access to those Customers whose rating is the lowest
--Step 1:
CREATE VIEW JanetsView
AS SELECT * 
FROM Customers 
WHERE rating = 
	(SELECT MIN(rating)
	FROM Customers)
--Step 2:
GRANT SELECT ON JanetsView TO Janet 

--RENAMING TABLES 
--Adrian would create a synonym Clients for Diane.Customer
CREATE SYNONYM Clients FOR Diane.Customers

--RENAMING WITH THE SAME NAME
--Adrian could define Customers as his synonym for Diane.Customers
CREATE SYNONYM Customers FOR Diane.Customers

--ONE NAME FOR EVERYBODY
--If all users are to call the Customers table Customers
CREATE PUBLIC SYNONYM Customers FOR Customers 

--DROPPING SYNONYMS 
--To drop synonym Clients, now that the public synonym Customers is available Adrain would enter
DROP SYNONYM Clients 

--HOW IS THE DATABASE ALLOCATED TO USERS 
--pctindec parameter specifies what percentage of the dbspace is to be set aside to store indexes on tables
--pctfree is the percentage of the dbspace that is set aside to allow tables to expand the size of their rows
CREATE DBSPACE SampleTables
	(pctindex	10,
	pctfree		25)
	
--Once a dbspace has been created, users are granted the right to create objects in it
--You could grant Diane the right to create tables in SampleTables 
GRANT RESOURCE ON SampleTables TO Diane 

--WHEN DOES A CHANGE BECOME PERMANENT
--Syntax to make all of your changes since logging on permanent 
COMMIT WORK 

--The syntax to reverse them
ROLLBACK WORK 

--AUTOCOMMIT automatically commits all actions that execute normally
--Actions that produce errors are automatically rolled back in any case
SET AUTOCOMMIT ON

--You could return a regular transaction processing with the command 
SET AUTOCOMMIT OFF

--Suppose you want to remove salesperson Motika from the database.
--Before you delete her from the SalesPeople table, you first should do something with her orders and her customers
--One logical solution would be to set the snum on her orders to NULL so that no salesperson receives a commission on those orders, while giving her customers to Peel 
UPDATE Orders
SET snum = NULL 
WHERE snum = 1004

UPDATE Customer
SET snum = 1001 
WHERE snum = 1004 

DELETE FROM SalesPeople
WHERE snum = 1004 
	
--Create a database called "MySpace" that allocates 15 percent of its space to indexes, and 40 percent to row expansion 
CREATE DBSPACE MySpace 
	(pctindex	15,
	pctfree		40)
	
--You have been granted SELECT on Diane's Orders table 
--Enter a command so that you will be able to refer to this table as "Orders" without using the name "Diane" as a prefix
CREATE SYNONYM Orders FOR Diane.Orders 

--DBA grants user Stephen the right to look at SYSTEMCATALOG 
GRANT SELECT ON SYSTEMCATALOG TO Stephen 

--USING VIEWS ON CATALOG TABLES 
--Define a view that specifically excludes the catalog tables
CREATE VIEW DataTables 
AS SELECT *
FROM SYSTEMCATALOG	
WHERE owner <> 'SYSTEM'
			
--LETTING USERS SEE ONLY THEIR OWN OBJECTS 
--Suppose you want each user to be able to query the catalog for information only on the tables that he or she owns
--Since the value of USER in a SQL command always stands for the authorization ID of the user issuing the command, it can be used to give users access only to their own tables 
--You can first create the following view:
CREATE VIEW OwnTables
AS SELECT * 
FROM SYSTEMCATALOG 
WHERE Owner = USER 
			
--Now you can grant all users access to this view 
GRANT SELECT ON OwnTables TO PUBLIC 

--VIEWING SYSTEMCOLUMNS 
--Here is the way to allow each user to see the SYSTEMCOLUMNS information only for his own tables 
CREATE VIEW OwnColumns 
AS SELECT * 
FROM SYSTEMCOLUMNS 
WHERE tabowner = USER;
			
GRANT SELECT ON OwnColumns TO PUBLIC 

--COMMENTING ON THE CATALOG CONTENTS 
--You can use the COMMENT ON command with a string of text to label any row in one of these tables
--State TABLE to comment on SYSTEMCATALOG, and COLUMN for SYSTEMCOLUMNS
COMMENT ON TABLE Chris.Orders
IS 'Current Customer Orders'

--To find all users who have the RESOURCE privilege and see which of them were DBAs
SELECT username, dba 
FROM SYSTEMUSERAUTH 
WHERE resource = 'Y'
		
--To find all SELECT, INSERT, and DELETE privileges that Adrian has granted on the Customers table 
SELECT username, selauth, insauth, delauth 
FROM SYSTEMTABAUTH
WHERE grantor = 'Adrian'
AND tname = 'Customers'
			
--To find out which columns of which tables you have the REFERENCES privilege on 
SELECT owner, tname, cname 
FROM SYSTEMCOLAUTH 
WHERE refauth IN ('Y', 'G')
AND username = USER 
ORDER BY 1, 2

--Assume Adrian has a synonym Clients for Diane's table Customers, and there is a public synonym Customers for the same table
--You query the table for all synonyms on the Customers table 
SELECT *
FROM SYSTEMSYNONS
WHERE tname = 'Customers'
		
--OTHER USES OF THE CATALOG 
--Lets you see the columns of the tables and the indexes based on each 
SELECT a.tname, a.cname, iname, cposition 
FROM SYSTEMCOLUMNS a, SYSTEMINDEXES b 
WHERE a.tabowner = b.tabowner
AND a.tname = b.tname
AND a.cnumber = b.cnumber 
ORDER BY 3 DESC 2 

--Query the catalog to produce, for each table with more than four columns, the table's name, and the names and data types of the columns
SELECT a.tname, a.owner, b.cname, b.datatype
FROM SYSTEMCATALOG a, SYSTEMCOLUMNS b
WHERE a.tname = b.tname 
AND a.owner = b.owner 
AND a.numcolumsn > 4 

--Query the catalog to find out how many synonyms exist for each table in the database
--Remember that the same synonym owned by two different users is in effect two different synonyms 
SELECT tname, synowner, COUNT(ALL synonym)
FROM SYSTEMSYNONYMS
GROUP BY tname, synowner

--Find out how many tables have indexes on more than fifty percent of their columns
SELECT COUNT(*)
FROM SYSTEMCATALOG a 
WHERE numcolumns / 2 <
	(SELECT COUNT(DISTINCT cnumber)
	FROM SYSTEMINDEXES b 
	WHERE a.owner = b.tabowner
	AND a.tname = b.tname)