/*Swiggy Case Study*/
/* Customers who have never ordered*/
select distinct name from users$
select name from users$ where user_id Not in (select user_id from orders$);
/*Average Price per Dish*/
select f.f_name,Avg(price) as 'Average Price' from menu$ m Join food$ f on m.f_id=f.f_id
group by f.f_name
order by [Average Price] desc
/*Find top restaurant in terms of number of orders for a given month*/
select*, format(date,'MMMM') as Month 
from orders$ 
where format(date,'MMMM') like 'June'
select r_id,count(*)  as Month 
from orders$ 
where format(date,'MMMM') like 'June'
group by r_id
select top 1 r_id,count(*)  as Month 
from orders$ 
where format(date,'MMMM') like 'June'
group by r_id
order by count(*) desc
--
select top 1 r.r_name,count(*)  as Month 
from orders$ o
join restaurants$ r on o.r_id=r.r_id
where format(date,'MMMM') like 'June'
group by r.r_name
order by count(*) desc
/*Which restaurant have a sales>x for a month of june*/
select r.r_name,Sum(amount)as 'Revenue' from [dbo].[orders$] o join [dbo].[restaurants$] r 
on r.r_id=o.r_id
where format(date,'MMMM') like 'June' 
group by r.r_name
having sum(amount)>=500
/*Show all orders with order details for a particular customer in a particular date range*/
select * from orders$ 
where user_id=(select user_id from users$ where name like 'Ankit')
 and (date>'2022-06-10' and date<'2022-07-10')

 select o.order_id,r_name   from orders$ o
 join restaurants$ r on r.r_id=o.r_id
where user_id=(select user_id from users$ where name like 'Ankit')
 and (date>'2022-06-10' and date<'2022-07-10')

 select o.order_id,r_name,od.f_id  from orders$ o
 join restaurants$ r on r.r_id=o.r_id
 join order_details$ od
 on o.order_id=od.order_id
where user_id=(select user_id from users$ where name like 'Ankit')
 and (date>'2022-06-10' and date<'2022-07-10')

 select o.order_id,r_name,f.f_name  from orders$ o
 join restaurants$ r on r.r_id=o.r_id
 join order_details$ od
 on o.order_id=od.order_id
 join food$ f
 on od.f_id=f.f_id
where user_id=(select user_id from users$ where name like 'Ankit')
 and (date>'2022-06-10' and date<'2022-07-10')
 /*Find Restaurant with max repeated customers*/
 select user_id,r_id,count(*) as 'visits' from orders$ 
 group by r_id,user_id
 having count(*)>1
 order by r_id

 select top 1 r.r_name,count(*) as 'Loyal customer'
 from
 (
    select user_id,r_id,count(*) as 'visits' from orders$ 
    group by r_id,user_id
    having count(*)>1
    
	)t
	join restaurants$ r
	on r.r_id=t.r_id
	group by r.r_name
	order by count(*) desc
/*Month over month revenue growth of swiggy*/
select month,((revenue-prev)/prev)*100 from 
(
 with sales as 
(select sum(amount) as 'revenue',format(date,'MMMM') as 'Month'  from [dbo].[orders$]
group by format(date,'MMMM'))
select month,revenue,lag(revenue,1) over(order by revenue) as prev from sales)t
