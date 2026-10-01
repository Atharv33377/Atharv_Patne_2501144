create database company_sql_test;
use company_sql_test;

create table departments (dept_id int primary key,dept_name varchar(100) Not null,location varchar(100));
insert into departments (dept_id,dept_name,location) values
(1,'IT','Pune'),
(2,'HR','Pune'),
(3,'Sales','Mumbai'),
(4,'Marketing','Mumbai'),
(5,'Finance','Nashik');


create table employees(emp_id int primary key,emp_name varchar(100),dept_id int,hire_date date,salary decimal(10,2),foreign key(dept_id) references departments(dept_id));
INSERT INTO employees (emp_id, emp_name,dept_id, hire_date, salary) VALUES
(101, 'Alice Johnson', 1, '2022-01-15', 60000),
(102, 'Bob Smith', 1, '2023-03-10', 55000),
(103, 'Charlie Brown', 2, '2021-07-01', 50000),
(104, 'Diana Prince', 3, '2020-11-20', 70000),
(105, 'Ethan Hunt', 3, '2024-05-05', 65000),
(106, 'Fiona Clark', 1, '2023-08-12', 48000),
(107, 'George Miller', 2, '2022-09-25', 52000),
(108, 'Hannah Lee', 4, '2021-12-01', 58000),
(109, 'Ian Wright', 4, '2023-02-14', 61000),
(110, 'Julia Davis', 1, '2024-06-18', 54000);

alter table employees add  email varchar(100);

UPDATE Employees
SET email = CASE emp_id
    WHEN 101 THEN 'alice.johnson@company.com'
    WHEN 102 THEN 'bob.smith@company.com'
    WHEN 103 THEN 'charlie.brown@company.com'
    WHEN 104 THEN 'diana.prince@company.com'
    WHEN 105 THEN 'ethan.hunt@company.com'
    WHEN 106 THEN 'fiona.clark@company.com'
    WHEN 107 THEN 'george.miller@company.com'
    WHEN 108 THEN 'hannah.lee@company.com'
    WHEN 109 THEN 'ian.wright@company.com'
    WHEN 110 THEN 'julia.davis@company.com'
END;

alter table employees add  status varchar(100);
UPDATE Employees SET status = 'On Leave'
WHERE emp_id = 103;

select * from employees  where salary >50000 and salary<90000 order by salary desc;

select emp_id,emp_name from employees where emp_name like 'A%' or emp_name like '%r%';

select d.dept_name,count(e.emp_id) as employee_count from departments d left join employees e on d.dept_id=e.dept_id group by dept_name;
 
select d.dept_name,avg(e.salary) as avg_salary from departments d join employees e on d.dept_id=e.dept_id 
group by dept_name having avg_salary>7000;

select e.emp_name,d.dept_name,d.location,e.salary from employees e inner join departments d on d.dept_id=e.dept_id;

select emp_name,salary from employees where salary>(select avg(salary) as avg_salary from employees);

select e.emp_name,e.salary,d.dept_name from employees e join departments d on d.dept_id=e.dept_id 
where e.salary>(select avg(e2.salary) as avg_salary from employees e2 where e.dept_id=e2.dept_id) ;


select d.dept_id,d.dept_name from departments d where exists(select 1 from employees e where e.dept_id= d.dept_id );

select d.dept_id,d.dept_name from departments d where not exists(select 1 from employees e where e.dept_id= d.dept_id );

select e.emp_name,e.salary,dense_rank()over(partition by e.dept_id order by salary desc) as salary_rank
from employees e join departments d on d.dept_id and e.dept_id; 

SELECT e.emp_name, e.salary, d.dept_name
FROM (
    SELECT e.*, 
           dense_rank() OVER (
               PARTITION BY e.dept_id
               ORDER BY e.salary DESC
           ) AS salary_rank
    FROM employees e
) ranked
JOIN departments d 
     ON d.dept_id = ranked.dept_id
WHERE ranked.salary_rank <= 2;
