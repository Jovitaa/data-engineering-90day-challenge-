# Day 2 – Netflix Data Engineering Challenge

## 📌 Overview

On **Day 2**, I focused on expanding the pipeline with:
- Practicing SQL joins (INNER, LEFT, RIGHT, FULL).
- Querying existing PostgreSQL tables (`movies`, `ratings`, `users`).

---

## 📌 Tools Used Today
- **Jupyter Notebook** → interactive coding and exploration  
- **Python** → linear and binary search implementations  
- **PostgreSQL** → existing tables for joins  
- **pandas** → fetching query results into DataFrames  
- **psycopg2-binary** → Python ↔ PostgreSQL integration  

---

## 🔹 Step 1: PostgreSQL Connection
**Tools used**: psycopg2-binary, pandas  

```python
import psycopg2
import pandas as pd

conn = psycopg2.connect(
    dbname="netflix_db",
    user="postgres",
    password="yourpassword",
    host="localhost",
    port="5432"
)
```
## Explanation
-**connect()** → establishes DB connection
-**pandas** → used later to fetch query results into DataFrames

---
## ♦ Step 2: SQL Joins
**Tools used**: SQL, psycopg2, pandas

**INNER JOIN**
```sql
SELECT u.user_id, u.name, r.movie_id, r.rating
FROM users u
INNER JOIN ratings r ON u.user_id = r.user_id;
```
## Explanation: Returns only rows where users have ratings.

**LEFT JOIN**
```sql
SELECT u.user_id, u.name, r.movie_id, r.rating
FROM users u
LEFT JOIN ratings r ON u.user_id = r.user_id;
```
## Explanation: 
-**Returns all users, even if they don’t have ratings.**

**RIGHT JOIN**
```sql
SELECT u.user_id, u.name, r.movie_id, r.rating
FROM users u
RIGHT JOIN ratings r ON u.user_id = r.user_id;
```
## Explanation: 
-**Returns all ratings, even if they don’t match a user.**

**FULL JOIN**
```sql
SELECT u.user_id, u.name, r.movie_id, r.rating
FROM users u
FULL JOIN ratings r ON u.user_id = r.user_id;
```
## Explanation: 
-**Returns all users and all ratings, matching where possible.**

---


## 🔹 What Went Wrong (and How You Fixed It)

### DuplicateTable error
- **Error:** relation "ratings" already exists  
- ✅ **Fix:** Skipped `CREATE TABLE` statements, used existing tables directly.  

---

### Indentation issue in linear search
- **Error:** Returned `-1` even when target existed.  
- ✅ **Fix:** Ensured `return -1` was outside the loop.  

---

## 🔹 Lessons Learned
- SQL joins are powerful for combining multiple tables.   
- Always check file paths and working directories in Jupyter.  
- Avoid re‑creating tables if they already exist in PostgreSQL.  
