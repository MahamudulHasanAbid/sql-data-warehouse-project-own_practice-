-- use DataWarehouse;

IF OBJECT_ID( 'silver.crm_cust_info', 'U') is not null
	drop table silver.crm_cust_info;

create table silver.crm_cust_info(
cst_id INT,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50),
cst_gndr nvarchar(20),
cst_create_date date,
-- Meta data
dwh_create_date datetime2 default getdate()
);

IF OBJECT_ID( 'silver.crm_prd_info', 'U') is not null
	drop table silver.crm_prd_info;

create table silver.crm_prd_info(
prd_id INT,
cat_id nvarchar(50),
prd_key nvarchar(50),
prd_nm nvarchar(100),
prd_cost INT,
prd_line nvarchar(20),
prd_start_dt date,
prd_end_dt date, 
-- Meta data
dwh_create_date datetime2 default getdate()
);

IF OBJECT_ID( 'silver.crm_sales_details', 'U') is not null
	drop table silver.crm_sales_details;

create table silver.crm_sales_details(
sls_ord_num nvarchar(50),
sls_prd_key nvarchar(50),
sls_cust_id INT,
sls_order_dt date,
sls_ship_dt date,
sls_due_dt date,
sls_sales INT,
sls_quantity INT,
sls_price INT,
-- Meta data
dwh_create_date datetime2 default getdate()
);


IF OBJECT_ID( 'silver.erp_cust_az12', 'U') is not null
	drop table silver.erp_cust_az12;

create table silver.erp_cust_az12(
CID nvarchar(50),
BDATE date,
GEN nvarchar(50),
-- Meta data
dwh_create_date datetime2 default getdate()
);


IF OBJECT_ID( 'silver.erp_loc_a101', 'U') is not null
	drop table silver.erp_loc_a101;

create table silver.erp_loc_a101(
CID nvarchar(50),
CNTRY nvarchar(50),
-- Meta data
dwh_create_date datetime2 default getdate()
);


IF OBJECT_ID( 'silver.erp_px_cat_g1v2', 'U') is not null
	drop table silver.erp_px_cat_g1v2;

create table silver.erp_px_cat_g1v2(
ID nvarchar(50),
CAT nvarchar(50),
SUBCAT nvarchar(50),
MAINTENANCE nvarchar(50),
-- Meta data
dwh_create_date datetime2 default getdate()
);
