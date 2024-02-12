-- Data cleaning
SELECT
	*
FROM dbo.WalmartSalesData

Alter table WalmartSalesData
drop column time_of_day

-- Add the time_of_day column

ALTER TABLE WalmartSalesData 
ADD  time_of_day varchar(20);


UPDATE WalmartSalesData
SET time_of_day = (
	CASE
		WHEN Time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN Time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) 

	-- Add day_name column

ALTER TABLE WalmartSalesData 
ADD day_name VARCHAR(20);

UPDATE dbo.WalmartSalesData
SET day_name = DATENAME(Weekday,Date);


SELECT
	Date,day_name
FROM WalmartSalesData;


-- Add month_name column
SELECT
Date,month_name
FROM WalmartSalesData;

ALTER TABLE WalmartSalesData
ADD  month_name VARCHAR(10);

UPDATE WalmartSalesData
SET month_name = DATENAME(Month,Date);


-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------
-- How many unique cities does the data have?
SELECT 
	DISTINCT city
FROM WalmartSalesData;

-- In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM WalmartSalesData;


-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT
	DISTINCT product_line
FROM WalmartSalesData


-- What is the most selling product line
SELECT
	SUM(quantity) as qty,
    product_line
FROM WalmartSalesData
GROUP BY product_line
ORDER BY qty DESC;

-- What is the most selling product line
SELECT
	SUM(quantity) as qty,
    product_line
FROM WalmartSalesData
GROUP BY product_line
ORDER BY qty DESC;

-- What is the total revenue by month
SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM WalmartSalesData
GROUP BY month_name 
ORDER BY total_revenue;


-- What month had the largest COGS?
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM WalmartSalesData
GROUP BY month_name 
ORDER BY cogs;


-- What product line had the largest revenue?
SELECT
	product_line,
	SUM(total) as total_revenue
FROM WalmartSalesData
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM WalmartSalesData
GROUP BY city, branch 
ORDER BY total_revenue;


-- What product line had the largest VAT?
SELECT
	product_line,
	AVG(Tax_5) as avg_tax
FROM WalmartSalesData
GROUP BY product_line
ORDER BY avg_tax DESC;


-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM WalmartSalesData

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM WalmartSalesData
GROUP BY product_line;


-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM WalmartSalesData
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM WalmartSalesData);


-- What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM WalmartSalesData
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM WalmartSalesData
GROUP BY product_line
ORDER BY avg_rating DESC;


-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM WalmartSalesData;

-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment
FROM WalmartSalesData;


-- What is the most common customer type?
SELECT
	customer_type,
	count(*) as count
FROM WalmartSalesData
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM WalmartSalesData
GROUP BY customer_type;


-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM WalmartSalesData
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM WalmartSalesData
WHERE branch ='C'
GROUP BY gender
ORDER BY gender_cnt DESC;


-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM WalmartSalesData
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter


-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM WalmartSalesData
WHERE branch = 'A'
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM WalmartSalesData
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?



-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM WalmartSalesData
WHERE branch = 'C'
GROUP BY day_name
ORDER BY total_sales DESC;


-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM WalmartSalesData
WHERE day_name = 'Sunday'
GROUP BY time_of_day 
ORDER BY total_sales DESC;


-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM WalmartSalesData
GROUP BY customer_type
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(tax_5), 2) AS avg_tax_pct
FROM WalmartSalesData
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(tax_5) AS total_tax
FROM WalmartSalesData
GROUP BY customer_type
ORDER BY total_tax;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------





