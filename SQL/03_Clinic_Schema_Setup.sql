-- Create database (safe)
CREATE DATABASE IF NOT EXISTS clinic_db;
USE clinic_db;

-- Drop tables if already exist (avoid errors)
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS clinics;

-- Create clinics table
CREATE TABLE clinics (
    cid VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

-- Create customer table
CREATE TABLE customer (
    uid VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    mobile VARCHAR(15)
);

-- Create clinic_sales table
CREATE TABLE clinic_sales (
    oid VARCHAR(50) PRIMARY KEY,
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount INT,
    datetime DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- Create expenses table
CREATE TABLE expenses (
    eid VARCHAR(50) PRIMARY KEY,
    cid VARCHAR(50),
    description VARCHAR(100),
    amount INT,
    datetime DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- Insert sample data into clinics
INSERT INTO clinics VALUES
('cnc-0100001', 'XYZ Clinic', 'Hyderabad', 'Telangana', 'India'),
('cnc-0100002', 'ABC Clinic', 'Bangalore', 'Karnataka', 'India');

-- Insert sample data into customer
INSERT INTO customer VALUES
('usr-001', 'John Doe', '97XXXXXXXX'),
('usr-002', 'Jane Smith', '98XXXXXXXX');

-- Insert sample data into clinic_sales
INSERT INTO clinic_sales VALUES
('ord-001', 'usr-001', 'cnc-0100001', 25000, '2021-09-23 12:03:22', 'online'),
('ord-002', 'usr-002', 'cnc-0100002', 15000, '2021-10-10 10:00:00', 'offline'),
('ord-003', 'usr-001', 'cnc-0100001', 20000, '2021-10-15 14:30:00', 'online');

-- Insert sample data into expenses
INSERT INTO expenses VALUES
('exp-001', 'cnc-0100001', 'Medical Supplies', 5000, '2021-09-23 07:36:48'),
('exp-002', 'cnc-0100002', 'Staff Salary', 7000, '2021-10-10 09:00:00'),
('exp-003', 'cnc-0100001', 'Maintenance', 3000, '2021-10-15 08:00:00');



SELECT * FROM clinics;
SELECT * FROM customer;
SELECT * FROM clinic_sales;
SELECT * FROM expenses;