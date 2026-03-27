# 📚 DBMS Complete Interview Guide
> Authoritative explanations of every core concept — written for technical interviews.

---

## Table of Contents
1. [What is DBMS?](#1-what-is-dbms)
2. [DBMS vs RDBMS vs File System](#2-dbms-vs-rdbms-vs-file-system)
3. [Keys in DBMS](#3-keys-in-dbms)
4. [Normalization](#4-normalization)
5. [ACID Properties](#5-acid-properties)
6. [Transactions](#6-transactions)
7. [SQL Clauses & Execution Order](#7-sql-clauses--execution-order)
8. [Joins](#8-joins)
9. [Indexes](#9-indexes)
10. [Views](#10-views)
11. [Stored Procedures vs Functions](#11-stored-procedures-vs-functions)
12. [Triggers](#12-triggers)
13. [Cursors](#13-cursors)
14. [Concurrency Control](#14-concurrency-control)
15. [Locking Mechanisms](#15-locking-mechanisms)
16. [Deadlock](#16-deadlock)
17. [ER Model](#17-er-model)
18. [Relational Algebra](#18-relational-algebra)
19. [Hashing & Indexing Techniques](#19-hashing--indexing-techniques)
20. [CAP Theorem](#20-cap-theorem)
21. [NoSQL vs SQL](#21-nosql-vs-sql)
22. [DCL & TCL](#22-dcl--tcl)
23. [Window Functions](#23-window-functions)
24. [CTEs & Subqueries](#24-ctes--subqueries)
25. [Top Interview Questions & Answers](#25-top-interview-questions--answers)

---

## 1. What is DBMS?

**Definition:**
A **Database Management System (DBMS)** is software that manages the storage, retrieval, and manipulation of structured data. It acts as an interface between the user/application and the physical database.

**Why it exists:**
Before DBMS, data was stored in flat files. Problems included data redundancy, inconsistency, no concurrent access, no security, and no crash recovery. DBMS solves all of these.

**Core functions of a DBMS:**
- Data definition (create/alter/drop structures)
- Data manipulation (insert/update/delete/query)
- Data security and access control
- Concurrency control (multiple users at once)
- Crash recovery and backup
- Data integrity enforcement

**Examples:** MySQL, PostgreSQL, Oracle, SQL Server, SQLite

---

## 2. DBMS vs RDBMS vs File System

| Feature | File System | DBMS | RDBMS |
|---------|-------------|------|-------|
| Data structure | Flat files | Any model | Tables (relations) |
| Redundancy | High | Controlled | Minimized via normalization |
| Relationships | None | Optional | Enforced via foreign keys |
| ACID support | No | Partial | Yes |
| Query language | No | Varies | SQL |
| Concurrency | No | Yes | Yes |
| Examples | .csv, .txt | MongoDB | MySQL, PostgreSQL |

**Key point for interviews:**
> RDBMS is a subset of DBMS. Every RDBMS is a DBMS, but not every DBMS is an RDBMS.

---

## 3. Keys in DBMS

Keys uniquely identify rows and establish relationships between tables.

### Primary Key
- Uniquely identifies each row in a table
- Cannot be NULL, cannot be duplicate
- Only **one** primary key per table

```sql
CREATE TABLE employee (
  employee_id INT PRIMARY KEY,
  name VARCHAR(50)
);
```

### Candidate Key
- A column (or set of columns) that **could** be a primary key
- Every table can have multiple candidate keys
- One candidate key is chosen as primary key; the rest become **alternate keys**

> Example: In an Employee table, both `employee_id` and `email` can uniquely identify a row — both are candidate keys.

### Composite Key
- A primary key made of **two or more columns** together
- Neither column alone is unique — only the combination is

```sql
PRIMARY KEY (student_id, course_id)  -- Enrollment table
```

### Foreign Key
- A column in one table that **references the primary key** of another table
- Enforces **referential integrity** — you can't insert a value that doesn't exist in the parent table

```sql
FOREIGN KEY (dept_id) REFERENCES parks_departments(department_id)
```

### Super Key
- Any set of columns that can uniquely identify a row
- Primary key is the **minimal** super key
- `{employee_id}`, `{employee_id, name}`, `{employee_id, name, age}` are all super keys

### Unique Key
- Like a primary key but **allows one NULL**
- Prevents duplicates but is not the main identifier

### Summary Table

| Key Type | Unique | NULL allowed | Count per table |
|----------|--------|--------------|-----------------|
| Primary | ✅ | ❌ | 1 |
| Candidate | ✅ | ❌ | Multiple |
| Alternate | ✅ | ❌ | Multiple |
| Unique | ✅ | ✅ (one) | Multiple |
| Foreign | ❌ | ✅ | Multiple |
| Composite | Together ✅ | ❌ | Multiple |
| Super | ✅ | ❌ | Many |

---

## 4. Normalization

**Definition:**
Normalization is the process of organizing a database to **reduce data redundancy** and **improve data integrity** by dividing large tables into smaller, related tables.

**The problem it solves:**
Without normalization you get:
- **Insertion anomaly** — can't add data without unrelated data
- **Update anomaly** — same data in multiple rows; update one, forget others
- **Deletion anomaly** — deleting one row accidentally removes other useful data

---

### 1NF — First Normal Form
**Rule:** Every column must hold **atomic (indivisible) values**. No repeating groups.

❌ Violates 1NF:
| emp_id | name | skills |
|--------|------|--------|
| 1 | Leslie | SQL, Excel, Python |

✅ 1NF:
| emp_id | name | skill |
|--------|------|-------|
| 1 | Leslie | SQL |
| 1 | Leslie | Excel |
| 1 | Leslie | Python |

---

### 2NF — Second Normal Form
**Rule:** Must be in 1NF + every non-key column must depend on the **entire** primary key (no partial dependency).
Applies only when the primary key is composite.

❌ Violates 2NF:
| student_id | course_id | student_name | course_name |
`student_name` depends only on `student_id` — not on the full `(student_id, course_id)` key.

✅ 2NF: Split into `Students(student_id, student_name)` and `Courses(course_id, course_name)` and `Enrollment(student_id, course_id)`.

---

### 3NF — Third Normal Form
**Rule:** Must be in 2NF + no **transitive dependency** (non-key column depending on another non-key column).

❌ Violates 3NF:
| emp_id | dept_id | dept_name |
`dept_name` depends on `dept_id`, not directly on `emp_id`.

✅ 3NF: Split into `Employee(emp_id, dept_id)` and `Department(dept_id, dept_name)`.

---

### BCNF — Boyce-Codd Normal Form
**Rule:** Stronger version of 3NF. For every functional dependency `A → B`, `A` must be a **super key**.

> BCNF handles edge cases where 3NF still allows some anomalies with overlapping candidate keys.

---

### 4NF & 5NF (Brief)
- **4NF:** No multi-valued dependencies
- **5NF:** No join dependencies — a table cannot be decomposed further without losing data

---

### Denormalization
Intentionally introducing redundancy back into a database for **read performance**.
Used in data warehouses and reporting systems where read speed > write consistency.

---

## 5. ACID Properties

ACID guarantees that database transactions are processed reliably.

### A — Atomicity
**"All or nothing."**
A transaction is treated as a single unit. Either all operations succeed, or none of them do.

> Bank transfer: debit account A AND credit account B. If the credit fails, the debit must be rolled back.

### C — Consistency
**"Data must always be valid."**
A transaction brings the database from one valid state to another. All defined rules (constraints, cascades, triggers) must hold before and after.

> You cannot transfer more money than the account balance — the constraint enforces consistency.

### I — Isolation
**"Transactions don't interfere with each other."**
Concurrent transactions execute as if they were sequential. Intermediate states are invisible to other transactions.

> Two people booking the last seat on a flight — isolation ensures only one succeeds.

### D — Durability
**"Committed data survives failures."**
Once a transaction is committed, it remains committed even if the system crashes. Data is written to persistent storage.

> After you get an "Order Confirmed" message, a server restart shouldn't lose your order.

---

## 6. Transactions

**Definition:**
A transaction is a sequence of SQL operations treated as a **single logical unit of work**.

### Transaction States
```
Active → Partially Committed → Committed
                ↓
             Failed → Aborted (Rolled Back)
```

### TCL Commands

| Command | Purpose |
|---------|---------|
| `START TRANSACTION` | Begin a transaction |
| `COMMIT` | Permanently save changes |
| `ROLLBACK` | Undo all changes since last commit |
| `SAVEPOINT name` | Create a checkpoint inside a transaction |
| `ROLLBACK TO name` | Undo only to a savepoint, not full rollback |

```sql
START TRANSACTION;

UPDATE accounts SET balance = balance - 5000 WHERE acc_id = 101;
SAVEPOINT debited;

UPDATE accounts SET balance = balance + 5000 WHERE acc_id = 102;
SAVEPOINT credited;

-- If something goes wrong:
ROLLBACK TO debited;

-- If all good:
COMMIT;
```

---

## 7. SQL Clauses & Execution Order

### Write Order (how you type it)
```sql
SELECT → FROM → JOIN → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT
```

### Execution Order (how DB processes it)
```
1. FROM          — identify table(s)
2. JOIN          — merge tables
3. WHERE         — filter rows        ← no aliases, no aggregates
4. GROUP BY      — form groups
5. HAVING        — filter groups      ← aggregates allowed
6. SELECT        — pick columns       ← aliases created here
7. DISTINCT      — remove duplicates
8. ORDER BY      — sort              ← aliases usable here
9. LIMIT         — restrict rows
```

**Why this matters:**
- `WHERE` cannot use `SELECT` aliases → alias doesn't exist yet
- `WHERE` cannot use aggregate functions → grouping hasn't happened yet
- `HAVING` can use aggregates → runs after `GROUP BY`
- `ORDER BY` can use aliases → runs after `SELECT`

---

## 8. Joins

A JOIN combines rows from two or more tables based on a related column.

### INNER JOIN
Returns only rows that have matching values in **both** tables.
```sql
SELECT * FROM employee_demographics dem
INNER JOIN employee_salary sal ON dem.employee_id = sal.employee_id;
```
> Ron Swanson (only in salary table) is excluded. Andy Dwyer appears in both — he's included.

---

### LEFT JOIN (LEFT OUTER JOIN)
Returns **all rows from the left table** + matching rows from right. Non-matching right side = NULL.
```sql
SELECT * FROM employee_demographics dem
LEFT JOIN employee_salary sal ON dem.employee_id = sal.employee_id;
```

---

### RIGHT JOIN (RIGHT OUTER JOIN)
Returns **all rows from the right table** + matching left. Non-matching left side = NULL.

---

### FULL OUTER JOIN
Returns all rows from **both tables**. NULLs fill where there's no match.
> MySQL doesn't have FULL OUTER JOIN natively — simulate with `LEFT JOIN UNION RIGHT JOIN`.

---

### CROSS JOIN
Returns the **Cartesian product** — every row in table A paired with every row in table B.
If A has 5 rows and B has 4 rows → result has 20 rows.

---

### SELF JOIN
A table joined to **itself**. Used for hierarchical or sequential data.
```sql
-- Each employee's "Secret Santa" is the next employee by ID
SELECT emp1.first_name AS giver, emp2.first_name AS receiver
FROM employee_salary emp1
JOIN employee_salary emp2 ON emp1.employee_id + 1 = emp2.employee_id;
```

---

### Join Summary

| Join Type | Left Non-Match | Right Non-Match |
|-----------|---------------|----------------|
| INNER | Excluded | Excluded |
| LEFT | Included (NULL right) | Excluded |
| RIGHT | Excluded | Included (NULL left) |
| FULL OUTER | Included (NULL) | Included (NULL) |
| CROSS | — all combinations — | |

---

## 9. Indexes

**Definition:**
An index is a data structure that **speeds up data retrieval** at the cost of additional storage and slower writes.
Think of it like a book's index — instead of scanning every page, you jump directly to the right page.

### Types of Indexes

**Clustered Index**
- Physically **sorts and stores** the table rows based on the index key
- Only **one** per table (because rows can only be stored in one order)
- Primary key automatically creates a clustered index

**Non-Clustered Index**
- A separate structure that holds the index key + a **pointer** to the actual row
- Multiple non-clustered indexes allowed per table
- Like a book's appendix — it doesn't rearrange the book, just points to pages

**Unique Index**
- Enforces uniqueness on a column (UNIQUE constraint creates this automatically)

**Composite Index**
- Index on multiple columns
- Order of columns matters — index on `(last_name, first_name)` helps queries filtering by `last_name` but not by `first_name` alone

**Full-Text Index**
- Used for text search operations (`LIKE '%word%'` is slow; full-text index is fast)

### When NOT to use an Index
- Small tables (full scan is faster)
- Columns that are updated very frequently
- Columns with very low cardinality (e.g., a boolean column — only 2 values)

```sql
CREATE INDEX idx_salary ON employee_salary(salary);
CREATE UNIQUE INDEX idx_email ON users(email);
```

---

## 10. Views

**Definition:**
A view is a **virtual table** based on the result of a SELECT query. It doesn't store data itself — it stores the query. Every time you query a view, it runs the underlying SELECT.

### Why use Views?
- **Security** — expose only specific columns/rows to users
- **Simplicity** — wrap complex joins into a simple name
- **Consistency** — centralize business logic in one place

```sql
CREATE VIEW high_earners AS
SELECT first_name, last_name, occupation, salary
FROM employee_salary
WHERE salary > 60000;

SELECT * FROM high_earners;
```

### Updatable Views
A view is updatable if it's based on a single table with no GROUP BY, DISTINCT, or aggregate functions.

### Materialized View
- Unlike regular views, a **materialized view** physically stores the query result
- Must be refreshed manually or on a schedule
- Faster reads, but data can be stale
- Available in PostgreSQL and Oracle (not MySQL natively)

---

## 11. Stored Procedures vs Functions

| Feature | Stored Procedure | Function |
|---------|-----------------|----------|
| Returns value | Optional (OUT params) | Must return a value |
| Can call in SELECT | ❌ No | ✅ Yes |
| Called with | `CALL proc_name()` | `SELECT func_name()` |
| DML inside | ✅ Yes | ❌ (in most DBs) |
| Transaction control | ✅ Yes | ❌ |
| Purpose | Business logic, multi-step ops | Computation, reusable expression |

```sql
-- Stored Procedure
DELIMITER $$
CREATE PROCEDURE get_employee(id INT)
BEGIN
  SELECT * FROM employee_salary WHERE employee_id = id;
END $$
DELIMITER ;

CALL get_employee(5);

-- Function
DELIMITER $$
CREATE FUNCTION get_annual_salary(monthly INT)
RETURNS INT DETERMINISTIC
BEGIN
  RETURN monthly * 12;
END $$
DELIMITER ;

SELECT get_annual_salary(5000);
```

---

## 12. Triggers

**Definition:**
A trigger is a stored procedure that **automatically executes** in response to a specific event (INSERT, UPDATE, DELETE) on a table.

### Types
- `BEFORE INSERT` — validate/modify data before it's saved
- `AFTER INSERT` — log the action after data is saved
- `BEFORE UPDATE` — check business rules before update
- `AFTER DELETE` — archive deleted rows

```sql
-- Log every salary update
DELIMITER $$
CREATE TRIGGER after_salary_update
AFTER UPDATE ON employee_salary
FOR EACH ROW
BEGIN
  INSERT INTO salary_audit(employee_id, old_salary, new_salary, changed_at)
  VALUES (OLD.employee_id, OLD.salary, NEW.salary, NOW());
END $$
DELIMITER ;
```

> `OLD` refers to values before the operation. `NEW` refers to values after.

---

## 13. Cursors

**Definition:**
A cursor is a database object that allows you to **process query results row by row** — like an iterator in programming.

**When to use:** When set-based operations are insufficient and you need row-by-row logic.

```sql
DELIMITER $$
CREATE PROCEDURE process_employees()
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE emp_name VARCHAR(50);
  DECLARE cur CURSOR FOR SELECT first_name FROM employee_demographics;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  read_loop: LOOP
    FETCH cur INTO emp_name;
    IF done THEN LEAVE read_loop; END IF;
    -- process emp_name here
  END LOOP;
  CLOSE cur;
END $$
DELIMITER ;
```

> Cursors are slow. Prefer set-based SQL wherever possible.

---

## 14. Concurrency Control

**Problem:** When multiple transactions execute simultaneously, they can conflict and corrupt data.

### Concurrency Problems

**Dirty Read**
Transaction A reads data modified by Transaction B that hasn't committed yet. If B rolls back, A read garbage data.

**Non-Repeatable Read**
Transaction A reads a row twice. Between reads, Transaction B updates the row. A gets different values each time.

**Phantom Read**
Transaction A reads a set of rows. Transaction B inserts/deletes rows. A re-reads and sees different rows.

**Lost Update**
Two transactions read the same value and both update it. The second update overwrites the first — one update is lost.

---

### Isolation Levels

| Level | Dirty Read | Non-Repeatable Read | Phantom Read |
|-------|-----------|--------------------|-|
| READ UNCOMMITTED | ✅ Possible | ✅ Possible | ✅ Possible |
| READ COMMITTED | ❌ Prevented | ✅ Possible | ✅ Possible |
| REPEATABLE READ | ❌ Prevented | ❌ Prevented | ✅ Possible |
| SERIALIZABLE | ❌ Prevented | ❌ Prevented | ❌ Prevented |

> Higher isolation = safer but slower. MySQL's default is **REPEATABLE READ**.

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

---

## 15. Locking Mechanisms

Locks prevent conflicting transactions from accessing the same data simultaneously.

### Shared Lock (S Lock / Read Lock)
- Multiple transactions can hold a shared lock on the same data simultaneously
- No transaction can write while shared locks exist
- "I'm reading — others can read too, but no one can write"

### Exclusive Lock (X Lock / Write Lock)
- Only one transaction can hold an exclusive lock
- No other transaction can read or write
- "I'm writing — no one else can touch this"

### Two-Phase Locking (2PL)
- **Growing phase:** Transaction acquires all locks it needs
- **Shrinking phase:** Transaction releases locks — cannot acquire new ones after releasing any
- Guarantees serializability but can cause deadlocks

### Optimistic vs Pessimistic Locking

| | Pessimistic | Optimistic |
|--|------------|-----------|
| Strategy | Lock before access | No lock; check at commit |
| When to use | High contention | Low contention |
| Risk | Deadlocks | Update conflicts |

---

## 16. Deadlock

**Definition:**
A deadlock occurs when two or more transactions are each waiting for the other to release a lock — resulting in a circular wait where none can proceed.

```
Transaction A holds Lock on Row 1, waiting for Row 2
Transaction B holds Lock on Row 2, waiting for Row 1
→ Neither can proceed. Deadlock.
```

### Deadlock Prevention Strategies
- **Wait-Die:** Older transaction waits; younger transaction is killed and restarted
- **Wound-Wait:** Older transaction kills younger one; younger waits
- **Timeout:** Transactions are killed if they wait too long
- **Lock ordering:** Always acquire locks in the same order across all transactions

### Deadlock Detection
DBMS periodically runs a **wait-for graph** algorithm. If a cycle is found, one transaction is chosen as the victim and rolled back.

---

## 17. ER Model

**Entity-Relationship (ER) Model** is a conceptual design tool that represents data as entities, attributes, and relationships — used to plan a database before building it.

### Components

**Entity**
A real-world object or concept with independent existence.
Examples: `Employee`, `Department`, `Project`

**Attributes**
Properties of an entity.
- **Simple:** `age`, `salary`
- **Composite:** `full_name` = `first_name + last_name`
- **Derived:** `age` derived from `birth_date`
- **Multi-valued:** an employee can have multiple `phone_numbers`

**Relationship**
An association between entities.
- `Employee` WORKS_IN `Department`
- `Student` ENROLLS_IN `Course`

### Cardinality

| Relationship | Meaning |
|-------------|---------|
| One-to-One (1:1) | One employee has one parking spot |
| One-to-Many (1:N) | One department has many employees |
| Many-to-Many (M:N) | Many students enroll in many courses |

### Weak Entity
An entity that **cannot be uniquely identified by its own attributes** alone — it depends on a strong entity.
Example: `Dependent` (family member) of an `Employee`.

---

## 18. Relational Algebra

Relational algebra is the **theoretical foundation** of SQL. It defines operations on relations (tables).

| Operation | SQL Equivalent | Description |
|-----------|---------------|-------------|
| σ (Select) | `WHERE` | Filter rows by condition |
| π (Project) | `SELECT col1, col2` | Choose specific columns |
| ⋈ (Join) | `JOIN` | Combine related tables |
| ∪ (Union) | `UNION` | Combine rows from two relations |
| − (Difference) | `EXCEPT` | Rows in A but not in B |
| ∩ (Intersection) | `INTERSECT` | Rows in both A and B |
| × (Cartesian Product) | `CROSS JOIN` | All combinations |
| ρ (Rename) | `AS` alias | Rename a relation or attribute |

---

## 19. Hashing & Indexing Techniques

### B-Tree Index (Default in most RDBMS)
- Balanced tree structure
- Supports equality and **range queries** (`>`, `<`, `BETWEEN`)
- Self-balancing — insertions/deletions maintain balance
- Used for most regular indexes

### B+ Tree Index
- Variant of B-Tree
- All data stored at **leaf nodes**; internal nodes only hold keys
- Leaf nodes are **linked** — range queries are very efficient
- MySQL InnoDB uses B+ Trees

### Hash Index
- Uses a hash function to map keys to bucket locations
- O(1) lookup for **exact match** queries
- **Cannot** support range queries
- Used in MEMORY storage engine in MySQL

### Clustered vs Non-Clustered (recap)
- Clustered: data rows stored with the index — one per table
- Non-Clustered: separate structure pointing to data — many per table

---

## 20. CAP Theorem

The **CAP Theorem** states that a distributed database system can guarantee at most **2 out of 3** properties simultaneously:

### C — Consistency
Every read receives the **most recent write** (or an error). All nodes see the same data at the same time.

### A — Availability
Every request receives a **response** (not necessarily the most recent data). The system is always operational.

### P — Partition Tolerance
The system continues to function even when **network partitions** (communication failures between nodes) occur.

### Real-world choices
| System | Guarantees | Sacrifices |
|--------|-----------|------------|
| Traditional RDBMS | C + A | P |
| Apache Cassandra | A + P | C |
| MongoDB (default) | C + P | A |
| HBase | C + P | A |

> In real distributed systems, network partitions **always happen** eventually. So the real trade-off is between **C and A**.

---

## 21. NoSQL vs SQL

| Feature | SQL (RDBMS) | NoSQL |
|---------|------------|-------|
| Schema | Fixed, predefined | Flexible / schema-less |
| Data model | Tables | Document, Key-Value, Graph, Column |
| Relationships | Via foreign keys (JOINs) | Typically embedded or denormalized |
| ACID | Full support | Varies (eventual consistency common) |
| Scaling | Vertical (bigger server) | Horizontal (more servers) |
| Query language | SQL (standardized) | Varies by database |
| Best for | Structured data, complex queries | Unstructured data, high scale, speed |

### NoSQL Types
| Type | Example | Best For |
|------|---------|---------|
| Document | MongoDB | JSON-like records, flexible schema |
| Key-Value | Redis | Caching, sessions, leaderboards |
| Column-Family | Cassandra | Time-series, write-heavy workloads |
| Graph | Neo4j | Social networks, recommendations |

---

## 22. DCL & TCL

### DCL — Data Control Language
Controls **permissions** on database objects.

```sql
-- Grant read + write (but not delete) access
GRANT SELECT, INSERT, UPDATE ON employees.* TO 'analyst'@'%';

-- Revoke all previously granted permissions
REVOKE SELECT, INSERT, UPDATE ON employees.* FROM 'analyst'@'%';

-- Check who has what permissions
SHOW GRANTS FOR 'analyst'@'%';
```

### TCL — Transaction Control Language
Manages **transaction boundaries and recovery**.

```sql
START TRANSACTION;
  UPDATE accounts SET balance = balance - 1000 WHERE id = 1;
  SAVEPOINT after_debit;
  UPDATE accounts SET balance = balance + 1000 WHERE id = 2;
COMMIT;

-- Undo only part of the transaction
ROLLBACK TO after_debit;
```

---

## 23. Window Functions

**Definition:**
Window functions perform calculations **across a set of rows related to the current row** without collapsing them the way GROUP BY does. Each row keeps its identity.

```sql
function_name() OVER (
  PARTITION BY column   -- define the window (group)
  ORDER BY column       -- order within the window
)
```

### Aggregate Window Functions
```sql
-- Show each employee + their gender group's average salary
SELECT first_name, gender, salary,
       AVG(salary) OVER(PARTITION BY gender) AS gender_avg
FROM employee_demographics
JOIN employee_salary USING(employee_id);
```

### Ranking Functions

| Function | Behaviour on Ties |
|----------|------------------|
| `ROW_NUMBER()` | Always unique — no tie handling |
| `RANK()` | Ties get same rank, next rank is skipped |
| `DENSE_RANK()` | Ties get same rank, next rank is NOT skipped |
| `NTILE(n)` | Divides rows into n buckets |

```sql
SELECT first_name, salary,
  ROW_NUMBER()  OVER(ORDER BY salary DESC) AS row_num,
  RANK()        OVER(ORDER BY salary DESC) AS rnk,
  DENSE_RANK()  OVER(ORDER BY salary DESC) AS dense_rnk
FROM employee_salary;
```

### Navigation Functions
```sql
LAG(column, n)   -- value from n rows BEFORE current row
LEAD(column, n)  -- value from n rows AFTER current row
FIRST_VALUE()    -- first value in the window
LAST_VALUE()     -- last value in the window
```

---

## 24. CTEs & Subqueries

### Subquery
A query nested inside another query. Evaluated first, result passed to outer query.

```sql
-- Find employees earning above the average salary
SELECT first_name, salary
FROM employee_salary
WHERE salary > (SELECT AVG(salary) FROM employee_salary);
```

**Types:**
- **Scalar subquery:** Returns one value (`= (SELECT MAX(salary)...)`)
- **Row subquery:** Returns one row
- **Table subquery / Derived table:** Returns a full result set used in FROM
- **Correlated subquery:** References columns from the outer query — re-executed for each outer row (slow)

---

### CTE — Common Table Expression
A named temporary result set defined with `WITH`. Cleaner and more readable than nested subqueries.

```sql
WITH dept_avg AS (
  SELECT dept_id, AVG(salary) AS avg_salary
  FROM employee_salary
  GROUP BY dept_id
)
SELECT e.first_name, e.salary, d.avg_salary
FROM employee_salary e
JOIN dept_avg d ON e.dept_id = d.dept_id
WHERE e.salary > d.avg_salary;
```

**CTE vs Subquery:**
| | Subquery | CTE |
|--|---------|-----|
| Readability | Harder (nested) | Cleaner (named) |
| Reusability | Must repeat | Reference multiple times |
| Recursion | ❌ | ✅ (Recursive CTEs) |
| Performance | Similar | Similar |

---

## 25. Top Interview Questions & Answers

### Q1: What is the difference between DELETE, TRUNCATE, and DROP?

| Command | Removes | WHERE clause | Rollback | Triggers | Resets identity |
|---------|---------|-------------|---------|---------|----------------|
| `DELETE` | Selected rows | ✅ | ✅ | ✅ | ❌ |
| `TRUNCATE` | All rows | ❌ | ❌ (mostly) | ❌ | ✅ |
| `DROP` | Entire table | ❌ | ❌ | ❌ | — |

---

### Q2: What is the difference between WHERE and HAVING?
- `WHERE` filters **individual rows before grouping** — cannot use aggregate functions
- `HAVING` filters **groups after GROUP BY** — can use aggregate functions

---

### Q3: What is a self join? When would you use it?
A self join joins a table to itself. Used when a table has a **hierarchical relationship within itself**.

Examples:
- Employee and Manager (both in the same Employee table)
- Find employees who earn more than their manager
- Organizational hierarchy traversal

---

### Q4: What is the difference between UNION and UNION ALL?
- `UNION` — combines result sets and **removes duplicate rows** (slower — requires sorting)
- `UNION ALL` — combines result sets and **keeps all rows including duplicates** (faster)

---

### Q5: Explain the difference between clustered and non-clustered indexes.
- **Clustered:** Physically reorders the table to match the index. Only one allowed. Primary key creates this automatically. Fast for range queries.
- **Non-clustered:** Separate structure with pointers to actual data. Multiple allowed. Good for frequently filtered columns.

---

### Q6: What is normalization? Why would you denormalize?
Normalization organizes tables to reduce redundancy and anomalies. You denormalize when **read performance is critical** — such as in data warehouses or analytics — where the cost of multiple JOINs outweighs the benefit of clean data structure.

---

### Q7: What is a deadlock and how is it resolved?
A deadlock is when two transactions each hold a resource the other needs — a circular wait. DBMS detects it via a wait-for graph, picks a **victim transaction**, and rolls it back to break the cycle.

---

### Q8: What are the isolation levels and what problems do they prevent?

| Level | Prevents |
|-------|---------|
| Read Uncommitted | Nothing |
| Read Committed | Dirty reads |
| Repeatable Read | Dirty + Non-repeatable reads |
| Serializable | All concurrency problems |

---

### Q9: What is the difference between a view and a materialized view?
- **View** — virtual; runs the query each time; always fresh; no extra storage
- **Materialized View** — physically stores the result; must be refreshed; faster reads; can be stale

---

### Q10: Can you have a foreign key reference a non-primary key column?
Yes — a foreign key can reference any column with a `UNIQUE` constraint, not just the primary key. The referenced column must be unique to ensure referential integrity.

---

### Q11: What is an execution plan and why does it matter?
An execution plan shows **how the database engine will execute** a query — which indexes it will use, how tables will be joined, in what order operations happen. Use `EXPLAIN` or `EXPLAIN ANALYZE` to inspect it. Critical for query performance tuning.

```sql
EXPLAIN SELECT * FROM employee_salary WHERE salary > 60000;
```

---

### Q12: What is the difference between RANK() and DENSE_RANK()?
If two employees tie for rank 2:
- `RANK()` gives both rank 2, next employee gets rank **4** (skips 3)
- `DENSE_RANK()` gives both rank 2, next employee gets rank **3** (no skip)

---

*This guide covers every concept asked in DBMS technical interviews — from fresher to senior level.*
