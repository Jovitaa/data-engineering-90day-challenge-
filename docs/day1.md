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

## ♦ Step 2: Data Exploration
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







