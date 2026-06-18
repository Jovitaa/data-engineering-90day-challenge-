# Week 02 - Day 02: Data Cleaning & Data Quality using PySpark

## 1. Overview
Data quality is one of the most important responsibilities of a Data Engineer. Before data is loaded into a Data Warehouse, Data Lake, or reporting system, it must be validated and cleaned.

In this exercise, PySpark is used to perform common production-level data quality checks on the user activity dataset.

The objective is to identify:
- clean_users_df
-clean_activity_df
- Invalid watch minutes
- clean_content_df

These datasets form the Silver Layer and are used for downstream analytics and ETL processing..

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
  
---

### Step 11: read the bronze layer datasets into a DataFrame
```python
users_df = pyspark.read.option("header", True).option("inferSchema", True).csv(
    "C:/Users/jovit/Desktop/Netflix_Project/01.-data/03.curated/bronze/users.csv"
) # read the users.csv file into a DataFrame
content_df = pyspark.read.option("header", True).option("inferSchema", True).csv(
    "C:/Users/jovit/Desktop/Netflix_Project/01.-data/03.curated/bronze/netflix_titles_clean.csv"
)
```
**Reads additional Bronze Layer datasets required for building a complete ETL pipeline.**

### Step 12: Clean users_df
```python
clean_users_df = (
    users_df
    .dropDuplicates(["user_id"])
    .filter(col("user_id").isNotNull())
    .filter(col("user_name").isNotNull())
    .filter(col("country").isNotNull())
    .filter(col("subscription_type").isin("Basic", "Standard", "Premium"))
)
```
**Validates user master data by removing duplicates and invalid records.**

### Step 13: Clean content_df
```python
clean_content_df = (
    content_df
    .dropDuplicates(["show_id"])
    .filter(col("show_id").isNotNull())
    .filter(col("title").isNotNull())
    .filter(col("show_type").isin("Movie", "TV Show"))
    .filter(col("release_year").isNotNull())
)
clean_content_df.show(5)
```
**Validates content metadata to ensure only complete and valid Netflix titles are available for analytics.**

### Step 14: Save Silver Layer as CSV files
```python
import pandas as pd
clean_users_df.toPandas().to_csv(
    r"C:\Users\jovit\OneDrive\Documents\GitHub\data-engineering-90day-challenge-\01.Netflix Recommendation Engine\01.-data\03.curated\silver\users.csv",
    index=False
)

clean_activity_df.toPandas().to_csv(
    r"C:\Users\jovit\OneDrive\Documents\GitHub\data-engineering-90day-challenge-\01.Netflix Recommendation Engine\01.-data\03.curated\silver\user_activity.csv",
    index=False
)

clean_content_df.toPandas().to_csv(
    r"C:\Users\jovit\OneDrive\Documents\GitHub\data-engineering-90day-challenge-\01.Netflix Recommendation Engine\01.-data\03.curated\silver\netflix_titles.csv",
    index=False
)
```
**Stores cleaned datasets in the Silver Layer for downstream transformations.**

### Step 15: read the cleaned CSV files into DataFrames
```python
clean_users_df = pyspark.read.option("header", True).option("inferSchema", True).csv(
    r"C:\Users\jovit\OneDrive\Documents\GitHub\data-engineering-90day-challenge-\01.Netflix Recommendation Engine\01.-data\03.curated\silver\users.csv"
)

clean_activity_df = pyspark.read.option("header", True).option("inferSchema", True).csv(
    r"C:\Users\jovit\OneDrive\Documents\GitHub\data-engineering-90day-challenge-\01.Netflix Recommendation Engine\01.-data\03.curated\silver\user_activity.csv"
)

clean_content_df = pyspark.read.option("header", True).option("inferSchema", True).csv(
    r"C:\Users\jovit\OneDrive\Documents\GitHub\data-engineering-90day-challenge-\01.Netflix Recommendation Engine\01.-data\03.curated\silver\netflix_titles.csv"
)
```
**Loads validated Silver Layer datasets back into Spark for future business transformations.**

**Notes:**
- Silver Layer was created after applying data quality checks on raw Bronze data.
- In production, Spark writes Silver data as Parquet/Delta.
- In this local Windows setup, Spark write failed due to missing Hadoop winutils configuration, so Pandas was temporarily used only for saving the cleaned output as CSV.

---
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

  ## Q9. What are Bronze, Silver, and Gold Layers?

- **Bronze Layer:**  
  Raw ingested data from source systems.  

- **Silver Layer:**  
  Cleaned, validated, and standardized datasets.  

- **Gold Layer:**  
  Business-ready datasets used for reporting, dashboards, and analytics.  

---

## ✅ Deliverable
 
 - **clean_users_df** - cleaned user dimension dataset
 - **clean_activity_df** - cleaned user activity fact dataset
 - **clean_content_df** - cleaned Netflix content dimension dataset

Silver Layer Output:
- silver/users.csv
- silver/user_activity.csv
- silver/netflix_titles.csv

### Day 2 Output
- ✓ No duplicates  
- ✓ No missing IDs  
- ✓ No invalid watch minutes  
- ✓ Correct data types

##   💾 Save Dataset if using spark 
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
**In production, this Silver Layer would usually be saved as Parquet or Delta. 
For this local Windows setup, the cleaned DataFrames were saved as CSV using Pandas because Spark write required additional Hadoop/winutils configuration.**
