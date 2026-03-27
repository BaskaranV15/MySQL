# 🧠 SQL Complete Roadmap — Beginner to Advanced
### MySQL | Interview Prep | Real-World Projects
> Written from the perspective of a Senior SQL Engineer & Interview Coach.
> Goal: Crack TCS, Infosys, and Product Company SQL rounds with confidence.

---

## 📌 Sample Tables Used Throughout This Guide

```sql
-- We'll use these three tables in all examples
CREATE TABLE employee (
  emp_id    INT PRIMARY KEY,
  name      VARCHAR(50),
  age       INT,
  gender    VARCHAR(10),
  dept_id   INT,
  hire_date DATE
);

CREATE TABLE salary (
  emp_id     INT,
  occupation VARCHAR(50),
  amount     INT,
  FOREIGN KEY (emp_id) REFERENCES employee(emp_id)
);

CREATE TABLE department (
  dept_id   INT PRIMARY KEY,
  dept_name VARCHAR(50)
);

INSERT INTO department VALUES (1,'Engineering'),(2,'HR'),(3,'Finance'),(4,'Marketing');

INSERT INTO employee VALUES
(1,'Alice',30,'Female',1,'2020-03-15'),
(2,'Bob',35,'Male',2,'2018-07-01'),
(3,'Carol',28,'Female',1,'2021-11-20'),
(4,'David',42,'Male',3,'2015-05-10'),
(5,'Eve',25,'Female',4,'2023-01-05'),
(6,'Frank',38,'Male',2,'2017-09-18');

INSERT INTO salary VALUES
(1,'Software Engineer',85000),
(2,'HR Manager',60000),
(3,'Junior Developer',55000),
(4,'Finance Head',95000),
(5,'Marketing Exec',48000),
(6,'HR Executive',52000);
```

---

# 🔹 SECTION 1: BASICS

---

## 1.1 What is SQL, DBMS, RDBMS

### 💡 Simple Explanation
- **SQL (Structured Query Language):** The language you use to talk to a database — ask for data, add data, update or delete it.
- **DBMS (Database Management System):** Software that manages databases. Examples: MySQL, MongoDB, SQLite.
- **RDBMS (Relational DBMS):** A DBMS where data is stored in **tables with relationships** between them. MySQL, PostgreSQL, and Oracle are RDBMS.

### 🏭 Real-World Use Case
Every time you log into Swiggy and see your past orders — that data is fetched using SQL from a relational database. Your order history, address, and payment info are stored in separate related tables.

### 🎯 Key Interview Points
- SQL is **not** a programming language — it's a **query language**
- RDBMS enforces relationships between tables using **keys**
- Every RDBMS is a DBMS, but not every DBMS is an RDBMS (MongoDB is a DBMS but not RDBMS)

### ⚠️ Common Mistakes
- Saying "SQL is a programming language" — it's a query language
- Confusing DBMS and RDBMS — the key difference is **relational tables and foreign keys**

---

## 1.2 Types of SQL Commands

### 💡 Simple Explanation
SQL commands are grouped into 5 categories based on what they do:

| Category | Full Name | Purpose | Commands |
|----------|-----------|---------|----------|
| DDL | Data Definition Language | Define/change structure | CREATE, ALTER, DROP, TRUNCATE |
| DML | Data Manipulation Language | Work with data | SELECT, INSERT, UPDATE, DELETE |
| DCL | Data Control Language | Manage permissions | GRANT, REVOKE |
| TCL | Transaction Control Language | Manage transactions | COMMIT, ROLLBACK, SAVEPOINT |
| DQL | Data Query Language | Retrieve data | SELECT |

> Note: In most interviews SELECT is classified under DML or DQL. Both answers are acceptable.

### 🏭 Real-World Use Case
When a developer adds a new `phone_number` column to the users table → that's **DDL (ALTER)**.
When a user updates their profile → that's **DML (UPDATE)**.
When a new DBA account is created with read-only access → that's **DCL (GRANT)**.

### 🎯 Key Interview Points
- DDL commands are **auto-committed** — you cannot rollback a `DROP` or `TRUNCATE`
- DML commands can be **rolled back** within a transaction
- TRUNCATE is DDL; DELETE is DML — this is a classic trick question

### ⚠️ Common Mistakes
- Saying TRUNCATE can be rolled back (it cannot in MySQL)
- Forgetting that DROP removes the entire table structure, not just data

---

## 1.3 CREATE, INSERT, SELECT

### 💡 Simple Explanation
- `CREATE` — builds the table structure (the blueprint)
- `INSERT` — adds rows of data into the table
- `SELECT` — retrieves data from the table

### 🏭 Real-World Use Case
An HR system creates an employee table, inserts new hires, and selects employee records when HR logs in.

```sql
-- CREATE a table
CREATE TABLE employee (
  emp_id  INT PRIMARY KEY,
  name    VARCHAR(50),
  age     INT,
  dept_id INT
);

-- INSERT data
INSERT INTO employee VALUES (1, 'Alice', 30, 1);
INSERT INTO employee VALUES (2, 'Bob', 35, 2);

-- SELECT all data
SELECT * FROM employee;

-- SELECT specific columns
SELECT name, age FROM employee;

-- SELECT with a condition
SELECT name FROM employee WHERE age > 30;
```

### 🎯 Key Interview Points
- `SELECT *` is convenient but bad in production — always specify column names
- `PRIMARY KEY` automatically creates an index
- `VARCHAR(50)` stores up to 50 characters; `CHAR(50)` always uses exactly 50

### ⚠️ Common Mistakes
- Inserting data without matching column order and forgetting to specify columns
- Using `SELECT *` in production queries — it's slow and fragile

---

## 1.4 WHERE, AND, OR, NOT

### 💡 Simple Explanation
`WHERE` filters rows. `AND`, `OR`, `NOT` combine multiple conditions.
- `AND` — both conditions must be true
- `OR` — at least one condition must be true
- `NOT` — reverses the condition

### 🏭 Real-World Use Case
An e-commerce company wants to find female customers aged above 25 from the Engineering department for a targeted campaign.

```sql
-- AND: both conditions true
SELECT name, age FROM employee
WHERE age > 30 AND gender = 'Male';

-- OR: either condition true
SELECT name FROM employee
WHERE dept_id = 1 OR dept_id = 2;

-- NOT: exclude a condition
SELECT name FROM employee
WHERE NOT dept_id = 3;

-- Combining all three (use brackets to control precedence)
SELECT name FROM employee
WHERE (dept_id = 1 OR dept_id = 2) AND age < 35;
```

