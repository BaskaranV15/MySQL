# 🧠 SQL Complete Roadmap — Beginner to Advanced
### MySQL | Interview Prep | Real-World Projects
> Written by a Senior SQL Engineer & Interview Coach.
> Every topic: Simple Explanation → Real Use Case → Basic → Intermediate → Advanced Queries → Interview Points → Mistakes.

---

## 📌 Tables Used Throughout This Guide

```sql
CREATE TABLE department (
  dept_id   INT PRIMARY KEY,
  dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE employee (
  emp_id    INT PRIMARY KEY,
  name      VARCHAR(50),
  age       INT,
  gender    VARCHAR(10),
  dept_id   INT,
  hire_date DATE,
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

CREATE TABLE salary (
  emp_id     INT,
  occupation VARCHAR(50),
  amount     INT,
  FOREIGN KEY (emp_id) REFERENCES employee(emp_id)
);

INSERT INTO department VALUES
(1,'Engineering'),(2,'HR'),(3,'Finance'),(4,'Marketing');

INSERT INTO employee VALUES
(1,'Alice',30,'Female',1,'2020-03-15'),
(2,'Bob',35,'Male',2,'2018-07-01'),
(3,'Carol',28,'Female',1,'2021-11-20'),
(4,'David',42,'Male',3,'2015-05-10'),
(5,'Eve',25,'Female',4,'2023-01-05'),
(6,'Frank',38,'Male',2,'2017-09-18'),
(7,'Grace',33,'Female',3,'2019-04-22');

INSERT INTO salary VALUES
(1,'Software Engineer',85000),
(2,'HR Manager',60000),
(3,'Junior Developer',55000),
(4,'Finance Head',95000),
(5,'Marketing Exec',48000),
(6,'HR Executive',52000),
(7,'Finance Analyst',72000);
```

---

# ═══════════════════════════════════════
# 🔹 SECTION 1 — BASICS
# ═══════════════════════════════════════

---

## 1.1 What is SQL, DBMS, RDBMS

### 💡 Simple Explanation
- **SQL (Structured Query Language):** The language used to communicate with a database — ask for data, add it, modify it, or delete it.
- **DBMS (Database Management System):** Software that manages and stores data. Examples: MySQL, MongoDB, SQLite.
- **RDBMS (Relational DBMS):** A DBMS where data is stored in **structured tables with relationships** enforced through keys. MySQL, PostgreSQL, Oracle are RDBMS.

> Think of DBMS as a filing cabinet system, and RDBMS as a smarter cabinet where all folders know how to reference each other.

### 🏭 Real-World Use Case
Every time you open Zomato and see your past orders — that data is fetched using SQL. Your orders, addresses, payment info, and restaurant details live in separate related tables, joined together when your app loads.

### 📝 Basic Queries

```sql
-- View all employees
SELECT * FROM employee;

-- View only name and age
SELECT name, age FROM employee;

-- View department names
SELECT dept_name FROM department;
```

### 📊 Intermediate Queries

```sql
-- Check how many tables exist in this database
SHOW TABLES;

-- Describe the structure of a table
DESCRIBE employee;
```

### 🔬 Advanced Query

```sql
-- Check storage engine, row count, and table info
SELECT table_name, engine, table_rows, create_time
FROM information_schema.tables
WHERE table_schema = 'your_database_name';
```

### 🎯 Key Interview Points
- SQL is a **query language**, not a programming language
- Every RDBMS is a DBMS, but not every DBMS is an RDBMS
- MongoDB = DBMS (NoSQL); MySQL = RDBMS (SQL)
- RDBMS enforces relationships using **Primary Keys and Foreign Keys**

### ⚠️ Common Mistakes
- Calling SQL a "programming language" in interviews — it is a **declarative query language**
- Confusing DBMS and RDBMS — the critical difference is **relational tables with enforced relationships**
- Saying MySQL and SQL are the same — MySQL is a **software**; SQL is the **language** it uses

---

## 1.2 Types of SQL Commands (DDL, DML, DCL, TCL)

### 💡 Simple Explanation
SQL commands are grouped into categories based on their purpose:

| Category | Full Name | Purpose | Commands |
|----------|-----------|---------|----------|
| DDL | Data Definition Language | Define/change structure | CREATE, ALTER, DROP, TRUNCATE, RENAME |
| DML | Data Manipulation Language | Work with data | SELECT, INSERT, UPDATE, DELETE |
| DCL | Data Control Language | Manage access/permissions | GRANT, REVOKE |
| TCL | Transaction Control Language | Control transactions | COMMIT, ROLLBACK, SAVEPOINT |

### 🏭 Real-World Use Case
- A developer adds a new `phone` column → **DDL (ALTER)**
- A user updates their address → **DML (UPDATE)**
- A new analyst account gets read-only access → **DCL (GRANT)**
- A failed payment reversal undoes a debit → **TCL (ROLLBACK)**

### 📝 Basic Queries

```sql
-- DDL: Create a table
CREATE TABLE project (
  project_id INT PRIMARY KEY,
  project_name VARCHAR(100)
);

-- DML: Insert data
INSERT INTO project VALUES (1, 'Payroll System');

-- DML: Update data
UPDATE project SET project_name = 'HR Payroll' WHERE project_id = 1;
```

### 📊 Intermediate Queries

```sql
-- DDL: Add a new column
ALTER TABLE employee ADD COLUMN email VARCHAR(100);

-- DDL: Drop a column
ALTER TABLE employee DROP COLUMN email;
```

### 🔬 Advanced Query

```sql
-- Rename a table (DDL)
RENAME TABLE project TO active_projects;

-- Safe drop: only drop if table exists
DROP TABLE IF EXISTS active_projects;
```

### 🎯 Key Interview Points
- **DDL commands are auto-committed** — you cannot ROLLBACK a DROP or TRUNCATE
- **TRUNCATE is DDL**, DELETE is DML — classic trick question
- DML commands can be wrapped in a transaction and rolled back
- SELECT is sometimes classified separately as **DQL (Data Query Language)**

### ⚠️ Common Mistakes
- Trying to ROLLBACK after TRUNCATE — DDL auto-commits, it's too late
- Saying DELETE and TRUNCATE are the same — DELETE is DML (logged, slow, triggers fire); TRUNCATE is DDL (minimal logging, fast, no triggers)

---

## 1.3 CREATE, INSERT, SELECT

### 💡 Simple Explanation
These are the three foundation commands of SQL:
- **CREATE** — builds the table structure (the blueprint)
- **INSERT** — adds rows of actual data into the table
- **SELECT** — retrieves data from the table

### 🏭 Real-World Use Case
An HR system creates an `employee` table when the company is set up, inserts new hires as they join, and retrieves employee records when HR logs in to the dashboard.

### 📝 Basic Queries

```sql
-- Create a simple table
CREATE TABLE employee (
  emp_id  INT PRIMARY KEY,
  name    VARCHAR(50) NOT NULL,
  age     INT,
  dept_id INT
);

-- Insert a single row
INSERT INTO employee (emp_id, name, age, dept_id) VALUES (1, 'Alice', 30, 1);

-- Insert multiple rows at once
INSERT INTO employee VALUES
(2, 'Bob', 35, 2),
(3, 'Carol', 28, 1);

-- Select all columns
SELECT * FROM employee;

-- Select specific columns
SELECT name, age FROM employee;
```

### 📊 Intermediate Queries

```sql
-- Select with a calculated column
SELECT name, age, age + 5 AS age_in_5_years FROM employee;

-- Insert data from another table (INSERT INTO ... SELECT)
CREATE TABLE employee_backup LIKE employee;
INSERT INTO employee_backup SELECT * FROM employee;
```

### 🔬 Advanced Query

```sql
-- Create table and populate from another table in one step
CREATE TABLE senior_employees AS
SELECT * FROM employee WHERE age > 35;

-- Verify structure and data
SELECT * FROM senior_employees;
```

### 🎯 Key Interview Points
- `SELECT *` is fine for learning but **bad in production** — always name your columns
- `PRIMARY KEY` automatically creates a clustered index on that column
- `NOT NULL` ensures the column must always have a value — combine with `DEFAULT` for smart defaults
- `INSERT INTO ... SELECT` is one of the most powerful data migration techniques

### ⚠️ Common Mistakes

```sql
-- WRONG: Column count mismatch
INSERT INTO employee VALUES (1, 'Alice', 30);
-- ERROR if table has 4 columns

-- CORRECT: Always specify columns explicitly
INSERT INTO employee (emp_id, name, age) VALUES (1, 'Alice', 30);

-- WRONG: Using SELECT * in production joins (unpredictable column order)
SELECT * FROM employee JOIN salary ON employee.emp_id = salary.emp_id;
```

---

## 1.4 WHERE, AND, OR, NOT

### 💡 Simple Explanation
`WHERE` filters which rows your query returns. Combine conditions with:
- **AND** — both conditions must be true
- **OR** — at least one must be true
- **NOT** — reverses/negates the condition

### 🏭 Real-World Use Case
A marketing team wants to target female employees aged over 28 who are NOT in the Finance department — for an internal survey.

### 📝 Basic Queries

```sql
-- AND: both must be true
SELECT name, age FROM employee
WHERE age > 30 AND gender = 'Male';

-- OR: either can be true
SELECT name FROM employee
WHERE dept_id = 1 OR dept_id = 2;

-- NOT: exclude a condition
SELECT name FROM employee
WHERE NOT dept_id = 3;
```

### 📊 Intermediate Queries

```sql
-- Combining AND + OR (always use parentheses)
SELECT name, age, gender FROM employee
WHERE (dept_id = 1 OR dept_id = 2) AND age < 35;

-- BETWEEN (inclusive range)
SELECT name, age FROM employee WHERE age BETWEEN 28 AND 35;

-- IN (cleaner alternative to multiple ORs)
SELECT name FROM employee WHERE dept_id IN (1, 2, 4);
```

### 🔬 Advanced Query

```sql
-- Complex filter: Female employees aged 25-35 NOT in Engineering
-- who were hired after 2019, ordered by age
SELECT name, age, hire_date
FROM employee
WHERE gender = 'Female'
  AND age BETWEEN 25 AND 35
  AND dept_id NOT IN (1)
  AND hire_date > '2019-12-31'
ORDER BY age;
```

