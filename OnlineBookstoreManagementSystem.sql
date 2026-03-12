CREATE DATABASE onlinebookstore


-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
	  
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20),
	City VARCHAR(50),
    Country VARCHAR(50)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM /Users/aakarshthukral/Downloads/30 Day - SQL Practice Files/Books.csv
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, Country)
FROM /Users/aakarshthukral/Downloads/30 Day - SQL Practice Files/Customers.csv
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM /Users/aakarshthukral/Downloads/30 Day - SQL Practice Files/Orders.csv
CSV HEADER;



--BASIC QUERIES

--1. Retrieve all books in the "Fiction" genre
SELECT *
FROM Books
WHERE Genre = 'Fiction';

--2. Find books published after the year 1950
SELECT *
FROM Books
WHERE Published_Year > 1950;

--3. List all customers from Canada
SELECT *
FROM Customers
WHERE Country = 'Canada';

--4. Show orders placed in November 2023
SELECT *
FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

--5. Retrieve the total stock of books available
SELECT SUM(Stock) AS Total_Stock
FROM Books;

--6. Find the details of the most expensive book
SELECT *
FROM Books
WHERE Price = (SELECT MAX(Price) FROM Books);

--7. Show all customers who ordered more than 1 quantity of a book
SELECT DISTINCT c.*
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
WHERE o.Quantity > 1;

--8. Retrieve all orders where the total amount exceeds $20
SELECT *
FROM Orders
WHERE Total_Amount > 20;

--9. List all genres available in the Books table
SELECT DISTINCT Genre
FROM Books;

--10. Find the book with the lowest stock
SELECT *
FROM Books
ORDER BY Stock ASC
LIMIT 1;

--11. Calculate the total revenue generated from all orders
SELECT SUM(Total_Amount) AS Total_Revenue
FROM Orders;


--ADVANCE QUERIES


--1. Retrieve the total number of books sold for each genre
SELECT b.Genre,
       SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b
ON o.Book_ID = b.Book_ID
GROUP BY b.Genre;

--2. Find the average price of books in the "Fantasy" genre
SELECT AVG(Price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

--3. List customers who have placed at least 2 orders
SELECT c.Customer_ID,
       c.Name,
       COUNT(o.Order_ID) AS Total_Orders
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) >= 2;

--4. Find the most frequently ordered book
SELECT b.Title,
       SUM(o.Quantity) AS Total_Ordered
FROM Orders o
JOIN Books b
ON o.Book_ID = b.Book_ID
GROUP BY b.Title
ORDER BY Total_Ordered DESC
LIMIT 1;

--5. Show the top 3 most expensive books of 'Fantasy' genre
SELECT *
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;

--6. Retrieve the total quantity of books sold by each author
SELECT b.Author,
       SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b
ON o.Book_ID = b.Book_ID
GROUP BY b.Author;

--7. List the cities where customers who spent over $30 are located
(Assuming the table has City column — if not, replace with Country)
SELECT DISTINCT c.Country
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
WHERE o.Total_Amount > 30;

--8. Find the customer who spent the most on orders
SELECT c.Name,
       SUM(o.Total_Amount) AS Total_Spent
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Name
ORDER BY Total_Spent DESC
LIMIT 1;

--9. Calculate the stock remaining after fulfilling all orders
SELECT b.Book_ID,
       b.Title,
       b.Stock - COALESCE(SUM(o.Quantity),0) AS Remaining_Stock
FROM Books b
LEFT JOIN Orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock;