CREATE TABLE Branch(
    branch_id int(20) PRIMARY KEY NOT NULL,
    branch_name varchar(255) NOT NULL,
    city varchar(255) NOT NULL);
    
CREATE TABLE Customer(
    customer_id varchar(255) PRIMARY KEY NOT NULL,
    full_name varchar(255) NOT NULL,
    city varchar(255) NOT NULL,
    created_at date NOT NULL);
    
CREATE TABLE Category(
    category_id int(20) PRIMARY KEY NOT NULL,
    category_name varchar(255) NOT NULL
    );

CREATE TABLE PRODUCT(
  product_id INTEGER PRIMARY KEY,
  category_id INTEGER NOT NULL,
  product_name CHAR(64) NOT NULL,
  price INTEGER NOT NULL,
  FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE CASCADE
);

CREATE TABLE SALES(
  sales_id INTEGER PRIMARY KEY,
  sales_date date NOT NULL,
  customer_id varchar(255) NOT NULL,
  branch_id INTEGER NOT NULL,
  total_amount INTEGER NOT null,
  FOREIGN KEY (branch_id) REFERENCES Branch(branch_id) ON DELETE CASCADE,
  FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE
);

CREATE TABLE SALES_DETAIL(
  sales_detail_id INTEGER PRIMARY KEY,
  sales_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  qty INTEGER NOT NULL,
  price INTEGER NOT null,
  FOREIGN KEY (sales_id) REFERENCES SALES(sales_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id) ON DELETE CASCADE
);

-- insert
INSERT INTO Branch Values (1, 'indonesia', 'jakarta');
INSERT INTO Branch Values (2, 'Jepang', 'Tokyo');
INSERT INTO Branch Values (3, 'UK', 'London');
INSERT INTO Branch Values(4, 'USA', 'Washington DC');
INSERT INTO Branch Values(5, 'Israel', 'Jerussalem');

INSERT INTO Customer Values (1, 'Palupi', 'Mgl', '2024-06-01');
INSERT INTO Customer Values(2, 'Alya', 'Ach', '2024-06-02');
INSERT INTO Customer Values (3, 'Rigel', 'Mgl', '2024-01-03');
INSERT INTO Customer Values(4, 'Goonmaster', 'Jgj', '2024-01-04');
INSERT INTO Customer Values (5, 'Izzy', 'Jog', '2024-01-05');

INSERT INTO Category Values (1, 'Rokok');
INSERT INTO Category Values (2, 'Babi Panggang');
INSERT INTO Category Values (3, 'Bir');
INSERT INTO Category Values (4, 'Serangga Goreng');
INSERT INTO Category Values(5, 'Makanan basi');

INSERT INTO Product Values (1, 1, 'Gudang Garam', 1000);
INSERT INTO Product Values(2, 2, 'Test Kriuk', 2000);
INSERT INTO Product Values (3, 3, 'Anggur Merah Orang Tua', 3000);
INSERT INTO Product Values (4, 4, 'Kecoa Goreng', 4000);
INSERT INTO Product Values(5, 5, 'Tape Nasi', 5000);
INSERT INTO Product Values (6, 1, 'Djarum 76', 1000);
INSERT INTO Product Values(7, 2, 'Bakso Afung', 2000);
INSERT INTO Product Values (8, 3, 'Sake', 3000);
INSERT INTO Product Values (9, 4, 'Kelabang Tomyum', 4000);
INSERT INTO Product Values(10, 5, 'Tempe Pistachio', 5000);

INSERT INTO Sales VALUES
(1, '2024-01-01', 1, 1, 1000),
(2, '2024-01-02', 2, 2, 2000),
(3, '2024-01-03', 3, 3, 3000),
(4, '2024-01-04', 4, 4, 4000),
(5, '2024-01-05', 5, 5, 5000),
(6, '2024-01-06', 1, 5, 10000),
(7, '2024-01-07', 2, 3, 3000),
(8, '2024-01-08', 3, 1, 5000),
(9, '2024-01-09', 4, 2, 6000),
(10, '2024-01-10', 5, 4, 8000);

INSERT INTO Sales_detail VALUES
(1, 1, 1, 1, 1000),
(2, 2, 2, 1, 2000),
(3, 3, 3, 1, 3000),
(4, 4, 4, 1, 4000),
(5, 5, 5, 1, 5000),
(6, 6, 10, 2, 5000),
(7, 7, 8, 1, 3000),
(8, 8, 6, 5, 1000),
(9, 9, 7, 3, 2000),
(10, 10, 9, 2, 4000);
SELECT * FROM Branch;
SELECT * FROM Category;
SELECT * FROM Customer;
SELECT * FROM PRODUCT;
SELECT * FROM SALES;
SELECT * FROM SALES_DETAIL;


SELECT c.full_name AS pembeli, p.product_name AS nama_produk, ca.category_name AS jenis_produk, sd.qty AS jumlah, sd.price AS harga FROM SALES_DETAIL sd 
JOIN SALES s ON sd.sales_id = s.sales_id 
JOIN Customer c ON s.customer_id = c.customer_id
JOIN product p ON sd.product_id = p.product_id
JOIN category ca ON p.category_id = ca.category_id
WHERE c.created_at LIKE "2024-06-%";

SELECT DISTINCT p.product_name AS nama_produk, ca.category_name AS jenis_produk, sd.qty AS jumlah FROM SALES_DETAIL sd
JOIN product p ON sd.product_id = p.product_id
JOIN category ca ON p.category_id = ca.category_id
GROUP BY p.product_name, ca.category_name, sd.qty ORDER BY jumlah DESC;

SELECT nama_produk, jenis_produk,  jumlah
FROM  (SELECT p.product_name AS nama_produk, ca.category_name AS jenis_produk, MAX(sd.qty) AS jumlah FROM SALES_DETAIL sd
JOIN product p ON sd.product_id = p.product_id
JOIN category ca ON p.category_id = ca.category_id
GROUP BY p.product_name, ca.category_name) AS recommended;

SELECT p.product_name AS nama_produk, ca.category_name AS jenis_produk, MAX(sd.qty) AS jumlah FROM SALES_DETAIL sd
JOIN product p ON sd.product_id = p.product_id
JOIN category ca ON p.category_id = ca.category_id
GROUP BY p.product_name, ca.category_name;

SELECT nama_produk, jenis_produk,  jumlah, RANK() OVER (PARTITION BY jenis_produk ORDER BY jumlah DESC) AS Terlaris
FROM  (SELECT p.product_name AS nama_produk, ca.category_name AS jenis_produk, SUM(sd.qty) AS jumlah FROM SALES_DETAIL sd
JOIN product p ON sd.product_id = p.product_id
JOIN category ca ON p.category_id = ca.category_id
GROUP BY p.product_name, ca.category_name) AS recommended;

SELECT * FROM(
SELECT nama_produk, jenis_produk,  jumlah, RANK() OVER (PARTITION BY jenis_produk ORDER BY jumlah DESC) AS Terlaris
FROM  (SELECT p.product_name AS nama_produk, ca.category_name AS jenis_produk, SUM(sd.qty) AS jumlah FROM SALES_DETAIL sd
JOIN product p ON sd.product_id = p.product_id
JOIN category ca ON p.category_id = ca.category_id
GROUP BY p.product_name, ca.category_name) AS recommended) sleepy WHERE Terlaris = 1;