### 🎯 Key Interview Points
- **AND has higher precedence than OR** — always use parentheses when mixing them
- `NOT IN (list)` behaves unexpectedly if the list contains NULL — returns no rows
- `BETWEEN` is inclusive: `BETWEEN 28 AND 35` means `>= 28 AND <= 35`
- `IN` is equivalent to multiple `OR` conditions but much cleaner

### ⚠️ Common Mistakes

```sql
-- WRONG: Without parentheses, AND binds tighter than OR
WHERE dept_id = 1 OR dept_id = 2 AND age < 30;
-- Reads as: dept_id=1 OR (dept_id=2 AND age<30)

-- CORRECT:
WHERE (dept_id = 1 OR dept_id = 2) AND age < 30;

-- TRAP: NOT IN with NULL — returns nothing!
WHERE dept_id NOT IN (1, 2, NULL);  -- Always returns empty!
-- NULL comparisons are undefined, so entire IN fails
```

---

## 1.5 ORDER BY & LIMIT

### 💡 Simple Explanation
- **ORDER BY** sorts results. Default is ascending (`ASC`). Use `DESC` for highest-first.
- **LIMIT** caps how many rows are returned. Combine with `OFFSET` for pagination.

### 🏭 Real-World Use Case
A finance dashboard needs the **top 3 highest-paid employees** displayed in a leaderboard widget. A mobile app needs **page 2 of results** (rows 6–10).

### 📝 Basic Queries

```sql
-- Sort by age ascending (default)
SELECT name, age FROM employee ORDER BY age;

-- Sort by salary descending
SELECT name, amount FROM salary ORDER BY amount DESC;

-- Top 3 earners
SELECT name, amount FROM salary ORDER BY amount DESC LIMIT 3;
```

### 📊 Intermediate Queries

```sql
-- Sort by multiple columns: dept first, then age within each dept
SELECT name, dept_id, age FROM employee
ORDER BY dept_id ASC, age DESC;

-- Pagination: skip first 3, get next 3 (page 2 of 3 results per page)
SELECT name, amount FROM salary
ORDER BY amount DESC LIMIT 3 OFFSET 3;
```

### 🔬 Advanced Query

```sql
-- Dynamic ranking: assign position numbers using ORDER BY + variable
-- Find the bottom 2 earners with their rank
SELECT name, amount,
  RANK() OVER (ORDER BY amount ASC) AS salary_rank
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
ORDER BY salary_rank
LIMIT 2;
```

### 🎯 Key Interview Points
- Without `ORDER BY`, row order is **never guaranteed** — don't rely on insertion order
- `LIMIT` is MySQL syntax. SQL Server = `TOP n`, Oracle = `ROWNUM`, PostgreSQL = `LIMIT` (same)
- `OFFSET` starts at 0: `LIMIT 3 OFFSET 0` = rows 1-3, `LIMIT 3 OFFSET 3` = rows 4-6
- `ORDER BY` runs **after SELECT** — so you can use SELECT aliases here

### ⚠️ Common Mistakes

```sql
-- WRONG: Using LIMIT without ORDER BY for "top N" — results are random
SELECT * FROM salary LIMIT 3;  -- could return any 3 rows

-- CORRECT: Always pair LIMIT with ORDER BY for meaningful results
SELECT * FROM salary ORDER BY amount DESC LIMIT 3;

-- WRONG: Using column position without clarity (fragile code)
SELECT name, age, dept_id FROM employee ORDER BY 3;
-- If column order changes, sort breaks silently
```

---

# ═══════════════════════════════════════
# 🔹 SECTION 2 — INTERMEDIATE
# ═══════════════════════════════════════

---

## 2.1 DISTINCT

### 💡 Simple Explanation
`DISTINCT` removes **duplicate rows** from your result set. It applies to the **combination of all selected columns**, not just the first one.

### 🏭 Real-World Use Case
An analyst wants to know which **unique departments currently have employees** — not how many, just which ones exist in the data.

### 📝 Basic Queries

```sql
-- Unique genders in the table
SELECT DISTINCT gender FROM employee;

-- Unique departments that have at least one employee
SELECT DISTINCT dept_id FROM employee;

-- Unique combinations of gender + department
SELECT DISTINCT gender, dept_id FROM employee;
```

### 📊 Intermediate Queries

```sql
-- Count of unique departments with employees
SELECT COUNT(DISTINCT dept_id) AS active_departments FROM employee;

-- Distinct occupations with their salary (unique combinations)
SELECT DISTINCT occupation, amount FROM salary ORDER BY amount DESC;
```

### 🔬 Advanced Query

```sql
-- Find departments that have BOTH male and female employees
SELECT dept_id
FROM employee
GROUP BY dept_id
HAVING COUNT(DISTINCT gender) = 2;
```

### 🎯 Key Interview Points
- `DISTINCT` applies to **all columns in SELECT**, not just the first
- `COUNT(DISTINCT col)` = count of unique non-NULL values — very common in interviews
- `DISTINCT` is slower than regular SELECT because it needs internal sorting/hashing
- `GROUP BY` can often replace `DISTINCT` and is more flexible (you can aggregate)

### ⚠️ Common Mistakes

```sql
-- Common misconception: thinks DISTINCT applies only to name
SELECT DISTINCT name, dept_id FROM employee;
-- This returns unique (name + dept_id) pairs, NOT just unique names

-- DISTINCT vs GROUP BY — same result but GROUP BY is more flexible:
SELECT DISTINCT dept_id FROM employee;
SELECT dept_id FROM employee GROUP BY dept_id;  -- both give same output
```

---

## 2.2 GROUP BY

### 💡 Simple Explanation
`GROUP BY` collapses rows sharing the same value into **a single group** so aggregate functions can compute summaries per group. Think of it as "put all rows with the same value together, then calculate."

### 🏭 Real-World Use Case
HR needs a **headcount per department report**. GROUP BY collapses all employees of each department into one row and COUNT() tallies them.

### 📝 Basic Queries

```sql
-- Employee count per department
SELECT dept_id, COUNT(*) AS headcount
FROM employee
GROUP BY dept_id;

-- Average salary per occupation
SELECT occupation, AVG(amount) AS avg_salary
FROM salary
GROUP BY occupation;

-- Total salary payout per department
SELECT e.dept_id, SUM(s.amount) AS total_payroll
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
GROUP BY e.dept_id;
```

### 📊 Intermediate Queries

```sql
-- Grouped by multiple columns: gender breakdown per department
SELECT dept_id, gender, COUNT(*) AS count
FROM employee
GROUP BY dept_id, gender
ORDER BY dept_id, gender;

-- Min, max, avg salary per department in one query
SELECT e.dept_id,
  MIN(s.amount) AS min_sal,
  MAX(s.amount) AS max_sal,
  ROUND(AVG(s.amount), 2) AS avg_sal
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
GROUP BY e.dept_id;
```

### 🔬 Advanced Query

```sql
-- Department-wise salary summary with department name (3-table)
SELECT d.dept_name,
  COUNT(e.emp_id)  AS headcount,
  SUM(s.amount)    AS total_payroll,
  ROUND(AVG(s.amount), 0) AS avg_salary,
  MAX(s.amount)    AS top_salary
FROM department d
LEFT JOIN employee e  ON d.dept_id = e.dept_id
LEFT JOIN salary s    ON e.emp_id = s.emp_id
GROUP BY d.dept_id, d.dept_name
ORDER BY total_payroll DESC;
```

### 🎯 Key Interview Points
- Every column in SELECT must be either **in GROUP BY** or **inside an aggregate function**
- `GROUP BY` runs **before HAVING** and **after WHERE** in execution order
- NULL values are grouped together in GROUP BY (treated as equal)
- Without an aggregate function, GROUP BY behaves like DISTINCT

### ⚠️ Common Mistakes

```sql
-- WRONG: 'name' is not in GROUP BY or aggregate — causes error or unpredictable result
SELECT dept_id, name, COUNT(*) FROM employee GROUP BY dept_id;

-- CORRECT:
SELECT dept_id, COUNT(*) FROM employee GROUP BY dept_id;

-- MySQL 5.7+ may run the wrong query silently due to sql_mode settings
-- Always check: SELECT @@sql_mode;  -- should include ONLY_FULL_GROUP_BY
```

---

## 2.3 HAVING

### 💡 Simple Explanation
`HAVING` filters **groups** after `GROUP BY`. It is the `WHERE` clause for aggregated results.

> **The golden rule:** `WHERE` filters rows (before grouping) → `HAVING` filters groups (after grouping)

### 🏭 Real-World Use Case
Management wants to identify departments where the **average salary exceeds ₹60,000** — useful for budget review. This requires grouping first, then filtering on the average.

### 📝 Basic Queries

```sql
-- Departments with more than 1 employee
SELECT dept_id, COUNT(*) AS headcount
FROM employee
GROUP BY dept_id
HAVING COUNT(*) > 1;

-- Occupations where average salary exceeds 60000
SELECT occupation, AVG(amount) AS avg_sal
FROM salary
GROUP BY occupation
HAVING AVG(amount) > 60000;
```

### 📊 Intermediate Queries

```sql
-- Departments where avg salary is between 55000 and 80000
SELECT e.dept_id, ROUND(AVG(s.amount), 0) AS avg_sal
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
GROUP BY e.dept_id
HAVING avg_sal BETWEEN 55000 AND 80000;

-- Departments with 2+ employees AND avg salary > 55000
SELECT e.dept_id, COUNT(*) AS cnt, AVG(s.amount) AS avg_sal
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
GROUP BY e.dept_id
HAVING COUNT(*) >= 2 AND AVG(s.amount) > 55000;
```

### 🔬 Advanced Query

```sql
-- Departments whose total payroll is in the top 2
SELECT d.dept_name, SUM(s.amount) AS total_payroll
FROM department d
JOIN employee e ON d.dept_id = e.dept_id
JOIN salary s ON e.emp_id = s.emp_id
GROUP BY d.dept_id, d.dept_name
HAVING total_payroll >= (
  SELECT MIN(dept_total) FROM (
    SELECT SUM(s2.amount) AS dept_total
    FROM employee e2
    JOIN salary s2 ON e2.emp_id = s2.emp_id
    GROUP BY e2.dept_id
    ORDER BY dept_total DESC
    LIMIT 2
  ) AS top2
);
```

