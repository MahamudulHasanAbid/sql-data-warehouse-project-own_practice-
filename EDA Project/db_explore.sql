-- Explore all objects in the DB

	Select * from INFORMATION_SCHEMA.Tables;

-- Explore all columns in the DB

	Select * from INFORMATION_SCHEMA.columns;

	Select * from INFORMATION_SCHEMA.columns
	Where table_name = 'gold.fact_sales';

	Select * from INFORMATION_SCHEMA.columns
	Where table_name = 'gold.dim_customers';

	Select * from INFORMATION_SCHEMA.columns
	Where table_name = 'gold.dim_products';
