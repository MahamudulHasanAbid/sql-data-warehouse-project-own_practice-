/* =================================================================
Part-to-whole Analysis ( Most important )
-------------------------
	 >> Analyze how an individual part is performing compared to overall

	 >> To understand which category has the greatest impact on business.

	 >> Compare performance

	 >>  [Measure] / [Total Measure] * 100 BY [Dimension]
		-> (sales/total_sales) * 100 BY category
		-> (quantity/total_quantity) * 100 BY country

================================================================= */
-- use datawarehouseanalytics;

-- Which categories contribute the most to overall sales
WITH category_sales as (
Select 
category,
sum(sales_amount) as total_sales
from [gold.fact_sales] s
left join [gold.dim_products] p
on s.product_key = p.product_key
group by category)

select 
category,
total_sales,
sum(total_sales) over() as overall_sales,
concat(round((cast(total_sales as float) / sum(total_sales) over()) * 100, 2), '%') as percentage_of_total
from category_sales
order by total_sales DESC
