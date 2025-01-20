SELECT * FROM project_a.sales;

-- Customer Analysis

-- Who are the most frequent customers?
SELECT 
    name, 
    COUNT(*) AS transaction_count
FROM 
    sales
GROUP BY 
    name
ORDER BY 
    transaction_count DESC
LIMIT 10;

-- What is the total amount spent by each customer?
SELECT 
    name, 
    SUM(price) AS total_spent
FROM 
    sales
GROUP BY 
    name
ORDER BY 
    total_spent DESC;

-- Which cities or states have the most customers?
-- City
SELECT 
    city, 
    COUNT(DISTINCT name) AS unique_customers
FROM 
    sales
GROUP BY 
    city
ORDER BY 
    unique_customers DESC
LIMIT 10;

-- State 
SELECT 
    state, 
    COUNT(DISTINCT name) AS unique_customers
FROM 
    sales
GROUP BY 
    state
ORDER BY 
    unique_customers DESC
LIMIT 10;


-- Sales Performance

-- What are the top-selling products?
SELECT 
    product, 
    COUNT(*) AS total_sold
FROM 
    sales
GROUP BY 
    product
ORDER BY 
    total_sold DESC
LIMIT 10;

-- What is the total revenue generated?
SELECT 
    SUM(price) AS total_revenue
FROM 
    sales;

-- Which payment methods are most commonly used?
SELECT 
    payment_type, 
    COUNT(*) AS usage_count
FROM 
    sales
GROUP BY 
    payment_type
ORDER BY 
    usage_count DESC;


-- Geographical Insight

-- Where do the majority of sales occur?
-- City
SELECT 
    city, 
    COUNT(*) AS total_sales
FROM 
    sales
GROUP BY 
    city
ORDER BY 
    total_sales DESC
LIMIT 10;

-- State
SELECT 
    state, 
    COUNT(*) AS total_sales
FROM 
    sales
GROUP BY 
    state
ORDER BY 
    total_sales DESC
LIMIT 10;


-- What are the top-selling products in each city/state?
-- City
SELECT 
    city, 
    product, 
    COUNT(*) AS total_sold
FROM 
    sales
GROUP BY 
    city, product
ORDER BY 
    city, total_sold DESC;
    
-- State
SELECT 
    state, 
    product, 
    COUNT(*) AS total_sold
FROM 
    sales
GROUP BY 
    state, product
ORDER BY 
    state, total_sold DESC;


-- What is the average revenue per customer in each country?
SELECT 
    country, 
    AVG(total_spent) AS avg_revenue_per_customer
FROM (
    SELECT 
        country, 
        name, 
        SUM(price) AS total_spent
    FROM 
        sales
    GROUP BY 
        country, name
) customer_totals
GROUP BY 
    country
ORDER BY 
    avg_revenue_per_customer DESC;


-- Time-based Trends

-- What is the sales trend over time?
-- Day
SELECT 
    DATE(transaction_date) AS transaction_day, 
    SUM(price) AS total_sales
FROM 
    sales
GROUP BY 
    transaction_day
ORDER BY 
    transaction_day;

-- Month
SELECT 
    DATE(transaction_date) AS transaction_day, 
    SUM(price) AS total_sales
FROM 
    sales
GROUP BY 
    transaction_day
ORDER BY 
    transaction_day;

-- Which days or times have the highest sales?
-- Day of the week
SELECT 
    DAYOFWEEK(transaction_date) AS day_of_week, 
    SUM(price) AS total_sales
FROM 
    sales
GROUP BY 
    DAYOFWEEK(transaction_date)
ORDER BY 
    total_sales DESC;


-- Hour
SELECT 
    HOUR(transaction_date) AS hour_of_day, 
    SUM(price) AS total_sales
FROM 
    sales
GROUP BY 
    hour_of_day
ORDER BY 
    total_sales DESC;




-- How does the time between account_created and last_login affect purchase behavior?
SELECT 
   last_login - account_created AS days_between, 
    AVG(price) AS avg_purchase_value, 
    COUNT(*) AS total_transactions
FROM 
    sales
GROUP BY 
    days_between
ORDER BY 
    days_between;


-- Revenue Metrics
-- What is the average transaction value?
SELECT 
    AVG(price) AS average_transaction_value
FROM 
    sales;

-- What is the total revenue per product?
SELECT 
    product, 
    SUM(price) AS total_revenue
FROM 
    sales
GROUP BY 
    product
ORDER BY 
    total_revenue DESC;

-- Which customers generate the most revenue?
SELECT 
    name, 
    SUM(price) AS total_revenue
FROM 
    sales
GROUP BY 
    name
ORDER BY 
    total_revenue DESC
LIMIT 10;


-- Logistics and Operational Insights

-- What regions (latitude/longitude) contribute most to sales?
SELECT 
    latitude, 
    longitude, 
    SUM(price) AS total_sales
FROM 
    sales
GROUP BY 
    latitude, longitude
ORDER BY 
    total_sales DESC
LIMIT 10;

-- Which payment types are more popular in specific regions?
SELECT 
    city, 
    payment_type, 
    COUNT(*) AS usage_count
FROM 
    sales
GROUP BY 
    city, payment_type
ORDER BY 
    city, usage_count DESC;


-- Advanced Insights

-- How does the time since account creation affect spending habits?
SELECT 
    transaction_date - account_created AS days_since_creation, 
    AVG(price) AS avg_spending, 
    COUNT(*) AS transaction_count
FROM 
    sales
GROUP BY 
    days_since_creation
ORDER BY 
    days_since_creation;

-- What are the refund or cancellation rates (if applicable)?
/* Merged tables, sales and transaction_statuses to find the refund and cancellation rates for the store */

/* CREATE TABLE merged_sales AS 
SELECT sales.id, sales.transaction_date, sales.price, sales.payment_type, 
	   sales.name, sales.city, sales.state, sales.country, 
       sales.account_created, sales.last_login, sales.latitude, sales.longitude, transaction_statuses.transaction_status 
FROM sales
INNER JOIN transaction_statuses 
ON sales.id = transaction_statuses.id;

/* refunded and cancellation rates */

SELECT 
    COUNT(*) AS total_transactions, 
    SUM(CASE WHEN transaction_status = 'refunded' THEN 1 ELSE 0 END) AS refunded_transactions, 
    ROUND((SUM(CASE WHEN transaction_status = 'refunded' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS refund_rate
FROM 
    merged_sales;
    
SELECT 
    COUNT(*) AS total_transactions, 
    SUM(CASE WHEN transaction_status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_transactions, 
    ROUND((SUM(CASE WHEN transaction_status = 'cancelled' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS cancel_rate
FROM 
    merged_sales;    

-- Are there seasonal trends in product sales?
SELECT
    CASE 
        WHEN MONTH(transaction_date) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(transaction_date) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(transaction_date) IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH(transaction_date) IN (9, 10, 11) THEN 'Autumn'
    END AS season, 
    product, 
    SUM(price) AS total_sales
FROM 
    sales
GROUP BY 
    season, product
ORDER BY 
    FIELD(season, 'Winter', 'Spring', 'Summer', 'Autumn'), total_sales DESC;



    
   