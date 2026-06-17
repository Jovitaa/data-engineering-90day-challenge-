# Week 02 - Day 02: Data Cleaning & Data Quality using PySpark

## 1. Overview
Data quality is one of the most important responsibilities of a Data Engineer. Before data is loaded into a Data Warehouse, Data Lake, or reporting system, it must be validated and cleaned.

In this exercise, PySpark is used to perform common production-level data quality checks on the user activity dataset.

The objective is to identify:
- Missing IDs
- Duplicate records
- Invalid watch minutes
- Incorrect data types

After validation, a cleaned dataset called **clean_activity_df** is created for downstream analytics and ETL processing.

---

## 2. Concepts Used

### 2.1 dropDuplicates()
Removes duplicate records from a DataFrame.

**Why is it needed?**
Duplicate records can occur due to:
- Multiple data ingestion runs
- Retry mechanisms in ETL pipelines
- Source system errors

**Syntax**
```python
df.dropDuplicates(["column_name"])
```
## Example
```python
activity_df.dropDuplicates(["activity_id"])
```

### 2.2 fillna()
Replaces NULL values with specified default values.

**Why is it needed?**
Missing values can cause:
- Reporting errors
- Aggregation issues
- Machine Learning failures

  **Syntax**
```python
df.fillna({"column":"value"})
```
## Example
```python
users_df.fillna({"country":"Unknown"})
```

### 2.3 withColumn()
Creates a new column or modifies an existing column.

**Why is it needed?**
Used extensively in ETL pipelines for:
- Data transformations
- Business calculations
- Derived columns

   **Syntax**
```python
df.withColumn("new_column", expression)
```
## Example
```python
activity_df.withColumn("watch_hours",col("watch_minutes") / 60)
```

### 2.4 cast()
Converts one data type into another.

**Why is it needed?**
Source systems often store numeric values as strings. Analytics systems require proper data types.

**Syntax**
```python
col("column_name").cast("datatype")
```
## Example
```python
activity_df.withColumn( "watch_minutes",col("watch_minutes").cast("int"))
```

---

## 3. Code Demonstration

### Step 1: Import Required Libraries
```python
# import necessary libraries
from pyspark.sql import SparkSession
from pyspark.sql.functions import col
```
### Explanation  
- SparkSession initializes PySpark.
- col() is used to reference DataFrame columns.

### Step 2: Create Spark Session
```python
# create a SparkSession
pyspark = SparkSession.builder.appName("DataQualityChecks").getOrCreate()
```
### Explanation  
- Creates a Spark application that will execute all transformations.

### Step 3: Load Dataset
```python
#load dataset
activity_df = pyspark.read.csv("C:/Users/jovit/Desktop/Netflix_Project/01.-data/03.curated/user_activity.csv", header=True, inferSchema=True)
```
### Explanation  
- Reads CSV file.
- Uses first row as header.
- Automatically detects column data types.

### Step 4: Examine Dataset
```python
activity_df.show(5) #column structure
activity_df.printSchema() #show datatypes
activity_df.count()   # count rows
```
### Explanation  
Before cleaning data, engineers profile the dataset.
This helps understand:
- Row count
- Data types
- Column structure

### Step 5: Check Missing IDs
```python
#checking Missing Ids
activity_df.filter(col("activity_id").isNull()).show()
activity_df.filter(col("user_id").isNull()).show()
activity_df.filter(col("show_id").isNull()).show()
```
### Explanation  
Primary keys should never be NULL.

### Step 6: Check Duplicate Records
```python
#Check duplicate records
activity_df.groupBy("activity_id")\
    .count()\
    .filter(col("count") > 1).show()
```
### Explanation  
- Finds duplicate activity records.
If count > 1, duplicate records exist.

### Step 7: Check Invalid Watch Minutes
```python
#Check invalid watch minutes
activity_df.filter(col("watch_minutes")<0).show()
activity_df.filter((col("watch_minutes")<0) | (col("watch_minutes")>300)).show()
```
### Explanation  
- Negative watch duration is invalid business data.

### Step 8: Convert Data Type
```python
activity_df = activity_df.withColumn("watch_minutes", col("watch_minutes").cast("int"))
```
### Explanation  
- Converts watch_minutes into integer format.

### Step 9: Create Derived Column
```python
activity_df = activity_df.withColumn(
    "watch_hours",
    col("watch_minutes") / 60
)
```
### Explanation  
- Creates a new business metric.
Example: 120 minutes = 2 hours

### Step 10: Create Clean Dataset
```python
clean_activity_df = (
    activity_df
    .dropDuplicates(["activity_id"])
    .filter(col("activity_id").isNotNull())
    .filter(col("user_id").isNotNull())
    .filter(col("show_id").isNotNull())
    .filter(col("watch_minutes") > 0)
)
```
### Explanation  
Pipeline performs:
- Duplicate removal
- Null validation
- Business rule validation
- Result: clean_activity_df

## 🎯 Interview Questions

- **Q1. Importance of Data Quality**  
  Poor data → wrong dashboards, bad decisions, failed ML models, broken systems.  
  Checks ensure reliable analytics.

- **Q2. Types of Checks**  
  Nulls, duplicates, data type, range, referential integrity, format.

- **Q3. dropDuplicates vs distinct**  
  - `distinct()` → removes duplicates across all columns.  
  - `dropDuplicates(["activity_id"])` → removes based on specific columns.

- **Q4. Why cast columns?**  
  Source files store numbers as strings. Casting → correct aggregations, schema enforcement, better performance.  
  Example: `"100" → 100`

- **Q5. Identify duplicates**  
  ```python
  df.groupBy("id").count().filter(col("count") > 1)
  ```

**Q6. Handle NULLs**   
Options: drop rows, replace defaults, impute, quarantine.
Example:
```python
fillna({"country":"Unknown"})
 ```
## Q7. Handle Negative `watch_minutes`
Violates business rules → remove, flag, or send to exception tables.

## Q8. Data Profiling
Analyze before transformation:
- Row counts  
- Data types  
- Null %  
- Duplicates  
- Distributions  

---

## ✅ Deliverable
**clean_activity_df** → validated & cleaned dataset ready for ETL.

### Day 2 Output
- ✓ No duplicates  
- ✓ No missing IDs  
- ✓ No invalid watch minutes  
- ✓ Correct data types

##   💾 Save Dataset
### CSV
 ```python
clean_activity_df.write \
    .mode("overwrite") \
    .option("header", True) \
    .csv("../../01-data/03.curated/clean_activity")
```
### Parquet (Recommended)
 ```python
clean_activity_df.write \
    .mode("overwrite") \
    .parquet("../../01-data/03.curated/clean_activity")
 ```
**Benefits:** faster reads, smaller storage, schema preserved, Spark‑preferred.
