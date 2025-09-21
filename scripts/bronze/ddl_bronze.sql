/* 
=====================================================================================
DDL Script: Create Bronze Tables
=====================================================================================

Script Purpose:
	This scripts
		>> Creates tables in the 'bronze' schema
		>> dropping existing tables if they already exist.
	Run this script to re-define the DDL structure of 'bronze' tables
======================================================================================

*/






IF OBJECT_ID( 'bronze.crm_cust_info', 'U') is not null
	drop table bronze.crm_cust_info;

create table bronze.crm_cust_info(
cst_id INT,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50),
cst_gndr nvarchar(20),
cst_create_date date
);

IF OBJECT_ID( 'bronze.crm_prd_info', 'U') is not null
	drop table bronze.crm_prd_info;

create table bronze.crm_prd_info(
prd_id INT,
prd_key nvarchar(50),
prd_nm nvarchar(100),
prd_cost INT,
prd_line nvarchar(20),
prd_start_dt datetime,
prd_end_dt datetime
);

IF OBJECT_ID( 'bronze.crm_sales_details', 'U') is not null
	drop table bronze.crm_sales_details;

create table bronze.crm_sales_details(
sls_ord_num nvarchar(50),
sls_prd_key nvarchar(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);


IF OBJECT_ID( 'bronze.erp_cust_az12', 'U') is not null
	drop table bronze.erp_cust_az12;

create table bronze.erp_cust_az12(
CID nvarchar(50),
BDATE date,
GEN nvarchar(50)
);


IF OBJECT_ID( 'bronze.erp_loc_a101', 'U') is not null
	drop table bronze.erp_loc_a101;

create table bronze.erp_loc_a101(
CID nvarchar(50),
CNTRY nvarchar(50)
);


IF OBJECT_ID( 'bronze.erp_px_cat_g1v2', 'U') is not null
	drop table bronze.erp_px_cat_g1v2;

create table bronze.erp_px_cat_g1v2(
ID nvarchar(50),
CAT nvarchar(50),
SUBCAT nvarchar(50),
MAINTENANCE nvarchar(50)
);
