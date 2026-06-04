# Day 1 – Netflix Data Engineering Challenge

## 📌 Overview
  
On **Day 1**, I focused on building the foundation of a data engineering pipeline:
- Environment setup with Jupyter Notebook and PostgreSQL.
- Exploring the Netflix dataset using pandas.
- Automating schema generation in Python.
- Importing data into PostgreSQL.
- Practicing SQL basics (SELECT, WHERE, GROUP BY, HAVING).
- Implementing Python data structures (arrays and linked lists).

---


## 📌 Tools Used Today
- **PowerShell** → environment setup, file management  
- **Jupyter Notebook** → interactive coding and exploration  
- **pandas** → data exploration and CSV handling  
- **Python** (f‑strings, list comprehensions, classes) → schema generation and linked list implementation  
- **PostgreSQL** → database storage and SQL queries  
- **psycopg2-binary** → Python ↔ PostgreSQL integration  

---

## 🔹 Step 1: Environment Setup
**Tools used**: PowerShell, Jupyter Notebook, Python 3.14  


```powershell
mkdir C:\Users\jovit\Desktop\Netflix_Project
move C:\Users\jovit\day1_netflix.ipynb C:\Users\jovit\Desktop\Netflix_Project
move C:\Users\jovit\Downloads\netflix_titles.csv C:\Users\jovit\Desktop\Netflix_Project
cd C:\Users\jovit\Desktop\Netflix_Project
jupyter notebook
```
### Explanation
- **mkdir** → creates a new folder  
- **move** → relocates files into the project folder  
- **cd** → changes directory  
- **jupyter notebook** → launches the notebook server in the current folder
  
---
---

## ♦ Step 2: Data Exploration in Jupyter
**Tools used**: pandas
```import pandas as pd
df = pd.read_csv("C:/Users/jovit/Desktop/Netflix_Project/netflix_titles.csv")

df.info()
print(df.columns.tolist())
```
### Explanation
- **pd.read_csv()** → loads CSV into a DataFrame  
- **df.info()** → shows column names, data types, and counts  
- **df.columns.tolist()** → lists all column names  

---
---

## ♦ Step 3: Schema Generation
**Tools used**: Python (f‑strings, list comprehensions)
```
table_name = "netflix"
reserved = {"cast": "cast_name", "type": "show_type"}
cols = [reserved.get(c, c) for c in df.columns]

sql = f"CREATE TABLE {table_name} (\n"
sql += ",\n".join([f'"{c}" TEXT' for c in cols])
sql += "\n);"

print(sql)
```
**Explanation**

| Keyword/Function | Purpose                                      |
|------------------|----------------------------------------------|
| **reserved**     | dictionary replaces reserved SQL keywords    |
| **f"..."**       | f‑string dynamically builds SQL              |
| **join()**       | concatenates column definitions              |
| **TEXT**         | defines string type in PostgreSQL            |

---
---

## ♦ Step 4: PostgreSQL Integration
**Tools used**: psycopg2‑binary
```
pip install psycopg2-binary
```
```
import psycopg2
conn = psycopg2.connect(
    dbname="netflix_db",
    user="postgres",
    password="your_password",
    host="localhost",
    port="5432"
)
cur = conn.cursor()
```
### Explanation
- **psycopg2-binary** → PostgreSQL adapter for Python  
- **connect()** → establishes DB connection  
- **cursor()** → executes SQL commands  

---
---

## ♦ Step 5: Data Loading
**Tools used**: pandas, psycopg2

```python
with open("C:/Users/jovit/Desktop/Netflix_Project/netflix_titles.csv", "r", encoding="utf-8") as f:
    cur.copy_expert(f"COPY {table_name} FROM STDIN WITH CSV HEADER DELIMITER ','", f)

conn.commit()
```
### Explanation
- **with open(...)** → opens the CSV file in read mode with UTF‑8 encoding  
- **cur.copy_expert(...)** → executes a PostgreSQL `COPY` command to bulk load data from the file into the table  
- **CSV HEADER** → ensures the first row (column names) is recognized and skipped during import  
- **DELIMITER ','** → specifies that values are separated by commas  
- **conn.commit()** → saves the transaction, making the imported data permanent in the database  

---
---

## ♦ Step 6: Verification
**Tools used**: SQL, psycopg2

```python
cur.execute("SELECT COUNT(*) FROM netflix;")
print("Row count:", cur.fetchone()[0])

cur.execute("SELECT * FROM netflix LIMIT 5;")
print("Sample rows:", cur.fetchall())
```
### Explanation
- **cur.execute("SELECT COUNT()...")** → runs a SQL query to count all rows in the `netflix` table  
- **cur.fetchone()[0]** → retrieves the first result from the query (the row count)  
- **cur.execute("SELECT * ... LIMIT 5")** → fetches the first 5 rows from the table for sampling  
- **cur.fetchall()** → returns all rows from the executed query as a list of tuples  
- **Output check** → confirms that 8,807 rows were successfully imported into PostgreSQL  

---
---
---

## 🔹 What Went Wrong (and How You Fixed It)

- **Missing psycopg2 library**  
  - Error: `ModuleNotFoundError: No module named 'psycopg2'`  
  - ✅ Fix: Installed **psycopg2-binary** package  

- **Transaction failure**  
  - Error: `InFailedSqlTransaction` during data loading  
  - ✅ Fix: Closed and reopened the session, then retried using `cur.copy_expert(...)` successfully  

- **Reserved keywords**  
  - Issue: Columns named `type` and `cast` caused SQL conflicts  
  - ✅ Fix: Renamed to `show_type` and `cast_name`  

- **Windows path issues**  
  - Issue: PostgreSQL `COPY` command failed with direct file path access  
  - ✅ Fix: Avoided path problems by streaming CSV from pandas or retrying with `copy_expert` after session reset  

---

### 🔹 Lessons Learned
- Installing missing libraries quickly resolves environment errors  
- PostgreSQL transactions abort after a failed command — reopening or rolling back is essential  
- Reserved SQL keywords must be renamed to avoid conflicts  
- File path handling differs across systems; using buffers or session resets ensures portability  

---
