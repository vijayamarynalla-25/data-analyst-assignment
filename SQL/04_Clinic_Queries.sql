USE clinic_db;

-- 1. Revenue from each sales channel in a given year (2021)
SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;


-- 2. Top 10 most valuable customers (based on total spend)
SELECT 
    uid,
    SUM(amount) AS total_spent
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;


-- 3. Month-wise revenue, expense, profit, and status
WITH revenue AS (
    SELECT 
        MONTH(datetime) AS month,
        SUM(amount) AS total_revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
),
expense AS (
    SELECT 
        MONTH(datetime) AS month,
        SUM(amount) AS total_expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
)
SELECT 
    r.month,
    r.total_revenue,
    COALESCE(e.total_expense, 0) AS total_expense,
    (r.total_revenue - COALESCE(e.total_expense, 0)) AS profit,
    CASE 
        WHEN (r.total_revenue - COALESCE(e.total_expense, 0)) > 0 THEN 'Profit'
        ELSE 'Loss'
    END AS status
FROM revenue r
LEFT JOIN expense e ON r.month = e.month;


-- 4. Most profitable clinic for each city
WITH profit_calc AS (
    SELECT 
        c.cid,
        c.city,
        SUM(cs.amount) - COALESCE(SUM(e.amount), 0) AS profit
    FROM clinics c
    JOIN clinic_sales cs ON c.cid = cs.cid
    LEFT JOIN expenses e ON c.cid = e.cid
    GROUP BY c.cid, c.city
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM profit_calc
)
SELECT *
FROM ranked
WHERE rnk = 1;


-- 5. Second least profitable clinic for each state
WITH profit_calc AS (
    SELECT 
        c.cid,
        c.state,
        SUM(cs.amount) - COALESCE(SUM(e.amount), 0) AS profit
    FROM clinics c
    JOIN clinic_sales cs ON c.cid = cs.cid
    LEFT JOIN expenses e ON c.cid = e.cid
    GROUP BY c.cid, c.state
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rnk
    FROM profit_calc
)
SELECT *
FROM ranked
WHERE rnk = 2;