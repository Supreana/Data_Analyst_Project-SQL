-- INSERT INTO book_issued in last 30 days
-- SELECT * from employees;
-- SELECT * from books;
-- SELECT * from members;
-- SELECT * from issued_status


INSERT INTO issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('IS151', 'C118', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL 24 day, '978-0-553-29698-2', 'E108'),
('IS152', 'C119', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL 13 day,  '978-0-553-29698-2', 'E109'),
('IS153', 'C106', 'Pride and Prejudice', CURRENT_DATE - INTERVAL 7 day,  '978-0-14-143951-8', 'E107'),
('IS154', 'C105', 'The Road', CURRENT_DATE - INTERVAL 32 day,  '978-0-375-50167-0', 'E101');

-- Adding new column in return_status

ALTER TABLE return_status
ADD Column book_quality VARCHAR(15) DEFAULT('Good');

UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id 
    IN ('IS112', 'IS117', 'IS118');
SELECT * FROM return_status;

/* Task 13 - Identify members with Overdue books
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's
name, book title, issue date and days overdue.
*/

SELECT ist.issued_member_id, m.member_name, bk.book_title, ist.issued_date, 
current_date - ist.issued_date AS Overdue_days
FROM issued_status ist
JOIN members m ON m.member_id = ist.issued_member_id
JOIN books bk ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status rs ON rs.issued_id = ist.issued_id
WHERE rs.return_date IS NULL AND
(current_date - ist.issued_date) > 30
ORDER BY ist.issued_member_id;

/* Update book status on return 
Write a query to update the status of books in the books table to 'Yes' when they are returned (based on
entries in the return status table
*/

INSERT INTO return_status (return_id, issued_id, return_date, book_quality)
VALUES 
('RS125', 'IS130', current_date, 'Good');
SELECT * FROM return_status
WHERE issued_id = 'IS130';

-- Stored Procedure

Drop procedure if exists add_return_records$$;
DELIMITER $$
CREATE PROCEDURE add_return_records (
IN p_return_id varchar(10), IN p_issued_id varchar(10), IN p_book_quality varchar(25)
)
BEGIN
DECLARE v_isbn varchar(50);
DECLARE V_book_name varchar (255);
	INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES
    (p_return_id, p_issued_id, current_date(), p_book_quality);
    
    SELECT
		issued_book_isbn,
        issued_book_name
        INTO
        v_isbn, v_book_name
	FROM issued_status
    WHERE issued_id = p_issued_id;
    
    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;
    
 END; 
 $$
 
 select * from issued_status 
 where issued_id = 'IS135';
 
 select * from return_status;
 
 CALL add_return_records('RS148', 'IS140','Good');
 
 /* Task 15 - Branch Performance Report
 Create a query that generates a performance report for each branch, showing the number of books issued, 
 number of books returned and the total revenue generated from book rentals. */
 
 CREATE TABLE branch_performance_report
 AS
 SELECT b.branch_id, b.manager_id, 
 COUNT(ist.issued_id) AS Number_of_books_issued,
 COUNT(rs.return_id) AS Number_of_books_returned,
 SUM(bk.rental_price) AS Total_revenue
 FROM issued_status ist
 JOIN employees e ON e.emp_id = ist.issued_emp_id
 JOIN branch b ON e.branch_id = b.branch_id
 LEFT JOIN return_status rs ON rs.issued_id = ist.issued_id
 JOIN books bk ON ist.issued_book_isbn = bk.isbn
 GROUP BY b.branch_id, b.manager_id;

/* Task 16 - Create a table of Active Members - Use create table as (CTAS Statement) to create a new table of
active members containing members who have issued at least one book in last 6 months */

CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN 
(SELECT issued_member_id
FROM issued_status
WHERE issued_date >= CURRENT_DATE - INTERVAL 6 month);

/* Task 17 - Find the employees with the most book issues processed
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name,
no. of books processed and their branch */

SELECT e.emp_name, b.manager_id, b.branch_address, b.contact_no, COUNT(*) AS count_of_books
FROM issued_status ist
JOIN employees e ON e.emp_id = ist.issued_emp_id
JOIN branch b ON e.branch_id = b.branch_id
GROUP BY e.emp_name, b.manager_id, b.branch_address, b.contact_no;

/* Task 18 - Stored Procedure Objective: Create a stored procedure to manage the status of books in a library
system. Description: Write a stored procedure that updates the status the status of the book in the library based 
on its issuance. The procedure should function as follows: The stored procedure should take the book_id as an input
parameter. The procedure should first check if the book is available (status = 'Yes'). If the book is available, 
it should be issued and the status in books table should be updated to 'no'. If the book is not available 
(status = 'no'), the procedure should return an error message indicating that the book is currently not available. */

DELIMITER $$
CREATE PROCEDURE issue_book (
 p_issued_id varchar(10), p_issued_member_id varchar(30), p_issued_book_isbn varchar(30),
 p_issued_emp_id varchar(10)
)

BEGIN
DECLARE v_status varchar(10);

	SELECT 
		status
		INTO 
		v_status
	FROM books
	WHERE isbn = p_issued_book_isbn;
    
    IF v_status = 'yes' THEN 
		INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
		VALUES
        (p_issued_id, p_issued_member_id, current_date, p_issued_book_isbn, p_issued_emp_id);
        
        UPDATE books
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;
        
         SELECT CONCAT('Book records added successfully for book_isbn:', p_issued_book_isbn) AS Message;
        
	ELSE 
		SELECT CONCAT('Sorry to inform you the book you have requested is unavailable book_isbn:', p_issued_book_isbn) AS Message;
	END IF;
    
END;
$$

CALL issue_book ('IS157', 'C108', '978-0-06-112008-4', 'E104');

select * from books
where isbn = 978-0-553-29698-2
    
    

    



