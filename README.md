# MySQL



# 🗃️ SQL Quick Reference Guide
### Based on Parks & Recreation Database

> A practical reference covering core SQL concepts with real-world analogies and ready-to-use queries.

---

## 📦 Database Setup

```sql
DROP DATABASE IF EXISTS Parks_and_Recreation;
CREATE DATABASE Parks_and_Recreation;
USE Parks_and_Recreation;
```

### Tables at a Glance

| Table | Key Columns |
|-------|------------|
| `employee_demographics` | employee_id, first_name, last_name, age, gender, birth_date |
| `employee_salary` | employee_id, first_name, last_name, occupation, salary, dept_id |
| `parks_departments` | department_id, department_name |

---

## 1. SELECT & PEMDAS (Arithmetic)

### 📖 Concept
SQL follows standard math order of operations. You can compute new values directly in a SELECT — perfect for on-the-fly calculations without changing the data.

### 🌍 Real-World Scenario
HR wants to preview what salaries would look like after a flat ₹10 raise for planning purposes.

```sql
-- Basic select with arithmetic
SELECT first_name, last_name, age, age + 10 AS updated_age
FROM employee_demographics;
```

---

## 2. DISTINCT

### 📖 Concept
Removes duplicate rows from results. Useful when you want unique combinations of values.

### 🌍 Real-World Scenario
You want a list of all unique gender-age combinations present in your workforce — no repeats.

```sql
SELECT DISTINCT gender, age
FROM employee_demographics;
```

---

## 3. WHERE & Filtering

### 📖 Concept
Filters rows before grouping or aggregation. Think of it as a gatekeeper — only matching rows move forward.

### 🌍 Real-World Scenario
Find all male employees above retirement age (45+) from the salary data.

```sql
SELECT *
FROM employee_demographics
WHERE employee_id IN (
    SELECT employee_id FROM employee_salary WHERE age > 45
)
AND gender = 'Male';
```

---

## 4. GROUP BY & Aggregate Functions

