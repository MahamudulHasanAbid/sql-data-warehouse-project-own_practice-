/* ========================================================================================== 
In this step we are going to Identify the unique values/categories in each dimension. 
Therefore, 
 >> We have to choose which column is 'Dimension' and which one is 'Measure' from a table. 
	#If the column is number and capable of perform aggregate function then 'Measure'
	#else, column is 'Dimension'
 >> Recognize, How data might be grouped or segmented (useful for later analysis) 
	# For example:
		DISTINCT[Dimension]
============================================================================================ */

-- DISTINCT[Dimension] for gold.dim_customers table

Select distinct country from [gold.dim_customers];
Select distinct gender from [gold.dim_customers];
Select distinct marital_status from [gold.dim_customers];

-- DISTINCT[Dimension] for gold.dim_products table

Select distinct category, subcategory, product_name
from [gold.dim_products]
order by  1,2,3;
