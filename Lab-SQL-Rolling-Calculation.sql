#Lab | SQL Rolling calculations

#In this lab, you will be using the Sakila database of movie rentals.

#Instructions

#1.Get number of monthly active customers.
select * from sakila.rental;

create or replace view sakila.rental_activity as
select customer_id, convert(rental_date, date) as Activity,
date_format(convert(rental_date, date), '%m') as Activity_month,
date_format(convert(rental_date,date),'%Y') as Activity_year
from sakila.rental;

create or replace view sakila.rental_activity_monthly 
as select count(distinct customer_id) as Number_Active_Customers,Activity_month, Activity_year from sakila.rental_activity
group by Activity_year, Activity_month;

select * from sakila.rental_activity_monthly;

#2.Active users in the previous month.

select Number_Active_Customers as Number_Active_Customers_NAC, Activity_month, Activity_year,
lag(Number_Active_Customers) over() as NAC_Last_Month
from sakila.rental_activity_monthly;


#3.Percentage change in the number of active customers.
create or replace view sakila.Rental_activity_monthly_with_lag as 
select Number_Active_Customers as Number_Active_Customers_NAC, Activity_month, Activity_year,
lag(Number_Active_Customers) over() as NAC_Last_Month
from sakila.rental_activity_monthly;

select concat(round(Number_Active_Customers_NAC/NAC_Last_Month *100,0),'%') as Monthly_Change_Active_Customers, Activity_month, Activity_Year
from sakila.Rental_activity_monthly_with_lag;


#4.Retained customers every month.
select * from sakila.Rental_activity_monthly_with_lag;

create or replace view sakila.rental_activity as
select customer_id, convert(rental_date, date) as Activity,
date_format(convert(rental_date, date), '%m') as Activity_month,
date_format(convert(rental_date,date),'%Y') as Activity_year
from sakila.rental;  #from above

create or replace view sakila.rental_activity_2005 
as 
(select * from sakila.rental_activity
having Activity_year=2005);

create or replace view sakila.rental_activity_2006 
as 
(select * from sakila.rental_activity
having Activity_year=2006);

select distinct Activity_Month from sakila.rental_activity_2005;
select distinct Activity_Month from sakila.rental_activity_2006;

create or replace view sakila.rental_2005_05 as select * from sakila.rental_activity_2005
having Activity_Month=05;

create or replace view sakila.rental_2005_06 as select * from sakila.rental_activity_2005
having Activity_Month=06;

create or replace view sakila.rental_2005_07 as select * from sakila.rental_activity_2005
having Activity_Month=07;

create or replace view sakila.rental_2005_08 as select * from sakila.rental_activity_2005
having Activity_Month=08;

create or replace view sakila.rental_2006_02 as select * from sakila.rental_activity_2006
having Activity_Month=02;



select Max(Ret_Cust_062005) as Ret_Cust_062005,
       Max(Ret_Cust_072005) as Ret_Cust_072005,
       Max(Ret_Cust_082005) as Ret_Cust_082005,
       Max(Ret_Cust_022006) as Ret_Cust_022006 
       from 
       (
select count(June.customer_id) Ret_Cust_062005, Null Ret_Cust_072005, Null Ret_Cust_082005, Null Ret_Cust_022006  
from sakila.rental_2005_06 as June join sakila.rental_2005_05 as May 
using(customer_id)
union 
select Null Ret_Cust_062005, count(June.customer_id) Ret_Cust_072005, Null Ret_Cust_082005, Null Ret_Cust_022006 
 from sakila.rental_2005_06 as June join sakila.rental_2005_07 as July 
 using(customer_id)
union  
select Null Ret_Cust_062005, Null Ret_Cust_072005, count(July.customer_id) Ret_Cust_082005, Null Ret_Cust_022006
from sakila.rental_2005_07 as July join sakila.rental_2005_08 as Aug 
using(customer_id)
union  
select Null Ret_Cust_062005, Null Ret_Cust_072005, Null Ret_Cust_082005, count(Aug.customer_id) Ret_Cust_022006
from sakila.rental_2005_08 as Aug join sakila.rental_2006_02 as Feb 
using(customer_id)
) sub;

 

