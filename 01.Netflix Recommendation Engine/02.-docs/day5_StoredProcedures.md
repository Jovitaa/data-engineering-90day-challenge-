# Day 5: PostgreSQL Stored Procedures & Time Complexity

## Overview
Stored Procedures are reusable database programs that group SQL statements and business logic into a single executable unit stored inside the database.

## Benefits of Stored Procedures
- **Execute multiple SQL statements** as a single operation.  
- **Accept input parameters** and process data dynamically.  
- **Reduce duplicate SQL code** across applications.  
- **Enforce consistent business rules** and validations.  
- **Centralize logic** within the database.

---
## General Syntax

### SQL Server Style
```sql
CREATE PROCEDURE procedure_name
(parameter1 datatype)
AS
BEGIN
    -- SQL Statements
END
```
## PostgreSQL Style

```sql
CREATE OR REPLACE PROCEDURE procedure_name(parameters)
LANGUAGE plpgsql
AS $$
BEGIN
    -- SQL Statements
END;
$$;
```
---
## Core Components

| Component         | Purpose                                   |
|-------------------|-------------------------------------------|
| CREATE PROCEDURE  | Creates a new stored procedure            |
| Parameters        | Accept input values                       |
| DECLARE           | Defines local variables                   |
| BEGIN...END       | Contains procedure logic                  |
| SELECT INTO       | Stores query results in variables         |
| RAISE NOTICE      | Displays informational messages           |
| RAISE EXCEPTION   | Throws an error                           |
| CALL              | Executes a stored 

---
## PostgreSQL Concepts Learned

### Why `LANGUAGE plpgsql`?
PostgreSQL supports multiple procedural languages such as:
- PL/pgSQL  
- SQL  
- Python (plpython)  
- Perl (plperl)  

Therefore, PostgreSQL requires the language to be explicitly specified.

### Example
```sql
LANGUAGE plpgsql
```
Unlike PostgreSQL, SQL Server uses T-SQL by default and does not require a language declaration.

---
## Why `$$`?

The `$$` symbols define the body of a procedure or function.

### Example
```sql
AS $$
BEGIN
    ...
END;
$$;
```
This allows semicolons to be used inside the procedure without prematurely ending the statement.

---
## Understanding ILIKE

```sql
WHERE country ILIKE '%' || country_name || '%'
```
## Key Points

- **ILIKE** → Case-insensitive search  
- **%** → Wildcard (matches any sequence of characters)  
- **||** → String concatenation  

### Example
```sql
country_name = 'India'
```
Becomes:
```sql
'%India%'
```
----
----
## Types of Stored Procedures

### 1. System Stored Procedures
Built-in procedures provided by the database system.

**Examples:**
- `sp_help`  
- `sp_rename`  

**Used for:**
- Administration  
- Troubleshooting  
- Database management

---

### 2. User-Defined Stored Procedures (UDPs)
Procedures created by developers to solve business problems.

**Examples:**
- Sales calculations  
- Order processing  
- Data quality checks  
- Audit logging  

All procedures created in this Netflix project belong to this category.

---

### 3. Extended Stored Procedures
Allow interaction with external programs and operating system resources.

**Examples:**
- Running OS commands  
- External integrations  

---

### 4. CLR Stored Procedures (SQL Server)
Written in .NET languages such as C# and executed inside SQL Server.

**Examples:**
- Complex string processing  
- External service integrations  

----
----
## Benefits of Stored Procedures

### Performance
Execution plans can be cached and reused.

### Security
Users can execute procedures without direct table access.

### Reusability
The same procedure can be used across multiple applications.

### Reduced Network Traffic
Multiple SQL operations can be executed in a single call.

### Maintainability
Business logic is centralized and easier to update.

---
---
## Stored Procedure Practice Using Netflix Dataset

### 1. Count Content by Country

**Business Requirement**  
Analytics team wants to know how many titles exist for a given country.

**Concepts Practiced**
- Input Parameters  
- Variable Declaration  
- SELECT INTO  
- RAISE NOTICE  

**Key Learning**
```sql
SELECT COUNT(*)
INTO total_titles
FROM netflix
WHERE country ILIKE '%' || country_name || '%';
```
Counts matching titles and stores the result in a variable.

---
## Stored Procedure Practice Using Netflix Dataset

### 2. Data Quality Check

**Business Requirement**  
Monitor missing values across important columns.

**Checks Performed**
- Missing Directors  
- Missing Countries  
- Missing Ratings  

**Concepts Practiced**
- Data Quality Validation  
- Aggregate Calculations  
- Monitoring Datasets  

