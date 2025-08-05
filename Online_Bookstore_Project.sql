-- Creating Database
CREATE  DATABASE Online_Bookstore;
-- Create tables
-- Creating Books table
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
      Book_ID SERIAL PRIMARY KEY,
	  Title VARCHAR(100),
	  Author VARCHAR(100),
	  Genre VARCHAR(50),
	  Published_Year INT,
	  Price NUMERIC(10,2),
	  Stock INT
);

-- Creating customers table
DROP TABLE IF EXISTS customers;
CREATE TABLE customers(
      Customer_ID SERIAL Primary key,
	  Name VARCHAR(100),
	  Email VARCHAR(100),
	  Phone VARCHAR(15),
	  City VARCHAR(50),
	  Country VARCHAR(150)
);

--Creating table orders
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders(
      Order_ID SERIAL PRIMARY KEY,
	  Customer_ID INT REFERENCES Customers(Customer_ID),
	  Book_ID INT REFERENCES Books(Book_ID),
	  Order_Date DATE,
	  Quantity INT,
	  Total_Amount NUMERIC(10,2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Import Data into Books Table
COPY Books(Book_ID,Title,Author,Genre,Published_Year,Price,Stock)
FROM "C:\Users\satya\Downloads\Books.csv"
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID,Name,Email,Phone,City,Country)
FROM "C:\Users\satya\Downloads\Customers.csv"
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
FROM "C:\Users\satya\Downloads\Orders.csv"
CSV HEADER;

--1) Retreive all books in the "Fiction" genre:
SELECT * FROM Books 
WHERE genre='Fiction'

--2) Find books published after the year 1950:
SELECT * FROM Books
WHERE Published_year>1950;

--3)List all customers from Canada:
SELECT * FROM Customers
WHERE country='Canada';

--4)Show orders placed in November 2023:
SELECT * FROM Orders
WHERE EXTRACT(MONTH FROM order_date) = 11
  AND EXTRACT(YEAR FROM order_date) = 2023;

--5)Retreive the total stock of book available:
SELECT SUM(Stock) 
AS Total_Stock 
FROM Books;

--6) Find the details of the most expensive book:
SELECT * FROM Books
ORDER BY Price desc LIMIT 1;

--7)Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders 
WHERE Quantity>1;

--8)Retreive all orders where the total amount exceeds $20:
SELECT * FROM Orders
WHERE Total_amount>20;

--9)List all genres available in the books table:
SELECT DISTINCT(Genre) from Books;

--10)Find the book with the lowest stock
SELECT * FROM Books 
ORDER BY Stock ASC LIMIT 1;

--11)Calculate the total revenue generated from all orders:
SELECT SUM(Total_amount) AS Total_Revenue from orders;

--12)Retreive the total_number of books sold for each genre:
SELECT Books.Genre,SUM(Orders.Quantity) AS Books_Sold
FROM Books
JOIN Orders
ON Books.Book_ID = Orders.Book_ID
GROUP BY Genre;

--13)Find the average price of books in the 'Fantasy Genre':
SELECT AVG(Price) AS Average_Price from Books 
WHERE Genre='Fantasy';

--14)List Customers who have placed atleast 2 orders:
SELECT orders.Customer_id,Customers.Name,COUNT(orders.Order_Id) AS Order_Count
FROM orders
JOIN Customers
ON Orders.Customer_id=Customers.Customer_id
GROUP BY orders.Customer_id,Customers.Name
HAVING Count(orders.Order_ID)>1;

--15)Find the most Frequently Ordered book:
SELECT Orders.Book_ID,Books.Title,COUNT(Orders.Book_ID) AS Total_sale FROM Orders 
INNER JOIN
Books
ON Orders.Book_ID=Books.Book_ID
GROUP BY Orders.Book_ID,Books.Title
ORDER BY Count(Orders.Book_ID) DESC
LIMIT 1;

--16)Show the top 3 most expensive books of 'Fantasy Genre':
SELECT * FROM Books
WHERE Genre='Fantasy'
ORDER BY Price DESC LIMIT 3;

--17) Retreive the total quantity of books sold by each genre:
SELECT Books.Author,Orders.Quantity AS Total_Books_Sold FROM Books
INNER JOIN
Orders
ON Books.Book_ID=Orders.Book_ID
GROUP BY Books.Author,Orders.Quantity

--18)List the cities where customers who spent over 30$ are located:
SELECT DISTINCT(Customers.city),Orders.Total_amount from Customers
INNER JOIN
Orders
On Customers.Customer_ID=Orders.Customer_ID
WHERE Total_amount > 30

--19)Find the customer who spent the most on orders:
SELECT Customers.Customer_id,Customers.Name,SUM(Orders.Total_Amount) from Orders
INNER JOIN 
Customers
ON Orders.Customer_ID=Customers.Customer_ID
GROUP BY Customers.Customer_id,Customers.Name
ORDER BY SUM(Total_amount) DESC LIMIT 1;

--20)Calculate the stock remaining after fulfilling all orders:
SELECT Books.Book_Id,Books.Title,Books.Stock,COALESCE(Sum(Orders.Quantity),0) AS Order_Quantity,
Books.stock-COALESCE(SUM(Orders.Quantity),0) AS Remaining_Quantity
from Books
Left join Orders On Books.Book_ID=Orders.Book_ID
Group by Books.Book_id
ORDER BY Books.Book_id;
