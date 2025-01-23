SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;

--Project Tasks:
--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
SELECT * FROM books;

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')
SELECT * FROM books


--Task 2. Update an existing member's address
SELECT * FROM members;

UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';

--Task 3. Delete a record from the Issued Status Table
--Delete the record with issue_id = 'IS107' from the issues_status table.
-- Since the issue_id (primary key in this table) is also a foreign key in the return's table, we cannot delete the records that correspond to the issue_id's in the 'returns' table. 
--We have to delete a record of books that have not yet been returned.
SELECT * FROM issued_status;
SELECT * FROM return_status;
--In this case, we can return records after issue_id 'IS120'.

DELETE FROM issued_status
WHERE issued_id= 'IS121'
SELECT * FROM issued_status;


--Task 4. Retrieve all books issued by a specific employee. Emp_id = 'E101'

SELECT * from issued_status
WHERE issued_emp_id = 'E101';


--Task 5. List Members who have issued more than 1 book. 
--Use GROUP BY to find members who have issued more than one book.

SELECT * FROM issued_status

SELECT 
	issued_emp_id
FROM 
	issued_status
GROUP BY 1
HAVING COUNT(issued_id) > 1



--CTAS (Create Table as Select)
--Task 6: Create summary tables: Use CTAS to generate new tables based on query results - each book and total_book_issed_cnt.

CREATE TABLE book_counts
AS
(
SELECT
	b.isbn,
	b.book_title,
	COUNT(ist.issued_id) as total_books_issued
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1,2
);

SELECT * FROM book_counts


--Task 7. Retrieve all books in the 'Classic' category.

SELECT * FROM books
WHERE category = 'Classic'


--Task 8. Find the total rental income by each category.

SELECT
	category,
	sum(rental_price),
	COUNT(*)
FROM 
	books as b
GROUP BY 1

--Task 9. List members who registered in the last 180 days.

INSERT INTO members (member_id, member_name, member_address, reg_date)
VALUES
('C150', 'sam', '145 Main St', '2024-12-01' ),
('C151', 'john', '133 Main St', '2025-01-01')

SELECT * 
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days'


--Task 10. List employees with their branch manager's name and their branch details

SELECT * FROM employees
SELECT * FROM branch

SELECT 
	e.*,
	br.manager_id,
	e2.emp_name as manager,
	br.branch_id
FROM branch as br
JOIN
	employees as e
ON 
	br.branch_id = e.branch_id
JOIN 
	employees as e2
ON 	
	br.manager_id = e2.emp_id



--Task 11. Create a table of books with a rental price above $7.

CREATE table books_7
AS
(
	SELECT * from books
	WHERE rental_price > 1
)

SELECT * FROM books_7



--Task 12. Retrieve the List of Books Not Yet Returned

SELECT * FROM return_status
SELECT * FROM issued_status

--We can do a left join

SELECT
	DISTINCT ist.issued_book_name
FROM 
	issued_status as ist
LEFT JOIN
	return_status as rst
ON 
	ist.issued_id = rst.issued_id
WHERE 
	rst.return_id IS NULL



--ADVANCED TASKS
--Task 13. 