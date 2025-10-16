/* =================================================================
Data Segmentation
-------------------------
	 >> Group the Data based on specific range

	 >> Correlate between 2 measures

	 >> So, the job is, 
			convert a measure into dimension/ category

	 >> [Measure] BY [Measure]
		-> total products  BY sales range
		-> total customers BY age 

	 >> For this analysis:
			We use Case When statement

================================================================= */

-- use datawarehouseanalytics;

-- Segment products into cost ranges and count how many products fall into eah segment
WITH product_segments as (
	select 
	product_key,
	product_name,
	cost,
	Case when cost < 100 then 'below 100'
		 when cost between 100 and 500 then '100-500'
		 when cost between 501 and 1000 then '500-100'
		 else 'above 1000'
	end cost_range
	from [gold.dim_products])

select 
cost_range,
count(product_key) as total_products
from product_segments
group by cost_range
order by total_products DESC

/* Group customers into three segments based on their spending behavior:
		- VIP: Customers with at least 12 months of history but spending more than 5000 EUR
		- Regular: Customers with at least 12 months of history but spending 5000 EUR or less
		- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group */
WITH customer_spending as(
select 
c.customer_key,
concat(c.first_name, ' ', c.last_name) as customer_name,
SUM(s.sales_amount) as total_spending,
min(order_date) as first_order_date,
max(order_date) as last_order_date,
datediff(month, min(order_date), max(order_date)) as lifespan
from [gold.dim_customers] c
left join [gold.fact_sales] s 
on c.customer_key =  s.customer_key
group by c.customer_key, 
		 concat(c.first_name, ' ', c.last_name))


select 
customer_segment,
count(customer_key) as total_customers
from
(
Select customer_key,
total_spending,
lifespan,
case when lifespan >= 12 and total_spending > 5000 then 'VIP'
	 when lifespan >= 12 and total_spending <= 5000 then 'Regular'
	 else 'New'
end customer_segment
from customer_spending
) t
group by customer_segment
order by total_customers desc