**Key Learning**  
Data Engineers commonly perform:
- NULL Checks  
- Completeness Checks  
- Missing Value Monitoring  

before data is used in dashboards and machine learning systems.

## Stored Procedure Practice Using Netflix Dataset

### 3. Input Validation

**Business Requirement**  
Country name must not be empty.

**Concepts Practiced**
- IF Statements  
- Exception Handling  
- Input Validation  

**Example**
```sql
IF country_name IS NULL THEN
    RAISE EXCEPTION 'Country name cannot be NULL';
END IF;
```
**Key Learning**  
Input validation prevents invalid data from entering pipelines.

## Stored Procedure Practice Using Netflix Dataset

### 4. Genre Popularity Analysis

**Business Requirement**  
Determine how many titles belong to a specific genre.

**Concepts Practiced**
- Parameters  
- String Matching  
- Business Analytics Logic  

**Example**
```sql
WHERE listed_in ILIKE '%' || genre_name || '%'
```
Searches for a genre within the comma-separated genre list.

## Data Modeling Observation  

**Current Design**  
- `listed_in` contains multiple genres.  

**A Better Normalized Model**  
- **Content**  
- **Genre**  
- **Content_Genre**  

**Benefits**  
- Better indexing  
- Faster queries  
- Easier analytics  
----
----
## Stored Procedure Practice Using Netflix Dataset

### 5. ETL Audit Logging

**Business Requirement**  
Track pipeline execution history.

**Audit Table**  
Stores:
- Load Timestamp  
- Records Loaded  
## ETL Audit Logging Example

**Example**
```sql
CALL LogDataLoad(8807);
```

## Concepts Practiced

- INSERT Statements  
- Audit Logging  
- ETL Tracking  
- Production Data Engineering
----
----
## Real-World Data Engineering Usage

Stored procedures are commonly used for:

### Data Quality Monitoring
- Missing Values  
- Duplicate Records  
- Invalid Data Checks  

### ETL Operations
- Load Data  
- Transform Data  
- Validation Logic  

### Audit Logging
- Load Tracking  
- Pipeline Monitoring  
- Failure Tracking  

### Business Rule Enforcement
- Input Validation  
- Compliance Checks  
- Data Standardization  

---

### Example Audit Fields
- pipeline_name  
- start_time  
- end_time  
- records_loaded  
- records_rejected  
- load_status  
- error_message  
----
----
## Common PostgreSQL Error

### Error
`query has no destination for result data`

### Cause
A `SELECT` statement inside a procedure generated a result but PostgreSQL did not know where to store it.

### Solution
```sql
SELECT ...
INTO variable_name;
```
or
```sql
PERFORM ...
```
-----
----
## Stored Procedure Best Practices

### Keep Procedures Small
Each procedure should solve one business problem.

### Use Parameters
Avoid hardcoded values.

### Validate Inputs
Check for NULL or invalid values.

### Use Error Handling
Raise exceptions when validation fails.

### Avoid Cursors
Prefer set-based SQL operations.

**Bad:**  
Process rows one-by-one  

**Good:**  
Process all rows together  

---
---
## Time Complexity Basics

| Complexity | Meaning        |
|------------|----------------|
| O(1)       | Constant       |
| O(log n)   | Logarithmic    |
| O(n)       | Linear         |
| O(n log n) | Sorting        |
| O(n²)      | Nested Loops   |

**Example Analysis**
```sql
SELECT *
FROM netflix
WHERE country ILIKE '%India%';
```

**Complexity:**
O(n)

### Reason
- PostgreSQL scans every row. 
- Leading wildcard (`%India%`) prevents normal index usage.
 
----
----
## Interview Notes (Summary)

### Stored Procedures
- **Definition**: Reusable database objects storing SQL logic and business rules.  
- **Benefits**: Reusability, Maintainability, Security, Centralized Business Logic.  

### Key Commands
- **DECLARE**: Define local variables.  
- **SELECT INTO**: Store query results into variables.  
- **RAISE NOTICE**: Display informational messages.  
- **Avoid Cursors**: Prefer set-based operations for efficiency.  

### Audit Logging
- Tracks ETL execution details: timestamps, row counts, status, errors.  

### Key Takeaways
- Learned PostgreSQL stored procedure syntax (`LANGUAGE plpgsql`, `$$`).  
- Practiced parameters, variables, validation, and exception handling.  
- Implemented data quality monitoring and ETL audit logging.  
- Understood PostgreSQL-specific error handling (`SELECT INTO`).  
- Connected stored procedures to real-world Data Engineering workflows.  
- Introduced basic SQL query time complexity analysis.  