### 🎯 Key Interview Points
- `AND` has higher precedence than `OR` — always use parentheses when mixing them
- `NOT IN` is cleaner than multiple `AND` conditions
- `BETWEEN` is equivalent to `>= AND <=`

### ⚠️ Common Mistakes
```sql
-- WRONG: AND has higher precedence — reads as dept=1 OR (dept=2 AND age<30)
WHERE dept_id = 1 OR dept_id = 2 AND age < 30;

-- CORRECT: use parentheses to clarify intent
WHERE (dept_id = 1 OR dept_id = 2) AND age < 30;
```

---

## 1.5 ORDER BY & LIMIT

### 💡 Simple Explanation
- `ORDER BY` sorts the result — ascending (`ASC`) by default, use `DESC` for descending
- `LIMIT` restricts how many rows are returned

### 🏭 Real-World Use Case
A finance dashboard needs the top 3 highest-paid employees to display on a leaderboard.

```sql
-- Sort by age ascending (default)
SELECT name, age FROM employee ORDER BY age;

-- Sort by age descending
SELECT name, age FROM employee ORDER BY age DESC;

-- Sort by multiple columns: gender first, then age
SELECT name, gender, age FROM employee ORDER BY gender, age DESC;

-- Top 3 highest salaries
SELECT name, amount FROM salary ORDER BY amount DESC LIMIT 3;

-- OFFSET: skip first 3, show next 3 (pagination)
SELECT name, amount FROM salary ORDER BY amount DESC LIMIT 3 OFFSET 3;
```

### 🎯 Key Interview Points
- `LIMIT` is MySQL syntax — SQL Server uses `TOP`, Oracle uses `ROWNUM`
- `LIMIT n OFFSET m` is the standard way to implement **pagination**
- `ORDER BY` runs near the end of execution — after `SELECT`, so aliases work here

### ⚠️ Common Mistakes
- Forgetting that without `ORDER BY`, the row order is **not guaranteed**
- Using `LIMIT` without `ORDER BY` for "top N" queries — results are unpredictable

---

# 🔹 SECTION 2: INTERMEDIATE

---

## 2.1 DISTINCT

### 💡 Simple Explanation
`DISTINCT` removes duplicate rows from your result. It applies to the **combination of all selected columns**.

### 🏭 Real-World Use Case
An analyst wants to know which departments currently have employees — no duplicates.

```sql
-- Unique departments that have employees
SELECT DISTINCT dept_id FROM employee;

-- Unique gender values
SELECT DISTINCT gender FROM employee;

-- DISTINCT on multiple columns: unique gender + dept combinations
SELECT DISTINCT gender, dept_id FROM employee;
```

### 🎯 Key Interview Points
- `DISTINCT` works on the **entire row of selected columns**, not just the first column
- `COUNT(DISTINCT column)` counts unique non-NULL values — very common in interviews
- `DISTINCT` is slower than a regular SELECT because it requires sorting/hashing

### ⚠️ Common Mistakes
```sql
-- Misconception: thinks DISTINCT applies only to name
SELECT DISTINCT name, dept_id FROM employee;
-- This gives unique (name, dept_id) pairs — not just unique names
```

---

## 2.2 GROUP BY

### 💡 Simple Explanation
`GROUP BY` collapses rows that share the same value into a **single group** so you can apply aggregate functions to each group.

### 🏭 Real-World Use Case
HR wants a count of employees in each department for a headcount report.

```sql
-- Count employees per department
SELECT dept_id, COUNT(*) AS employee_count
FROM employee
GROUP BY dept_id;

-- Average salary per occupation
SELECT occupation, AVG(amount) AS avg_salary
FROM salary
GROUP BY occupation;

-- Group by multiple columns
SELECT gender, dept_id, COUNT(*) AS count
FROM employee
GROUP BY gender, dept_id;
```

### 🎯 Key Interview Points
- Every column in `SELECT` must either be in `GROUP BY` or inside an aggregate function
- `GROUP BY` comes **before** `HAVING` and **after** `WHERE` in execution order
- `NULL` values are grouped together in `GROUP BY`

### ⚠️ Common Mistakes
```sql
-- WRONG: 'name' is not in GROUP BY or aggregate
SELECT dept_id, name, COUNT(*) FROM employee GROUP BY dept_id;

-- CORRECT:
SELECT dept_id, COUNT(*) FROM employee GROUP BY dept_id;
```

---

## 2.3 HAVING

### 💡 Simple Explanation
`HAVING` filters **groups** after `GROUP BY`. It's like `WHERE` but for groups, and it can use aggregate functions.

> Rule: `WHERE` filters rows → `HAVING` filters groups

### 🏭 Real-World Use Case
Management wants to see only departments that have **more than 1 employee** for resource planning.

```sql
-- Departments with more than 1 employee
SELECT dept_id, COUNT(*) AS emp_count
FROM employee
GROUP BY dept_id
HAVING COUNT(*) > 1;

-- Departments where avg salary exceeds 60000
SELECT e.dept_id, AVG(s.amount) AS avg_sal
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
GROUP BY e.dept_id
HAVING AVG(s.amount) > 60000;
```

### 🎯 Key Interview Points
- `HAVING` can use aggregate functions; `WHERE` cannot
- `HAVING` executes **after** `GROUP BY`; `WHERE` executes **before** `GROUP BY`
- You can use `HAVING` without `GROUP BY` — it filters the entire result as one group

### ⚠️ Common Mistakes
```sql
-- WRONG: Can't use aggregate in WHERE
SELECT dept_id FROM employee
WHERE COUNT(*) > 1
GROUP BY dept_id;

-- CORRECT: Use HAVING
SELECT dept_id FROM employee
GROUP BY dept_id
HAVING COUNT(*) > 1;
```

---

## 2.4 Aggregate Functions

### 💡 Simple Explanation
Aggregate functions compute a **single result from multiple rows**.

| Function | Returns |
|----------|---------|
| `COUNT(*)` | Total row count |
| `COUNT(col)` | Count of non-NULL values |
| `SUM(col)` | Total sum |
| `AVG(col)` | Average value |
| `MIN(col)` | Smallest value |
| `MAX(col)` | Largest value |

### 🏭 Real-World Use Case
Payroll system needs total salary expenditure, average pay, and highest/lowest salary in each department.

