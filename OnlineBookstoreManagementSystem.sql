CREATE DATABASE onlinebookstore


DROP TABLE IF EXISTS books;

CREATE TABLE employee3(
       employee_id INT PRIMARY KEY, 
	   first_name VARCHAR(20) NOT NULL,
	   last_name VARCHAR(20) NOT NULL,
	   dept VARCHAR(20),
	   salary numeric(15,2),
	   age INT
	  
);

SELECT*FROM employee3;
--manually
COPY
employee3(employee_id, first_name, last_name, dept, salary, age)
FROM '/Users/aakarshthukral/Downloads/Book 7(Sheet1).csv'
DELIMITER ','
CSV HEADER;  ``

