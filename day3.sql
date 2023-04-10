-- Question1
-- 1.	Write a SQL query to find the total salary of employees who is in Tokyo excluding whose first name is Nancy

select sum(salary) from employee_table 
join departments on employee_table.department_id = departments.department_id 
join locations on departments.location_id = locations.location_id
where employee_table.first_name <> 'Nancy' and locations.city = 'Seattle';

-- Question2
-- 2.	 Fetch all details of employees who has salary more than the avg salary by each department.
select * 
from employee_table e 
where e.salary >= (
    select avg(salary)
    from employee_table
    where department_id = e.department_id
);


-- Question3
-- 3.	Write a SQL query to find the number of employees and its location whose salary is greater than or equal to 70000 and less than 100000
select  l.city, count(*) as num_employees
from employee_table e
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
where e.salary >= 7000 and e.salary < 10000
group by l.city, l.state_province;




-- Question4
-- 4.	Fetch max salary, min salary and avg salary by job and department.  Info:  grouped by department id and job id ordered by department id and max salary
select d.department_id,
       max(e.salary) as max_salary,
       min(e.salary) as min_salary,
       avg(e.salary) as avg_salary
from employee_table e
join departments d on e.department_id = d.department_id
join jobs j on e.job_id = j.job_id
group by d.department_id, d.department_name, j.job_id, j.job_title
order by d.department_id, max_salary desc;


-- Question5
-- 5.	Write a SQL query to find the total salary of employees whose country_id is ‘US’ excluding whose first name is Nancy  
select sum(salary) from employee_table et join
departments d on et.department_id = d.department_id
join locations l on l.location_id = d.location_id
where l.country_id = 'US' and et.first_name <> 'Nancy';



-- Question6
-- 6.	Fetch max salary, min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department.
select job_id,department_id ,max(salary), min(salary), avg(salary) from employee_table et where (select count(distinct e.job_id) from employee_table e where e.department_id = et.department_id)>1 group by job_id, department_id ;

-- Question7
-- 7.	Display the employee count in each department and also in the same result the null department count categorized as "-" *
-- Info: * the total employee count categorized as "Total"•	

select ifnull(d.department_name,'-') as department_name, count(e.employee_id) as total
from employee_table e
full outer join departments d on e.department_id = d.department_id
group by d.department_name
order by d.department_name;

-- Question8
-- 8.	Display the jobs held and the employee count. 
-- Hint: every employee is part of at least 1 job 
-- Hint: use the previous questions answer
-- Sample
-- JobsHeld EmpCount
-- 1	100
-- 2	4
with cte as (
select (count(employee_table.job_id)+count(job_history.job_id)) as jobs_held,count(employee_table.employee_id) as EmpCount  from employee_table 
left join job_history on
employee_table.employee_id = job_history.employee_id group by employee_table.employee_id)
select cte.jobs_held, count(cte.empcount) from cte group by cte.jobs_held order by jobs_held;


-- Question9
-- 9.	 Display average salary by department and country.
select d.department_name, l.country_id, avg(e.salary) as avg_salary
from employee_table e
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
where l.country_id is not null
group by d.department_name, l.country_id
order by d.department_name, l.country_id;




-- Question10
-- 10.	Display manager names and the number of employees reporting to them by countries (each employee works for only one department, and each department belongs to a country)
select l.country_id, m.employee_id as manager_id,  count(e.employee_id) as employee_count
from employee_table e
join employee_table m on e.manager_id = m.employee_id
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
group by m.employee_id, l.country_id
order by l.country_id, manager_id;



-- Question11
-- 11.  Group salaries of employees in 4 buckets eg: 0-10000, 10000-20000,.. (Like the previous question) 
-- but now group by department and categorize it like below.
-- Eg : 
-- DEPT ID 0-10000 10000-20000
-- 50          2               10
-- 60          6                5
select d.department_id,
       sum(case when e.salary >= 0 and e.salary < 10000 then 1 else 0 end) as "0-10000",
       sum(case when e.salary >= 10000 and e.salary < 20000 then 1 else 0 end) as "10000-20000",
       sum(case when e.salary >= 30000 then 1 else 0 end) as ">20000"
from employee_table e
join departments d on e.department_id = d.department_id
group by d.department_id;



-- Question12
-- 12.  Display employee count by country and the avg salary 
-- Eg : 
-- Emp Count       Country        Avg Salary
-- 10                     Germany      34242.8
select count(employee_id) as employee_count,countries.country_name, avg(salary) from employee_table 
join departments on departments.department_id = employee_table.department_id
join locations on departments.location_id = locations.location_id 
join countries on locations.country_id = countries.country_id
group by countries.country_name;




