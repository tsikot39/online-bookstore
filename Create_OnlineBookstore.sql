-- DELETE DATABASE IF EXISTS
IF EXISTS (
  SELECT name 
  FROM sys.databases 
  WHERE name = N'OnlineBookstore'
)
BEGIN
  -- Terminate all connections to the database to be dropped
  ALTER DATABASE OnlineBookstore SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  -- Drop the database
  DROP DATABASE OnlineBookstore;
END
GO

-- CREATE THE DATABASE
CREATE DATABASE OnlineBookstore;
GO

-- SWITCH TO THE NEWLY CREATED DATABASE TO CREATE TABLES
USE OnlineBookstore;
GO

-- CREATE TABLES
CREATE TABLE tbl_books (
    bookID INT PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(255),
    ISBN VARCHAR(20),
    genre VARCHAR(50),
    price DECIMAL(10, 2)
);
GO

CREATE TABLE tbl_customers (
    customerID INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    address VARCHAR(255)
);
GO

CREATE TABLE tbl_orders (
    orderID INT PRIMARY KEY,
    customerID INT,
    orderDate DATETIME,
    totalCost DECIMAL(10, 2),
    FOREIGN KEY (customerID) REFERENCES tbl_customers(customerID)
);
GO

CREATE TABLE tbl_orderDetails (
    orderDetailID INT PRIMARY KEY,
    orderID INT,
    bookID INT,
    quantity INT,
    subTotal DECIMAL(10, 2),
    FOREIGN KEY (orderID) REFERENCES tbl_orders(orderID),
    FOREIGN KEY (bookID) REFERENCES tbl_books(bookID)
);
GO

CREATE TABLE tbl_inventory (
    bookID INT PRIMARY KEY,
    quantityInStock INT,
    FOREIGN KEY (bookID) REFERENCES tbl_books(bookID)
);
GO


-- POPULATE DATA TO CREATED TABLES 

-- Populate the tbl_books table
INSERT INTO tbl_books (bookID, title, author, ISBN, genre, price) VALUES
(1, 'Noli Me Tangere', 'Jose Rizal', '9780143039693', 'Fiction', 12.99),
(2, 'El Filibusterismo', 'Jose Rizal', '9780143039693', 'Fiction', 12.99),
(3, 'Smaller and Smaller Circles', 'F.H. Batacan', '9780143126973', 'Mystery', 11.50),
(4, 'America Is in the Heart', 'Carlos Bulosan', '9780295952894', 'Autobiography', 14.75),
(5, 'The Woman Who Had Two Navels', 'Nick Joaquin', '9789712717921', 'Magical Realism', 10.25);

-- Populate the tbl_customers table
INSERT INTO tbl_customers (customerID, name, email, address) VALUES
(1, 'Juan dela Cruz', 'juan@example.com', '123 Rizal St, Manila, Philippines'),
(2, 'Maria Santos', 'maria@example.com', '456 Katipunan Ave, Quezon City, PH'),
(3, 'Pedro Reyes', 'pedro@example.com', '789 EDSA, Mandaluyong, Metro Manila'),
(4, 'Ana Garcia', 'ana@example.com', '321 Ayala Ave, Makati, Philippines'),
(5, 'Josefa Lim', 'josefa@example.com', '567 Quezon Ave, Quezon City, PH');

-- Populate the tbl_orders table
INSERT INTO tbl_orders (orderID, customerID, orderDate, totalCost) VALUES
(1, 1, '2024-02-19 10:30:00', 64.95),
(2, 2, '2024-02-18 14:45:00', 51.48),
(3, 3, '2024-02-18 09:15:00', 38.24),
(4, 4, '2024-02-17 11:00:00', 72.74),
(5, 5, '2024-02-17 13:20:00', 39.48);

-- Populate the tbl_orderDetails table
INSERT INTO tbl_orderDetails (orderDetailID, orderID, bookID, quantity, subtotal) VALUES
(1, 1, 1, 3, 38.97),
(2, 1, 2, 2, 25.98),
(3, 2, 3, 1, 11.50),
(4, 3, 4, 2, 29.50),
(5, 4, 5, 1, 10.25);

-- Populate the tbl_inventory table
INSERT INTO tbl_inventory (bookID, quantityInStock) VALUES
(1, 5),
(2, 8),
(3, 3),
(4, 6),
(5, 10);
