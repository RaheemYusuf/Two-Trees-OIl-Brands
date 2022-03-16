/*
What is the number of orders placed per month for each customer?
*/

SELECT customer_id, COUNT(*) total_no_of_orders, 
	COUNT(*) FILTER(WHERE order_date BETWEEN '2021-03-01' AND '2021-03-31') march_orders,
	COUNT(*) FILTER(WHERE order_date BETWEEN '2021-04-01' AND '2021-04-30') april_orders
FROM sales.orders
GROUP BY 1;


/*
What is the quantity of each product sold?
*/
SELECT sku, SUM(quantity)
FROM sales.order_lines
GROUP BY 1;

/*
What is the quantity of each product sold?
*/
SELECT category_id, product_name, size, price,
	COUNT(*) OVER(pn),
	MIN(price) OVER(pn) min_price,
	MAX(price) OVER(pn) max_price,
	AVG(price) OVER(pn) avg_price
FROM inventory.products
WINDOW pn AS (PARTITION BY category_id, size)
ORDER BY 1,2,3;


/*
What is the min, max, first quartile, second quartile, and third quartile and range of prices
*/

SELECT category_id,
MIN(price) min_price, MAX(price) max_price,
PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY price) first_quartile,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) second_quartile,
PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY price) third_quartile,
MAX(price)- MIN(price) range_of_price
FROM inventory.products
GROUP BY ROLLUP(category_id);

/*
Display ranking overall, segmented by category and by size
*/

select product_name, category_id, size, price,
	dense_rank() over (order by price desc) as "rank overall",
	dense_rank() over (partition by category_id order by price desc) as "rank category",
	dense_rank() over (partition by size order by price desc) as "rank price"
from inventory.products
order by category_id, price desc;