### 🎯 Key Interview Points
- `HAVING` can use aggregate functions; `WHERE` cannot — this is the core difference
- In MySQL, you can use a `SELECT` alias in `HAVING` (unlike most other databases)
- You can use `HAVING` without `GROUP BY` — it treats the entire result as one group

### ⚠️ Common Mistakes

```sql
-- WRONG: Aggregate function in WHERE
SELECT dept_id FROM employee
WHERE COUNT(*) > 1
GROUP BY dept_id;   -- ERROR: aggregate not allowed in WHERE

-- CORRECT:
SELECT dept_id FROM employee
GROUP BY dept_id
HAVING COUNT(*) > 1;
```

---

## 2.4 Aggregate Functions (COUNT, SUM, AVG, MIN, MAX)

### 💡 Simple Explanation
Aggregate functions compute a **single value from multiple rows**.

| Function | Returns |
|----------|---------|
| `COUNT(*)` | Total row count including NULLs |
| `COUNT(col)` | Count of non-NULL values in column |
| `SUM(col)` | Total sum of numeric column |
| `AVG(col)` | Average (ignores NULLs) |
| `MIN(col)` | Smallest value |
| `MAX(col)` | Largest value |

### 🏭 Real-World Use Case
A payroll dashboard needs: total employees, total salary expense, average pay, and the highest/lowest salary — all from one query.

### 📝 Basic Queries

```sql
-- Full company salary overview
SELECT
  COUNT(*)        AS total_employees,
  SUM(amount)     AS total_payroll,
  ROUND(AVG(amount), 0) AS avg_salary,
  MIN(amount)     AS lowest_salary,
  MAX(amount)     AS highest_salary
FROM salary;

-- Count only distinct occupations
SELECT COUNT(DISTINCT occupation) AS unique_roles FROM salary;
```

### 📊 Intermediate Queries

```sql
-- Department-wise breakdown
SELECT e.dept_id,
  COUNT(*) AS headcount,
  SUM(s.amount) AS total,
  MAX(s.amount) AS highest
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
GROUP BY e.dept_id;

-- Salary range (spread) per occupation
SELECT occupation,
  MAX(amount) - MIN(amount) AS salary_range
FROM salary
GROUP BY occupation
ORDER BY salary_range DESC;
```

### 🔬 Advanced Query

```sql
-- Salary summary per gender with % contribution to total payroll
SELECT e.gender,
  COUNT(*)                AS headcount,
  SUM(s.amount)           AS total_salary,
  ROUND(AVG(s.amount), 0) AS avg_salary,
  ROUND(SUM(s.amount) * 100.0 / (SELECT SUM(amount) FROM salary), 2) AS payroll_pct
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
GROUP BY e.gender;
```

### 🎯 Key Interview Points
- `COUNT(*)` counts **all rows** including NULLs; `COUNT(column)` **skips NULLs**
- `AVG` ignores NULL values — `AVG(NULL, 10, 20)` = 15 (not 10!)
- `SUM(NULL)` = NULL — wrap with `COALESCE(SUM(col), 0)` to default to 0
- Aggregate functions cannot be used in `WHERE` — use them in `HAVING`

### ⚠️ Common Mistakes

```sql
-- Expecting COUNT(col) to count NULLs — it doesn't
-- Suppose 3 of 7 salary rows have NULL amount:
COUNT(*)      -- returns 7
COUNT(amount) -- returns 4

-- Forgetting COALESCE when SUM could return NULL
SELECT SUM(amount) FROM salary WHERE dept_id = 99;  -- returns NULL
SELECT COALESCE(SUM(amount), 0) FROM salary WHERE dept_id = 99;  -- returns 0
```

---

## 2.5 Joins (INNER, LEFT, RIGHT, SELF JOIN)

### 💡 Simple Explanation
A JOIN combines rows from two tables using a **matching column** (usually a foreign key).

| Join Type | Returns |
|-----------|---------|
| `INNER JOIN` | Only rows with matches in **both** tables |
| `LEFT JOIN` | All rows from left + matched rows from right (NULL if no match) |
| `RIGHT JOIN` | All rows from right + matched rows from left (NULL if no match) |
| `SELF JOIN` | Table joined to itself — for hierarchical/comparative data |

### 🏭 Real-World Use Case
An HR report needs employee name + department name + salary. These live in 3 separate tables — JOINs bring them together. LEFT JOIN ensures we see employees even if their salary hasn't been entered yet.

### 📝 Basic Queries

```sql
-- INNER JOIN: Only employees with salary records
SELECT e.name, s.occupation, s.amount
FROM employee e
INNER JOIN salary s ON e.emp_id = s.emp_id;

-- LEFT JOIN: All employees, NULL if no salary record exists
SELECT e.name, s.amount
FROM employee e
LEFT JOIN salary s ON e.emp_id = s.emp_id;

-- RIGHT JOIN: All departments, even if no employee is assigned
SELECT e.name, d.dept_name
FROM employee e
RIGHT JOIN department d ON e.dept_id = d.dept_id;
```

### 📊 Intermediate Queries

```sql
-- Three-table JOIN: name + department + salary
SELECT e.name, d.dept_name, s.amount
FROM employee e
JOIN department d ON e.dept_id = d.dept_id
JOIN salary s ON e.emp_id = s.emp_id
ORDER BY s.amount DESC;

-- SELF JOIN: Find pairs of employees in the same department
SELECT a.name AS emp1, b.name AS emp2, a.dept_id
FROM employee a
JOIN employee b
  ON a.dept_id = b.dept_id AND a.emp_id < b.emp_id;
```

### 🔬 Advanced Query

```sql
-- Find employees who earn MORE than the average salary of their department
SELECT e.name, d.dept_name, s.amount, dept_avg.avg_sal
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
JOIN department d ON e.dept_id = d.dept_id
JOIN (
  SELECT e2.dept_id, ROUND(AVG(s2.amount), 0) AS avg_sal
  FROM employee e2
  JOIN salary s2 ON e2.emp_id = s2.emp_id
  GROUP BY e2.dept_id
) AS dept_avg ON e.dept_id = dept_avg.dept_id
WHERE s.amount > dept_avg.avg_sal
ORDER BY e.dept_id;
```

### 🎯 Key Interview Points
- `JOIN` and `INNER JOIN` are identical — INNER is the default
- `LEFT JOIN` is the most commonly used in production (preserves all primary table records)
- MySQL does not support `FULL OUTER JOIN` — simulate with `LEFT JOIN UNION ALL RIGHT JOIN`
- Always alias tables (`e`, `s`, `d`) when joining — prevents ambiguity errors

### ⚠️ Common Mistakes

```sql
-- WRONG: Missing ON clause = CROSS JOIN (cartesian product = disaster)
SELECT * FROM employee JOIN salary;
-- Returns 7 × 7 = 49 rows instead of 7

-- CORRECT:
SELECT * FROM employee JOIN salary ON employee.emp_id = salary.emp_id;

-- WRONG: Joining on wrong column (logical error, no SQL error)
SELECT * FROM employee e JOIN salary s ON e.dept_id = s.emp_id;
-- Produces wrong data silently — always double-check your ON condition
```

---

## 2.6 Subqueries

### 💡 Simple Explanation
A subquery is a **SELECT query nested inside another query**. The inner query runs first; its result is passed to the outer query. Think of it as answering a question to answer a bigger question.

### 🏭 Real-World Use Case
Find all employees earning above the company average — you first need the average (inner query), then compare each employee's salary against it (outer query).

### 📝 Basic Queries

```sql
-- Scalar subquery: returns one value
SELECT name FROM employee
WHERE emp_id IN (
  SELECT emp_id FROM salary WHERE amount > 70000
);

-- Find employees earning above average
SELECT name, amount FROM salary
WHERE amount > (SELECT AVG(amount) FROM salary);
```

### 📊 Intermediate Queries

```sql
-- Subquery in FROM (derived table) — must have alias
SELECT dept_id, avg_sal
FROM (
  SELECT e.dept_id, ROUND(AVG(s.amount), 0) AS avg_sal
  FROM employee e
  JOIN salary s ON e.emp_id = s.emp_id
  GROUP BY e.dept_id
) AS dept_averages
WHERE avg_sal > 60000;

-- Correlated subquery: references outer query — runs per row
SELECT e.name, s.amount
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
WHERE s.amount > (
  SELECT AVG(s2.amount)
  FROM employee e2
  JOIN salary s2 ON e2.emp_id = s2.emp_id
  WHERE e2.dept_id = e.dept_id   -- references outer 'e'
);
```

### 🔬 Advanced Query

```sql
-- Find the department with the highest total payroll using a subquery
SELECT d.dept_name, total_payroll.total
FROM department d
JOIN (
  SELECT e.dept_id, SUM(s.amount) AS total
  FROM employee e
  JOIN salary s ON e.emp_id = s.emp_id
  GROUP BY e.dept_id
) AS total_payroll ON d.dept_id = total_payroll.dept_id
WHERE total_payroll.total = (
  SELECT MAX(t.total) FROM (
    SELECT e2.dept_id, SUM(s2.amount) AS total
    FROM employee e2
    JOIN salary s2 ON e2.emp_id = s2.emp_id
    GROUP BY e2.dept_id
  ) AS t
);
```

### 🎯 Key Interview Points
- **Scalar subquery** returns exactly one value; **Row subquery** returns one row; **Table subquery** returns multiple rows
- **Correlated subquery** references the outer query — re-runs for every outer row (expensive!)
- Always alias derived tables (subqueries in FROM): `... ) AS alias_name`
- Replace correlated subqueries with JOINs whenever possible for performance

### ⚠️ Common Mistakes

```sql
-- WRONG: Forgetting alias on derived table
SELECT * FROM (SELECT emp_id FROM salary WHERE amount > 60000);
-- ERROR: Every derived table must have its own alias

-- CORRECT:
SELECT * FROM (SELECT emp_id FROM salary WHERE amount > 60000) AS high_earners;

-- WRONG: Subquery returns multiple rows where one is expected
WHERE amount = (SELECT amount FROM salary WHERE dept_id = 1);
-- ERROR if multiple rows returned — use IN instead
WHERE amount IN (SELECT amount FROM salary WHERE dept_id = 1);
```

