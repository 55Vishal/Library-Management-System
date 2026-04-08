-- Section 1

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;


-- Problem Statement ----

-- 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;


-- 2: Update an Existing Member's Address

UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';
SELECT * FROM members;


-- 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT * FROM issued_status
WHERE issued_id = 'IS121';

DELETE FROM issued_status
WHERE issued_id = 'IS121'



-- 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';


-- 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT 
    ist.issued_emp_id,
     e.emp_name,
    COUNT(*)
FROM issued_status as ist
JOIN
employees as e
ON e.emp_id = ist.issued_emp_id
GROUP BY 1, 2
HAVING COUNT(ist.issued_id) > 1

Select * From employees;
Select * From issued_status;
-------------------------------- 2nd Solution with names ---------------------------------------------
Select 
	ist.issued_emp_id,
	e.emp_name,
	Count(*) as Total_books_issued
From issued_status as ist
Join employees as e
ON e.emp_id = ist.issued_emp_id
Group By ist.issued_emp_id, e.emp_name
Having Count(*) > 1


/*
	 6: Using the CTAS (Create Table As Select) approach, write an SQL query to create a new summary table that
	displays each book’s ISBN, book title, and the total number of times it has been issued. 
	The solution should involve joining the books and issued_status tables and grouping the results appropriately**
*/


SELECT * FROM books;
Select * From issued_status;

Create Table book_issued_count
AS
Select
	b.isbn,
	b.book_title,
	Count(i.issued_id) AS total_book_issued_cnt
From books AS b
Join
	issued_status AS i
ON b.isbn = i.issued_book_isbn
Group By 
	b.isbn,
	b.book_title;

Select * From book_issued_count

/*
 7: Write an SQL query to determine the total rental income generated for each book category. 
	The output should include the category name, the total rental income (sum of rental prices), 
	and the total number of books issued. Use appropriate joins between the books and issued_status 
	tables and group the results by category
*/

Select * from books;
Select * from issued_status

Select 
	b.category,
	Count(*),    -- or Count(issued_id)
	SUM(rental_price)
From books AS b
Join issued_status AS i
ON b.isbn = i.issued_book_isbn
Group By b.category;

-- 8: Write an SQL query to retrieve all members who have registered within the last 180 days from the current date.

Select * From members
Where reg_date >= Current_Date - Interval '180 days';
    
INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
('C120', 'Alice', '123 New St', CURRENT_DATE - INTERVAL '30 days'),
('C121', 'Mark', '456 New St', CURRENT_DATE - INTERVAL '100 days');

 
-- 9: Write an SQL query to display employee details along with their branch information and the name of their respective branch manager.
SELECT * FROM branch;
SELECT * FROM employees;

Select 
	e.*,
	b.manager_id,
	m.emp_name AS manager_name
From employees AS e
Join branch AS b
ON b.branch_id = e.branch_id
Join employees as m
ON b.manager_id = m.emp_id;

/*
 10: Using the CTAS (Create Table As Select) approach, write an SQL query to create a new table containing all books with a 
	 rental price greater than 7 USD.
*/

Select * From books;

Create Table
	books_rental_prices_greater_then_7
AS	
Select 
	book_title,
	rental_price
From books
Where rental_price > 7

Select * From books_rental_prices_greater_then_7;

/*
 11: Write an SQL query to retrieve the names of books that have been issued but not yet returned. 
     Ensure that duplicate book names are not included in the result.
*/

Select * From issued_status
Select * From return_status 

Select 
	i.issued_book_name
From issued_status AS i
Left Join return_status AS r
ON i.issued_id = r.issued_id
Where r.return_id IS null;


-----------------*********************--------------------******************---------------------------

-- INSERT INTO book_issued in last 30 days
-- SELECT * from employees;
-- SELECT * from books;
-- SELECT * from members;
-- SELECT * from return_status


INSERT INTO issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('IS151', 'C118', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL '24 days',  '978-0-553-29698-2', 'E108'),
('IS152', 'C119', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL '13 days',  '978-0-553-29698-2', 'E109'),
('IS153', 'C106', 'Pride and Prejudice', CURRENT_DATE - INTERVAL '7 days',  '978-0-14-143951-8', 'E107'),
('IS154', 'C105', 'The Road', CURRENT_DATE - INTERVAL '32 days',  '978-0-375-50167-0', 'E101');

-- Adding new column in return_status

ALTER TABLE return_status
ADD Column book_quality VARCHAR(15) DEFAULT('Good');

UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id 
    IN ('IS112', 'IS117', 'IS118');
SELECT * FROM return_status;


------------*************-------------------****************-------------------****************------------------












