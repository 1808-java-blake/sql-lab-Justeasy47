-- Part I – Working with an existing database

-- Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.
-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.
-- 2.1 SELECT
-- Task – Select all records from the Employee table.
SELECT * FROM Employee;
-- Task – Select all records from the Employee table where last name is King.
SELECT * FROM Employee WHERE lastname = 'King';
-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
SELECT * FROM Employee WHERE firstname = 'Andrew' AND REPORTSTO IS NULL;
-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
SELECT * From Album ORDER BY title DESC;
-- Task – Select first name from Customer and sort result set in ascending order by city
Select firstname, city FROM Customer ORDER BY city ASC;
-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
INSERT INTO genre (genreid, name) VALUES (26,'Electronic'),(27,'Dub'); 
-- Task – Insert two new records into Employee table
INSERT INTO employee (employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone, fax, email)
VALUES (9, 'Ricardo', 'Reeky', 'CIO', null, '02-27-1999 00:00:00', '01-01-2001 00:00:00', '123 Your Way Ave', 'Boston', 'MA', 'USA', 'T1J 5F4', '1+(203)695-5595', '1+(203)856-8955', 'ReekyCIO@Gmail.com'),
		(10, 'Wild', 'Wesley', 'CEO', null, '05-18-1987 00:00:00', '08-16-1985 00:00:00', '568 That Way Ave', 'Chicago', 'IL', 'USA', 'G3T 6G3', '1+(852)894-8455', '1+(865)568-9555', 'WWildCEO@gmail.com');   
-- Task – Insert two new records into Customer table
INSERT INTO customer (customerid, firstname, lastname, company, address, city, state, country, postalcode, phone, fax, email, supportrepid)
VALUES (60, 'Wally', 'Waldo', NULL, '8478 Probo Way',  'Atlanta', 'GA', 'USA', '95864', '+33 212 548 6544', NULL, 'juju23@hotmail.com', 3),
		(61, 'Sally', 'Sue', NULL, '59866 E 12th ave', 'Long Beach', 'CA', 'USA', '56874', '+33 265 845 2457', NULL, 'froline222@yahoo.com', 4);   
-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
UPDATE customer
SET firstname = 'Robert', lastname = 'Walter'
WHERE customerid = 32;
-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
UPDATE artist
SET name = 'CCR'
WHERE name = 'Creedence Clearwater Revival';
-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
SELECT * FROM invoice
WHERE billingaddress 
LIKE 'T%';
-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
SELECT * FROM invoice
WHERE total 	
BETWEEN 15 AND 50;
-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
SELECT * FROM employee
WHERE hiredate 
BETWEEN '2003-06-01' AND '2004-03-01';
-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
DELETE FROM invoiceline WHERE invoiceid IN
        (SELECT invoiceid FROM invoice WHERE customerid IN
        (SELECT  customerid FROM customer WHERE firstname = 'Robert' AND lastname = 'Walter'));
        DELETE FROM invoice WHERE customerid IN
        (SELECT  customerid FROM customer WHERE firstname = 'Robert' AND lastname = 'Walter');
        DELETE FROM customer WHERE firstname = 'Robert' AND lastname = 'Walter';
-- SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
CREATE OR REPLACE FUNCTION new_time()
RETURNS TIME AS $$
BEGIN
RETURN current_time;
END;
$$ LANGUAGE plpgsql;
SELECT new_time();
-- Task – create a function that returns the length of a mediatype from the mediatype table
CREATE OR REPLACE FUNCTION new_mediatype(name_type VARCHAR(120))
RETURNS VARCHAR AS $$
BEGIN
RETURN AVG(total) FROM invoice;
END;
$$ LANGUAGE plpgsql;
SELECT new_mediatype(name) FROM mediatype;
-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
CREATE OR REPLACE FUNCTION new_total()
RETURNS NUMERIC AS $$
BEGIN
RETURN AVG(total) FROM invoice;
END;
$$ LANGUAGE plpgsql;
SELECT new_total();
-- Task – Create a function that returns the most expensive track
CREATE OR REPLACE FUNCTION mstexp_track()
RETURNS NUMERIC AS $$
BEGIN
RETURN MAX(unitprice) FROM track;
END;
$$ LANGUAGE plpgsql;
SELECT mstexp_track();
-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
CREATE OR REPLACE FUNCTION avg_invlne()
RETURNS NUMERIC AS $$
BEGIN
RETURN AVG(unitprice) FROM invoiceline;
END;
$$ LANGUAGE plpgsql;
SELECT avg_invlne();
-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
CREATE OR REPLACE FUNCTION brnaftr_1968()
REUTRNS SETOF employee AS $$
BEGIN
RETURN QUERY SELECT * FROM employee WHERE birthdate>= '1968-01-01';
END;
$$ LANGUAGE plpgsql;
SELECT brnaftr_1968();
-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
CREATE OR REPLACE FUNCTION frstlst_name()
RETURNS TABLE(first_name VARCHAR(20), last_name VARCHAR(20)) AS $$
BEGIN
RETURN QUERY SELECT firstname, lastname FROM employee;
END;
$$ LANGUAGE plpgsql;
SELECT frstlst_name();
-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
CREATE OR REPLACE FUNCTION update_prsinfo() 
RETURNS NUMERIC(10,2) AS $$
RETURNS list NUMERIC(10,2);
BEGIN
UPDATE employee
SET firstname = 'Andy' lastname = 'Andame'
WHERE employeeid = 1;
RETURN LIST;
END;
$$ LANGUAGE plpgsql;
SELECT update_prsinfo();
-- Task – Create a stored procedure that returns the managers of an employee.

-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
-- 5.0 Transactions - Include Begin and end
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.

-- 6.2 INSTEAD OF
-- Task – Create an instead of trigger that restricts the deletion of any invoice that is priced over 50 dollars.
-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
SELECT customer.firstname, customer.lastname, invoice.invoiceid
FROM customer
INNER JOIN invoice ON customer.customerid = invoice.invoiceid
-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
SELECT customer.customerid, customer.firstname, customer.lastname, invoice.invoiceid, invoice.total
FROM customer 
FULL OUTER JOIN invoice
ON customer.customerid = invoice.invoiceid
-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
SELECT artist.name, album.title
FROM artist
RIGHT JOIN album
ON artist.artistid = album.albumid
-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
SELECT * FROM album
CROSS JOIN artist
ORDER BY artist.name ASC
-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
SELECT
    e.firstname || ' ' || e.lastname employee,
    m.firstname || ' ' || m.lastname manager
FROM
    employee e, employee m
WHERE m.reportsto = e.reportsto;