---

## 2.7 UNION

### 💡 Simple Explanation
`UNION` stacks results from two SELECT queries vertically (one on top of the other).
- `UNION` — removes duplicate rows (slower — requires deduplication)
- `UNION ALL` — keeps all rows including duplicates (always faster)

**Rule:** Both queries must have the **same number of columns** with **compatible data types**.

### 🏭 Real-World Use Case
Generate a combined "categorized employees" report — tag senior staff (age > 35) and junior staff separately, then display in one list.

### 📝 Basic Queries

```sql
-- Combine employee IDs from two tables (no duplicates)
SELECT emp_id FROM employee
UNION
SELECT emp_id FROM salary;

-- Tag and combine into one labeled report
SELECT name, age, 'Senior' AS category FROM employee WHERE age > 35
UNION
SELECT name, age, 'Junior' AS category FROM employee WHERE age <= 35
ORDER BY age DESC;
```

### 📊 Intermediate Queries

```sql
-- UNION ALL: keep duplicates, faster execution
SELECT emp_id FROM employee
UNION ALL
SELECT emp_id FROM salary;

-- Find employees OR departments that have certain dept IDs
SELECT dept_id, 'employee' AS source FROM employee WHERE dept_id IN (1, 2)
UNION
SELECT dept_id, 'department' AS source FROM department WHERE dept_id IN (1, 2);
```

### 🔬 Advanced Query

```sql
-- Comprehensive staff report: combine different employee categories with labels and sort
SELECT name, amount, 'High Earner'  AS tag FROM salary s JOIN employee e ON s.emp_id = e.emp_id WHERE amount > 80000
UNION ALL
SELECT name, amount, 'Mid Level'    AS tag FROM salary s JOIN employee e ON s.emp_id = e.emp_id WHERE amount BETWEEN 55000 AND 80000
UNION ALL
SELECT name, amount, 'Entry Level'  AS tag FROM salary s JOIN employee e ON s.emp_id = e.emp_id WHERE amount < 55000
ORDER BY amount DESC;
```

### 🎯 Key Interview Points
- Column names in the final result come from the **first** SELECT statement
- `ORDER BY` applies to the **entire UNION result** — put it at the very end
- Use `UNION ALL` whenever you're sure there are no duplicates — it skips deduplication and is faster
- `UNION` vs `JOIN`: UNION = vertical stack; JOIN = horizontal merge

### ⚠️ Common Mistakes

```sql
-- WRONG: Column count mismatch
SELECT name, age FROM employee
UNION
SELECT emp_id FROM salary;  -- ERROR: different column counts

-- WRONG: Putting ORDER BY inside individual UNION parts
SELECT name FROM employee WHERE age > 35 ORDER BY name  -- not allowed inside
UNION
SELECT name FROM employee WHERE age <= 35;

-- CORRECT: ORDER BY only at the end
SELECT name FROM employee WHERE age > 35
UNION
SELECT name FROM employee WHERE age <= 35
ORDER BY name;
```

---

# ═══════════════════════════════════════
# 🔹 SECTION 3 — STRING & DATE FUNCTIONS
# ═══════════════════════════════════════

---

## 3.1 String Functions (LENGTH, CONCAT, UPPER, LOWER, TRIM, SUBSTRING)

### 💡 Simple Explanation
String functions manipulate text data — measure length, join strings, change case, remove spaces, or extract portions.

| Function | Purpose |
|----------|---------|
| `LENGTH(str)` | Count characters (bytes) |
| `CHAR_LENGTH(str)` | Count characters (Unicode safe) |
| `CONCAT(a, b, ...)` | Join strings together |
| `UPPER(str)` | Convert to UPPERCASE |
| `LOWER(str)` | Convert to lowercase |
| `TRIM(str)` | Remove leading and trailing spaces |
| `SUBSTRING(str, start, len)` | Extract a portion (1-indexed) |
| `REPLACE(str, old, new)` | Swap a substring |
| `LIKE 'pattern'` | Pattern matching with wildcards |

### 🏭 Real-World Use Case
A CRM system receives employee name data with inconsistent casing and extra spaces. Before storing, it cleans (TRIM, UPPER), validates length (LENGTH), and generates display names (CONCAT).

### 📝 Basic Queries

```sql
-- LENGTH and CHAR_LENGTH
SELECT name, LENGTH(name) AS byte_len, CHAR_LENGTH(name) AS char_len FROM employee;

-- CONCAT: build a full profile string
SELECT CONCAT(name, ' [', occupation, ']') AS profile
FROM employee e JOIN salary s ON e.emp_id = s.emp_id;

-- UPPER and LOWER
SELECT UPPER(name) AS upper_name, LOWER(occupation) AS lower_occ
FROM employee e JOIN salary s ON e.emp_id = s.emp_id;
```

### 📊 Intermediate Queries

```sql
-- TRIM variants
SELECT
  TRIM('   Alice   ')  AS both_trimmed,   -- 'Alice'
  LTRIM('   Alice')    AS left_trimmed,   -- 'Alice'
  RTRIM('Alice   ')    AS right_trimmed;  -- 'Alice'

-- SUBSTRING: extract initials and short name
SELECT
  name,
  SUBSTRING(name, 1, 1) AS initial,
  SUBSTRING(name, 1, 3) AS short_name
FROM employee;

-- LIKE pattern matching
SELECT name FROM employee WHERE name LIKE 'A%';    -- starts with A
SELECT name FROM employee WHERE name LIKE '%e';    -- ends with e
SELECT name FROM employee WHERE name LIKE '_r%';   -- second letter is 'r'
```

### 🔬 Advanced Query

```sql
-- Data cleaning pipeline: trim, standardize case, validate length, build display name
SELECT
  e.emp_id,
  CONCAT(UPPER(TRIM(e.name)), ' | ', TRIM(s.occupation)) AS display_name,
  CHAR_LENGTH(TRIM(e.name)) AS name_length,
  REPLACE(s.occupation, 'Engineer', 'Developer') AS updated_role,
  CASE
    WHEN CHAR_LENGTH(TRIM(e.name)) < 4 THEN 'Short Name'
    ELSE 'Normal'
  END AS name_flag
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
ORDER BY name_length;
```

### 🎯 Key Interview Points
- `SUBSTRING(str, start, length)` — index starts at **1**, not 0
- `LIKE '%word%'` cannot use indexes — causes a full table scan (use FULLTEXT indexes for text search)
- `LENGTH()` returns **bytes**, not characters — for multibyte (e.g., UTF-8 emojis), use `CHAR_LENGTH()`
- `CONCAT()` returns NULL if **any** argument is NULL — use `CONCAT_WS(separator, ...)` which skips NULLs

### ⚠️ Common Mistakes

```sql
-- WRONG: 0-index assumption
SELECT SUBSTRING('Alice', 0, 3);  -- Returns '' in MySQL (0 = nothing)

-- CORRECT: Start at 1
SELECT SUBSTRING('Alice', 1, 3);  -- Returns 'Ali'

-- WRONG: CONCAT returns NULL if one argument is NULL
SELECT CONCAT('Hello', NULL, 'World');  -- Returns NULL

-- CORRECT: Use CONCAT_WS to skip NULLs
SELECT CONCAT_WS(' ', 'Hello', NULL, 'World');  -- Returns 'Hello World'
```

---

## 3.2 Date Functions (NOW, CURDATE, TIMESTAMPDIFF, DATE_FORMAT)

### 💡 Simple Explanation
Date functions let you work with date/time values — get current time, calculate differences, extract parts, and format for display.

| Function | Returns |
|----------|---------|
| `NOW()` | Current date and time |
| `CURDATE()` | Current date only |
| `CURTIME()` | Current time only |
| `TIMESTAMPDIFF(unit, start, end)` | Difference between two dates |
| `DATEDIFF(date1, date2)` | Days between dates |
| `DATE_ADD(date, INTERVAL n unit)` | Add time to a date |
| `DATE_FORMAT(date, format)` | Format date as string |
| `YEAR/MONTH/DAY(date)` | Extract date parts |

### 🏭 Real-World Use Case
HR needs to calculate employee tenure (years of service), find employees with upcoming work anniversaries, and flag employees hired in the last year for probation review.

### 📝 Basic Queries

```sql
-- Current date and time
SELECT NOW() AS current_datetime, CURDATE() AS today;

-- Employee tenure in years
SELECT name, hire_date,
  TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years_of_service
FROM employee;

-- Extract parts of a date
SELECT name, hire_date,
  YEAR(hire_date)  AS yr,
  MONTH(hire_date) AS mo,
  DAY(hire_date)   AS dy
FROM employee;
```

### 📊 Intermediate Queries

```sql
-- Employees hired in the last 5 years
SELECT name, hire_date
FROM employee
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);

-- Format hire date for display (e.g., "15-Mar-2020")
SELECT name, DATE_FORMAT(hire_date, '%d-%b-%Y') AS formatted_date FROM employee;

-- Days since each employee was hired
SELECT name, hire_date, DATEDIFF(CURDATE(), hire_date) AS days_at_company
FROM employee
ORDER BY days_at_company DESC;
```

### 🔬 Advanced Query

```sql
-- Full tenure report: years, months, work anniversary this year
SELECT
  name,
  hire_date,
  TIMESTAMPDIFF(YEAR, hire_date, CURDATE())  AS full_years,
  TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) % 12 AS extra_months,
  DATE_FORMAT(hire_date, '%d-%b') AS anniversary_date,
  CASE
    WHEN MONTH(hire_date) = MONTH(CURDATE()) THEN '🎉 Work Anniversary This Month!'
    ELSE ''
  END AS anniversary_flag
FROM employee
ORDER BY full_years DESC;
```

### 🎯 Key Interview Points
- `TIMESTAMPDIFF(unit, start_date, end_date)` — always **start first, end second** for positive result
- `DATEDIFF(date1, date2)` = date1 - date2 in days (can be negative if date2 is later)
- Never store dates as VARCHAR — always use `DATE`, `DATETIME`, or `TIMESTAMP` column types
- `TIMESTAMP` auto-updates on row change; `DATETIME` stays fixed unless manually updated

