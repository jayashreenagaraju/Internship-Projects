-- Top Markets

select 
	market,
    round(sum(net_sales)/1000000,2) as net_sales_mln
from net_sales
where fiscal_year = 2021
group by market
order by net_sales_mln desc
limit 5;

-- we will write above code in stored Procedure as well because we need to use this code multiple times.

-- Top Customers

select 
	c.customer,
    round(sum(net_sales)/1000000,2) as net_sales_mln
from net_sales n
join dim_customer c
on n.customer_code = c.customer_code
where fiscal_year = 2021
group by customer
order by net_sales_mln desc
limit 5;

-- Top Products

select 
	product,
    round(sum(net_sales)/1000000,2) as net_sales_mln
from net_sales
where fiscal_year = 2021
group by product
order by net_sales_mln desc
limit 5;

-- Windows Function
 -- For the FY = 2021 show Top 10 markets by % net Sales.
 
with cte1 as(select 
	c.customer,
    round(sum(net_sales)/1000000,2) as net_sales_mln
from net_sales n
join dim_customer c
on n.customer_code = c.customer_code
where n.fiscal_year = 2021 
group by customer
)

select * from cte1
order by net_sales_mln desc