### 📖 Concept
Groups rows sharing a value so you can apply aggregate functions (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`) to each group.

### 🌍 Real-World Scenario
Management wants a salary summary per job role — minimum, maximum, and average pay for each occupation.

```sql
SELECT occupation, MIN(salary), MAX(salary), AVG(salary), COUNT(*)
FROM employee_salary
GROUP BY occupation;
```

```sql
-- Count employees by gender
SELECT gender, COUNT(*) AS employee_count
FROM employee_demographics
GROUP BY gender;
```

---

## 5. HAVING

### 📖 Concept
Filters **after** grouping — unlike WHERE which filters before. Use HAVING when your condition involves an aggregate value.

> 🔑 Rule of thumb: `WHERE` = filter rows → `HAVING` = filter groups

### 🌍 Real-World Scenario
Find departments where the average employee age is above 40 (to flag teams nearing retirement age).

```sql
SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;
```

```sql
-- Managers earning above average
SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%Manager%'
GROUP BY occupation
HAVING AVG(salary) > 25000
ORDER BY AVG(salary)
LIMIT 2;
```

---

## 6. ORDER BY

### 📖 Concept
Sorts the final result set. Default is ascending (`ASC`). Use `DESC` for descending. You can also sort by column position number.

### 🌍 Real-World Scenario
Display a directory sorted alphabetically by gender first, then by age within each gender group.

```sql
SELECT * FROM employee_demographics ORDER BY gender, age;

-- Using column position (5 = gender, 4 = birth_date)
SELECT * FROM employee_demographics ORDER BY 5, 4;
```

---

## 7. JOINS

### 📖 Concept
Combines rows from two or more tables based on a related column.

| Join Type | Returns |
|-----------|---------|
| `INNER JOIN` | Only matching rows in **both** tables |
| `LEFT JOIN` | All rows from left table + matches from right |
| `RIGHT JOIN` | All rows from right table + matches from left |
| `SELF JOIN` | A table joined to itself |

### 🌍 Real-World Scenario
Payroll needs a combined report: employee personal info + their salary + their department name.

```sql
-- INNER JOIN: Only employees present in both tables
SELECT empdem.employee_id, empdem.first_name, empdem.last_name,
       empdem.age, empdem.gender, empsal.occupation, empsal.salary
FROM employee_demographics AS empdem
INNER JOIN employee_salary AS empsal
    ON empdem.employee_id = empsal.employee_id;
```

```sql
-- LEFT JOIN: All demographics, even if no salary record
SELECT empdem.first_name, empsal.occupation, empsal.salary
FROM employee_demographics AS empdem
LEFT JOIN employee_salary AS empsal
    ON empdem.employee_id = empsal.employee_id;
```

```sql
-- Three-table JOIN: demographics + salary + department
SELECT *
FROM employee_demographics dem
INNER JOIN employee_salary sal  ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments dept ON sal.dept_id = dept.department_id;
```

```sql
-- SELF JOIN: Assign "Secret Santa" — each person gives to the next employee
SELECT emp1.employee_id AS giver_id, emp1.first_name AS giver,
       emp2.employee_id AS receiver_id, emp2.first_name AS receiver
FROM employee_salary AS emp1
JOIN employee_salary AS emp2
    ON emp1.employee_id + 1 = emp2.employee_id;
```

---

## 8. UNION

### 📖 Concept
Stacks result sets from multiple SELECT queries vertically. `UNION` removes duplicates; `UNION ALL` keeps them. All queries must have the same number of columns and compatible types.

### 🌍 Real-World Scenario
Generate a categorized employee list — tag each person as 'Young', 'Old', or 'High Earner' in one report.

```sql
SELECT first_name, last_name, 'Old Man'       AS label FROM employee_demographics WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old Lady'      AS label FROM employee_demographics WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'High Earner'   AS label FROM employee_salary      WHERE salary > 70000
ORDER BY first_name, last_name;
```

---

## 9. String Functions

### 📖 Concept
Built-in functions to manipulate text data — clean, format, extract, or measure strings.

| Function | Purpose |
|----------|---------|
| `LENGTH()` | Character count of a string |
| `CONCAT()` | Join strings together |
| `UPPER()` / `LOWER()` | Change case |
| `TRIM()` | Remove leading/trailing spaces |
| `SUBSTR(str, start, len)` | Extract a substring |

### 🌍 Real-World Scenario
Format a name badge display and extract birth month for birthday celebrations.

```sql
-- Full name in uppercase last name
SELECT CONCAT(first_name, ' ', UPPER(last_name)) AS full_name_display
FROM employee_demographics;
```

```sql
-- Extract birth month from birth_date
SELECT employee_id, first_name, last_name,
       SUBSTR(birth_date, 6, 2) AS birth_month
FROM employee_demographics;
```

```sql
-- Find employees whose full name exceeds 12 characters
SELECT first_name, last_name,
       CONCAT(first_name, ' ', last_name) AS full_name,
       LENGTH(CONCAT(first_name, ' ', last_name)) AS name_length
FROM employee_demographics
WHERE LENGTH(CONCAT(first_name, ' ', last_name)) > 12;
```

```sql
-- Real-time age calculation using TIMESTAMPDIFF
SELECT first_name, birth_date,
       TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS current_age
FROM employee_demographics;
```

---

## 10. CASE Statement

### 📖 Concept
Conditional logic inside a query — like an `if-else` in programming. Returns different values based on conditions.

### 🌍 Real-World Scenario
Categorize employees by age bracket for HR reporting, and calculate tiered salary increments.

```sql
-- Age categorization
SELECT first_name, last_name, age,
    CASE
        WHEN age <= 35             THEN 'Young'
        WHEN age BETWEEN 36 AND 50 THEN 'Mid-Career'
        WHEN age > 50              THEN 'Senior'
    END AS career_stage
FROM employee_demographics;
```

```sql
-- Tiered salary increment + Finance department bonus
SELECT first_name, last_name, salary,
    CASE
        WHEN salary < 50000  THEN salary * 0.07
        WHEN salary >= 50000 THEN salary * 0.075
    END AS increment,
    CASE
        WHEN salary < 50000  THEN salary + salary * 0.07
        WHEN salary >= 50000 THEN salary + salary * 0.075
    END AS total_after_increment,
    CASE
        WHEN dept_id = 6 THEN salary * 0.10
    END AS finance_bonus
FROM employee_salary;
```

---

## 11. Window Functions (PARTITION BY)

### 📖 Concept
Perform calculations **across a set of rows** related to the current row — without collapsing them like GROUP BY does. You keep all individual rows AND get the aggregate side by side.

| Function | Behaviour |
|----------|-----------|
| `AVG() OVER(PARTITION BY ...)` | Rolling average per group |
| `SUM() OVER(PARTITION BY ... ORDER BY ...)` | Running total per group |
| `ROW_NUMBER()` | Unique sequential rank |
| `RANK()` | Rank with gaps on ties |
| `DENSE_RANK()` | Rank without gaps on ties |

### 🌍 Real-World Scenario
Show each employee's salary alongside the average salary for their gender group — without losing individual rows.

```sql
-- Average salary per gender shown on every row
SELECT dem.first_name, dem.last_name, gender, salary,
       AVG(salary) OVER(PARTITION BY gender) AS gender_avg_salary
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal ON dem.employee_id = sal.employee_id;
```

```sql
-- Running salary total per gender (ordered by employee ID)
SELECT dem.first_name, dem.last_name, gender, salary,
       SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS running_total
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal ON dem.employee_id = sal.employee_id;
```

```sql
-- Rank employees by salary within their gender
SELECT dem.first_name, dem.last_name, gender, salary,
       ROW_NUMBER()  OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
       RANK()        OVER(PARTITION BY gender ORDER BY salary DESC) AS rnk,
       DENSE_RANK()  OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rnk
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal ON dem.employee_id = sal.employee_id;
```

> **ROW_NUMBER vs RANK vs DENSE_RANK example (tied salary = 70000):**
> - ROW_NUMBER: 1, 2, 3 (always unique)
> - RANK:       1, 1, 3 (skips 2)
> - DENSE_RANK: 1, 1, 2 (no skip)

---

## 12. Common Table Expressions (CTE)

### 📖 Concept
A named temporary result set defined with `WITH`. Acts like a readable sub-query you can reference multiple times in the main query. Great for breaking complex logic into readable steps.

### 🌍 Real-World Scenario
Calculate the overall average of average salaries by gender (a two-step aggregation that's impossible in one GROUP BY).

```sql
-- Step 1: Summarize by gender, Step 2: Average those summaries
WITH gender_salary_summary AS (
    SELECT gender,
           AVG(salary) AS avg_salary,
           MIN(salary) AS min_sal,
           MAX(salary) AS max_sal,
           COUNT(*)    AS employee_count
    FROM employee_demographics AS dem
    INNER JOIN employee_salary AS sal ON dem.employee_id = sal.employee_id
    GROUP BY gender
)
SELECT AVG(avg_salary) AS overall_avg_of_group_averages
FROM gender_salary_summary;
```

```sql
-- Multiple CTEs: chain them with a comma
WITH young_employees AS (
    SELECT employee_id, gender, birth_date
    FROM employee_demographics
    WHERE birth_date > '1985-01-01'
),
well_paid AS (
    SELECT employee_id, salary
    FROM employee_salary
    WHERE salary >= 50000
)
SELECT *
FROM young_employees
INNER JOIN well_paid ON young_employees.employee_id = well_paid.employee_id;
```

---

## 13. Temporary Tables

### 📖 Concept
A table that exists only for the current session. Automatically dropped when the connection closes. Useful for staging intermediate results in multi-step processing.

### 🌍 Real-World Scenario
Store high earners mid-report so downstream queries don't re-scan the full table.

```sql
-- Create and populate a temp table from a query
CREATE TEMPORARY TABLE salary_over_50k
SELECT * FROM employee_salary WHERE salary > 50000;

SELECT * FROM salary_over_50k;
```

```sql
-- Manually defined temp table
CREATE TEMPORARY TABLE temp_table (
    first_name     VARCHAR(50),
    last_name      VARCHAR(50),
    favorite_movie VARCHAR(100)
);

INSERT INTO temp_table VALUES ('Alex', 'Freberg', 'Lord of the Rings');
SELECT * FROM temp_table;
```

---

## 14. Stored Procedures

### 📖 Concept
A saved, named SQL block that can be executed on demand with `CALL`. Supports parameters, multiple statements, and reusability — like a function in programming.

### 🌍 Real-World Scenario
Finance team regularly needs salary reports; wrap the query in a procedure so anyone can run it without knowing SQL.

```sql
-- Simple procedure (no parameters)
CREATE PROCEDURE high_earners()
SELECT * FROM employee_salary WHERE salary > 60000;

CALL high_earners();
```

```sql
-- Procedure with a parameter
DELIMITER $$
CREATE PROCEDURE get_employee_by_id(id INT)
BEGIN
    SELECT * FROM employee_salary WHERE employee_id = id;
END $$
DELIMITER ;

CALL get_employee_by_id(5);
```

```sql
-- Multi-statement procedure
DELIMITER $$
CREATE PROCEDURE salary_tiers()
BEGIN
    SELECT * FROM employee_salary WHERE salary >= 60000;
    SELECT * FROM employee_salary WHERE salary >= 50000;
END $$
DELIMITER ;
```

> **Tip:** Use `DROP PROCEDURE procedure_name;` to remove a procedure before recreating it.

---

## 15. DCL — Data Control Language

### 📖 Concept
Controls **who** can do **what** in the database. `GRANT` gives permissions; `REVOKE` takes them away.

### 🌍 Real-World Scenario
A new analyst joins — give them read/write access to the book database, but not DELETE or DROP.

```sql
-- Grant specific permissions
GRANT SELECT, INSERT, UPDATE ON book.* TO 'test1';

-- Remove permissions
REVOKE SELECT, INSERT, UPDATE ON book.* FROM 'test1';

-- Audit: check a user's current privileges
SHOW GRANTS FOR 'test1'@'%';
```

---

## 16. TCL — Transaction Control Language

### 📖 Concept
Groups SQL operations into **atomic units**. Either all succeed or all roll back — protecting data integrity.

| Command | Purpose |
|---------|---------|
| `START TRANSACTION` | Begin a transaction block |
| `SAVEPOINT name` | Create a rollback checkpoint |
| `ROLLBACK TO name` | Undo back to a savepoint |
| `COMMIT` | Permanently save all changes |

### 🌍 Real-World Scenario
Bank transfer: debit one account and credit another. If the credit fails, roll back the debit too.

```sql
START TRANSACTION;

UPDATE transfer SET balance = balance - 1000 WHERE tid = 101;  -- Debit
SAVEPOINT debit_done;

UPDATE transfer SET balance = balance + 1000 WHERE tid = 100;  -- Credit
SAVEPOINT credit_done;

-- Something went wrong — roll back to just after the debit
ROLLBACK TO debit_done;

COMMIT;  -- Save whatever state we ended at
```

---

## 🔖 Cheat Sheet: Clause Execution Order

```
FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT
```

> SQL processes clauses in this order internally — understanding this explains why you can't use a SELECT alias in a WHERE clause, but you can in ORDER BY.

---

## 🔖 Quick Comparison: GROUP BY vs PARTITION BY

| Feature | GROUP BY | PARTITION BY (Window) |
|---------|----------|-----------------------|
| Collapses rows | ✅ Yes | ❌ No |
| Shows individual rows | ❌ No | ✅ Yes |
| Use with aggregates | ✅ Yes | ✅ Yes |
| Requires `OVER()` | ❌ No | ✅ Yes |

---

*Reference built from Parks and Recreation database practice scripts.*
