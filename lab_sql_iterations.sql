-- Lab | SQL Iterations --

use sakila;

-- 1 Write a query to find what is the total business done by each store.
select s.store_id, round(sum(p.amount),2) as total_business from staff s
join payment p
on s.staff_id = p.staff_id
group by s.store_id;


-- 2 Convert the previous query into a stored procedure.

drop procedure if exists total_business_per_store_proc_1;

delimiter //
create procedure total_business_per_store_proc_1()
begin
	select s.store_id, round(sum(p.amount),2) as total_business from staff s
	join payment p
	on s.staff_id = p.staff_id
	group by s.store_id;
end;
//
delimiter ;

call total_business_per_store_proc_1();


-- 3 Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

drop procedure if exists total_business_per_store_proc_2;

delimiter //
create procedure total_business_per_store_proc_2(in param1 int)
begin
	select s.store_id, round(sum(p.amount),2) as total_business from staff s
	join payment p
	on s.staff_id = p.staff_id
    where s.store_id = param1
	group by s.store_id;
end;
//
delimiter ;

call total_business_per_store_proc_2(1);
call total_business_per_store_proc_2(2);


-- 4 Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store).
-- Call the stored procedure and print the results.

drop procedure if exists total_business_per_store_proc_3;

delimiter //
create procedure total_business_per_store_proc_3(in param1 int, out param2 int, out param3 float)
begin
	declare total_sales_value float default 0.0;
    
	select round(sum(p.amount),2) as total_business into total_sales_value from staff s
	join payment p
	on s.staff_id = p.staff_id
    where s.store_id = param1
    group by param1;
    
    select param1 into param2;
    select total_sales_value into param3;
end;
//
delimiter ;

call total_business_per_store_proc_3(1, @x, @y);
select @x as store_id, round(@y, 2) as total_sales_value;


-- 5 In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
-- Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

drop procedure if exists total_business_per_store_proc_4;

delimiter //
create procedure total_business_per_store_proc_4(in param1 int, out param2 int, out param3 float, out param4 varchar(20))
begin
	declare total_sales_value float default 0.0;
    declare flag varchar(20) default "";
    
	select round(sum(p.amount),2) as total_business into total_sales_value from staff s
	join payment p
	on s.staff_id = p.staff_id
    where s.store_id = param1
	group by param1;
    
    select param1 into param2;
    select total_sales_value into param3;
    
	case
		when total_sales_value > 30000 then
			set flag = 'green';
	  else
			set flag = 'red';
	  end case;
	
    select flag into param4;
end;
//
delimiter ;

call total_business_per_store_proc_4(2, @x, @y, @z);
select @x store_id , round(@y,2) as total_sales_value, @z as flag;
