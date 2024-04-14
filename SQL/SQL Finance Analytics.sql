-- Month
-- Product Name
-- Variant
-- Sold Quantity
-- Gross Price Per Item
-- Gross Price Total

-- a. first grab customer codes for Croma india
select * from dim_customer where customer like "%croma%" and market = "India";

### Module: User-Defined SQL Functions
-- b. Get all the sales transaction data from fact_sales_monthly table for that customer(croma: 90002002) in the fiscal_year 2021 and quarter of Q3
select * from fact_sales_monthly 
where 
	customer_code = 90002002 and
	get_fiscal_year(date)=2021 and 
    get_fiscal_quarter(date) = "Q3" 
order by date desc;

### Module: Gross Sales Report: Monthly Product Transactions

-- c. Get all the sales transaction data from fact_sales_monthly table and Monthly Product Transactions and perform join on fact_gross_price
select s.date,s.product_code,
	   p.product,p.variant,s.sold_quantity,
       g.gross_price,
       round((g.gross_price * s.sold_quantity),2) as gross_price_total
from fact_sales_monthly s
join dim_product p 
on s.product_code = p.product_code
join fact_gross_price g
on g.product_code = s.product_code and g.fiscal_year = get_fiscal_year(s.date)
where 
	customer_code = 90002002 and
	get_fiscal_year(date)=2021
    order by date desc;  

###Croma Monthly Total Sales
-- Report Should have columns - Month , Total gross sales amount to Croma India in this month

select s.date, sum(gross_price * sold_quantity) as gross_price_total
from fact_sales_monthly s
join fact_gross_price g 
on g.product_code = s.product_code and g.fiscal_year = get_fiscal_year(s.date)
where customer_code = 90002002 
group by s.date
order by s.date asc;

--  Generate a yearly report for Croma India where there are two columns 1. Fiscal Year 2. Total Gross Sales amount In that year from Croma

select 
      get_fiscal_year(s.date) as fiscal_year, 
      sum(gross_price * sold_quantity) as yearly_sales
from fact_sales_monthly s
join fact_gross_price g 
on g.product_code = s.product_code and
   g.fiscal_year = get_fiscal_year(s.date)
where 
	customer_code = 90002002 
group by get_fiscal_year(s.date)
order by fiscal_year;