### ⚠️ Common Mistakes

```sql
-- WRONG: Reversed argument order gives negative tenure
SELECT TIMESTAMPDIFF(YEAR, CURDATE(), hire_date);  -- returns negative

-- CORRECT:
SELECT TIMESTAMPDIFF(YEAR, hire_date, CURDATE());  -- returns positive years

-- WRONG: Using function on indexed date column kills index usage
WHERE YEAR(hire_date) = 2020  -- index on hire_date NOT used

-- CORRECT: Range query uses the index
WHERE hire_date BETWEEN '2020-01-01' AND '2020-12-31'
```

---

# ═══════════════════════════════════════
# 🔹 SECTION 4 — ADVANCED SQL
# ═══════════════════════════════════════

---

## 4.1 CASE Statement

### 💡 Simple Explanation
`CASE` is conditional logic inside SQL — like an `if-else` chain. It evaluates conditions top-to-bottom and returns the first match.

```sql
CASE
  WHEN condition1 THEN result1
  WHEN condition2 THEN result2
  ELSE default_result
END
```

### 🏭 Real-World Use Case
A payroll system displays salary bands on a dashboard and calculates tiered performance bonuses — both need conditional logic per row.

### 📝 Basic Queries

```sql
-- Salary band labeling
SELECT name, amount,
  CASE
    WHEN amount < 55000 THEN 'Entry Level'
    WHEN amount BETWEEN 55000 AND 75000 THEN 'Mid Level'
    WHEN amount > 75000 THEN 'Senior Level'
  END AS salary_band
FROM employee e JOIN salary s ON e.emp_id = s.emp_id;

-- Sort by custom priority (not alphabetically)
SELECT dept_name FROM department
ORDER BY
  CASE dept_name
    WHEN 'Engineering' THEN 1
    WHEN 'Finance' THEN 2
    ELSE 3
  END;
```

### 📊 Intermediate Queries

```sql
-- Tiered bonus calculation
SELECT name, amount,
  ROUND(amount * CASE
    WHEN amount < 60000 THEN 0.05
    WHEN amount < 80000 THEN 0.08
    ELSE 0.12
  END, 0) AS bonus
FROM employee e JOIN salary s ON e.emp_id = s.emp_id;

-- Pivot: gender count per department in one row
SELECT dept_id,
  COUNT(CASE WHEN gender = 'Male'   THEN 1 END) AS male_count,
  COUNT(CASE WHEN gender = 'Female' THEN 1 END) AS female_count
FROM employee
GROUP BY dept_id;
```

### 🔬 Advanced Query

```sql
-- Full salary review: band, bonus, new total, flag for review
SELECT
  e.name,
  d.dept_name,
  s.amount AS current_salary,
  CASE WHEN amount < 55000 THEN 'Entry' WHEN amount < 75000 THEN 'Mid' ELSE 'Senior' END AS band,
  ROUND(s.amount * CASE WHEN amount < 55000 THEN 0.05 WHEN amount < 75000 THEN 0.08 ELSE 0.12 END, 0) AS bonus,
  s.amount + ROUND(s.amount * CASE WHEN amount < 55000 THEN 0.05 WHEN amount < 75000 THEN 0.08 ELSE 0.12 END, 0) AS new_total,
  CASE WHEN s.amount < 55000 THEN '⚠ Review Required' ELSE 'OK' END AS review_flag
FROM employee e
JOIN department d ON e.dept_id = d.dept_id
JOIN salary s ON e.emp_id = s.emp_id
ORDER BY s.amount ASC;
```

### 🎯 Key Interview Points
- If no `ELSE` is provided and no condition matches, result is **NULL** — always add ELSE
- `CASE` can be used in `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`, and `HAVING`
- The **pivot pattern** (`COUNT(CASE WHEN ... THEN 1 END)`) is one of the most-asked advanced SQL patterns

### ⚠️ Common Mistakes

```sql
-- WRONG: Forgetting ELSE — silently returns NULL
CASE WHEN amount > 80000 THEN 'High'
     WHEN amount > 50000 THEN 'Medium'
END
-- Employees with amount <= 50000 silently get NULL

-- CORRECT: Always add ELSE
CASE WHEN amount > 80000 THEN 'High'
     WHEN amount > 50000 THEN 'Medium'
     ELSE 'Entry'
END
```

---

## 4.2 Window Functions (ROW_NUMBER, RANK, DENSE_RANK, PARTITION BY)

### 💡 Simple Explanation
Window functions compute calculations **across related rows** without collapsing them like GROUP BY does. Each row keeps its full identity AND gets the computed value alongside.

```sql
function_name() OVER (
  PARTITION BY column   -- define groups (like GROUP BY, but rows stay visible)
  ORDER BY column       -- ordering within each partition
)
```

| Function | Ties handled how |
|----------|-----------------|
| `ROW_NUMBER()` | Always unique — no ties |
| `RANK()` | Ties = same rank, **next rank skipped** |
| `DENSE_RANK()` | Ties = same rank, **no gap** in next rank |
| `SUM/AVG/MIN/MAX OVER()` | Running aggregate |

### 🏭 Real-World Use Case
HR wants each employee's salary alongside their department's average — without losing individual rows. Finance wants to rank employees by salary within each department.

### 📝 Basic Queries

```sql
-- Average salary per department shown beside every employee
SELECT e.name, e.dept_id, s.amount,
  ROUND(AVG(s.amount) OVER(PARTITION BY e.dept_id), 0) AS dept_avg
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id;

-- Running total of salary by employee ID
SELECT e.name, s.amount,
  SUM(s.amount) OVER(ORDER BY e.emp_id) AS running_total
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id;
```

### 📊 Intermediate Queries

```sql
-- Rank employees by salary within each department
SELECT e.name, e.dept_id, s.amount,
  ROW_NUMBER()  OVER(PARTITION BY e.dept_id ORDER BY s.amount DESC) AS row_num,
  RANK()        OVER(PARTITION BY e.dept_id ORDER BY s.amount DESC) AS rnk,
  DENSE_RANK()  OVER(PARTITION BY e.dept_id ORDER BY s.amount DESC) AS dense_rnk
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id;

-- Salary vs department average: show difference
SELECT e.name, s.amount,
  ROUND(AVG(s.amount) OVER(PARTITION BY e.dept_id), 0) AS dept_avg,
  s.amount - ROUND(AVG(s.amount) OVER(PARTITION BY e.dept_id), 0) AS diff_from_avg
FROM employee e JOIN salary s ON e.emp_id = s.emp_id;
```

### 🔬 Advanced Query

```sql
-- Top earner per department + their % of total company payroll
SELECT * FROM (
  SELECT
    e.name,
    d.dept_name,
    s.amount,
    ROUND(AVG(s.amount) OVER(PARTITION BY e.dept_id), 0) AS dept_avg,
    DENSE_RANK() OVER(PARTITION BY e.dept_id ORDER BY s.amount DESC) AS dept_rank,
    ROUND(s.amount * 100.0 / SUM(s.amount) OVER(), 2) AS pct_of_total_payroll
  FROM employee e
  JOIN department d ON e.dept_id = d.dept_id
  JOIN salary s ON e.emp_id = s.emp_id
) ranked
WHERE dept_rank = 1
ORDER BY amount DESC;
```

### 🎯 Key Interview Points
- Window functions **cannot** be used in `WHERE` or `HAVING` — wrap in a subquery or CTE
- `OVER()` with no PARTITION = entire result is one window
- Classic interview Q: *"Find the 2nd highest salary per department"* → `DENSE_RANK() = 2`
- `SUM() OVER(ORDER BY ...)` = running total — a very common reporting pattern

### ⚠️ Common Mistakes

```sql
-- WRONG: Using window function directly in WHERE
SELECT name FROM salary WHERE RANK() OVER(ORDER BY amount DESC) = 1;
-- ERROR: Window functions not allowed in WHERE

-- CORRECT: Wrap in subquery
SELECT name FROM (
  SELECT name, RANK() OVER(ORDER BY amount DESC) AS rnk FROM salary
) ranked
WHERE rnk = 1;

-- Confusing RANK and DENSE_RANK when interviewer asks "2nd highest"
-- RANK() may skip 2 → use DENSE_RANK() to be safe
```

---

## 4.3 CTE — Common Table Expressions

### 💡 Simple Explanation
A CTE is a **named temporary result set** defined at the top of a query with `WITH`. It's like giving a subquery a meaningful name so your query reads like plain English. It exists only for the duration of that single query.

### 🏭 Real-World Use Case
Find employees earning above their department's average — a two-step problem: first calculate department averages (CTE), then compare each employee's salary (main query).

### 📝 Basic Queries

```sql
-- Basic CTE: department average salaries
WITH dept_avg AS (
  SELECT e.dept_id, ROUND(AVG(s.amount), 0) AS avg_sal
  FROM employee e JOIN salary s ON e.emp_id = s.emp_id
  GROUP BY e.dept_id
)
SELECT * FROM dept_avg;

-- Use CTE to find employees above their dept average
WITH dept_avg AS (
  SELECT e.dept_id, ROUND(AVG(s.amount), 0) AS avg_sal
  FROM employee e JOIN salary s ON e.emp_id = s.emp_id
  GROUP BY e.dept_id
)
SELECT e.name, e.dept_id, s.amount, d.avg_sal
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
JOIN dept_avg d ON e.dept_id = d.dept_id
WHERE s.amount > d.avg_sal;
```

### 📊 Intermediate Queries

```sql
-- Multiple CTEs chained with comma
WITH high_earners AS (
  SELECT emp_id FROM salary WHERE amount > 70000
),
senior_staff AS (
  SELECT emp_id FROM employee WHERE age > 35
)
SELECT e.name, s.amount
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
WHERE e.emp_id IN (SELECT emp_id FROM high_earners)
  AND e.emp_id IN (SELECT emp_id FROM senior_staff);
```

### 🔬 Advanced Query

