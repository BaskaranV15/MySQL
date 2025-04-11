DROP DATABASE IF EXISTS `Parks_and_Recreation`;
CREATE DATABASE `Parks_and_Recreation`;
USE `Parks_and_Recreation`;






CREATE TABLE employee_demographics (
  employee_id INT NOT NULL,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  age INT,
  gender VARCHAR(10),
  birth_date DATE,
  PRIMARY KEY (employee_id)
);

CREATE TABLE employee_salary (
  employee_id INT NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  occupation VARCHAR(50),
  salary INT,
  dept_id INT
);


INSERT INTO employee_demographics (employee_id, first_name, last_name, age, gender, birth_date)
VALUES
(1,'Leslie', 'Knope', 44, 'Female','1979-09-25'),
(3,'Tom', 'Haverford', 36, 'Male', '1987-03-04'),
(4, 'April', 'Ludgate', 29, 'Female', '1994-03-27'),
(5, 'Jerry', 'Gergich', 61, 'Male', '1962-08-28'),
(6, 'Donna', 'Meagle', 46, 'Female', '1977-07-30'),
(7, 'Ann', 'Perkins', 35, 'Female', '1988-12-01'),
(8, 'Chris', 'Traeger', 43, 'Male', '1980-11-11'),
(9, 'Ben', 'Wyatt', 38, 'Male', '1985-07-26'),
(10, 'Andy', 'Dwyer', 34, 'Male', '1989-03-25'),
(11, 'Mark', 'Brendanawicz', 40, 'Male', '1983-06-14'),
(12, 'Craig', 'Middlebrooks', 37, 'Male', '1986-07-27');


INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES
(1, 'Leslie', 'Knope', 'Deputy Director of Parks and Recreation', 75000,1),
(2, 'Ron', 'Swanson', 'Director of Parks and Recreation', 70000,1),
(3, 'Tom', 'Haverford', 'Entrepreneur', 50000,1),
(4, 'April', 'Ludgate', 'Assistant to the Director of Parks and Recreation', 25000,1),
(5, 'Jerry', 'Gergich', 'Office Manager', 50000,1),
(6, 'Donna', 'Meagle', 'Office Manager', 60000,1),
(7, 'Ann', 'Perkins', 'Nurse', 55000,4),
(8, 'Chris', 'Traeger', 'City Manager', 90000,3),
(9, 'Ben', 'Wyatt', 'State Auditor', 70000,6),
(10, 'Andy', 'Dwyer', 'Shoe Shiner and Musician', 20000, NULL),
(11, 'Mark', 'Brendanawicz', 'City Planner', 57000, 3),
(12, 'Craig', 'Middlebrooks', 'Parks Director', 65000,1);



CREATE TABLE parks_departments (
  department_id INT NOT NULL AUTO_INCREMENT,
  department_name varchar(50) NOT NULL,
  PRIMARY KEY (department_id)
);

INSERT INTO parks_departments (department_name)
VALUES
('Parks and Recreation'),
('Animal Control'),
('Public Works'),
('Healthcare'),
('Library'),
('Finance');



select * from employee_demographics;
#PEMDAS
select first_name,last_name,age,age+10 as update_age from employee_demographics;

#DESTINCT
select  distinct gender ,age  from employee_demographics;
select * from employee_salary;

#GROUP BY
select count(*) as count_of_employee_by_age,gender from employee_demographics group by gender;

select max(salary),occupation from employee_salary group by occupation;

select  salary,occupation from employee_salary group by occupation ,salary;

select occupation ,min(salary),max(salary),avg(salary),count(*) from employee_salary group by occupation;

select * from employee_demographics where employee_id in (select employee_id from employee_salary where age > 45) and gender='Male';

#ORDER BY
select * from employee_demographics order by age ;
select * from employee_demographics order by gender ,age;
# order by column prescision or position of column
select * from employee_demographics order by 5,4;

#HAVING
select gender ,avg(age) as avg_age from employee_demographics group by gender having avg_age >40;

SELECT 
    occupation, AVG(salary)
FROM
    employee_salary
WHERE
    occupation LIKE '%Manager%'
GROUP BY occupation
HAVING AVG(salary) > 25000
ORDER BY AVG(salary) limit 2;



alter table employee_demographics rename column  emp_id to employee_id;
alter table employee_salary rename column  emp_id to employee_id;

#joins
select * from employee_demographics;
select * from employee_salary;

SELECT  *
FROM
    employee_demographics 
        INNER JOIN
    employee_salary ON employee_demographics.employee_id = employee_salary.employee_id;
    
SELECT  *
FROM
    employee_demographics 
        RIGHT JOIN
    employee_salary ON employee_demographics.employee_id = employee_salary.employee_id;

