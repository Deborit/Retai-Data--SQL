create database retail_data
use retail_data
select * from customer
select * from transactions
select * from prod_cat_info

-- Data Preperation & Understaing :

-- 1. Total Row No:

select count(customer_Id) as row_number from customer;
select count(prod_cat_code) as row_number from prod_cat_info;
select count(cust_id) as row_number from transactions;

-- 2 Total

select count(cust_id) as Return_count from transactions
where total_amt <0;

-- 3 
select Convert(datetime, (convert (varchar,tran_date,102))) from Copy_transactions


-- 4
select DATEDIFF(DAY,(select min(tran_date)from Transactions),(select max(tran_date) from Transactions)) as diff_in_days,
DATEDIFF(month,(select min(tran_date)from Transactions),(select max(tran_date) from Transactions)) as diff_in_months,
DATEDIFF(YEAR,(select min(tran_date)from Transactions),(select max(tran_date) from Transactions)) as Diff_in_yrs

-- 5
select prod_cat,prod_subcat from prod_cat_info 
where prod_subcat = 'DIY';

-- DATA ANALYSIS -----------------------------

-- 1
Select * from transactions;

Select TOP 1 Store_type,Count(store_type) from transactions
group by Store_type 
order by Count(store_type)DESC;

-- 2
select Gender,Count(Gender) as TotalCount from customer
group by Gender;

-- 3
select City_code,count(City_code) as TotalCount from customer 
group by city_code
order by TotalCount DESC;

--4 
select Prod_cat,Prod_subcat from prod_cat_info
where prod_cat = 'Books'

-- 5

select max(Qty) from transactions;

-- 6

select * from Transactions ;

select prod_cat,Round(SUM(total_amt),2) as TOTAL_VALUE from Transactions full join prod_cat_info on Transactions.prod_subcat_code=prod_cat_info.prod_sub_cat_code
where prod_cat= 'Electronics' or prod_cat= 'Books'
group by prod_cat;

-- 7

select cust_id ,Count(Cust_id) as transactions_count from transactions WHERE rate >0 group by Cust_id having Count(Cust_id)>10 
;

-- 8
select * from prod_cat_info


select prod_cat, Round(SUM(total_amt),2) as Total_Value  from Transactions full join prod_cat_info on Transactions.prod_subcat_code=prod_cat_info.prod_sub_cat_code
where prod_cat= 'Electronics' or prod_cat= 'Clothing' and store_type= 'Flagship Store' group by prod_cat;

--9 
select * from transactions
select * from prod_cat_info
select * from Customer;

select prod_subcat_code, Round(SUM(total_amt),2) as Total_Value  from Transactions full join prod_cat_info on Transactions.prod_subcat_code=prod_cat_info.prod_sub_cat_code
full join Customer on customer.customer_Id=Transactions.cust_id
where prod_cat='Electronics' and GENDER ='M' group by prod_subcat_code;

-- 10
select * from transactions
select * from prod_cat_info



select top 5 prod_subcat_code,
Round(SUM(total_amt)*100/(select sum(total_amt) from Transactions),2) as Total_Sales_in_PERCENT,
ROUND(SUM(case when total_amt<0 then total_amt else 0 end)*100/(Select SUM(Total_amt) from Transactions where Total_amt<0),2) as Total_Percentage_of_Return
from Transactions full join prod_cat_info on Transactions.prod_subcat_code = prod_cat_info.prod_sub_cat_code
group by prod_subcat_code
order by Total_Sales_in_PERCENT DESC;	


-- 11

SELECT SUM(t.total_amt) as net_total_revenue
FROM (SELECT t.*,
             MAX(t.tran_date) OVER () as max_tran_date
      FROM Transactions t
     ) t JOIN
     Customer c
     ON t.cust_id = c.customer_Id
WHERE t.tran_date >= DATEADD(day, -30, t.max_tran_date) AND 
      t.tran_date >= DATEADD(YEAR, 25, c.DOB) AND
      t.tran_date < DATEADD(YEAR, 31, c.DOB);



-- 12 
select * from transactions
select * from prod_cat_info

select prod_cat_code,convert(date,tran_date,102) as date_of_return,total_amt from Transactions where total_amt<0 and
Convert(datetime,tran_date,102) >= (select Dateadd(M,-3,MAX(convert(datetime,tran_date,102))) from Transactions)


-- 13
select Store_type,SUM(total_amt) as TOTAL_SALES,sum(QTY) as TOTAL_QTY  from transactions group by Store_type order by TOTAL_SALES DESC
select Store_type,SUM(total_amt) as TOTAL_SALES,sum(QTY) as TOTAL_QTY  from transactions group by Store_type  order by TOTAL_QTY DESC

-- 14

select Prod_cat,AVG(TOTAL_amt) as Average from (select *,avg(t.total_amt) over() as overall_average from Transactions as T) as TT join 
prod_cat_info as p on TT.prod_cat_code = p.prod_cat_code
group by p.prod_cat,overall_average
having AVG(TOTAL_amt) >overall_average


-- 15
select * from transactions

-- FINAL ANSWER
select prod_subcat_code,sum(total_amt) as total_revenue,AVG(total_amt) as AVG_Revenue from Transactions
where prod_cat_code in (select TOP 5 Prod_cat_code from Transactions group by prod_cat_code order by sum(qty)) 
group by prod_subcat_code;
-- --------------------------------------------------
