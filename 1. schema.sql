-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS electroworld; 
USE electroworld; 

SET FOREIGN_KEY_CHECKS = 0; 
DROP TABLE IF EXISTS customers, products, orders, order_items; 
SET FOREIGN_KEY_CHECKS = 1; 

-- Tabla customers
CREATE TABLE customers(
	customer_id INT AUTO_INCREMENT PRIMARY KEY, 
    first_name VARCHAR (30), 
    email VARCHAR (50), 
    country VARCHAR (30), 
    signup_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 

-- Tabla products
CREATE TABLE products(
	product_id INT AUTO_INCREMENT PRIMARY KEY, 
    product_name VARCHAR (50), 
    category ENUM ('Laptop', 'Computer', 'Iphone', 'headphones', 'Electronic device') DEFAULT 'Electronic device', 
    price DECIMAL (10,2), 
    stock_quantity INT
); 

-- Tabla orders
CREATE TABLE orders(
	order_id INT AUTO_INCREMENT PRIMARY KEY, 
    customer_id INT,
    order_date DATE, 
    status ENUM ('Completed', 'Cancelled', 'Pending', 'Pending completion') DEFAULT 'Pending completion', 
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
); 

-- Tabla order_items
CREATE TABLE order_items(
	item_id INT AUTO_INCREMENT PRIMARY KEY, 
    order_id INT, 
    product_id INT, 
    quantity INT, 
    unit_price DECIMAL (10, 2),
	FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);     

-- Insertar algunos clientes de ejemplo
INSERT INTO customers(first_name, email, country) VALUES
('Paula', 'pau@hotmail.es', 'ESP'), 
('Dani', 'dani@hotmail.es', 'RUM'), 
('Roxana', 'roxa@hotmail.es', 'PER'); 

-- Insertar algunos productos
INSERT INTO products (product_name, category, price, stock_quantity) VALUES
('Apple', 'Laptop', 20, 1), 
('Samsung', 'Computer', 50.88, 2), 
('Xaomi', 'Iphone', 199.34, 3); 

-- Insertar algunos pedidos 
INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2026-10-05', 'Completed'), 
(2, '2026-03-02', 'Pending'), 
(3, '2026-02-27', 'Completed'), 
(3, '2026-10-05', 'Completed'), 
(3, '2026-03-02', 'Completed'), 
(3, '2026-02-27', 'Completed'), 
(2, '2026-10-05', 'Completed'), 
(3, '2026-03-02', 'Pending'), 
(3, '2026-02-27', 'Cancelled'); 

-- Insertar algunos items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 5, 200), 
(9, 2, 8, 277.09), 
(8, 3, 6, 678),
(7, 1, 5, 200), 
(6, 2, 8, 277.09), 
(5, 3, 5, 678), 
(4, 1, 5, 200), 
(3, 2, 2, 277.09), 
(2, 3, 7, 678); 

SHOW TABLES; 
SELECT * FROM products; 
SELECT * FROM customers; 
SELECT * FROM orders; 
SELECT * FROM order_items; 