```sql
-- Full salary summary
SELECT
  COUNT(*)        AS total_employees,
  SUM(amount)     AS total_payroll,
  AVG(amount)     AS avg_salary,
  MIN(amount)     AS lowest_salary,
  MAX(amount)     AS highest_salary
FROM salary;

-- Per department breakdown
SELECT e.dept_id,
  COUNT(*)    AS headcount,
  AVG(amount) AS avg_pay,
  MAX(amount) AS top_salary
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
GROUP BY e.dept_id;
```

### 🎯 Key Interview Points
- `COUNT(*)` counts all rows including NULLs; `COUNT(column)` skips NULLs
- `AVG` ignores NULLs — `AVG(NULL, 10, 20)` = 15, not 10
- `SUM(NULL)` = NULL — wrap in `COALESCE(SUM(col), 0)` to handle nulls safely

### ⚠️ Common Mistakes
```sql
-- Expecting COUNT(col) to count NULLs — it doesn't
-- If 3 out of 6 rows have NULL salary:
COUNT(*)      -- returns 6
COUNT(salary) -- returns 3
```

---

## 2.5 Joins

### 💡 Simple Explanation
A JOIN combines rows from two tables based on a matching column (usually a foreign key relationship).

### INNER JOIN
Returns only rows with matching values in **both** tables.

```sql
SELECT e.name, e.age, s.occupation, s.amount
FROM employee e
INNER JOIN salary s ON e.emp_id = s.emp_id;
```

### LEFT JOIN
Returns **all rows from the left table** + matched rows from right. Unmatched right side = NULL.

```sql
-- All employees, even those with no salary record
SELECT e.name, s.amount
FROM employee e
LEFT JOIN salary s ON e.emp_id = s.emp_id;
```

### RIGHT JOIN
Returns **all rows from the right table** + matched left rows.

```sql
SELECT e.name, d.dept_name
FROM employee e
RIGHT JOIN department d ON e.dept_id = d.dept_id;
-- Shows all departments even if no employee is assigned
```

### SELF JOIN
A table joined to itself — for hierarchical or comparative data.

```sql
-- Find pairs of employees in the same department
SELECT a.name AS emp1, b.name AS emp2, a.dept_id
FROM employee a
JOIN employee b ON a.dept_id = b.dept_id AND a.emp_id < b.emp_id;
```

### Three-Table JOIN
```sql
SELECT e.name, d.dept_name, s.amount
FROM employee e
JOIN department d ON e.dept_id = d.dept_id
JOIN salary s ON e.emp_id = s.emp_id;
```

### 🏭 Real-World Use Case
An HR report needs employee name + department name + salary in one view. Three tables, two JOINs.

### 🎯 Key Interview Points
- `INNER JOIN` is the default — `JOIN` and `INNER JOIN` are identical
- `LEFT JOIN` is most commonly used in production (preserves all data from the primary table)
- FULL OUTER JOIN is not natively supported in MySQL — simulate with `LEFT JOIN UNION RIGHT JOIN`

### ⚠️ Common Mistakes
```sql
-- Forgetting the ON clause — creates a CROSS JOIN (cartesian product)
SELECT * FROM employee JOIN salary;  -- WRONG: returns n*m rows

-- Correct:
SELECT * FROM employee JOIN salary ON employee.emp_id = salary.emp_id;
```

---

## 2.6 Subqueries

### 💡 Simple Explanation
A subquery is a query **inside another query**. The inner query runs first and its result is passed to the outer query.

### 🏭 Real-World Use Case
Find all employees who earn above the company average salary — you need the average first, then compare.

```sql
-- Scalar subquery: returns one value
SELECT name FROM employee
WHERE emp_id IN (
  SELECT emp_id FROM salary WHERE amount > 70000
);

-- Find employees earning above average
SELECT name, amount
FROM salary
WHERE amount > (SELECT AVG(amount) FROM salary);

-- Subquery in FROM (derived table)
SELECT dept_id, avg_sal
FROM (
  SELECT e.dept_id, AVG(s.amount) AS avg_sal
  FROM employee e JOIN salary s ON e.emp_id = s.emp_id
  GROUP BY e.dept_id
) AS dept_avg
WHERE avg_sal > 60000;
```

### 🎯 Key Interview Points
- Subqueries in `WHERE` using `IN` can be slow on large datasets — JOIN is often faster
- A **correlated subquery** references the outer query and re-runs for every row (slow)
- Subqueries in `FROM` clause are called **derived tables** and must have an alias

### ⚠️ Common Mistakes
```sql
-- Forgetting alias on derived table
SELECT * FROM (SELECT emp_id FROM salary WHERE amount > 60000);
-- ERROR: Every derived table must have an alias

-- CORRECT:
SELECT * FROM (SELECT emp_id FROM salary WHERE amount > 60000) AS high_earners;
```

---

## 2.7 UNION

### 💡 Simple Explanation
`UNION` stacks results from two SELECT queries vertically.
- `UNION` — removes duplicates (slower)
- `UNION ALL` — keeps all rows including duplicates (faster)

Both queries must have the **same number of columns** with **compatible data types**.

### 🏭 Real-World Use Case
Generate a combined report tagging employees as "Senior" (age > 35) or "Junior" (age ≤ 35).

```sql
-- Tag and combine
SELECT name, age, 'Senior' AS category FROM employee WHERE age > 35
UNION
SELECT name, age, 'Junior' AS category FROM employee WHERE age <= 35
ORDER BY age DESC;

-- Combine employee IDs from two tables (de-duped)
SELECT emp_id FROM employee
UNION
SELECT emp_id FROM salary;

-- Keep duplicates (faster)
SELECT emp_id FROM employee
UNION ALL
SELECT emp_id FROM salary;
```

### 🎯 Key Interview Points
- Column names in the final result come from the **first** SELECT statement
- `ORDER BY` applies to the **entire UNION result**, not individual queries
- Use `UNION ALL` whenever you know there are no duplicates — it's always faster

### ⚠️ Common Mistakes
```sql
-- WRONG: Different column counts
SELECT name, age FROM employee
UNION
SELECT emp_id FROM salary;  -- ERROR: column count mismatch
```

---

# 🔹 SECTION 3: STRING & DATE FUNCTIONS

---

## 3.1 String Functions

### 💡 Simple Explanation
String functions let you manipulate text data — measure, clean, format, or extract parts of strings.

### 🏭 Real-World Use Case
A CRM system needs to standardize customer names (trim whitespace, uppercase), build full names, and validate email field lengths.