```sql
-- Recursive CTE: generate a number series 1 to 5
WITH RECURSIVE number_series AS (
  SELECT 1 AS n            -- base case
  UNION ALL
  SELECT n + 1             -- recursive step
  FROM number_series
  WHERE n < 5
)
SELECT * FROM number_series;

-- Real use: recursive CTE for org chart (manager → employee chain)
-- (Assumes employee table has a manager_id column)
WITH RECURSIVE org_chart AS (
  SELECT emp_id, name, NULL AS manager_id, 1 AS level
  FROM employee WHERE dept_id = 1 LIMIT 1   -- start from top
  UNION ALL
  SELECT e.emp_id, e.name, oc.emp_id, oc.level + 1
  FROM employee e
  JOIN org_chart oc ON e.dept_id = oc.emp_id
  WHERE oc.level < 3
)
SELECT * FROM org_chart;
```

### 🎯 Key Interview Points
- CTE vs Subquery: CTEs are **more readable** and can be **referenced multiple times** in the same query
- CTE performance is generally similar to subqueries — it's primarily a readability/maintainability win
- **Recursive CTEs** (MySQL 8.0+) are used for hierarchical data like org charts and category trees

### ⚠️ Common Mistakes

```sql
-- WRONG: CTE and its query must be ONE statement — no semicolon between
WITH my_cte AS (SELECT * FROM employee);  -- semicolon here = CTE is gone
SELECT * FROM my_cte;  -- ERROR: table doesn't exist

-- CORRECT: No semicolon between WITH and the main query
WITH my_cte AS (SELECT * FROM employee)
SELECT * FROM my_cte;
```

---

## 4.4 Views

### 💡 Simple Explanation
A view is a **saved SELECT query** stored in the database with a name. It behaves like a virtual table — query it just like any real table. The underlying SELECT re-executes each time the view is queried.

> View = "stored query with a name." It does not store data itself.

### 🏭 Real-World Use Case
A company exposes a simplified employee view to junior analysts — showing name, department, and salary band — without giving them access to raw salary tables with confidential exact figures.

### 📝 Basic Queries

```sql
-- Create a view combining 3 tables
CREATE VIEW employee_overview AS
SELECT e.name, e.age, e.gender, d.dept_name,
       s.occupation, s.amount AS salary
FROM employee e
JOIN department d ON e.dept_id = d.dept_id
JOIN salary s ON e.emp_id = s.emp_id;

-- Query the view like a table
SELECT * FROM employee_overview;

-- Filter on the view
SELECT name, salary FROM employee_overview WHERE salary > 70000;
```

### 📊 Intermediate Queries

```sql
-- Create or replace a view (update without dropping first)
CREATE OR REPLACE VIEW employee_overview AS
SELECT e.name, e.gender, d.dept_name, s.amount
FROM employee e
JOIN department d ON e.dept_id = d.dept_id
JOIN salary s ON e.emp_id = s.emp_id;

-- Use view in another query with aggregation
SELECT dept_name, AVG(amount) AS avg_sal
FROM employee_overview
GROUP BY dept_name;
```

### 🔬 Advanced Query

```sql
-- Security view: expose only non-sensitive data, mask salary as a band
CREATE OR REPLACE VIEW public_employee_view AS
SELECT
  e.emp_id,
  e.name,
  d.dept_name,
  CASE
    WHEN s.amount < 55000 THEN 'Entry Level'
    WHEN s.amount < 80000 THEN 'Mid Level'
    ELSE 'Senior Level'
  END AS salary_band,
  TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) AS tenure_years
FROM employee e
JOIN department d ON e.dept_id = d.dept_id
JOIN salary s ON e.emp_id = s.emp_id;

SELECT * FROM public_employee_view;
```

### 🎯 Key Interview Points
- Views do **not store data** — they store the query; data is always live from the base tables
- **Updatable views:** Simple views (single table, no GROUP BY, no aggregate) can be INSERT/UPDATE-d
- Views improve **security** (hide columns), **simplicity** (hide complex joins), and **consistency**
- **Materialized views** (PostgreSQL/Oracle) physically store the data — MySQL doesn't have them natively

### ⚠️ Common Mistakes
- Thinking views improve query performance — they don't (the underlying query still runs each time)
- Trying to `ORDER BY` inside a view definition in MySQL — it's ignored when querying the view
- Using views to "cache" results — use a temporary table or application-level cache instead

---

## 4.5 Indexes

### 💡 Simple Explanation
An index is a **data structure that speeds up data retrieval** — like a book's index. Without one, MySQL reads every single row to find matches (full table scan). With one, it jumps directly to the matching rows.

> Trade-off: Indexes make **reads faster** but **writes slightly slower** (index must be maintained on INSERT/UPDATE/DELETE).

### 🏭 Real-World Use Case
A salary table with 5 million rows. `WHERE emp_id = 12345` without index = scan all 5M rows. With an index = microsecond lookup. At scale, indexes are the single biggest performance lever.

### 📝 Basic Queries

```sql
-- Create a simple index on a frequently filtered column
CREATE INDEX idx_dept_id ON employee(dept_id);

-- Create a unique index (also enforces no duplicates)
CREATE UNIQUE INDEX idx_emp_name ON employee(name);

-- Check indexes on a table
SHOW INDEX FROM employee;

-- Drop an index
DROP INDEX idx_dept_id ON employee;
```

### 📊 Intermediate Queries

```sql
-- Composite index: best for queries filtering on both columns together
CREATE INDEX idx_dept_gender ON employee(dept_id, gender);

-- Check if your query uses an index
EXPLAIN SELECT * FROM employee WHERE dept_id = 1;
-- Look for: type = 'ref' (good) vs type = 'ALL' (bad = full scan)
```

### 🔬 Advanced Query

```sql
-- Demonstrate index vs no-index behavior using EXPLAIN
-- Without index:
DROP INDEX idx_dept_id ON employee;
EXPLAIN SELECT * FROM employee WHERE dept_id = 1;
-- type: ALL, key: NULL — full scan

-- With index:
CREATE INDEX idx_dept_id ON employee(dept_id);
EXPLAIN SELECT * FROM employee WHERE dept_id = 1;
-- type: ref, key: idx_dept_id — index used

-- Force MySQL to use a specific index (when optimizer chooses wrong)
SELECT * FROM employee USE INDEX (idx_dept_id) WHERE dept_id = 1;
```

### 🎯 Key Interview Points
- **Primary key = clustered index** in InnoDB — one per table, rows physically sorted by it
- **Non-clustered index** = separate structure with pointers — multiple allowed
- Composite index `(a, b)` helps queries on `a` alone, but **NOT** queries on `b` alone (leftmost prefix rule)
- `EXPLAIN` is the most important tool for index debugging — always use it on slow queries

### ⚠️ Common Mistakes

```sql
-- Index won't fire when you wrap column in a function
WHERE YEAR(hire_date) = 2020          -- index on hire_date NOT used
WHERE UPPER(name) = 'ALICE'           -- index on name NOT used

-- CORRECT: restructure query so raw column is compared
WHERE hire_date BETWEEN '2020-01-01' AND '2020-12-31'  -- index used
WHERE name = 'Alice'                  -- index used (case-insensitive by default)

-- Adding indexes on every column — too many indexes slow down writes
-- Rule: index columns used in WHERE, JOIN ON, ORDER BY — not everything
```

---

# ═══════════════════════════════════════
# 🔹 SECTION 5 — DATABASE DESIGN
# ═══════════════════════════════════════

---

## 5.1 Primary Key & Foreign Key

### 💡 Simple Explanation
- **Primary Key (PK):** Uniquely identifies each row. Cannot be NULL. Cannot be duplicate. One per table.
- **Foreign Key (FK):** A column in one table that **references the PK of another table**. Enforces that a value must exist in the parent table before being used in the child table.

### 🏭 Real-World Use Case
In a school system: `student_id` is the PK in `Students`. In `Enrollments`, `student_id` is a FK. You cannot enroll a student who doesn't exist.

### 📝 Basic Queries

```sql
-- Table with PK
CREATE TABLE department (
  dept_id   INT PRIMARY KEY,
  dept_name VARCHAR(50) NOT NULL
);

-- Table with FK referencing department
CREATE TABLE employee (
  emp_id  INT PRIMARY KEY,
  name    VARCHAR(50),
  dept_id INT,
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);
```

### 📊 Intermediate Queries

```sql
-- ON DELETE CASCADE: delete employee when department is deleted
CREATE TABLE employee (
  emp_id  INT PRIMARY KEY,
  name    VARCHAR(50),
  dept_id INT,
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- ON DELETE SET NULL: department deleted → set dept_id to NULL in employee
-- ON DELETE RESTRICT: prevent department deletion if employees exist
```

### 🔬 Advanced Query

```sql
-- Composite primary key (when no single column is unique alone)
CREATE TABLE enrollment (
  student_id INT,
  course_id  INT,
  enrolled_on DATE,
  PRIMARY KEY (student_id, course_id),   -- combination is unique
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id)  REFERENCES courses(course_id)
);
```

### 🎯 Key Interview Points
- A table can have only **one Primary Key** but **multiple Foreign Keys**
- FK columns can be NULL — meaning the relationship is optional
- Referential integrity: FK prevents orphan records (child without parent)
- `ON DELETE CASCADE` vs `ON DELETE SET NULL` vs `ON DELETE RESTRICT` — know these options

### ⚠️ Common Mistakes
- Confusing PK and UNIQUE — PK cannot be NULL; UNIQUE allows one NULL
- Forgetting to index FK columns — MySQL does this automatically for declared FKs, but explicit is safer

---

## 5.2 Normalization (1NF, 2NF, 3NF)

### 💡 Simple Explanation
Normalization organizes tables to **eliminate data redundancy** and prevent three types of anomalies:
- **Insertion anomaly:** Can't add data without entering unrelated data
- **Update anomaly:** Same info in many rows — update one, forget others
- **Deletion anomaly:** Deleting a row accidentally removes other needed info

---

### 1NF — Each cell holds ONE atomic value, no repeating groups

❌ Violates 1NF:
| emp_id | name | skills |
|--------|------|--------|
| 1 | Alice | SQL, Python, Excel |

✅ 1NF:
| emp_id | name | skill |
|--------|------|-------|
| 1 | Alice | SQL |
| 1 | Alice | Python |
| 1 | Alice | Excel |

---

### 2NF — No partial dependency (only matters for composite primary keys)

