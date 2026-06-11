# Day 4: CTEs, Subqueries, Window Functions & Two Pointers

---

## 🎯 Learning Objectives
- Understand **Common Table Expressions (CTEs)**
- Learn when to use **CTEs vs Subqueries**
- Practice SQL patterns using the **Netflix dataset**
- Understand when **Window Functions** are needed
- Learn the **Two Pointer** DSA pattern
- Solve **interview-style SQL problems**

---

## 📂 Dataset Used

### Netflix Table
- show_id  
- title  
- show_type  
- release_year  
- rating  

### Ratings Table
- rating_id  
- show_id  
- user_id  
- rating  

### Users Table
- user_id  
- user_name  

---

## 📘 Common Table Expressions (CTEs)

A **CTE** is a temporary result set that exists only during query execution.

**Benefits**
- Improves readability  
- Breaks large queries into smaller logical steps  
- Makes complex transformations easier to understand  
- Useful when aggregated results need further analysis  
- Supports recursive queries for hierarchies  

**Syntax**
```sql
WITH cte_name AS (
    SELECT ...
)
SELECT *
FROM cte_name;
```

## Example 1: Average Release Year by Content Type
### Query

```sql
WITH avg_release AS (
    SELECT
        ROUND(AVG(release_year),0) AS avg_releaseyr,
        show_type
    FROM netflix
    GROUP BY show_type
)
SELECT *
FROM avg_release;
```
## Explanation
-The CTE calculates the average release year for each content type.
-The result is stored temporarily in avg_release.
-The main query retrieves the calculated values.
