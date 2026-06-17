# 📘 DAY 7 - SQL Views

## 1. What is a SQL View?
- A **View** is a virtual table created from the result of a `SELECT` query.  
- It does **not store data physically**; instead, it displays data from underlying tables.  
- Benefits:  
  - Simplifies complex queries  
  - Enhances security (restricts column/row access)  
  - Provides customized, cleaner data presentation  

**Example:**
```sql
CREATE VIEW StudentView AS
SELECT NAME, ADDRESS
FROM StudentDetails;

SELECT * FROM StudentView;
```
---
## 2. Creating Views
```sql
CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```
- **view_name** → Name of the View
- **table_name** → Base table(s)
- **condition** → Optional filter criteria
---
## Example 1: Single Table View
```sql
-- Create a view from StudentDetails table
CREATE VIEW DetailsView AS
SELECT NAME, ADDRESS
FROM StudentDetails
WHERE S_ID < 5;   -- Only include students with ID less than 5

-- Retrieve data from the view
SELECT * FROM DetailsView;
```

## Example 2: Multiple Tables View
```sql
-- Create a view combining StudentDetails and StudentMarks
CREATE VIEW MarksView AS
SELECT StudentDetails.NAME, StudentDetails.ADDRESS, StudentMarks.MARKS
FROM StudentDetails, StudentMarks
WHERE StudentDetails.NAME = StudentMarks.NAME;  -- Join condition

-- Fetch data from the view
SELECT * FROM MarksView;
```
👉 This view merges student info with their marks.

----

## 3. Managing Views
  ### 3.1 Listing Views
  ```sql
-- Show all views in a database
USE database_name;
SHOW FULL TABLES WHERE table_type LIKE "%VIEW";

-- Using information_schema
SELECT table_name
FROM information_schema.views
WHERE table_schema = 'database_name';

-- Get detailed view definitions
SELECT table_schema, table_name, view_definition
FROM information_schema.views
WHERE table_schema = 'database_name';
```

 ### 3.1 Listing Views
   ```sql
-- Drop the MarksView
DROP VIEW MarksView;
```
 ### 3.2 Deleting a View
   ```sql
-- Drop the MarksView
DROP VIEW MarksView;
```
### 3.2 Updating a View Definition
   ```sql
-- Update data inside a view (only if updatable)
UPDATE view_name
SET column1 = value1
WHERE condition;

-- Update the view definition itself
CREATE OR REPLACE VIEW MarksView AS
SELECT NAME, ADDRESS, AGE
FROM StudentDetails;
```

----

## 4. Rules for Updatable Views
- A view can be updated only if:  
  - No **GROUP BY** or **ORDER BY** clause 
  - No **DISTINCT** keyword  
  - All columns allow **NOT NULL** values
  - Created from a **single** table
  - No nested or complex queries 

----

## 5. Advanced Techniques
  ### 5.1 Updating Data Through Views
  ```sql
-- Add AGE column to MarksView
CREATE OR REPLACE VIEW MarksView AS
SELECT StudentDetails.NAME, StudentDetails.ADDRESS, StudentMarks.MARKS, StudentMarks.AGE
FROM StudentDetails, StudentMarks
WHERE StudentDetails.NAME = StudentMarks.NAME;

-- Fetch updated view
SELECT * FROM MarksView;
```

### 5.2 Inserting Data into Views
  ```sql
-- Insert new student into base table (reflected in view)
INSERT INTO StudentDetails(NAME, ADDRESS)
VALUES("John","German");

-- Fetch updated data
SELECT * FROM DetailsView;
```

### 5.3 Deleting Data Through Views
  ```sql
-- Delete student from base table (reflected in view)
DELETE FROM StudentDetails
WHERE NAME = "John";

-- Fetch updated data
SELECT * FROM DetailsView;
```

### 5.4 WITH CHECK OPTION
 ```sql
-- Create a view with restriction
CREATE VIEW SampleView AS
SELECT S_ID, NAME
FROM StudentDetails
WHERE NAME IS NOT NULL
WITH CHECK OPTION;  -- Ensures updates/inserts respect the condition

-- Update within allowed condition
UPDATE SampleView SET NAME = 'Mark' WHERE S_ID = 2;
```

----

## 6. Key Learnings
- Views simplify query logic and improve security.
- They can be created from single or multiple tables.
- Views can be managed (listed, updated, deleted) easily.
- Updatable views must follow strict rules.
- Advanced techniques include inserting, deleting, and using WITH CHECK OPTION for data integrity.
