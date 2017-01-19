CREATE SCHEMA organizationA;

SET search_path TO organizationA;

CREATE TABLE companies(
   id INT PRIMARY KEY     NOT NULL,
   name           TEXT    NOT NULL,
   age            INT     NOT NULL,
   address        CHAR(50),
   salary         REAL
);

CREATE TABLE departments(
   id INT PRIMARY KEY      NOT NULL,
   dept           CHAR(50) NOT NULL,
   emp_id         INT      NOT NULL
);

CREATE TABLE customers(
  customer_id   INTEGER UNIQUE,
  customer_name VARCHAR(50),
  phone         CHAR(8),
  birth_date    DATE,
  balance       DECIMAL(7,2)
);

CREATE TABLE orders(
  customer_number   INTEGER,
  part_number       CHAR(8),
  quantity_ordered  INTEGER,
  price_per_part    DECIMAL(7,2),

  CONSTRAINT verify_minimum_order
   CHECK (( price_per_part * quantity_ordered) >= 5.00::DECIMAL )
);
