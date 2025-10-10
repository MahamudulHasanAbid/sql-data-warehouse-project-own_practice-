/* =============================================
Cumulative Analysis
-------------------------
	 >> Aggregate the Data progressively over time

	 >> Helps to understand 
					whether the business is growing or declining

	 >> Σ[Cumulative Measure] BY [Date Dimension]
		-> Running total sales by year 
		-> Moving Average of sales by month

	 >> For this analysis:
			We use "Window Functions"
============================================= */

-- use DataWarehouseAnalytics;

-- Calculate the total sales per month 
-- and the running total sales over time


select
order_date,
total_sales,
sum(total_sales) over(partition by order_date order by order_date) as running_total_slaes
from
(
	Select 
	datetrunc(month,order_date) as order_date,
	sum(sales_amount) as total_sales
	from [gold.fact_sales]
	where order_date is not null
	group by datetrunc(month,order_date)

) t

-- Calculate the total sales per year 
-- and the running total sales over time


select
order_date,
total_sales,
sum(total_sales) over( order by order_date) as running_total_slaes,
avg(avg_price) over(order by order_date) as moving_avg_price
from
(
	Select 
	datetrunc(year,order_date) as order_date,
	sum(sales_amount) as total_sales,
	avg(price) as avg_price
	from [gold.fact_sales]
	where order_date is not null
	group by datetrunc(year,order_date)

) t
