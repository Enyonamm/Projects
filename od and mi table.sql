-- 1. Combining the menu_items table and order_details table into a single table.
SELECT * FROM menu_items;
SELECT * FROM order_details;
/* The primary key in these tables is the item_id column. 
That is what has been used to join the table.
The command LEFT JOIN is used instead of the INNER JOIN because we want to see all the columns in both
 the transactions table (order_details) and look-up table (menu_items)
     The transactions table is always called first whenever tables are being joined. */
 
SELECT *
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id;
    
-- 2. What were the least and most ordered items? What categories were they in?

/* Query below shows us the least ordered items. */
 SELECT item_name, COUNT(order_details_id) AS num_purchases 
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY item_name
ORDER BY num_purchases;    
/* Query below shows the most ordered items at the top of the table shown. */
SELECT item_name, COUNT(order_details_id) AS num_purchases 
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY item_name
ORDER BY num_purchases DESC;  

/* Which category are they in? 
Queries below show for the categories for the least and most ordered items. */

SELECT item_name, category, COUNT(order_details_id) AS num_purchases 
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY num_purchases;

SELECT item_name, category, COUNT(order_details_id) AS num_purchases 
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY num_purchases DESC; 

-- 3. What were the top 5 orders that spent the most money?

SELECT order_id, SUM(price) AS total_spend
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spend DESC
LIMIT 5;
 
-- 4. View the details of the highest spend order. What insights can you gather from there?
SELECT category, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id = 440
GROUP BY category;

/* Highest spender orders mostly Italian dishes as opposed to the rest.
This menu items should be kept on the menu.
However, the least ordered menu_items must be reviewed.
In terms of taste, advertising, and other metrics
such as the portion size and 
the preferences of the people in the restaurant area. */


-- 5. View the details of the top 5 highest spend orders. What insights can we draw from this?

SELECT order_id, category, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY order_id, category; 

/* The insights from this is that 
we should keep the expensive Italian menu_items
 because the highest top spenders, always purchase those foods */
 