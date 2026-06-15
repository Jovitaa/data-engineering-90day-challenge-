# 📘 Week 1 Closing Notes: Views vs Stored Procedures vs Functions in SQL

## Overview
In SQL, **Views**, **Functions**, and **Stored Procedures** are reusable database objects, but each serves a different purpose:

| Feature              | **View** (Virtual Table)                          | **Function** (Reusable Logic)                  | **Stored Procedure** (Business Logic)          |
|----------------------|---------------------------------------------------|------------------------------------------------|------------------------------------------------|
| **Main Purpose**     | Simplifies `SELECT` queries                       | Performs calculations or returns values        | Executes multi-step business logic             |
| **Parameters**       | No                                                | Yes                                            | Yes                                            |
| **Return Type**      | Virtual table                                     | Single value or table                          | Optional result set                            |
| **Data Modification**| Usually No                                        | No                                             | Yes                                            |
| **Called Using**     | `SELECT`                                          | `SELECT`, `WHERE`                              | `EXEC`                                         |
| **Best Used For**    | Reading simplified data                           | Reusable calculations                          | Insert, update, delete, workflows              |

---

## 1. View
A **View** is a saved SQL `SELECT` query. It behaves like a virtual table but does not store actual data.

```sql
-- Create a view of active customers
CREATE VIEW ActiveCustomers AS
SELECT customer_id, customer_name, city
FROM customers
WHERE status = 'Active';

-- Fetch data from the view
SELECT * FROM ActiveCustomers;
```

## 2. Function
A Function accepts input values, performs logic, and returns a value or table.

```sql
-- Create a function to calculate bonus
CREATE FUNCTION CalculateBonus(@salary INT)
RETURNS INT
AS
BEGIN
    RETURN @salary * 0.10;   -- Bonus is 10% of salary
END;

-- Use the function inside a query
SELECT employee_name, dbo.CalculateBonus(salary) AS bonus
FROM employees;
```
👉 Functions are best for calculations, formatting, and reusable logic inside queries.

## 3. Stored Procedure
A Stored Procedure is a saved block of SQL statements used to perform operations such as inserting, updating, deleting, or processing data.
```sql
-- Create a procedure to update salary
CREATE PROCEDURE UpdateEmployeeSalary
    @employee_id INT,
    @new_salary INT
AS
BEGIN
    UPDATE employees
    SET salary = @new_salary
    WHERE employee_id = @employee_id;
END;

-- Execute the procedure
EXEC UpdateEmployeeSalary @employee_id = 101, @new_salary = 60000;
```
👉 Stored procedures are useful for automating business processes and handling multi-step database tasks.

---
## 📌 Important Notes

- **Views, Functions, and Stored Procedures** store only their **definition/code**, not actual table data.  
- A **normal view** always runs fresh from the base table every time it is queried.  
- **Functions and procedures** may cache execution plans for performance optimization.  
- **Temporary variables/tables** inside procedures or functions are cleared automatically after execution.  
- **Materialized Views / Indexed Views** are exceptions — they can physically store query results for faster retrieval.

  ---
  ## 📌 Virtual Table (View) vs Temporary Table

A common misconception is that a **View** is the same as a **Temporary Table**.  
They are different in purpose and behavior:

| Feature              | **View (Virtual Table)**              | **Temporary Table**                  |
|----------------------|---------------------------------------|--------------------------------------|
| **Stores actual data?** | No                                | Yes                                  |
| **Storage**          | Stores only query definition          | Stores actual rows in temp storage   |
| **Data Source**      | Reads directly from base tables       | Maintains its own copy of data       |
| **Reflects changes?**| Yes                                   | No                                   |
| **Lifetime**         | Permanent until dropped               | Exists only for current session      |
| **Use Case**         | Simplify complex queries              | Store intermediate results for processing |

--
### View Example
```sql
CREATE VIEW HighSalaryEmployees AS
SELECT *
FROM Employees
WHERE Salary > 55000;


SELECT * FROM HighSalaryEmployees;
```
👉 Always shows latest data from Employees.

### Temporary Table Example
```sql
CREATE TABLE #HighSalaryEmployees
(
    ID INT,
    Name VARCHAR(50),
    Salary INT
);

-- Insert snapshot data
INSERT INTO #HighSalaryEmployees
SELECT *
FROM Employees
WHERE Salary > 55000;

SELECT * FROM #HighSalaryEmployees;
```
👉 Stores a snapshot of data at the time of insertion.

----
### Simple Analogy
- **View** = 📺 Live camera feed (always shows current data)
-  **Temporary Table** = 📸 Screenshot (captures data at one point in time)
  
----
## Quick Summary
- Use a View when you want to simplify reading data.
- Use a Function when you want to calculate and return a value.
- Use a Stored Procedure when you want to execute business logic or modify data.
- Views ≠ Temporary Tables — views are dynamic, temporary tables are static snapshots.
