-- Question1
-- 1.	Write a SQL query to remove the details of an employee whose first name ends in ‘even’
delete from employee_table where lower(first_name) like '%even';

-- Question2
-- 2.	Write a query in SQL to show the three minimum values of the salary from the table.
select  top 3 salary from employee_table order by salary;
select first_name, salary from employee_table order by salary fetch next 3 rows;

-- Question3
-- 3.	Write a SQL query to copy the details of this table into a new table with table name as Employee table and to delete the records in employees table
create table employee_table as SELECT * from EMPLOYEES;
truncate employees;

select * from employee_table;

-- Question4
-- 4.	Write a SQL query to remove the column Age from the table
alter table employee_table drop column age;

select * from employee_table;

-- Question5
-- 5.	Obtain the list of employees (their full name, email, hire_year) where they have joined the firm before 2000
select concat_ws(' ',first_name,last_name) as full_name, email, year(hire_date) as hire_year from employee_table where hire_year < 2000; 

-- Question6
-- 6.	Fetch the employee_id and job_id of those employees whose start year lies in the range of 1990 and 1999
select employee_id, job_id, year(hire_date) from employee_table where year(hire_date) between 1990 and 1999 order by year(hire_date);


-- Question7
-- 7.	Find the first occurrence of the letter 'A' in each employees Email ID Return the employee_id, email id and the letter position
select employee_id, email, position('A',email) as letter_position from employee_table where email like '%A%';



-- Question8
-- 8.	Fetch the list of employees(Employee_id, full name, email) whose full name holds characters less than 12
select employee_id, concat_ws(' ',first_name,last_name) as full_name from employee_table where length(full_name) <12;

-- Question9
-- 9.	Create a unique string by hyphenating the first name, last name , and email of the employees to obtain a new field named UNQ_ID  Return the employee_id, and their corresponding UNQ_ID;
select employee_id, concat_ws('-',first_name,last_name,email) as UNQ_ID from employee_table;

-- Question10
-- 10.	Write a SQL query to update the size of email column to 30
alter table employee_table modify email varchar(30);

-- Question11
-- Doubt
-- 11.	Write a SQL query to change the location of Diana to London
with londonId as (select location_id from locations where city='London')
update departments
set
departments.location_id = londonId
from 
departments
 join
employee_table 
on
departments.department_id = employee_table.department_id;
where
employee_table.first_name = 'Diana';



-- Question12
-- 12.	Fetch all employees with their first name , email , phone (without extension part) and extension (just the extension)  
-- Info : this mean you need to separate phone into 2 parts 
-- eg: 123.123.1234.12345 => 123.123.1234 and 12345 . first half in phone column and second half in extension column
-- doubt

select first_name, email,
split(phone_number,'.') as number_array,
array_to_string(array_slice(number_array,0,array_size(number_array)-1),'.') as phone_number,
split_part(phone_number,'.',-1) as extension 
from employee_table;

-- Question13
-- 13.	Write a SQL query to find the employee with second and third maximum salary with and without using top/limit keyword
select * from (select employee_id, salary, dense_rank() over(order by salary desc) as salary_rank from employee_table) max_salary where max_salary.salary_rank in (2,3);  

-- Question14
-- 14.  Fetch all details of top 3 highly paid employees who are in department Shipping and IT
select * from employee_table where department_id in (select department_id from departments where department_name in ('IT','Shipping')) order by salary desc limit 3;


-- Question15
-- alter
-- 15.  Display employee id and the positions(jobs) held by that employee (including the current position)

with job_det as (select employee_id, job_id from employee_table union select employee_id, job_id from job_history)
select employee_id, job_title from jobs join job_det on jobs.job_id = job_det.job_id  order by employee_id;



-- Question16
-- 16.	Display Employee first name and date joined as WeekDay, Month Day, Year
-- Eg : 
-- Emp ID      Date Joined
-- 1	Monday, June 21st, 1999

select employee_id, concat_ws(', ',dayname(hire_date),concat_ws(' ',monthname(hire_date), concat(day(hire_date),
CASE
    WHEN day(hire_date) >10 and day(hire_date) < 21 THEN 'th'
    WHEN endswith(day(hire_date),'1') THEN 'st'
    WHEN endswith(day(hire_date),'2') THEN 'nd'
    WHEN endswith(day(hire_date),'3') THEN 'rd'
    ELSE 'th'
END)),year(hire_date)) as Date_Joined  from employee_table;

-- Question17
-- 17.	The company holds a new job opening for Data Engineer (DT_ENGG) with a minimum salary of 12,000 and maximum salary of 30,000 .  
-- The job position might be removed based on market trends (so, save the changes).
--  - Later, update the maximum salary to 40,000 .
-- - Save the entries as well.
-- -  Now, revert back the changes to the initial state, where the salary was 30,000


ALTER SESSION SET autocommit = false;

INSERT INTO jobs VALUES (
    'DT_ENGG',
    'Data Engineer',
    12000,
    30000 );

commit;

select * from jobs;


update jobs set max_salary = 40000 where job_id = 'DT_ENGG';
rollback;

select * from jobs;

ALTER SESSION SET autocommit = true;

-- Question18
-- 18.	Find the average salary of all the employees who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals
select round(avg(salary),3) as avg_salary from employee_table where hire_date between '1996-1-8' and '2000-1-1';


-- Question19
-- Display  Australia, Asia, Antarctica, Europe along with the regions in the region table (Note: Do not insert data into the table)
-- A. Display all the regions
-- B. Display all the unique regions

select region_name from regions union all select 'Australia' union all select 'Asia' union all select 'Antartica' union all select 'Europe';


select region_name from regions union select 'Australia' union select 'Asia' union select 'Antartica' union select 'Europe';

-- Question20
-- 20.	Write a SQL query to remove the employees table from the database
drop table employees;