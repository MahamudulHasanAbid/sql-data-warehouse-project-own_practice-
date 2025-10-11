/* =================================================================
Performance Analysis
-------------------------
	 >> Compare the current value to a target value

	 >> Measure success

	 >> Compare performance

	 >> Σ[Current Measure] - [Target Measure]
		-> Current sales - Target Sales
		-> Current year sales - previous year sales (YOY analysis)

	 >> For this analysis:
			We use "Window Functions (aggregate and value(lead(), lag())"

================================================================= */

-- use datawarehouseanalytics;

/* Analyze the yearly performance of products by comparing their sales
to both the average sales performance of the product and the previous year's sales */
-- use DataWarehouseAnalytics;
WITH yearly_product_sales as(
select 
year(s.order_date) as order_year,
p.product_name,
sum(s.sales_amount) as current_sales
from [gold.fact_sales] s
left join [gold.dim_products] p
ON s.product_key = p.product_key
where order_date is not null
group by year(s.order_date), p.product_name
)

select 
order_year,
product_name,
current_sales,
avg(current_sales) over(partition by product_name) as avg_sales,
current_sales - avg(current_sales) over(partition by product_name) as diff_avg,
CASE when current_sales - avg(current_sales) over(partition by product_name) >0 then 'above avg'
	 when current_sales - avg(current_sales) over(partition by product_name) <0 then 'below avg'
	 else 'avg'
end avg_change,


lag(current_sales) over(partition by product_name order by order_year) as py_sales,
current_sales- lag(current_sales) over(partition by product_name order by order_year) as diff_py,
CASE when current_sales- lag(current_sales) over(partition by product_name order by order_year) >0 then 'Increase'
	 when current_sales- lag(current_sales) over(partition by product_name order by order_year) <0 then 'Decrease'
	 else 'No change'
end py_change

from yearly_product_sales
order by product_name, order_year