```sql
-- LENGTH: count characters
SELECT name, LENGTH(name) AS name_length FROM employee;

-- CONCAT: join strings
SELECT CONCAT(name, ' - ', occupation) AS profile FROM employee
JOIN salary ON employee.emp_id = salary.emp_id;

-- UPPER / LOWER: change case
SELECT UPPER(name) AS upper_name, LOWER(occupation) AS lower_occ
FROM employee JOIN salary ON employee.emp_id = salary.emp_id;

-- TRIM: remove leading and trailing spaces
SELECT TRIM('   Alice   ') AS cleaned;          -- 'Alice'
SELECT LTRIM('   Alice') AS left_trimmed;       -- 'Alice'
SELECT RTRIM('Alice   ') AS right_trimmed;      -- 'Alice'

-- SUBSTRING: extract part of a string
SELECT name, SUBSTRING(name, 1, 3) AS short_name FROM employee;
-- Alice → Ali, Bob → Bob, Carol → Car

-- REPLACE: swap characters
SELECT REPLACE(occupation, 'Engineer', 'Dev') FROM salary;

-- LIKE: pattern matching
SELECT name FROM employee WHERE name LIKE 'A%';   -- starts with A
SELECT name FROM employee WHERE name LIKE '%e';   -- ends with e
SELECT name FROM employee WHERE name LIKE '_o%';  -- second letter is 'o'
```

### 🎯 Key Interview Points
- `LENGTH()` counts bytes (not always characters) — for Unicode use `CHAR_LENGTH()`
- `LIKE '%word%'` is slow — it cannot use indexes (full table scan)
- `SUBSTRING(str, start, length)` — index starts at **1**, not 0

### ⚠️ Common Mistakes
```sql
-- WRONG: INDEX starts at 0 assumption
SUBSTRING('Alice', 0, 3)  -- returns '' in MySQL (0 index = empty)

-- CORRECT: Start from 1
SUBSTRING('Alice', 1, 3)  -- returns 'Ali'
```

---

## 3.2 Date Functions

### 💡 Simple Explanation
Date functions let you work with date/time data — get current time, calculate differences, extract parts.

### 🏭 Real-World Use Case
HR needs employee tenure, birth month for birthday alerts, and to find who was hired in the last year.

```sql
-- Current date and time
SELECT NOW();           -- 2024-11-15 14:30:00
SELECT CURDATE();       -- 2024-11-15
SELECT CURTIME();       -- 14:30:00

-- Calculate age or tenure using TIMESTAMPDIFF
SELECT name, hire_date,
  TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years_at_company
FROM employee;

-- Extract parts of a date
SELECT name,
  YEAR(hire_date)  AS hire_year,
  MONTH(hire_date) AS hire_month,
  DAY(hire_date)   AS hire_day
FROM employee;

-- Date arithmetic
SELECT name, hire_date,
  DATE_ADD(hire_date, INTERVAL 1 YEAR)  AS one_year_later,
  DATE_SUB(hire_date, INTERVAL 30 DAY)  AS thirty_days_before
FROM employee;

-- Find employees hired in the last 5 years
SELECT name, hire_date FROM employee
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);

-- Format dates for display
SELECT name, DATE_FORMAT(hire_date, '%d-%b-%Y') AS formatted_date
FROM employee;
-- Output: 15-Mar-2020
```

### 🎯 Key Interview Points
- `TIMESTAMPDIFF(unit, start, end)` — order is start then end (not reversed)
- `DATEDIFF(date1, date2)` returns days difference: date1 - date2
- Always store dates as `DATE` or `DATETIME`, never as `VARCHAR`

### ⚠️ Common Mistakes
```sql
-- WRONG: Reversed argument order in TIMESTAMPDIFF gives negative age
TIMESTAMPDIFF(YEAR, CURDATE(), hire_date)  -- returns negative number

-- CORRECT:
TIMESTAMPDIFF(YEAR, hire_date, CURDATE())  -- returns positive tenure
```

---

# 🔹 SECTION 4: ADVANCED SQL

---

## 4.1 CASE Statement

### 💡 Simple Explanation
`CASE` is conditional logic inside SQL — like an `if-else` chain. Returns different values based on conditions.

```sql
CASE
  WHEN condition1 THEN result1
  WHEN condition2 THEN result2
  ELSE default_result
END
```

### 🏭 Real-World Use Case
Payroll system needs to calculate tiered bonuses and display salary bands on an HR dashboard.

```sql
-- Salary band labeling
SELECT name, amount,
  CASE
    WHEN amount < 55000 THEN 'Entry Level'
    WHEN amount BETWEEN 55000 AND 75000 THEN 'Mid Level'
    WHEN amount > 75000 THEN 'Senior Level'
  END AS salary_band
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id;

-- Tiered bonus calculation
SELECT name, amount,
  CASE
    WHEN amount < 60000 THEN amount * 0.05
    WHEN amount >= 60000 THEN amount * 0.10
  END AS bonus,
  amount + CASE
    WHEN amount < 60000 THEN amount * 0.05
    ELSE amount * 0.10
  END AS total_package
FROM employee e JOIN salary s ON e.emp_id = s.emp_id;

-- Pivot-style count using CASE
SELECT
  COUNT(CASE WHEN gender = 'Male'   THEN 1 END) AS male_count,
  COUNT(CASE WHEN gender = 'Female' THEN 1 END) AS female_count
FROM employee;
```

### 🎯 Key Interview Points
- If no `ELSE` is provided and no condition matches, result is `NULL`
- `CASE` can be used in `SELECT`, `WHERE`, `ORDER BY`, and `GROUP BY`
- The pivot pattern (`COUNT(CASE WHEN ... THEN 1 END)`) is very common in interviews

### ⚠️ Common Mistakes
```sql
-- WRONG: Forgetting ELSE — returns NULL when no condition matches
CASE WHEN amount > 80000 THEN 'High'
     WHEN amount > 50000 THEN 'Medium'
END
-- Employees with amount <= 50000 get NULL silently

-- CORRECT: Always add ELSE
CASE WHEN amount > 80000 THEN 'High'
     WHEN amount > 50000 THEN 'Medium'
     ELSE 'Entry'
END
```

---

## 4.2 Window Functions

### 💡 Simple Explanation
Window functions compute values **across a set of rows** related to the current row — **without collapsing rows** like `GROUP BY` does. Every row keeps its identity, and you get the aggregate alongside it.

```sql
function() OVER (
  PARTITION BY column   -- define groups (optional)
  ORDER BY column       -- order within group (optional)
)
```

### 🏭 Real-World Use Case
HR wants to see each employee's salary alongside their department's average — without losing individual rows.

