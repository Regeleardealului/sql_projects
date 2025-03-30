-- #1: Find the top 3 cities with the lowest total sales, where the city name contains the substring "land"
SELECT city, SUM(total_sales) AS total_sales
FROM walmart
WHERE city LIKE '%land%'
GROUP BY city
ORDER BY total_sales ASC
LIMIT 3;

-- #2: Calculate to `total_profit` given by (unit_price * quantity * margin) for each category and order it by total_profit in descending order
SELECT category, SUM(unit_price * quantity * margin) AS total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC;

-- #3: Get for each city and category the AVERAGE, MINIMUM, MAXIMUM rating 
SELECT city, category, AVG(rating) AS avg_rating, MIN(rating) AS min_rating, MAX(rating) AS max_rating
FROM walmart
GROUP BY city, category
ORDER BY city, category;

-- #4: Identify the busiest day for each branch based on the number of transactions
SELECT * 
FROM
	(SELECT 
		branch,
		TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') as day_name,
		COUNT(*) as no_transactions,
		RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
	FROM walmart
	GROUP BY 1, 2)
WHERE rank = 1;

-- #5: Identify the highest-rated category in each branch
SELECT * 
FROM
	(SELECT 
		branch,
		category,
		AVG(rating) as avg_rating,
		RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) as rank
	FROM walmart
	GROUP BY 1, 2)
WHERE rank = 1;

-- #6: Determine the most common payment method for each branch
WITH common_payment_method AS
(SELECT 
	branch,
	payment_method,
	COUNT(*) as total_trans,
	RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
FROM walmart
GROUP BY 1, 2)

SELECT *
FROM common_payment_method
WHERE rank = 1;

-- #7: Categorize sales into 3 group MORNING, AFTERNOON, EVENING and find the number of invoices for each time frame 
SELECT
	branch,
	CASE 
		WHEN EXTRACT(HOUR FROM(time::time)) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM(time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END day_time,
	COUNT(*) AS nr_of_invoices
FROM walmart
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

-- #8: Identify 5 branch with highest decrese ratio from 2022 to 2023
WITH revenue_2022 AS
(SELECT 
	branch,
	SUM(total_sales) as revenue
 FROM walmart
 WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2022 
 GROUP BY 1),

revenue_2023 AS
(SELECT 
	branch,
	SUM(total_sales) as revenue
 FROM walmart
 WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2023
 GROUP BY 1)

SELECT 
	ls.branch,
	ls.revenue as last_year_revenue,
	cs.revenue as cr_year_revenue,
	ROUND((ls.revenue - cs.revenue)::numeric/ ls.revenue::numeric * 100, 2) as rev_decrease_ratio
FROM revenue_2022 as ls
JOIN revenue_2023 as cs
ON ls.branch = cs.branch
WHERE ls.revenue > cs.revenue
ORDER BY 4 DESC
LIMIT 5;

-- #9: Get the unique payment methods
SELECT DISTINCT(payment_method)
FROM walmart;

-- #10: Find the top 3 cities where the most used payment method was 'Cash'
WITH city_payment_method AS (
    SELECT city, payment_method, COUNT(*) AS payment_count
    FROM walmart
    WHERE payment_method = 'Cash'
    GROUP BY city, payment_method)
	
SELECT city, payment_method, payment_count
FROM city_payment_method
ORDER BY payment_count DESC
LIMIT 3;