SELECT  *
FROM
    employee_demographics 
        LEFT JOIN
    employee_salary ON employee_demographics.employee_id = employee_salary.employee_id;
# here we select them using approiate table and using alies name    
SELECT 
    empdem.employee_id,empdem.first_name,empdem.last_name,empdem.age,empdem.gender,empsal.occupation,empsal.salary,empsal.dept_id
FROM
    employee_demographics as empdem
        INNER JOIN
    employee_salary as empsal ON empdem.employee_id = empsal.employee_id;

SELECT 
    empdem.employee_id,empdem.first_name,empdem.last_name,empdem.age,empdem.gender,empsal.occupation,empsal.salary,empsal.dept_id
FROM
    employee_demographics as empdem
        RIGHT JOIN
    employee_salary as empsal ON empdem.employee_id = empsal.employee_id;
    
SELECT 
    empdem.employee_id,empdem.first_name,empdem.last_name,empdem.age,empdem.gender,empsal.occupation,empsal.salary,empsal.dept_id
FROM
    employee_demographics as empdem
        LEFT JOIN
    employee_salary as empsal ON empdem.employee_id = empsal.employee_id;
    
    
SELECT emp1.employee_id as emp_santa, emp1.first_name as santa_first_name, emp1.last_name as santa_last_name, emp2.employee_id, emp2.first_name, emp2.last_name
FROM employee_salary AS emp1
JOIN employee_salary AS emp2
	ON emp1.employee_id + 1  = emp2.employee_id;
    
SELECT *
FROM employee_demographics dem
INNER JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
JOIN parks_departments dept
	ON dept.department_id = sal.dept_id;
    
    
SELECT 
    *
FROM
    employee_demographics AS dem
        INNER JOIN
    employee_salary AS sal ON dem.employee_id = sal.employee_id
        INNER JOIN
    parks_departments AS park ON sal.dept_id = park.department_id;
    
SELECT 
    *
FROM
    employee_demographics dem
        INNER JOIN
    employee_salary sal ON dem.employee_id = sal.employee_id
        LEFT JOIN
    parks_departments dept ON dept.department_id = sal.dept_id;



select employee_id,first_name,last_name from employee_demographics
union 
select employee_id,first_name,last_name from employee_salary ;

select first_name,last_name ,'old_man' as label from employee_demographics where age > 40 and gender ='Male'
union
select first_name,last_name,'old_lady' as label from employee_demographics where age > 40 and gender='Female'
union
select first_name,last_name,'highest_salary' as label from employee_salary where salary>70000
order by first_name,last_name;


#sting function
-- length-- 
select length('baskaran') as length_of_name;
select first_name, length(first_name) as length_of_name from employee_demographics order by length_of_name ;

SELECT 
    first_name,
    last_name,
    LENGTH(first_name) AS len_firstname,
    LENGTH(last_name) AS len_lastname,
    (LENGTH(first_name) + LENGTH(last_name)) AS total_len
FROM
    employee_demographics
WHERE
    (LENGTH(first_name) + LENGTH(last_name)) > 10
ORDER BY total_len;

SELECT 
    first_name,
    last_name,
    CONCAT(first_name, ' ', last_name) AS full_name,
    LENGTH(CONCAT(first_name, ' ', last_name)) AS length_of_name
FROM
    employee_demographics
WHERE
    LENGTH(CONCAT(first_name, ' ', last_name)) > 12;
    
#upper string

select concat((first_name),' ',upper(last_name)) as 'FULL NAME IN CAPS' from employee_demographics;

select TRIM('BASKARAN');

#SUBSTRING
select * FROM employee_demographics;
select employee_id,first_name,last_name,age,gender,birth_date,substr(birth_date,6,2) as 'BIRTH MONTH OF EMPLOYEE' FROM employee_demographics ;

select * FROM employee_demographics;
SELECT 
    FIRST_NAME,
    BIRTH_DATE,
    TIMESTAMPDIFF(year,BIRTH_DATE, CURDATE()) AS age
FROM 
    employee_demographics;


select * from employee_demographics where age between 10 and 35;

#case statement

select first_name,last_name,age,
case 
	when age <= 35 then 'young'
    when age between 36 and 50 then 'old'
    when age >50 then 'very _old'
end as age_list
 from employee_demographics;
 
 select * from employee_salary;    
 
 select first_name,last_name,salary,
 case 
	when salary < 50000 then salary*0.07
    when salary >= 50000 then salary*0.075
 end as increment, 
  case 
	when salary < 50000 then salary+salary*0.07
    when salary >= 50000 then salary+salary*0.075
 end as total_salary_after_increment, 
 case 
	when dept_id=6 then salary*0.10
