-- using - views are Virtual Tables

select *,
	 round(gross_price_total - (gross_price_total*pre_invoice_discount_pct),2) as net_invoice_sales
from sales_preinv_discount s;
 -- net_invoice_sales formula can also be written as [(1-pre_invoice_discount_pct)*gross_price_total]  
 
 -- Now Joining post_invoice table 
 
 select *,
	(1-pre_invoice_discount_pct)*gross_price_total as net_invoice_sales,
    (po.discounts_pct + po.other_deductions_pct) as post_invoice_discount_pct
from sales_preinv_discount s
join fact_post_invoice_deductions po
on  s.date = po.date and
	s.customer_code = po.customer_code and
    s.product_code = po.product_code;
    
-- we will create one more view i.e sales_postinv_discount by using above code because we need net sales    
-- we can get net_sales by writing cte or subquery or views -->we cannot write in the same query because derived column cannot be used in the same query 

-- now using views -->sales_postinv_discount we will calculate net_sales

select  *, 
		(1-post_invoice_discount_pct)*net_invoice_sales as net_sales
from sales_postinv_discount;

-- Create a view for gross sales. It should have the following columns,
-- date, fiscal_year, customer_code, customer, market, product_code, product, variant,
-- sold_quanity, gross_price_per_item, gross_price_total