❌ Violates 2NF: (student_id, course_id) is PK, but student_name depends only on student_id
| student_id | course_id | student_name | course_name |
|------------|-----------|--------------|-------------|

✅ 2NF: Split into three tables:
```sql
Students(student_id, student_name)
Courses(course_id, course_name)
Enrollment(student_id, course_id)
```

---

### 3NF — No transitive dependency (non-key column depends on another non-key column)

❌ Violates 3NF: dept_name depends on dept_id, not on emp_id
| emp_id | dept_id | dept_name |
|--------|---------|-----------|

✅ 3NF: Split into two tables:
```sql
Employee(emp_id, dept_id)
Department(dept_id, dept_name)
```

### 🎯 Key Interview Points
- Most production databases are designed to **3NF**
- **Denormalization** (adding redundancy back) is used in data warehouses for faster reads
- BCNF is stricter than 3NF — handles edge cases where 3NF still allows anomalies
- The real test: "Does every non-key column depend on THE KEY, THE WHOLE KEY, AND NOTHING BUT THE KEY?"

---

# ═══════════════════════════════════════
# 🔹 SECTION 6 — TRANSACTIONS & CONTROL
# ═══════════════════════════════════════

---

## 6.1 ACID Properties

### 💡 Simple Explanation

| Property | Meaning | Real Example |
|----------|---------|-------------|
| **Atomicity** | All or nothing | Bank transfer: debit + credit both succeed or both fail |
| **Consistency** | Always valid state | Can't transfer more than balance |
| **Isolation** | Transactions don't interfere | Two users booking last flight seat — only one wins |
| **Durability** | Committed = permanent | "Order confirmed" survives a server crash |

### 🎯 Key Interview Points
- **InnoDB** supports full ACID; **MyISAM** does NOT
- Isolation levels (READ UNCOMMITTED → SERIALIZABLE) control how much transactions see each other
- Atomicity is enforced by ROLLBACK on failure
- Durability is achieved through **write-ahead logging (WAL)**

---

## 6.2 Transactions (COMMIT, ROLLBACK, SAVEPOINT)

### 📝 Basic Queries

```sql
-- Start and commit a transaction
START TRANSACTION;
UPDATE salary SET amount = amount + 5000 WHERE emp_id = 1;
COMMIT;  -- make it permanent

-- Start and rollback a transaction
START TRANSACTION;
DELETE FROM employee WHERE emp_id = 5;
ROLLBACK;  -- undo everything back
```

### 📊 Intermediate Queries

```sql
-- SAVEPOINT: create a checkpoint mid-transaction
START TRANSACTION;
UPDATE salary SET amount = amount - 5000 WHERE emp_id = 4;
SAVEPOINT after_debit;

UPDATE salary SET amount = amount + 5000 WHERE emp_id = 7;
SAVEPOINT after_credit;

-- Oops — undo only to after_debit, keep the debit
ROLLBACK TO after_debit;

COMMIT;
```

### 🔬 Advanced Query

```sql
-- Simulate a safe transfer with error handling logic (in stored procedure)
DELIMITER $$
CREATE PROCEDURE safe_transfer(IN from_id INT, IN to_id INT, IN transfer_amount INT)
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SELECT 'Transfer Failed — Rolled Back' AS result;
  END;

  START TRANSACTION;
    UPDATE salary SET amount = amount - transfer_amount WHERE emp_id = from_id;
    UPDATE salary SET amount = amount + transfer_amount WHERE emp_id = to_id;
  COMMIT;
  SELECT 'Transfer Successful' AS result;
END $$
DELIMITER ;

CALL safe_transfer(4, 1, 5000);
```

### ⚠️ Common Mistakes
- DDL statements (CREATE, DROP, TRUNCATE) **auto-commit** — they end any open transaction
- MySQL auto-commit is ON by default — each single statement is its own transaction unless you explicitly use `START TRANSACTION`

---

## 6.3 DCL — GRANT & REVOKE

### 📝 Basic Queries

```sql
-- Grant read and write (not delete) to an analyst
GRANT SELECT, INSERT, UPDATE ON employees.* TO 'analyst'@'localhost';

-- Remove a specific permission
REVOKE INSERT ON employees.* FROM 'analyst'@'localhost';

-- Full access for admin
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%';
```

### 📊 Intermediate Query

```sql
-- Check what permissions a user has
SHOW GRANTS FOR 'analyst'@'localhost';

-- Revoke all permissions at once
REVOKE ALL PRIVILEGES ON employees.* FROM 'analyst'@'localhost';

-- Apply changes immediately
FLUSH PRIVILEGES;
```

### 🎯 Key Interview Points
- `'user'@'%'` = connect from **any host**; `'user'@'localhost'` = only local machine
- Always apply **principle of least privilege** — grant only what's needed, nothing more
- GRANT and REVOKE do not require COMMIT — they take effect immediately

---

# ═══════════════════════════════════════
# 🔹 SECTION 7 — STORED PROCEDURES & FUNCTIONS
# ═══════════════════════════════════════

---

## 7.1 Stored Procedures

### 💡 Simple Explanation
A stored procedure is a **named, saved SQL block** executed with `CALL`. Write complex logic once, call it any number of times. Supports parameters, multiple statements, loops, and conditionals.

### 🏭 Real-World Use Case
The payroll team runs a monthly salary report. Instead of rewriting the query every time, they call `CALL monthly_payroll_report(11, 2024)` — no SQL knowledge needed.

### 📝 Basic Queries

```sql
-- Simple procedure: no parameters
DELIMITER $$
CREATE PROCEDURE show_all_employees()
BEGIN
  SELECT * FROM employee;
END $$
DELIMITER ;

CALL show_all_employees();

-- Procedure with IN parameter
DELIMITER $$
CREATE PROCEDURE get_by_dept(IN dept INT)
BEGIN
  SELECT e.name, s.amount FROM employee e
  JOIN salary s ON e.emp_id = s.emp_id
  WHERE e.dept_id = dept;
END $$
DELIMITER ;

CALL get_by_dept(1);
```

### 📊 Intermediate Queries

```sql
-- Procedure with OUT parameter
DELIMITER $$
CREATE PROCEDURE dept_total_salary(IN dept INT, OUT total INT)
BEGIN
  SELECT SUM(s.amount) INTO total
  FROM employee e
  JOIN salary s ON e.emp_id = s.emp_id
  WHERE e.dept_id = dept;
END $$
DELIMITER ;

CALL dept_total_salary(1, @result);
SELECT @result AS dept_total;

-- Procedure with IF logic
DELIMITER $$
CREATE PROCEDURE categorize_salary(IN emp INT)
BEGIN
  DECLARE sal INT;
  SELECT amount INTO sal FROM salary WHERE emp_id = emp;
  IF sal > 80000 THEN
    SELECT 'Senior Level' AS category;
  ELSEIF sal > 55000 THEN
    SELECT 'Mid Level' AS category;
  ELSE
    SELECT 'Entry Level' AS category;
  END IF;
END $$
DELIMITER ;

CALL categorize_salary(1);
```

### 🔬 Advanced Query

```sql
-- Procedure with LOOP: apply bonus to all employees in a department
DELIMITER $$
CREATE PROCEDURE apply_dept_bonus(IN dept INT, IN bonus_pct DECIMAL(5,2))
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE eid INT;
  DECLARE cur CURSOR FOR
    SELECT emp_id FROM employee WHERE dept_id = dept;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  bonus_loop: LOOP
    FETCH cur INTO eid;
    IF done THEN LEAVE bonus_loop; END IF;
    UPDATE salary SET amount = amount + (amount * bonus_pct / 100) WHERE emp_id = eid;
  END LOOP;
  CLOSE cur;
  SELECT CONCAT('Bonus applied to dept ', dept) AS status;
END $$
DELIMITER ;

CALL apply_dept_bonus(1, 10.0);  -- 10% bonus to all Engineering employees
```

### 🎯 Key Interview Points
- `DELIMITER $$` changes the statement terminator so `;` inside the procedure doesn't end it early
- `IN` = input, `OUT` = output, `INOUT` = both
- Procedures can contain DML, DDL, flow control (IF/LOOP/WHILE), and error handling
- Use `DROP PROCEDURE IF EXISTS proc_name` before recreating to avoid errors

### ⚠️ Common Mistakes

```sql
-- WRONG: Forgetting to reset DELIMITER after
DELIMITER $$
CREATE PROCEDURE test() BEGIN SELECT 1; END $$
-- WRONG: Missing DELIMITER ; at the end — subsequent queries will break

-- CORRECT: Always reset delimiter
DELIMITER $$
CREATE PROCEDURE test() BEGIN SELECT 1; END $$
DELIMITER ;   -- reset back to default
```

---

## 7.2 Stored Functions vs Procedures

| Feature | Procedure | Function |
|---------|-----------|---------|
| Returns value | Optional (OUT) | **Must** return a value |
| Called with | `CALL name()` | `SELECT name()` |
| Use in SELECT | ❌ | ✅ |
| Multiple statements | ✅ | ✅ |
| Transaction control | ✅ | ❌ |

```sql
-- Stored Function: usable inline in SELECT
DELIMITER $$
CREATE FUNCTION salary_band(sal INT)
RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
  IF sal > 80000   THEN RETURN 'Senior';
  ELSEIF sal > 55000 THEN RETURN 'Mid';
  ELSE RETURN 'Entry';
  END IF;
END $$
DELIMITER ;

-- Use like any built-in function
SELECT name, amount, salary_band(amount) AS band
FROM employee e JOIN salary s ON e.emp_id = s.emp_id;
```

---

# ═══════════════════════════════════════
# 🔹 SECTION 8 — PERFORMANCE & OPTIMIZATION
# ═══════════════════════════════════════

---

## 8.1 Query Optimization Basics

### 💡 Simple Explanation
A slow query wastes server resources and creates bad user experience. Optimization means rewriting queries and structuring data so MySQL finds answers with minimal work.

**Start with EXPLAIN — always.**

```sql
EXPLAIN SELECT e.name, s.amount
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
WHERE e.dept_id = 1;
```

### Reading EXPLAIN output