```sql
-- Average salary per department shown on every row
SELECT e.name, e.dept_id, s.amount,
  AVG(s.amount) OVER(PARTITION BY e.dept_id) AS dept_avg_salary
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id;

-- Running total of salary ordered by employee ID
SELECT e.name, s.amount,
  SUM(s.amount) OVER(ORDER BY e.emp_id) AS running_total
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id;
```

---

## 4.3 ROW_NUMBER, RANK, DENSE_RANK

### 💡 Simple Explanation

| Function | Behaviour on Tied Values |
|----------|--------------------------|
| `ROW_NUMBER()` | Unique number always — no ties |
| `RANK()` | Same rank for ties, **skips** next rank |
| `DENSE_RANK()` | Same rank for ties, **no skip** |

```
Salary:  95000  85000  85000  60000
ROW_NUM:    1       2       3      4
RANK:       1       2       2      4   ← skips 3
DENSE_RANK: 1       2       2      3   ← no skip
```

```sql
-- All three ranking functions compared
SELECT e.name, s.amount,
  ROW_NUMBER()  OVER(ORDER BY s.amount DESC) AS row_num,
  RANK()        OVER(ORDER BY s.amount DESC) AS rnk,
  DENSE_RANK()  OVER(ORDER BY s.amount DESC) AS dense_rnk
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id;

-- Top earner per department (use ROW_NUMBER for strictly one)
SELECT * FROM (
  SELECT e.name, e.dept_id, s.amount,
    ROW_NUMBER() OVER(PARTITION BY e.dept_id ORDER BY s.amount DESC) AS rn
  FROM employee e JOIN salary s ON e.emp_id = s.emp_id
) ranked
WHERE rn = 1;
```

### 🎯 Key Interview Points
- "Find the 2nd highest salary per department" → use `DENSE_RANK() = 2`
- "Find the top 1 salary per department" → use `ROW_NUMBER() = 1` (no ties)
- Window functions cannot be used directly in `WHERE` — wrap in a subquery or CTE

### ⚠️ Common Mistakes
```sql
-- WRONG: Window function directly in WHERE
SELECT name FROM (SELECT name, RANK() OVER(...) AS rnk FROM salary) WHERE rnk = 1;
-- Missing the subquery alias

-- CORRECT:
SELECT name FROM (
  SELECT name, RANK() OVER(ORDER BY amount DESC) AS rnk FROM salary
) AS ranked
WHERE rnk = 1;
```

---

## 4.4 CTE — Common Table Expressions

### 💡 Simple Explanation
A CTE is a **named temporary result set** defined with `WITH` at the top of a query. Think of it as giving a subquery a readable name. It exists only for the duration of the query.

### 🏭 Real-World Use Case
Find employees who earn more than the average salary in their department — a two-step problem.

```sql
-- Basic CTE
WITH dept_avg AS (
  SELECT e.dept_id, AVG(s.amount) AS avg_sal
  FROM employee e
  JOIN salary s ON e.emp_id = s.emp_id
  GROUP BY e.dept_id
)
SELECT e.name, e.dept_id, s.amount, d.avg_sal
FROM employee e
JOIN salary s  ON e.emp_id = s.emp_id
JOIN dept_avg d ON e.dept_id = d.dept_id
WHERE s.amount > d.avg_sal;

-- Multiple CTEs (chain with comma)
WITH high_earners AS (
  SELECT emp_id FROM salary WHERE amount > 70000
),
senior_staff AS (
  SELECT emp_id FROM employee WHERE age > 30
)
SELECT e.name FROM employee e
WHERE e.emp_id IN (SELECT emp_id FROM high_earners)
  AND e.emp_id IN (SELECT emp_id FROM senior_staff);
```

### 🎯 Key Interview Points
- CTE vs Subquery: CTEs are more **readable** and can be **referenced multiple times**
- MySQL supports **Recursive CTEs** (for hierarchical data like org charts)
- Performance is generally similar to subqueries — it's mainly a readability win

### ⚠️ Common Mistakes
```sql
-- WRONG: Trying to use CTE outside its query
WITH my_cte AS (SELECT * FROM employee);
SELECT * FROM my_cte;  -- ERROR: CTE is gone after the semicolon

-- CORRECT: CTE and its query must be one statement
WITH my_cte AS (SELECT * FROM employee)
SELECT * FROM my_cte;
```

---

## 4.5 Views

### 💡 Simple Explanation
A view is a **saved SELECT query** stored with a name. It behaves like a virtual table. Every time you query it, the underlying SELECT is executed.

### 🏭 Real-World Use Case
Expose a simplified employee summary to junior analysts without giving them access to raw salary tables.

```sql
-- Create a view
CREATE VIEW employee_summary AS
SELECT e.name, e.age, e.gender, d.dept_name, s.amount AS salary
FROM employee e
JOIN department d ON e.dept_id = d.dept_id
JOIN salary s ON e.emp_id = s.emp_id;

-- Query the view like a table
SELECT * FROM employee_summary WHERE salary > 60000;

-- Update a view
CREATE OR REPLACE VIEW employee_summary AS
SELECT e.name, e.gender, d.dept_name, s.amount
FROM employee e
JOIN department d ON e.dept_id = d.dept_id
JOIN salary s ON e.emp_id = s.emp_id;

-- Drop a view
DROP VIEW employee_summary;
```

### 🎯 Key Interview Points
- Views do **not store data** — they store the query; data is always live
- **Updatable views:** simple views (single table, no GROUP BY, no aggregates) can be updated
- Use views for **security** (hide sensitive columns) and **simplicity** (hide complex joins)

### ⚠️ Common Mistakes
- Thinking views improve performance — they don't (unless it's a materialized view)
- Trying to add an `ORDER BY` inside a view in MySQL — it's ignored when querying the view

---

## 4.6 Indexes

### 💡 Simple Explanation
An index is a **lookup structure** that speeds up data retrieval — like a book's index. Without it, MySQL reads every row (full table scan). With it, MySQL jumps directly to matching rows.

### 🏭 Real-World Use Case
A salary table with 1 million rows. Querying `WHERE emp_id = 500` without an index = scan all 1M rows. With an index = direct lookup in microseconds.

```sql
-- Create an index on a frequently filtered column
CREATE INDEX idx_dept_id ON employee(dept_id);

-- Create a unique index (also enforces uniqueness)
CREATE UNIQUE INDEX idx_email ON employee(email);

-- Composite index (for queries filtering on both columns)
CREATE INDEX idx_dept_gender ON employee(dept_id, gender);

-- Check existing indexes on a table
SHOW INDEX FROM employee;

-- Drop an index
DROP INDEX idx_dept_id ON employee;
```