-- Question13
-- 13.	 Display region and the number off employees by department
-- Eg : 
-- Dept ID   America   Europe  Asia
-- 10            22               -            -
-- 40             -                 34         -
-- (Please put "-" instead of leaving it NULL or Empty)
select et.department_id as Dept_ID,
       (case when region_name = 'Americas' then employee_count else 0 end) as America,
       sum(case when region_name = 'Europe' then  employee_count else 0 end) as Europe,
       sum(case when region_name = 'Asia' then 1 else 0 end) as Asia
from (
select employee_table.department_id,r.region_name, count(countries.region_id) as employee_count from employee_table
join 
departments d on employee_table.department_id=d.department_id
join 
locations on locations.location_id=d.location_id
join
countries on countries.country_id=locations.country_id
join 
regions r on r.region_id=countries.region_id
group by employee_table.department_id , r.region_name) as et
group by et.region_name,et.department_id,et.employee_count ;

-- Question14
-- 14.  Select the list of all employees who work either for one or more departments or have not yet joined / allocated to any department
select * from employee_table;
 -- (Or)
select *
from employee_table e
left join departments d
on  d.department_id = e.department_id 
where d.department_id is null or e.department_id is not null;

-- Question15
-- 15.	write a SQL query to find the employees and their respective managers. Return the first name, last name of the employees and their managers
select concat(e.first_name,' ',e.last_name) as employee_name, concat(m.first_name,' ',m.last_name) as manager from employee_table e 
join employee_table m
on e.manager_id = m.employee_id;


-- Question16
-- 16.	write a SQL query to display the department name, city, and state province for each department.
select department_name,city,state_province from departments join locations on departments.location_id = locations.location_id;

-- Question17
-- 17.	write a SQL query to list the employees (first_name , last_name, department_name) who belong to a department or don't
select et.first_name, et.last_name, d.department_name from employee_table et join departments d on et.department_id = d.department_id;

-- Question18
-- 18.	The HR decides to make an analysis of the employees working in every department. Help him to determine the salary given in average per department and the total number of employees working in a department.  List the above along with the department id, department name
select departments.department_id, departments.department_name, count(employee_table.employee_id) as num_employees, avg(employee_table.salary) as avg_salary
from departments
left join employee_table on departments.department_id = employee_table.department_id
group by departments.department_id, departments.department_name;


-- Question19
-- 19.	Write a SQL query to combine each row of the employees with each row of the jobs to obtain a consolidated results. (i.e.) Obtain every possible combination of rows from the employees and the jobs relation.
select e.*, j.*
from employee_table e
cross join jobs j;




-- Question20
-- 20.	 Write a query to display first_name, last_name, and email of employees who are from Europe and Asia
select e.first_name, e.last_name, e.email from employee_table e join
departments d on e.department_id = d.department_id 
join locations l on d.location_id = l.location_id 
join countries c on c.country_id = l.country_id
join regions r on c.region_id = r.region_id
where e.department_id = d.department_id
and d.location_id = l.location_id
and l.country_id = c.country_id
and c.region_id = r.region_id
and r.region_name in ('Asia', 'Europe');


-- Question21
-- 21.	 Write a query to display full name with alias as FULL_NAME (Eg: first_name = 'John' and last_name='Henry' - full_name = "John Henry") who are from oxford city and their second last character of their last name is 'e' and are not from finance and shipping department.
select concat(e.first_name,' ',e.last_name) as FULL_NAME from employee_table e
join departments d on d.department_id =e.department_id
join locations l on l.location_id = d.location_id
where l.city = 'Oxford'
and lower(LEFT(RIGHT(E.LAST_NAME,2),1)) = 'e'
and d.department_name not in ('Finance', 'Shipping');

-- Question22
-- 22.  Display the first name and phone number of employees who have less than 50 months of experience
-- doubt
-- whether to consider the job history of the employees ( but job history may vary in departments)
select first_name, phone_number
from employee_table
where datediff(month, hire_date, getdate()) < 50;



-- Question23
-- 23.	 Display Employee id, first_name, last name, hire_date and salary for employees who has the highest salary for each hiring year. (For eg: John and Deepika joined on year 2023,  and john has a salary of 5000, and Deepika has a salary of 6500. Output should show Deepika’s details only).
select e.employee_id, e.first_name, e.last_name, e.hire_date, e.salary
from employee_table e
where e.salary = (
  select max(salary)
  from employee_table
  where year(hire_date) = year(e.hire_date)
) order by hire_date;