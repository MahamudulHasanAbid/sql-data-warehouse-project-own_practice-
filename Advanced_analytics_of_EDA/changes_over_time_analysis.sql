* =============================================
Change-over-Time Analysis
-------------------------
	>> It represents the Trend overtime.
	>> Analyze sales performance (total sales, total customers, total quantity) over time.

	>> Σ[Measure] BY [Date Dimension]
		-> Total sales BY year
		-> Average costs BY month

============================================= */
 use DataWarehouseAnalytics; -- before starting any query we have to choose database

-- Analyze Sales performance over time (Year)

Select 
YEAR(order_date) as order_year,
SUM(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from [gold.fact_sales]
where order_date is not null 
group by YEAR(order_date)
order by YEAR(order_date)

-- Analyze Sales performance over time (Month)
SELECT
MONTH(order_date) as order_month,
SUM(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from [gold.fact_sales]
where order_date is not null 
group by MONth(order_date)
order by MONth(order_date)

-- Analyze Sales performance over time
SELECT 
DATETRUNC(month, order_date) as order_date,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from [gold.fact_sales]
where order_date is not null
group by DATETRUNC(month, order_date)
order by DATETRUNC(month, order_date)

-- How many new customers were added each year

Select
DATETRUNC(year, create_date) as create_year,
count(customer_key) as total_customer
from [gold.dim_customers]
group by DATETRUNC(YEAR, create_date)
order by DATETRUNC(year, create_date)

