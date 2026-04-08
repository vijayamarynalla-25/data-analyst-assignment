SELECT * FROM users;
SELECT * FROM bookings;
SELECT * FROM items;
SELECT * FROM booking_commercials;
SELECT user_id, room_no
FROM (
    SELECT 
        user_id,
        room_no,
        booking_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) as rn
    FROM bookings
) t
WHERE rn = 1;


SELECT 
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_bill
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE YEAR(b.booking_date) = 2021 
  AND MONTH(b.booking_date) = 11
GROUP BY b.booking_id;



SELECT 
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE YEAR(bc.bill_date) = 2021 
  AND MONTH(bc.bill_date) = 10
GROUP BY bc.bill_id
HAVING bill_amount > 1000; 

WITH item_orders AS (
    SELECT 
        MONTH(bc.bill_date) AS month,
        bc.item_id,
        SUM(bc.item_quantity) AS total_qty,
        RANK() OVER (PARTITION BY MONTH(bc.bill_date) ORDER BY SUM(bc.item_quantity) DESC) as rnk_desc,
        RANK() OVER (PARTITION BY MONTH(bc.bill_date) ORDER BY SUM(bc.item_quantity) ASC) as rnk_asc
    FROM booking_commercials bc
    GROUP BY MONTH(bc.bill_date), bc.item_id
)
SELECT *
FROM item_orders
WHERE rnk_desc = 1 OR rnk_asc = 1;


WITH monthly_bills AS (
    SELECT 
        b.user_id,
        MONTH(bc.bill_date) AS month,
        SUM(bc.item_quantity * i.item_rate) AS total_bill
    FROM bookings b
    JOIN booking_commercials bc ON b.booking_id = bc.booking_id
    JOIN items i ON bc.item_id = i.item_id
    GROUP BY b.user_id, MONTH(bc.bill_date)
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY month ORDER BY total_bill DESC) as rnk
    FROM monthly_bills
)
SELECT *
FROM ranked
WHERE rnk = 2;