### When to use indexes:
- Columns frequently used in `WHERE`, `JOIN ON`, `ORDER BY`
- Foreign key columns
- High-cardinality columns (many unique values)

### When NOT to use:
- Small tables (full scan is faster)
- Columns updated very frequently (index must be maintained)
- Low-cardinality columns (e.g., gender — only 2 values)

### 🎯 Key Interview Points
- Primary key automatically creates a **clustered index** in InnoDB
- `EXPLAIN SELECT ...` shows whether MySQL is using an index or doing a full scan
- Composite index `(a, b)` helps queries on `a` alone, but NOT queries on `b` alone

### ⚠️ Common Mistakes
```sql
-- Index on col won't be used with a function wrapper
WHERE YEAR(hire_date) = 2020  -- index on hire_date NOT used

-- CORRECT: Restructure to use the index
WHERE hire_date BETWEEN '2020-01-01' AND '2020-12-31'
```

---

# 🔹 SECTION 5: DATABASE DESIGN

---

## 5.1 Primary Key & Foreign Key

### 💡 Simple Explanation
- **Primary Key (PK):** Uniquely identifies each row. Cannot be NULL or duplicate. One per table.
- **Foreign Key (FK):** A column in one table that references the Primary Key in another table. Enforces that you can't insert a value that doesn't exist in the parent table.

### 🏭 Real-World Use Case
In a school database, `student_id` is the PK in the Students table. In the Enrollments table, `student_id` is a FK — you can't enroll a student who doesn't exist.

```sql
CREATE TABLE department (
  dept_id   INT PRIMARY KEY,
  dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE employee (
  emp_id  INT PRIMARY KEY,
  name    VARCHAR(50),
  dept_id INT,
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);
```

### ON DELETE / ON UPDATE options:
| Option | Behaviour |
|--------|-----------|
| `CASCADE` | Delete/update child rows automatically |
| `SET NULL` | Set FK to NULL when parent is deleted |
| `RESTRICT` | Prevent delete/update if child rows exist |
| `NO ACTION` | Same as RESTRICT in MySQL |

### 🎯 Key Interview Points
- A table can have only **one Primary Key** but **multiple Foreign Keys**
- Foreign Keys can be NULL (meaning the relationship is optional)
- Foreign Keys create implicit indexes — good for JOIN performance

---

## 5.2 Normalization

### 💡 Simple Explanation
Normalization organizes tables to **eliminate redundancy** and prevent data anomalies. Done step by step through "Normal Forms."

**The 3 Anomalies normalization prevents:**
- **Insertion anomaly:** Can't add partial data (e.g., can't add a department with no employees yet)
- **Update anomaly:** Updating one record requires changing many rows
- **Deletion anomaly:** Deleting one record accidentally removes other useful data

---

### 1NF — Each cell must hold ONE value

❌ Violates 1NF (multiple phones in one cell):
| emp_id | name | phone |
|--------|------|-------|
| 1 | Alice | 9999, 8888 |

✅ 1NF:
| emp_id | name | phone |
|--------|------|-------|
| 1 | Alice | 9999 |
| 1 | Alice | 8888 |

---

### 2NF — No partial dependency (applies to composite keys)

❌ Violates 2NF:
| student_id | course_id | student_name | course_name |
`student_name` depends only on `student_id` — not on the full composite key.

✅ 2NF: Split into `Student(student_id, student_name)` + `Course(course_id, course_name)` + `Enrollment(student_id, course_id)`

---

### 3NF — No transitive dependency

❌ Violates 3NF:
| emp_id | dept_id | dept_name |
`dept_name` depends on `dept_id`, not directly on `emp_id`.

✅ 3NF: Split into `Employee(emp_id, dept_id)` + `Department(dept_id, dept_name)`

### 🎯 Key Interview Points
- Most production databases are designed to 3NF
- **Denormalization** (intentional redundancy) is used in data warehouses for read speed
- BCNF is stricter than 3NF — handles edge cases with overlapping candidate keys

---

# 🔹 SECTION 6: TRANSACTIONS & CONTROL

---

## 6.1 ACID Properties

### 💡 Simple Explanation
ACID is a set of 4 guarantees that ensure database transactions are processed reliably.

| Property | Meaning | Example |
|----------|---------|---------|
| **Atomicity** | All or nothing | Bank transfer: both debit AND credit succeed, or neither does |
| **Consistency** | Rules always hold | Can't transfer more than account balance |
| **Isolation** | Transactions don't interfere | Two bookings for last seat — only one succeeds |
| **Durability** | Committed = permanent | "Order confirmed" survives a server crash |

### 🎯 Key Interview Points
- Atomicity is enforced by `ROLLBACK` (undo on failure)
- Isolation level controls how much transactions see each other (READ COMMITTED, SERIALIZABLE, etc.)
- InnoDB storage engine in MySQL fully supports ACID; MyISAM does NOT

---

## 6.2 Transactions (COMMIT, ROLLBACK, SAVEPOINT)

### 🏭 Real-World Use Case
Bank fund transfer: debit one account, credit another. If the credit step fails, the debit must be undone.

```sql
START TRANSACTION;

-- Step 1: Debit sender
UPDATE accounts SET balance = balance - 5000 WHERE acc_id = 101;
SAVEPOINT debit_done;

-- Step 2: Credit receiver
UPDATE accounts SET balance = balance + 5000 WHERE acc_id = 102;
SAVEPOINT credit_done;

-- Something failed — rollback to just after debit
ROLLBACK TO debit_done;

-- Everything succeeded — make it permanent
COMMIT;
```

### 🎯 Key Interview Points
- Auto-commit is ON by default in MySQL — each statement is its own transaction
- `SET autocommit = 0` to disable auto-commit manually
- DDL statements (CREATE, DROP, TRUNCATE) **implicitly commit** any open transaction

### ⚠️ Common Mistakes
- Calling `ROLLBACK` after `COMMIT` — you can't undo a committed transaction
- Forgetting that TRUNCATE inside a transaction auto-commits

---

## 6.3 DCL — GRANT & REVOKE

```sql
-- Give read and write access to a user
GRANT SELECT, INSERT, UPDATE ON employees.* TO 'analyst'@'localhost';

-- Remove specific permissions
REVOKE INSERT ON employees.* FROM 'analyst'@'localhost';

-- Give full access to everything
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%';

-- Apply permission changes immediately
FLUSH PRIVILEGES;

-- Check a user's grants
SHOW GRANTS FOR 'analyst'@'localhost';
```