| Column | What to look for |
|--------|-----------------|
| `type` | `const`/`ref` = good ✅; `ALL` = full scan = bad ❌ |
| `key` | Which index used — NULL means no index |
| `rows` | Estimated rows scanned — lower is better |
| `Extra` | `Using filesort` or `Using temporary` = warning signs |

---

## 8.2 Index Usage Rules

### 📝 Basic

```sql
-- ✅ Index used: raw column in WHERE
SELECT * FROM employee WHERE dept_id = 1;

-- ❌ Index NOT used: function wraps the column
SELECT * FROM employee WHERE YEAR(hire_date) = 2020;

-- ✅ Rewrite to use index
SELECT * FROM employee WHERE hire_date BETWEEN '2020-01-01' AND '2020-12-31';
```

### 📊 Intermediate

```sql
-- ❌ Leading wildcard kills index
SELECT * FROM employee WHERE name LIKE '%lice';

-- ✅ Trailing wildcard still uses index
SELECT * FROM employee WHERE name LIKE 'Al%';

-- ❌ Implicit type conversion disables index (dept_id is INT)
SELECT * FROM employee WHERE dept_id = '1';   -- string vs int

-- ✅ Matching type
SELECT * FROM employee WHERE dept_id = 1;
```

### 🔬 Advanced

```sql
-- Covering index: index includes all columns the query needs — no table lookup needed
CREATE INDEX idx_covering ON employee(dept_id, name, age);

-- Query only touches the index (extremely fast)
SELECT name, age FROM employee WHERE dept_id = 1;

-- Composite index leftmost prefix rule:
-- Index on (dept_id, gender) helps:
--   WHERE dept_id = 1             ✅
--   WHERE dept_id = 1 AND gender = 'F' ✅
--   WHERE gender = 'F'            ❌ (leftmost column not used)
```

---

## 8.3 Top Optimization Techniques

```sql
-- 1. SELECT only columns you need
-- ❌ Bad
SELECT * FROM salary WHERE emp_id = 1;
-- ✅ Good
SELECT amount FROM salary WHERE emp_id = 1;

-- 2. Filter early with WHERE before JOIN
-- ❌ Bad: join all rows, then filter
SELECT * FROM employee e JOIN salary s ON e.emp_id = s.emp_id WHERE e.dept_id = 1;
-- ✅ Good: same query, but add index on dept_id so WHERE filters before join

-- 3. Avoid OR on different columns (use UNION instead)
-- ❌ May skip indexes
SELECT * FROM employee WHERE dept_id = 1 OR age = 30;
-- ✅ Each side can use its own index
SELECT * FROM employee WHERE dept_id = 1
UNION
SELECT * FROM employee WHERE age = 30;

-- 4. Use EXISTS instead of IN for large subqueries (often faster)
-- ❌ IN loads all results
SELECT name FROM employee WHERE emp_id IN (SELECT emp_id FROM salary WHERE amount > 80000);
-- ✅ EXISTS stops at first match
SELECT name FROM employee e WHERE EXISTS (SELECT 1 FROM salary s WHERE s.emp_id = e.emp_id AND s.amount > 80000);
```

---

# ═══════════════════════════════════════
# 🔹 SECTION 9 — INTERVIEW PREPARATION
# ═══════════════════════════════════════

---

## 🔥 Most Asked SQL Interview Questions

---

### Q1: Difference between DELETE, TRUNCATE, and DROP?

| | DELETE | TRUNCATE | DROP |
|--|--------|---------|------|
| Removes | Selected rows | All rows | Entire table |
| WHERE | ✅ | ❌ | ❌ |
| Rollback | ✅ | ❌ | ❌ |
| Triggers | ✅ | ❌ | ❌ |
| Resets AUTO_INCREMENT | ❌ | ✅ | — |
| Type | DML | DDL | DDL |

---

### Q2: Find the Nth highest salary

```sql
-- Method 1: DENSE_RANK (best — handles ties)
SELECT amount FROM (
  SELECT amount, DENSE_RANK() OVER(ORDER BY amount DESC) AS rnk
  FROM salary
) ranked
WHERE rnk = 2;

-- Method 2: Subquery
SELECT MAX(amount) FROM salary
WHERE amount < (SELECT MAX(amount) FROM salary);

-- Method 3: LIMIT OFFSET (fragile — no tie handling)
SELECT DISTINCT amount FROM salary ORDER BY amount DESC LIMIT 1 OFFSET 1;
```

---

### Q3: Find duplicate records and delete them

```sql
-- Find duplicates
SELECT name, COUNT(*) FROM employee GROUP BY name HAVING COUNT(*) > 1;

-- Delete duplicates, keep lowest emp_id
DELETE FROM employee
WHERE emp_id NOT IN (
  SELECT min_id FROM (
    SELECT MIN(emp_id) AS min_id FROM employee GROUP BY name
  ) AS keepers
);
```

---

### Q4: Find employees who have no salary record

```sql
-- Method 1: LEFT JOIN + IS NULL
SELECT e.name FROM employee e
LEFT JOIN salary s ON e.emp_id = s.emp_id
WHERE s.emp_id IS NULL;

-- Method 2: NOT EXISTS (often faster)
SELECT name FROM employee e
WHERE NOT EXISTS (
  SELECT 1 FROM salary s WHERE s.emp_id = e.emp_id
);

-- Method 3: NOT IN (avoid if subquery can return NULLs)
SELECT name FROM employee WHERE emp_id NOT IN (SELECT emp_id FROM salary);
```

---

### Q5: Top earner per department

```sql
SELECT name, dept_id, amount FROM (
  SELECT e.name, e.dept_id, s.amount,
    ROW_NUMBER() OVER(PARTITION BY e.dept_id ORDER BY s.amount DESC) AS rn
  FROM employee e JOIN salary s ON e.emp_id = s.emp_id
) ranked
WHERE rn = 1;
```

---

### Q6: Running total of salaries

```sql
SELECT e.name, s.amount,
  SUM(s.amount) OVER(ORDER BY e.emp_id) AS running_total
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id;
```

---

### Q7: Count employees per department including departments with zero employees

```sql
SELECT d.dept_name, COUNT(e.emp_id) AS headcount
FROM department d
LEFT JOIN employee e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY headcount DESC;
```

---

### Q8: Tricky NULL questions

```sql
-- NULL = NULL is NULL (not TRUE)
SELECT NULL = NULL;   -- returns NULL

-- Use IS NULL / IS NOT NULL
SELECT * FROM salary WHERE amount IS NULL;

-- NULLs in aggregates
SELECT AVG(amount) FROM salary;     -- NULLs ignored
SELECT COUNT(*) FROM salary;        -- counts all rows
SELECT COUNT(amount) FROM salary;   -- skips NULLs

-- Safe NULL handling
SELECT name, COALESCE(amount, 0) AS salary FROM salary;
SELECT name, IFNULL(amount, 0) AS salary FROM salary;
```

---

### Q9: Swap column values between two rows without a temp variable

```sql
-- Classic puzzle: swap salaries of emp_id 1 and 2
UPDATE salary s1
JOIN salary s2 ON s1.emp_id IN (1, 2) AND s2.emp_id IN (1, 2) AND s1.emp_id != s2.emp_id
SET s1.amount = s2.amount
WHERE s1.emp_id = 1;
-- Cleaner approach using CASE
UPDATE salary
SET amount = CASE
  WHEN emp_id = 1 THEN (SELECT amount FROM (SELECT amount FROM salary WHERE emp_id = 2) t)
  WHEN emp_id = 2 THEN (SELECT amount FROM (SELECT amount FROM salary WHERE emp_id = 1) t)
END
WHERE emp_id IN (1, 2);
```

---

### Q10: Optimization — find employees in dept 1 with salary > 60000 (efficient)

```sql
-- Step 1: Check if indexes exist
SHOW INDEX FROM employee;
SHOW INDEX FROM salary;

-- Step 2: Run EXPLAIN to check plan
EXPLAIN
SELECT e.name, s.amount
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
WHERE e.dept_id = 1 AND s.amount > 60000;

-- Step 3: Add indexes if missing
CREATE INDEX idx_dept ON employee(dept_id);
CREATE INDEX idx_amount ON salary(amount);

-- Step 4: Re-run EXPLAIN — confirm 'ref' or 'range' instead of 'ALL'
```

---

## ⚡ SQL Execution Order — Quick Revision

```
1. FROM          — load table(s)
2. JOIN          — merge tables
3. WHERE         — filter rows        ← no aliases, no aggregates
4. GROUP BY      — group rows
5. HAVING        — filter groups      ← aggregates allowed
6. SELECT        — choose columns     ← aliases created here
7. DISTINCT      — remove duplicates
8. ORDER BY      — sort results       ← aliases usable here
9. LIMIT/OFFSET  — trim output
```

---

## ⚡ One-Line Summaries for Last-Minute Revision

| Concept | One Line |
|---------|---------|
| Primary Key | Unique + NOT NULL row identifier — one per table |
| Foreign Key | References PK in another table — enforces referential integrity |
| INNER JOIN | Only matching rows from both tables |
| LEFT JOIN | All left rows + matched right rows (NULL if no match) |
| GROUP BY | Collapse rows into groups for aggregation |
| HAVING | Filter groups after GROUP BY — can use aggregates |
| WHERE | Filter rows before grouping — cannot use aggregates |
| DISTINCT | Remove duplicate rows from result |
| CASE | Inline if-else logic per row |
| ROW_NUMBER | Unique sequential number — no ties |
| RANK | Same rank for ties, skips next rank |
| DENSE_RANK | Same rank for ties, no gap in next rank |
| CTE | Named temp result set using WITH — lives for one query |
| View | Saved SELECT query — virtual table, no physical data |
| Index | Data structure for fast lookups — makes reads faster |
| 1NF | Each cell = one atomic value, no repeating groups |
| 2NF | No partial dependency on composite key |
| 3NF | No transitive dependency between non-key columns |
| ACID | Atomicity, Consistency, Isolation, Durability |
| Correlated Subquery | Subquery that references outer query — runs per row |
| COMMIT | Permanently save transaction |
| ROLLBACK | Undo all changes in transaction |
| SAVEPOINT | Checkpoint within a transaction |

---

*Consistency beats intensity — run every query yourself in MySQL Workbench.*
*Understanding comes from doing, not just reading.*