end as bonus
 from employee_salary;
 
 
 select* from employee_demographics;
 
 select * from employee_salary;
 
 
 #partion by (window function)
 select emdem.first_name,emdem.last_name,emdem.age,emdem.id ,emsal.salary from employee_demographics as emdem
inner join 
 employee_salary as emsal on emdem.employee_id = emsal.employee_id;
 
 
 select gender,avg(salary) from employee_demographics as dem 
 inner join employee_salary as sal
 on dem.employee_id=sal.employee_id group by gender;
 
  select gender,avg(salary) over( partition by gender)
  from employee_demographics as dem 
 inner join employee_salary as sal
 on dem.employee_id=sal.employee_id;
 
  select dem.first_name,dem.last_name, gender,salary,sum(salary) over( partition by gender order by dem.employee_id )
  from employee_demographics as dem 
 inner join employee_salary as sal
 on dem.employee_id=sal.employee_id;
 
   select dem.employee_id,dem.first_name,dem.last_name, gender,salary,
   row_number() over(partition by gender order by salary desc)
  from employee_demographics as dem 
 inner join employee_salary as sal
 on dem.employee_id=sal.employee_id;
 
    select dem.employee_id,dem.first_name,dem.last_name, gender,salary,
   row_number() over(partition by gender order by salary desc),
   rank() over(partition by gender order by salary desc)
  from employee_demographics as dem 
 inner join employee_salary as sal
 on dem.employee_id=sal.employee_id;
 
     select dem.employee_id,dem.first_name,dem.last_name, gender,salary,
   row_number() over(partition by gender order by salary desc),
   rank() over(partition by gender order by salary desc),
   dense_rank() over(partition by gender order by salary desc)
     from employee_demographics as dem 
 inner join employee_salary as sal
 on dem.employee_id=sal.employee_id;
 
 
 #Using Common Table Expressions (CTE)
 with example_cte as
 (
 select gender,avg(salary) as avg_salary ,min(salary)as min_sal,max(salary)as max_sal,count(*) as count_of_eml from employee_demographics as dem
 inner join
 employee_salary sal 
 on dem.employee_id=sal.employee_id 
 group by gender)
 
 select * from example_cte ;
 
 select avg(salary) from employee_salary;
 
 #here to find avg salary from the group
 #Common Table Expression
  with example_cte as
 (
 select gender,avg(salary) as avg_salary ,min(salary)as min_sal,max(salary)as max_sal,count(*) as count_of_eml from employee_demographics as dem
 inner join
 employee_salary sal 
 on dem.employee_id=sal.employee_id 
 group by gender)
 select avg(avg_salary) from example_cte;
 
 WITH CTE_Example AS 
(
SELECT employee_id, gender, birth_date
FROM employee_demographics dem
WHERE birth_date > '1985-01-01'
), -- just have to separate by using a comma
CTE_Example2 AS 
(
SELECT employee_id, salary
FROM parks_and_recreation.employee_salary
WHERE salary >= 50000
)
select * from CTE_Example 
inner join CTE_Example2
on CTE_Example.employee_id =CTE_Example2.employee_id;
 
 
 
 #Temporary Table
CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);

SELECT *
FROM temp_table;

INSERT INTO temp_table
VALUES ('Alex','Freberg','Lord of the Rings: The Twin Towers');


create temporary table salary_over_50k select * from employee_salary where salary >50000;

select * from salary_over_50k;

#	STORE PROCEDURES 


create procedure large_salary() 
select * from employee_salary where salary >60000;

-- drop procedure large_salary;  drop a procedeure-- 
call large_salary();


delimiter $$
create procedure second_large_salary()
begin 
select * from employee_salary where salary >=5000;
select * from employee_salary where salary >= 10000;
end $$
delimiter;


DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 60000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
END $$
-- now we change the delimiter back after we use it to make it default again
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE large_salaries2(id int)
BEGIN
	SELECT *
	FROM employee_salary
	WHERE id=employee_id;
END $$
-- now we change the delimiter back after we use it to make it default again
DELIMITER ;

call large_salaries2(5);



select avg(price) as avgprice from product group by category_id having avgprice<50;




-- Data Control Language

use book;

grant select,insert,update  on book.* to "test1";

revoke select,insert,update on book.* from "test1";



SELECT user, host FROM mysql.user WHERE user = 'test1';


SHOW GRANTS FOR 'test1'@'%';


-- Transaction Control Language

start transaction;
UPDATE transfer SET balance = balance - 1000 WHERE tid = 101;
savepoint debit;
UPDATE transfer SET balance = balance + 1000 WHERE tid = 100;
savepoint credit;
UPDATE transfer SET balance = balance - 1000 WHERE tid in (101,102);
savepoint DEMO;
rollback to DEMO;
commit;

 