### 🎯 Key Interview Points
- `*.*` means all databases and all tables
- `'user'@'%'` means the user can connect from **any host**
- Always use the principle of **least privilege** — grant only what's needed

---

# 🔹 SECTION 7: STORED PROCEDURES & FUNCTIONS

---

## 7.1 Stored Procedures

### 💡 Simple Explanation
A stored procedure is a **saved, named SQL block** that executes on demand with `CALL`. Like a function in programming — write once, call many times.

### 🏭 Real-World Use Case
The payroll team calls a procedure every month-end to generate the salary report — they don't need to know SQL.

```sql
-- Simple procedure (no parameters)
DELIMITER $$
CREATE PROCEDURE get_all_employees()
BEGIN
  SELECT * FROM employee;
END $$
DELIMITER ;

CALL get_all_employees();

-- Procedure with INPUT parameter
DELIMITER $$
CREATE PROCEDURE get_employee_by_dept(IN dept INT)
BEGIN
  SELECT e.name, s.amount
  FROM employee e
  JOIN salary s ON e.emp_id = s.emp_id
  WHERE e.dept_id = dept;
END $$
DELIMITER ;

CALL get_employee_by_dept(1);

-- Procedure with OUT parameter
DELIMITER $$
CREATE PROCEDURE get_dept_total(IN dept INT, OUT total DECIMAL(10,2))
BEGIN
  SELECT SUM(s.amount) INTO total
  FROM employee e JOIN salary s ON e.emp_id = s.emp_id
  WHERE e.dept_id = dept;
END $$
DELIMITER ;

CALL get_dept_total(1, @result);
SELECT @result;
```

### 🎯 Key Interview Points
- `DELIMITER $$` changes the statement terminator so `;` inside the procedure doesn't end it prematurely
- `IN` = input only, `OUT` = output only, `INOUT` = both
- Use `DROP PROCEDURE IF EXISTS proc_name` before recreating

### ⚠️ Common Mistakes
- Forgetting to reset `DELIMITER` back to `;` after creating the procedure
- Not using `IF EXISTS` when dropping — causes error if procedure doesn't exist

---

## 7.2 Stored Functions vs Stored Procedures

| Feature | Procedure | Function |
|---------|-----------|---------|
| Returns | Optional (via OUT) | Must return a value |
| Called with | `CALL name()` | `SELECT name()` |
| Use in SELECT | ❌ | ✅ |
| Transaction control | ✅ | ❌ |
| DML inside | ✅ | Limited |

```sql
-- Stored Function example
DELIMITER $$
CREATE FUNCTION calculate_bonus(sal INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE bonus DECIMAL(10,2);
  IF sal >= 75000 THEN SET bonus = sal * 0.15;
  ELSE SET bonus = sal * 0.10;
  END IF;
  RETURN bonus;
END $$
DELIMITER ;

-- Use in SELECT like any built-in function
SELECT name, amount, calculate_bonus(amount) AS bonus
FROM employee e JOIN salary s ON e.emp_id = s.emp_id;
```

---

# 🔹 SECTION 8: PERFORMANCE & OPTIMIZATION

---

## 8.1 Query Optimization Basics

### 💡 Simple Explanation
A slow query wastes server resources and makes users angry. Optimization means rewriting queries and designing schemas so MySQL finds answers faster.

### The Golden Rule
> Always start with `EXPLAIN` to see what MySQL is actually doing.

```sql
-- See the execution plan
EXPLAIN SELECT e.name, s.amount
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
WHERE e.dept_id = 1;
```

**Key columns in EXPLAIN output:**
| Column | What to look for |
|--------|-----------------|
| `type` | `const` or `ref` = good; `ALL` = full scan = bad |
| `key` | Which index is being used (NULL = no index used) |
| `rows` | Estimated rows MySQL will scan — smaller is better |
| `Extra` | `Using filesort` or `Using temporary` = warning signs |

---

### 8.2 Index Usage Tips

```sql
-- ✅ GOOD: Index on dept_id is used
SELECT * FROM employee WHERE dept_id = 2;

-- ❌ BAD: Function on column prevents index use
SELECT * FROM employee WHERE YEAR(hire_date) = 2020;

-- ✅ GOOD: Rewrite to use index
SELECT * FROM employee
WHERE hire_date BETWEEN '2020-01-01' AND '2020-12-31';

-- ❌ BAD: Leading wildcard kills index
SELECT * FROM employee WHERE name LIKE '%lice';

-- ✅ GOOD: Trailing wildcard still uses index
SELECT * FROM employee WHERE name LIKE 'Al%';

-- ❌ BAD: OR on different columns may skip indexes
SELECT * FROM employee WHERE dept_id = 1 OR age = 30;

-- ✅ GOOD: UNION can use indexes on each side
SELECT * FROM employee WHERE dept_id = 1
UNION
SELECT * FROM employee WHERE age = 30;
```

---

### 8.3 Avoiding Full Table Scans

```sql
-- ❌ Implicit type conversion disables index
WHERE emp_id = '1'  -- emp_id is INT but comparing to string

-- ✅ Use matching types
WHERE emp_id = 1

-- ❌ Negative conditions often do full scan
WHERE dept_id != 2

-- ✅ Rewrite with IN if possible
WHERE dept_id IN (1, 3, 4)

-- ❌ SELECT * fetches all columns — wasteful
SELECT * FROM salary WHERE emp_id = 1;

-- ✅ Select only what you need
SELECT amount FROM salary WHERE emp_id = 1;
```

### 🎯 Key Interview Points
- The most impactful optimization is usually **adding the right index**
- `EXPLAIN` is your most important tool for diagnosing slow queries
- Avoid `SELECT *` in production — it fetches unnecessary data and breaks with schema changes

---

# 🔹 SECTION 9: INTERVIEW PREPARATION

---

## Most Asked SQL Interview Questions

---

### Q1: What is the difference between DELETE, TRUNCATE, and DROP?

| | DELETE | TRUNCATE | DROP |
|--|--------|---------|------|
| What it removes | Selected rows | All rows | Entire table |
| WHERE clause | ✅ | ❌ | ❌ |
| Rollback | ✅ | ❌ | ❌ |
| Fires triggers | ✅ | ❌ | ❌ |
| Resets AUTO_INCREMENT | ❌ | ✅ | — |
| Type | DML | DDL | DDL |

---

### Q2: Find the 2nd highest salary

