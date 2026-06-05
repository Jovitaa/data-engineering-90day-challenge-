# Day 2 – Netflix Data Engineering Challenge

## 📌 Overview

On **Day 2**, I focused on expanding the pipeline with:
- Practicing SQL joins (INNER, LEFT, RIGHT, FULL).
- Implementing searching algorithms (linear and binary).
- Querying existing PostgreSQL tables (`movies`, `ratings`, `users`).
- Demonstrating binary search on sorted ratings.

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
**connect()** → establishes DB connection
**pandas** → used later to fetch query results into DataFrames

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
## Explanation: Returns all users, even if they don’t have ratings.

**RIGHT JOIN**
```sql
SELECT u.user_id, u.name, r.movie_id, r.rating
FROM users u
RIGHT JOIN ratings r ON u.user_id = r.user_id;
```
## Explanation: Returns all ratings, even if they don’t match a user.

**FULL JOIN**
```sql
SELECT u.user_id, u.name, r.movie_id, r.rating
FROM users u
FULL JOIN ratings r ON u.user_id = r.user_id;
```
## Explanation: Returns all users and all ratings, matching where possible.

---

## ♦ Step 3: Linear Search
**Tools used**: Python

```python
def linear_search(arr, target):
    for i in range(len(arr)):
        if arr[i] == target:
            return i
    return -1

ratings = [3, 5, 2, 4, 1]
print("Target found at index:", linear_search(ratings, 4))
```
## Explanation
**Start at index 0.**
**Compare each element with the target.**
**If found, return the index.**
**If not found, return -1.**

---

## ♦ Step 4: Binary Search
**Tools used**: Python

```python
def binary_search(arr, target):
    low, high = 0, len(arr) - 1
    while low <= high:
        mid = (low + high) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return -1

ratings = sorted([3, 5, 2, 4, 1])
print("Target found at index:", binary_search(ratings, 4))
```
## Explanation
**Sort the list first.**
**Check the middle element.**
**If target is smaller, search left side.**
**If target is larger, search right side.**
**Repeat until found or exhausted.**

---

## ♦ Step 5: Comparison
Linear Search: Simple, works on unsorted lists, but slow (O(n)).

Binary Search: Fast (O(log n)), but requires sorted data.

---

## ♦ Step 6: Integration with PostgreSQL
Tools used: psycopg2, pandas

**Query Ratings Table**
```python
df_ratings = pd.read_sql("SELECT * FROM ratings LIMIT 10;", conn)
df_ratings
Join Movies with Ratings
python
query = """
SELECT m.movie_id, m.title, r.user_id, r.rating
FROM movies m
INNER JOIN ratings r ON m.movie_id = r.movie_id
LIMIT 10;
"""
df_join = pd.read_sql(query, conn)
df_join
```

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
- Linear search is straightforward but inefficient for large datasets.  
- Binary search is efficient but requires sorted data.  
- Always check file paths and working directories in Jupyter.  
- Avoid re‑creating tables if they already exist in PostgreSQL.  
