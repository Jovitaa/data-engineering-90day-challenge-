# Day 3 – Window Functions & Merge Sort

## 🎯 Objective
Learn **SQL window functions** * using the Netflix dataset.

---

# 📊 Dataset – Netflix Titles

## 🎬 Source
**Netflix Titles Dataset**

---

## 📑 Columns Used
- **title** → Name of the movie or show  
- **show_type** → Type of content (Movie / TV Show)  
- **release_year** → Year the title was released  
- **date_added** → Date the title was added to Netflix  

---

## 🎯 Purpose
This dataset will be used for:
- Practicing **SQL window functions** (`ROW_NUMBER`, `RANK`, `DENSE_RANK`)  
- Implementing **sorting algorithms** (e.g., Merge Sort in Python)  
- Ranking and analyzing Netflix titles by popularity and release trends

# Part 1: SQL Window Functions

## 📌 ROW_NUMBER()

**Definition:**  
Assigns a unique sequential number to each row in the result set.

```sql
SELECT
    title,
    release_year,
    ROW_NUMBER() OVER (
        ORDER BY release_year DESC
    ) AS row_num
FROM netflix;
```
---

## 📌 RANK()


**Definition:**  
Assigns ranks to rows, skipping ranks for duplicates.

``` SELECT
    title,
    release_year,
    RANK() OVER(
        ORDER BY release_year DESC
    ) AS movie_rank
FROM netflix;
```
## 📌 DENSE_RANK()

**Definition:**  
Assigns ranks to rows without skipping rank numbers for duplicates.

```
SELECT
    title,
    release_year,
    DENSE_RANK() OVER(
        ORDER BY release_year DESC
    ) AS dense_rank
FROM netflix;
```

## 📌 PERCENT_RANK()

**Definition:**  
Shows the relative rank of a row as a percentage between 0 and 1.

```
SELECT
    title,
    show_type,
    release_year,
    PERCENT_RANK() OVER(
        PARTITION BY show_type
        ORDER BY release_year DESC
    ) AS release_rank
FROM netflix;
```
# 📊 Summary – SQL Window Functions

- **ROW_NUMBER()** → Sequential numbering.  
- **RANK()** → Ranking with gaps for ties.  
- **DENSE_RANK()** → Ranking without gaps for ties.  
- **PARTITION BY** → Groups rows so ranking restarts within each group.

---

# 📝 Key Takeaways

- Learned the difference between **ROW_NUMBER()**, **RANK()**, and **DENSE_RANK()**.  
- Understood how **PARTITION BY** creates separate ranking groups.  
- Applied **SQL ranking concepts** and **Python sorting concepts** to the same Netflix dataset.