```sql
-- Method 1: Subquery
SELECT MAX(amount) FROM salary
WHERE amount < (SELECT MAX(amount) FROM salary);

-- Method 2: DENSE_RANK (best — handles ties)
SELECT amount FROM (
  SELECT amount, DENSE_RANK() OVER(ORDER BY amount DESC) AS rnk
  FROM salary
) ranked
WHERE rnk = 2;

-- Method 3: LIMIT OFFSET (but only works without ties)
SELECT DISTINCT amount FROM salary
ORDER BY amount DESC LIMIT 1 OFFSET 1;
```

---

### Q3: Find duplicate records

```sql
-- Find names that appear more than once
SELECT name, COUNT(*) AS occurrences
FROM employee
GROUP BY name
HAVING COUNT(*) > 1;

-- Delete duplicates, keep the one with lowest emp_id
DELETE FROM employee
WHERE emp_id NOT IN (
  SELECT MIN(emp_id)
  FROM employee
  GROUP BY name
);
```

---

### Q4: Find employees who don't have a salary record

```sql
-- Using LEFT JOIN
SELECT e.name
FROM employee e
LEFT JOIN salary s ON e.emp_id = s.emp_id
WHERE s.emp_id IS NULL;

-- Using NOT EXISTS
SELECT name FROM employee e
WHERE NOT EXISTS (
  SELECT 1 FROM salary s WHERE s.emp_id = e.emp_id
);
```

---

### Q5: Display department-wise highest paid employee

```sql
SELECT e.name, e.dept_id, s.amount FROM (
  SELECT e.emp_id, e.name, e.dept_id, s.amount,
    ROW_NUMBER() OVER(PARTITION BY e.dept_id ORDER BY s.amount DESC) AS rn
  FROM employee e JOIN salary s ON e.emp_id = s.emp_id
) ranked
WHERE rn = 1;
```

---

### Q6: Difference between WHERE and HAVING?
- `WHERE` filters individual **rows** before grouping — cannot use aggregate functions
- `HAVING` filters **groups** after GROUP BY — can use aggregate functions

---

### Q7: What is a correlated subquery?

A subquery that **references a column from the outer query**. It runs once for **every row** of the outer query — making it slow for large datasets.

```sql
-- Find employees earning more than their department average
SELECT e.name, s.amount
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
WHERE s.amount > (
  SELECT AVG(s2.amount)
  FROM employee e2
  JOIN salary s2 ON e2.emp_id = s2.emp_id
  WHERE e2.dept_id = e.dept_id   -- ← references outer query
);
```

---

### Q8: What is the difference between RANK and DENSE_RANK?

```
Values: 90000, 85000, 85000, 60000
RANK:        1,      2,      2,      4   ← gap after tie
DENSE_RANK:  1,      2,      2,      3   ← no gap
```

Use `DENSE_RANK` for "Nth highest" problems to avoid missing ranks.

---

### Q9: How do you optimize a slow query?

1. Run `EXPLAIN` to identify full table scans (`type = ALL`)
2. Add appropriate indexes on `WHERE`, `JOIN ON`, `ORDER BY` columns
3. Avoid functions on indexed columns in `WHERE` clause
4. Replace `SELECT *` with specific column names
5. Replace correlated subqueries with JOINs or CTEs
6. Use `LIMIT` to avoid fetching unnecessary rows

---

### Q10: Tricky NULL questions

```sql
-- NULL is not equal to anything, including itself
SELECT NULL = NULL;   -- returns NULL, not TRUE

-- Use IS NULL / IS NOT NULL to check
SELECT * FROM salary WHERE amount IS NULL;

-- NULL in aggregate functions
SELECT AVG(amount) FROM salary;   -- NULLs are ignored in AVG
SELECT COUNT(*) FROM salary;      -- counts all rows including NULL amounts
SELECT COUNT(amount) FROM salary; -- skips NULL amounts

-- COALESCE: return first non-NULL value
SELECT name, COALESCE(amount, 0) AS salary FROM salary;

-- IFNULL: MySQL-specific shorthand
SELECT IFNULL(amount, 0) AS salary FROM salary;
```

---

### Q11: Write a query to show running total of salaries

```sql
SELECT e.name, s.amount,
  SUM(s.amount) OVER(ORDER BY e.emp_id) AS running_total
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id;
```

---

### Q12: What is a self join? Write an example.

```sql
-- Find all pairs of employees in the same department
SELECT a.name AS employee1, b.name AS employee2, a.dept_id
FROM employee a
JOIN employee b
  ON a.dept_id = b.dept_id
  AND a.emp_id < b.emp_id;   -- prevents duplicates and self-pairing
```

---

## ⚡ Quick Reference: SQL Execution Order

```
1. FROM          ← identify table(s)
2. JOIN          ← merge tables
3. WHERE         ← filter rows       [no aliases, no aggregates]
4. GROUP BY      ← group rows
5. HAVING        ← filter groups     [aggregates OK here]
6. SELECT        ← choose columns    [aliases born here]
7. DISTINCT      ← remove duplicates
8. ORDER BY      ← sort results      [aliases usable here]
9. LIMIT/OFFSET  ← restrict output
```

---

## ⚡ Quick Reference: Which Join to Use?

| Scenario | Join |
|---------|------|
| Only matching rows from both tables | INNER JOIN |
| All from left, matches from right | LEFT JOIN |
| All records including unmatched (MySQL workaround) | LEFT JOIN UNION RIGHT JOIN |
| Compare rows within the same table | SELF JOIN |
| Every row × every row combination | CROSS JOIN |

---

## ⚡ One-Line Summaries for Fast Revision

| Concept | One Line |
|---------|---------|
| Primary Key | Unique + NOT NULL identifier for each row |
| Foreign Key | Links to PK in another table; enforces referential integrity |
| 1NF | Each cell = one atomic value |
| 2NF | No partial dependency on composite key |
| 3NF | No transitive dependency between non-key columns |
| ACID | Atomicity, Consistency, Isolation, Durability |
| Clustered Index | Physically sorts table data — one per table |
| Non-Clustered Index | Separate structure pointing to data — many per table |
| View | Saved SELECT query — virtual table, no data stored |
| CTE | Named temp result set using WITH — lives for one query |
| Window Function | Aggregate without collapsing rows — uses OVER() |
| RANK | Ties get same rank, next rank is skipped |
| DENSE_RANK | Ties get same rank, no skip |
| Correlated Subquery | Subquery that references outer query — runs per row |
| Deadlock | Two transactions each waiting for the other's lock |

---

*This guide is designed to take you from zero to interview-ready in SQL.*
*Practice every query in MySQL Workbench. Understanding comes from running, not reading.*
