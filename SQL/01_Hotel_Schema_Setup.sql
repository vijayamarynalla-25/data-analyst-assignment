CREATE DATABASE IF NOT EXISTS hotel_db;
USE hotel_db;
CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    phone_number VARCHAR(15),
    mail_id VARCHAR(100),
    billing_address VARCHAR(200)
);

CREATE TABLE bookings (
    booking_id VARCHAR(50) PRIMARY KEY,
    booking_date DATETIME,
    room_no VARCHAR(50),
    user_id VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE items (
    item_id VARCHAR(50) PRIMARY KEY,
    item_name VARCHAR(100),
    item_rate INT
);

CREATE TABLE booking_commercials (
    id VARCHAR(50),
    booking_id VARCHAR(50),
    bill_id VARCHAR(50),
    bill_date DATETIME,
    item_id VARCHAR(50),
    item_quantity FLOAT,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

INSERT INTO users VALUES 
('21wrcxuy-67erfn', 'John Doe', '97XXXXXXXX', 'john@example.com', 'ABC City');

INSERT INTO bookings VALUES 
('bk-09f3e-95hj', '2021-09-23 07:36:48', 'rm-1', '21wrcxuy-67erfn');

INSERT INTO items VALUES 
('itm-a9e8-q8fu', 'Tawa Paratha', 18),
('itm-a07vh-aer8', 'Mix Veg', 89);

INSERT INTO booking_commercials VALUES 
('1', 'bk-09f3e-95hj', 'bl-01', '2021-09-23 12:03:22', 'itm-a9e8-q8fu', 3),
('2', 'bk-09f3e-95hj', 'bl-01', '2021-09-23 12:03:22', 'itm-a07vh-aer8', 1);