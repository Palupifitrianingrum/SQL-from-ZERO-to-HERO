-- create
CREATE TABLE CUSTOMERS (
  customer_id INTEGER PRIMARY KEY,
  customer_name TEXT NOT NULL,
  phone_number CHAR(12) NOT NULL,
  email_address TEXT NOT NULL,
  member_id INTEGER NOT NULL 
);

CREATE TABLE SALES (
  sales_id INTEGER PRIMARY KEY,
  sales_date DATE NOT NULL,
  total_amount INTEGER NOT NULL,
  payment_method VARCHAR(64),
  customer_id INTEGER NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id) ON DELETE CASCADE
);

CREATE TABLE PRODUCTS (
  product_id INTEGER PRIMARY KEY,
  product_name VARCHAR(64) NOT NULL,
  category VARCHAR(15) NOT NULL,
  price INTEGER NOT NULL,
  stock INTEGER NOT NULL,
  cost_price INTEGER NOT NULL,
  exp_date DATE NOT NULL
);

CREATE TABLE SALES_DETAIL(
  detail_id INTEGER PRIMARY KEY,
  quantity INTEGER NOT NULL,
  price INTEGER NOT NULL,
  sales_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  FOREIGN KEY (sales_id) REFERENCES SALES(sales_id) ON DELETE CASCADE, 
  FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id) ON DELETE CASCADE
);



-- insert
INSERT INTO CUSTOMERS VALUES (1, 'Adit', '085111111111', 'aditmedit@gmail.com', 00001);
INSERT INTO CUSTOMERS VALUES (2, 'Sopo', '085222222222', 'soposingsalah@gmail.com', 00002);
INSERT INTO CUSTOMERS VALUES (3, 'Jarwo', '085333333333', 'jajaranprabowo@gmail.com', 00003);
INSERT INTO CUSTOMERS VALUES (4, 'Denis', '085444444444', 'dontol@gmail.com', 00004);
INSERT INTO CUSTOMERS VALUES (5, 'Pak Haji', '085555555555', 'pakhajinaikbubur@gmail.com', 00005);
INSERT INTO CUSTOMERS VALUES (6, 'Ko Lim', '085666666666', 'kolimitededition@gmail.com', 00006);

INSERT INTO SALES VALUES (1, '2026-01-27', 1000, 'kredit', 1);
INSERT INTO SALES VALUES (2, '2026-01-27', 2000, 'cash', 2);
INSERT INTO SALES VALUES (3, '2026-01-27', 3000, 'qris', 3);
INSERT INTO SALES VALUES (4, '2026-04-30', 4000, 'kredit', 4);
INSERT INTO SALES VALUES (5, '2026-04-30', 5000, 'cash', 5);
INSERT INTO SALES VALUES (6, '2026-04-30', 6000, 'qris', 6);

INSERT INTO PRODUCTS VALUES (1, 'jagoan neon', 'permen', 500, 10, 250, '2027-01-01');
INSERT INTO PRODUCTS VALUES (2, 'softex 29cm', 'pampers', 3000, 5, 2000, '2027-01-02');
INSERT INTO PRODUCTS VALUES (3, 'mie sakura', 'mie', 2000, 7, 1500, '2027-01-03');
INSERT INTO PRODUCTS VALUES (4, 'garuda rosta', 'snack', 2000, 10, 1500, '2027-01-04');
INSERT INTO PRODUCTS VALUES (5, 'susu jahe sidomuncul', 'minuman', 1000, 10, 700, '2027-01-05');
INSERT INTO PRODUCTS VALUES (6, 'rokok djeruk bijian', 'rokok', 5000, 30, 2000, '2030-01-06');

INSERT INTO SALES_DETAIL VALUES (1, 2, 500, 1, 1);
INSERT INTO SALES_DETAIL VALUES (2, 2, 1000, 2, 5);
INSERT INTO SALES_DETAIL VALUES (3, 1, 3000, 3, 2);
INSERT INTO SALES_DETAIL VALUES (4, 2, 2000, 4, 4);
INSERT INTO SALES_DETAIL VALUES (5, 1, 5000, 5, 6);
INSERT INTO SALES_DETAIL VALUES (6, 3, 2000, 6, 3);

DELETE FROM CUSTOMERS WHERE customer_name = 'Adit';
DELETE FROM SALES WHERE payment_method = 'kredit' AND total_amount = 1000;
DELETE FROM PRODUCTS WHERE category = 'rokok';
DELETE FROM SALES_DETAIL WHERE quantity * price >= 6000;

UPDATE CUSTOMERS SET customer_name = 'dontol' WHERE email_address = 'dontol@gmail.com';
UPDATE SALES SET total_amount = total_amount * 2 WHERE payment_method = 'kredit';
UPDATE PRODUCTS SET exp_date = '2050-04-30' WHERE exp_date between '2027-01-03' AND '2027-01-05';
UPDATE SALES_DETAIL SET quantity = 4 WHERE product_id = 4;

-- fetch 
SELECT * FROM CUSTOMERS;
SELECT DISTINCT payment_method FROM SALES;
SELECT quantity, price FROM SALES_DETAIL ORDER BY quantity;
SELECT price, cost_price, stock, (stock * price) - cost_price AS ending_inventory FROM PRODUCTS ORDER BY price;
SELECT payment_method FROM SALES GROUP BY payment_method;
SELECT cost_price FROM PRODUCTS GROUP BY cost_price HAVING COUNT(*) > 2;
SELECT payment_method, SUM(total_amount) AS income FROM SALES GROUP BY payment_method HAVING SUM(total_amount > 3000) ORDER BY income;

SELECT c.customer_name, s.payment_method FROM CUSTOMERS c INNER JOIN SALES s ON s.customer_id = c.customer_id;
SELECT (SELECT product_name FROM PRODUCTS WHERE SALES_DETAIL.product_id = PRODUCTS.product_id) AS product_name, quantity AS sold FROM SALES_DETAIL WHERE quantity > 1 ORDER BY quantity DESC;
SELECT c.customer_name, s.total_amount FROM CUSTOMERS c INNER JOIN SALES s ON s.customer_id = c.customer_id WHERE s.total_amount >= (SELECT AVG(total_amount) FROM SALES);
