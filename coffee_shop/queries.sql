-- #1: How many people in each city are estimated to consume coffee? (given that 25% of the population does)
SELECT 
	city_name, 
	population*0.25/POWER(10, 6) AS coffee_consumers
FROM city
ORDER BY 2 DESC;

-- #2: What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?
SELECT SUM(total) AS total_revenue
FROM sales
WHERE EXTRACT(YEAR FROM date) = 2023 AND EXTRACT(QUARTER FROM date) = 4;

-- #3: How many units of each coffee product have been sold?
SELECT 
	p.product_name, 
	COUNT(*) AS total_orders
FROM products AS p
LEFT JOIN sales AS s ON s.product_id = p.product_id
GROUP BY 1
ORDER BY 2 DESC;

-- #4: What is the average sales amount per customer in each city?
SELECT 
	c2.city_name, 
	SUM(s.total) AS total_revenue, 
	COUNT(DISTINCT c1.customer_id) AS total_customers,
	ROUND(SUM(s.total)::numeric / COUNT(DISTINCT c1.customer_id), 2) AS avg_sale_per_customer
FROM sales AS s
INNER JOIN customers AS c1 USING (customer_id)
INNER JOIN city AS c2 USING (city_id)
GROUP BY c2.city_name
ORDER BY total_revenue DESC;

-- #5: What are the top3 selling products in each city based on sales volume?
SELECT *
FROM
	(SELECT 
		c2.city_name,
		p.product_name,
		COUNT(s.sale_id) AS total_orders,
		DENSE_RANK() OVER(PARTITION BY c2.city_name ORDER BY COUNT(s.sale_id) DESC) AS rank_nr
		FROM sales AS s
		INNER JOIN products AS p USING(product_id)
		INNER JOIN customers AS c1 USING(customer_id)
		INNER JOIN city AS c2 USING(city_id)
		GROUP BY 1, 2
		ORDER BY 1, 3 DESC
	) AS tmp
WHERE rank_nr <= 3;

-- #6: How many unique customers are there in each city who purchased coffee products?
SELECT 
	c1.city_name,
	COUNT(DISTINCT c2.customer_id) as unique_cx
FROM city AS c1
LEFT JOIN customers AS c2 ON c2.city_id = c1.city_id
INNER JOIN sales AS s ON s.customer_id = c2.customer_id
WHERE s.product_id IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
GROUP BY 1;

-- #7: Find each city and their average sale per customer and average rent per customer.
WITH city_table AS
	(SELECT 
		c2.city_name,
		SUM(s.total) as total_revenue,
		COUNT(DISTINCT s.customer_id) as total_customer,
		ROUND(SUM(s.total)::numeric/COUNT(DISTINCT s.customer_id)::numeric,2) as avg_sale_pr_customer
	FROM sales as s
	JOIN customers as c1 ON s.customer_id = c1.customer_id
	JOIN city as c2 ON c1.city_id = c2.city_id
	GROUP BY 1
	ORDER BY 2 DESC
	),
city_rent AS
	(SELECT 
		city_name, 
		estimated_rent
	FROM city
)
SELECT 
	cr.city_name,
	cr.estimated_rent,
	ct.total_customer,
	ct.avg_sale_pr_customer,
	ROUND(cr.estimated_rent::numeric/ct.total_customer::numeric, 2) as avg_rent_per_customer
FROM city_rent as cr
JOIN city_table as ct ON cr.city_name = ct.city_name
ORDER BY 4 DESC;

-- #8: Get the percentage growth (or decline) in sales over different time periods (monthly) in each city.
WITH monthly_sales AS
	(SELECT 
		c2.city_name,
		EXTRACT(MONTH FROM date) AS month,
		EXTRACT(YEAR FROM date) AS year,
		SUM(s.total) AS total_sale
	FROM sales AS s
	JOIN customers AS c1 ON c1.customer_id = s.customer_id
	JOIN city AS c2 ON c2.city_id = c1.city_id
	GROUP BY 1, 2, 3
	ORDER BY 1, 3, 2
	),
growth_ratio AS
	(SELECT
		city_name,
		month,
		year,
		total_sale AS cr_month_sale,
		LAG(total_sale, 1) OVER(PARTITION BY city_name ORDER BY year, month) AS last_month_sale
		FROM monthly_sales
	)
SELECT
	city_name,
	month,
	year,
	cr_month_sale,
	last_month_sale,
	ROUND((cr_month_sale-last_month_sale)::numeric/last_month_sale::numeric * 100, 2) AS growth_ratio
FROM growth_ratio
WHERE last_month_sale IS NOT NULL;

-- #9: Which cities have the highest-rated customer satisfaction?
SELECT 
    c2.city_name,
    ROUND(AVG(s.rating), 2) AS avg_rating,
    COUNT(s.rating) AS total_reviews
FROM sales AS s
JOIN customers AS c1 ON s.customer_id = c1.customer_id
JOIN city AS c2 ON c2.city_id = c1.city_id
GROUP BY c2.city_name
HAVING COUNT(s.rating) > 5  
ORDER BY avg_rating DESC;

-- #10: List all products that have never been sold.
SELECT p.product_name
FROM products AS p
LEFT JOIN sales AS s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;
