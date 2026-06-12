# 📘 DAY 6 - SQL Functions

## 1. What is a Function?
- **Definition**: A reusable database object that encapsulates logic and returns a value.
- **Purpose**: Simplifies queries, enforces business rules, improves maintainability.
- **General Syntax**:
  ```sql
  CREATE FUNCTION function_name(parameters)
  RETURNS return_type AS $$
  BEGIN
    -- logic
    RETURN value;
  END;
  $$ LANGUAGE plpgsql;
  ```
----
## 2. Types of Functions
Functions are broadly classified into **built-in** and **user-defined**.

### 2.1 Built-in Functions
Built-in functions are provided by the database engine and are frequently used in **Data Engineering** for tasks like aggregation, analytics, formatting, and system queries.

- **Aggregate Functions** → `SUM()`, `AVG()`, `COUNT()`  
  Perform calculations on sets of values and return a single result.

- **Analytic Functions** → `ROW_NUMBER()`, `RANK()`, `AVG() OVER(...)`  
  Compute values across partitions/windows of rows without collapsing them.

- **Scalar Functions** → `UPPER()`, `LEN()`, `ABS()`  
  Operate on a single value and return a single result.

- **Date & Time Functions** → `NOW()`, `GETDATE()`  
  Handle date/time operations such as current timestamp retrieval.

- **String Functions** → `LOWER()`, `INITCAP()`  
  Manipulate text values (case conversion, formatting).

- **System Functions** → `DATABASE()`, `VERSION()`  
  Provide metadata and system-level information about the database instance.

## Example
```sql
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;
```
----
### 2.2 User-Defined Functions (UDFs)
- **Definition**: Functions created by developers to extend SQL capabilities beyond built-in functions.  
- **Languages Supported**: Can be written in **PL/pgSQL, SQL, C, Java** (depending on the database).  
- **Purpose**: Useful for implementing **custom business logic**, especially in **ETL pipelines** and data engineering workflows.  
- **Benefits**:
  - Encapsulation of complex logic.
  - Reusability across queries and applications.
  - Flexibility to handle scenarios not covered by built-in functions.

**Example – PostgreSQL UDF:**
```sql
CREATE FUNCTION inc(val integer) RETURNS integer AS $$
BEGIN
  RETURN val + 1;
END;
$$ LANGUAGE plpgsql;
```

**Example – SQL Server Scalar Function:**
```sql
CREATE FUNCTION dbo.GetAnnualSalary(@monthly_salary INT)
RETURNS INT
AS
BEGIN
  RETURN @monthly_salary * 12;
END;
```
----
### 2.3 Function Overloading (Important Concept)

- **Definition**: Function overloading is the ability to create multiple functions with the **same name** but different **parameter lists** (number or type of parameters).  

- **Why Important**:
  - **Supports polymorphism in SQL** → Enables flexible use of the same function name for different scenarios.  
  - **Improves readability** → Developers can use intuitive names without worrying about conflicts.  
  - **Encapsulation** → Different versions of a function can handle different input types or business rules.  

- **Database Support**:
  - **PostgreSQL** → Strong support for function overloading. Multiple versions of the same function can coexist.  
  - **SQL Server (T-SQL)** → Limited support; functions must have unique names within a schema.  

**Example – PostgreSQL Function Overloading**
```sql
-- First version: increments by 1
CREATE FUNCTION inc(val integer) RETURNS integer AS $$
BEGIN
  RETURN val + 1;
END;
$$ LANGUAGE plpgsql;
```
Usage:
```sql
SELECT inc(10);       -- returns 11
SELECT inc(10, 5);    -- returns 15
```
----
## 3. Differences Across Databases

### Open Source – PostgreSQL
- **Language Support**: Supports multiple procedural languages such as `plpgsql`, `plpython`, `plperl`.  
- **Dollar Quoting**: Uses `$$` to avoid escaping issues in function bodies.  
- **Strong Support for Function Overloading**: Multiple versions of the same function can coexist with different parameter lists.  
- **Use Cases**: Commonly applied in **analytics**, **ETL logic**, and **reusable transformations** for data pipelines.  

### Proprietary – SQL Server (T-SQL)
- **Function Types**: Offers scalar, inline table-valued, and multi-statement table-valued functions.  
- **Schema Binding**: Functions can be tied to schema objects using `SCHEMABINDING` for performance and consistency.  
- **Configuration Functions**: Provides system-level information (e.g., `@@SERVERNAME`).  
- **Overloading**: Limited compared to PostgreSQL; functions must generally have unique names within a schema.
----
## 4. Functions vs Stored Procedures

| Aspect        | **Functions**                                                                 | **Stored Procedures**                                      |
|---------------|-------------------------------------------------------------------------------|------------------------------------------------------------|
| **Return**    | Must return a value (scalar or table).                                        | May or may not return values.                              |
| **Usage**     | Can be used directly in `SELECT`, `WHERE`, `ORDER BY` clauses.                | Invoked explicitly using `EXEC` or `CALL`.                 |
| **Purpose**   | Encapsulate reusable calculations and transformations.                        | Perform business logic, ETL workflows, auditing, and DML.  |
| **Side Effects** | Generally not allowed (no DML operations unless special cases).            | Can perform DML operations (`INSERT`, `UPDATE`, `DELETE`). |
| **Determinism** | Often deterministic (same input → same output).                             | May include nondeterministic operations.                   |

---
## 5. Key Learnings / Important Points

### Determinism
- **Deterministic** → Same input always produces the same output.  
- **Nondeterministic** → Results may vary (e.g., system functions like `GETDATE()`).

### Collation
- String functions follow **input/database collation rules**.  
- Important for ensuring consistent text comparisons and outputs across queries.

### Encapsulation
- **User-Defined Functions (UDFs)** improve **reusability** and **maintainability** in data pipelines.  
- Encapsulate complex logic into modular, reusable components.

### Data Engineering Use Cases
- **Data Quality Checks** → Validate NULLs, completeness, duplicates.  
- **ETL Audit Logging** → Track timestamps, row counts, and process status.  
- **Analytics** → Running totals, moving averages, forecasting.  
- **Business Rule Enforcement** → Validation logic embedded in queries.

### Best Practices
- Keep functions **small and focused**.  
- **Validate inputs** to avoid runtime errors.  
- Prefer **set-based operations** over cursors for efficiency.  
- Use **stored procedures** for ETL workflows, and **functions** for reusable calculations.
