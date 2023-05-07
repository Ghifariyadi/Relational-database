# Creating table
CREATE TABLE CITY(
	kota_id int PRIMARY KEY,
	nama_kota varchar UNIQUE NOT NULL,
	latitude float8,
	longitude float8
);

CREATE TABLE car_product (
	product_id int PRIMARY KEY, 
	brand VARCHAR,
	model VARCHAR,
	body_type VARCHAR,
	year INT,
	price INT NOT NULL,
	kota_id INT,
	date_post date
);

CREATE TABLE customer(
	customer_id int PRIMARY KEY,
	customer_name VARCHAR
);

CREATE TABLE bid_details(
	bid_id int PRIMARY KEY,
	product_id int,
	customer_id int,
	date date
);