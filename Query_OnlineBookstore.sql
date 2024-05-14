-- Ensure we are querying the correct database
USE OnlineBookstore;
GO

-- 1. Retrieve all books in the 'Fiction' genre
SELECT title, author, price
FROM tbl_books
WHERE genre = 'Fiction';
GO

-- 2. Find the total number of books sold per title
SELECT b.title, SUM(od.quantity) AS TotalBooksSold
FROM tbl_orderDetails od
JOIN tbl_books b ON od.bookID = b.bookID
GROUP BY b.title;
GO

-- 3. List customers and the total amount they've spent, sorted by the highest spender
SELECT c.name, SUM(o.totalCost) AS TotalSpent
FROM tbl_orders o
JOIN tbl_customers c ON o.customerID = c.customerID
GROUP BY c.name
ORDER BY TotalSpent DESC;
GO

-- 4. Find books that are low in stock (less than 5 units)
SELECT title, quantityInStock
FROM tbl_inventory
JOIN tbl_books ON tbl_inventory.bookID = tbl_books.bookID
WHERE quantityInStock < 5;
GO

-- 5. List all orders placed in the last 30 days, including customer name and order total
SELECT c.name, o.orderID, o.orderDate, o.totalCost
FROM tbl_orders o
JOIN tbl_customers c ON o.customerID = c.customerID
WHERE o.orderDate > DATEADD(day, -30, GETDATE());
GO

-- 6. Retrieve the most popular book genre based on quantities sold
SELECT TOP 1 b.genre, SUM(od.quantity) AS TotalQuantity
FROM tbl_orderDetails od
JOIN tbl_books b ON od.bookID = b.bookID
GROUP BY b.genre
ORDER BY TotalQuantity DESC;
GO

-- 7. Show a list of books that have never been ordered
SELECT title
FROM tbl_books
WHERE bookID NOT IN (SELECT DISTINCT bookID FROM tbl_orderDetails);
GO

-- 8. Calculate the average order value
SELECT AVG(totalCost) AS AverageOrderValue
FROM tbl_orders;
GO

-- 9. Identify customers who have made more than 3 orders
SELECT c.name, COUNT(o.orderID) AS NumberOfOrders
FROM tbl_orders o
JOIN tbl_customers c ON o.customerID = c.customerID
GROUP BY c.name
HAVING COUNT(o.orderID) > 3;
GO

-- 10. Find the difference in total sales between the current month and the previous month, handling potential null values
SELECT
  ISNULL((SELECT SUM(totalCost) FROM tbl_orders WHERE MONTH(orderDate) = MONTH(GETDATE()) AND YEAR(orderDate) = YEAR(GETDATE())), 0) AS CurrentMonthSales,
  ISNULL((SELECT SUM(totalCost) FROM tbl_orders WHERE MONTH(orderDate) = MONTH(DATEADD(month, -1, GETDATE())) AND YEAR(orderDate) = YEAR(DATEADD(month, -1, GETDATE()))), 0) AS PreviousMonthSales,
  ISNULL((SELECT SUM(totalCost) FROM tbl_orders WHERE MONTH(orderDate) = MONTH(GETDATE()) AND YEAR(orderDate) = YEAR(GETDATE())), 0) -
  ISNULL((SELECT SUM(totalCost) FROM tbl_orders WHERE MONTH(orderDate) = MONTH(DATEADD(month, -1, GETDATE())) AND YEAR(orderDate) = YEAR(DATEADD(month, -1, GETDATE()))), 0) AS DifferenceInSales;
GO

