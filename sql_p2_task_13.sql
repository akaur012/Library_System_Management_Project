--Library Systems Management Part 2

--Task 13: Identify Members with Overdue Books
--Write a query to identify members who have overdue books (assume a 30-day return period)
--The query should also display the member's id, member's name, book title, issue date, and days overdue.

-- issued_status == members

SELECT
 	ist.issued_member_id,
	 m.member_name,
	 bk.book_title,
	 ist.issued_date,
	 CURRENT_DATE - ist.issued_date as over_dues_days
FROM 
	issued_status as ist
JOIN
	members as m
ON 
	m.member_id = ist.issued_member_id
JOIN
	books as bk
ON	
	bk.isbn = ist.issued_book_isbn
LEFT JOIN
	return_status as rst
ON
	rst.issued_id = ist.issued_id
WHERE 
	rst.return_date IS NULL
	and 
	(CURRENT_DATE - ist.issued_date) > 30
	ORDER BY 1
	
/*
---Task 14: write a query to update the status of books in the books 
table to 'yes' when they are returned based on the entries made in 
the books table.
*/ 

select * from books 
where isbn = '978-0-451-52994-2';

--We can update manually:

UPDATE books
SET status = 'yes'
WHERE isbn = '978-0-451-52994-2'

/*
--But it would be more effective to create a Store Procedure.
As soon as we add a record into the 'return_status' table, we want to update
the book's status in the 'books' table.
*/


CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
    
BEGIN

    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES
    (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT 
        issued_book_isbn,
        issued_book_name
        INTO
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
    
END;
$$;

-- calling function 
CALL 
	add_return_records('RS138', 'IS135', 'Good');

SELECT * from books
WHERE isbn = '978-0-307-58837-1'



