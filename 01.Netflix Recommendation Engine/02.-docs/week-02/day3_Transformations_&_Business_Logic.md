# Week 02 / Day 03 — Transformations & Business Logic

## 01. Overview

Today’s focus is on building the **Gold Layer dataset** from the cleaned **Silver Layer datasets**.  
This step represents the **business logic and transformations** phase of the ETL pipeline, where raw activity data is enriched with user and content information to produce analytics-ready outputs.

### Datasets Used
- **clean_activity_df** → Validated user activity records  
- **clean_users_df** → Standardized user information  
- **clean_content_df** → Cleaned Netflix content metadata  

The Gold Layer will combine these datasets to generate **aggregated insights** such as:
- Total watch minutes per user  
- Number of shows watched  
- Country-level viewing statistics  
- Genre popularity trends

## user_summary_df

### Output Columns
- **user_id**  
- **user_name**  
- **country**  
- **total_watch_minutes**  
- **shows_watched**

### Business Meaning
Each row represents a **single user**, showing:
- Their **total watch time** (aggregated minutes)  
- The **number of unique shows** they have watched  

This dataset provides a **user-level engagement summary**.

### Use Cases
- **User engagement analytics** → Measure activity and retention  
- **Recommendation systems** → Suggest content based on viewing behavior  
- **Country-level reporting** → Compare engagement across regions  
- **Subscription behavior analysis** → Understand usage patterns by plan/country  
- **Dashboarding** → Power BI / Tableau visualizations for stakeholders

  ---
## 02. Concepts Used

### 2.1 **[join()](ca://s?q=Explain_join_function_in_PySpark)**
- **Definition:** Combines two DataFrames using a common column.  
- **Syntax Example:**
```python
df1.join(df2, on="user_id", how="inner")
```
#### Usage Today
- **user_activity + users** → Enrich activity records with user details  
- **user_activity + netflix_titles** → Add content metadata to activity records  

This operation is the foundation for building the **Gold Layer dataset**, enabling **aggregation and analytics** across multiple dimensions.

### 2.2 **[groupBy()](ca://s?q=Explain_groupBy_in_PySpark)**
- **Definition:** Groups records at a specific business level.  
- **Syntax Example:**
```python
df.groupBy("user_id", "user_name", "country")
```
#### Usage Today
- Creates **one group per user**, enabling aggregation of watch minutes and unique shows watched.
- This grouping is essential for building the **user_summary_df** dataset in the Gold Layer.

### 2.3 **[agg()](ca://s?q=Explain_agg_in_PySpark)**
- **Definition:** Applies aggregate calculations across grouped records.  
- **Syntax Example:**
```python
df.agg(
    spark_sum("watch_minutes").alias("total_watch_minutes"),
    countDistinct("show_id").alias("shows_watched")
)
```
#### Usage Today:
Used to calculate user-level metrics such as:
- Total_watch_minutes → Sum of all watch minutes per user
- shows_watched → Count of distinct shows watched by each user

----
## 03. Production-Style Code Demonstration

### Step 1: Import required libraries
   ```python
# Import SparkSession to initialize and manage the Spark application
from pyspark.sql import SparkSession

# Import functions for column operations and aggregations
from pyspark.sql.functions import col, sum as spark_sum, countDistinct
 ```
#### Explanation:

- **[SparkSession](ca://s?q=Explain_SparkSession_in_PySpark):** Entry point to Spark, required to create DataFrames and run transformations.  
- **[col()](ca://s?q=Explain_col_function_in_PySpark):** Used to reference DataFrame columns in transformations.  
- **[spark_sum()](ca://s?q=Explain_sum_function_in_PySpark):** Aggregates numeric values, here used to calculate total watch minutes.  
- **[countDistinct()](ca://s?q=Explain_countDistinct_in_PySpark):** Counts unique values, here used to calculate the number of distinct shows watched per user.

 ### Step 2: Create SparkSession

```python
# Initialize SparkSession — the entry point to Spark
# Naming convention follows the Day 2 notebook style
pyspark = (
    SparkSession.builder
    .appName("UserEngagementGoldLayer")  # Application name for tracking in Spark UI
    .getOrCreate()
)
 ```
### Explanation

- **[SparkSession](ca://s?q=Explain_SparkSession_in_PySpark):** Required to start any Spark application.  
- **appName("UserEngagementGoldLayer")** → Assigns a meaningful name to the Spark job, useful for monitoring in the Spark UI.  
- **getOrCreate()** → Creates a new SparkSession if none exists, or reuses the existing one.

### Step 3: Read Silver Layer Datasets
```python
# Read the cleaned Users dataset from the Silver Layer
clean_users_df = pyspark.read.option("header", True).option("inferSchema", True).csv(
    r"C:\Users\jovit\OneDrive\Documents\GitHub\data-engineering-90day-challenge-\01.Netflix Recommendation Engine\01.-data\03.curated\silver\users.csv"
)

# Read the cleaned User Activity dataset from the Silver Layer
clean_activity_df = pyspark.read.option("header", True).option("inferSchema", True).csv(
    r"C:\Users\jovit\OneDrive\Documents\GitHub\data-engineering-90day-challenge-\01.Netflix Recommendation Engine\01.-data\03.curated\silver\user_activity.csv"
)

# Read the cleaned Netflix Titles dataset from the Silver Layer
clean_content_df = pyspark.read.option("header", True).option("inferSchema", True).csv(
    r"C:\Users\jovit\OneDrive\Documents\GitHub\data-engineering-90day-challenge-\01.Netflix Recommendation Engine\01.-data\03.curated\silver\netflix_titles.csv"
)
 ```
### Explanation

- **[clean_users_df](ca://s?q=Explain_clean_users_df):** Contains standardized user details (IDs, names, countries).  
- **[clean_activity_df](ca://s?q=Explain_clean_activity_df):** Holds validated user activity records (watch minutes, show IDs).  
- **[clean_content_df](ca://s?q=Explain_clean_content_df):** Includes curated Netflix content metadata (titles, genres, release years).

### Step 4: Select Only Required Columns

```python
# Select only the necessary columns from the User Activity dataset
activity_selected_df = clean_activity_df.select(
    "user_id",        # Unique identifier for each user
    "show_id",        # Unique identifier for each show
    "watch_minutes"   # Total minutes watched
)

# Select only the necessary columns from the Users dataset
users_selected_df = clean_users_df.select(
    "user_id",        # Unique identifier for each user
    "user_name",      # User's name
    "country"         # User's country
)

# Select only the necessary columns from the Content dataset
content_selected_df = clean_content_df.select(
    "show_id",        # Unique identifier for each show
    "title",          # Show title
    "show_type"       # Type of show (Movie/TV Show)
)
 ```
### Explanation

- **[activity_selected_df](ca://s?q=Explain_activity_selected_df):** Keeps only `user_id`, `show_id`, and `watch_minutes` for aggregation.  
- **[users_selected_df](ca://s?q=Explain_users_selected_df):** Retains `user_id`, `user_name`, and `country` for enrichment.  
- **[content_selected_df](ca://s?q=Explain_content_selected_df):** Preserves `show_id`, `title`, and `show_type` for metadata joins.  

In **production pipelines**, unnecessary columns are removed before joins to **reduce memory usage and shuffle cost**, ensuring efficient execution of transformations.

### Step 5: Validate Join Keys

```python
# Validate schema of the Activity dataset
activity_selected_df.printSchema()

# Validate schema of the Users dataset
users_selected_df.printSchema()

# Validate schema of the Content dataset
content_selected_df.printSchema()
 ```
### Explanation

- **[activity_selected_df](ca://s?q=Explain_activity_selected_df):** Ensures `user_id` and `show_id` exist with correct data types.  
- **[users_selected_df](ca://s?q=Explain_users_selected_df):** Confirms `user_id` is present and compatible for joining with activity records.  
- **[content_selected_df](ca://s?q=Explain_content_selected_df):** Validates `show_id` for joining with activity records.  

By validating these **join keys**, we ensure that the **Gold Layer transformations** will run smoothly without schema mismatches or runtime errors.

### Step 6: Join User Activity with Users

```python
# Perform an inner join between Activity and Users datasets
# This enriches each activity record with user profile details
activity_users_df = (
    activity_selected_df
    .join(
        users_selected_df,   # Users dataset
        on="user_id",        # Common join key
        how="inner"          # Inner join ensures only matching records are kept
    )
)
 ```
### Explanation

- **[activity_selected_df](ca://s?q=Explain_activity_selected_df):** Provides activity records with `user_id`, `show_id`, and `watch_minutes`.  
- **[users_selected_df](ca://s?q=Explain_users_selected_df):** Supplies user profile information (`user_name`, `country`).  
- **Join Logic:** Uses `user_id` as the common key with an **inner join** to ensure only valid matches are included.  

This join adds **user profile information** such as `user_name` and `country` to each activity record, enriching the dataset for downstream analytics in the **Gold Layer user_summary_df**.

### Step 7: Join with Netflix content

```python
# Perform an inner join between Activity and Users datasets
# This enriches each activity record with user profile details
activity_users_df = (
    activity_selected_df
    .join(
        users_selected_df,   # Users dataset
        on="user_id",        # Common join key
        how="inner"          # Inner join ensures only matching records are kept
    )
)
 ```
### Explanation

- **[activity_users_df](ca://s?q=Explain_activity_users_df):** Contains enriched activity records with user profile details (`user_name`, `country`).  
- **[content_selected_df](ca://s?q=Explain_content_selected_df):** Provides content metadata (`title`, `show_type`).  
- **Join Logic:** Uses `show_id` as the common key with an **inner join** to ensure only valid matches are included.  

This join adds **content details** such as `title` and `show_type` to each user activity record, completing the enrichment process for building the **Gold Layer user_summary_df**.

### Step 8: Create user_summary_df

```python
# Aggregate user-level metrics from the enriched dataset
user_summary_df = (
    activity_users_content_df
    .groupBy(
        "user_id",     # Grouping by unique user identifier
        "user_name",   # Grouping by user name
        "country"      # Grouping by country for regional analysis
    )
    .agg(
        spark_sum("watch_minutes").alias("total_watch_minutes"),  # Total minutes watched per user
        countDistinct("show_id").alias("shows_watched")           # Number of unique shows watched per user
    )
    .orderBy(col("total_watch_minutes").desc())  # Sort users by highest watch time
)
 ```
### Explanation

- **[activity_users_content_df](ca://s?q=Explain_activity_users_content_df):** Provides enriched activity records with user profile and content metadata.  
- **[groupBy()](ca://s?q=Explain_groupBy_in_PySpark):** Groups the dataset at the **user level** (`user_id`, `user_name`, `country`).  
- **[agg()](ca://s?q=Explain_agg_in_PySpark):** Performs aggregations for each user:  
  - **total_watch_minutes** → Sum of all watch minutes.  
  - **shows_watched** → Count of distinct shows watched.  
- **[orderBy()](ca://s?q=Explain_orderBy_in_PySpark):** Sorts users in descending order of total watch minutes, highlighting the most engaged users.  

This step produces the **[user_summary_df](ca://s?q=Explain_user_summary_df)** dataset, which is the **Gold Layer deliverable** for **user engagement analytics**.

### Step 10: Validate Final Output

```python
# Validate schema of the final Gold Layer dataset
user_summary_df.printSchema()

# Count total number of records in the final dataset
user_summary_df.count()

# Optional validation checks

# Ensure no null values exist in total_watch_minutes
user_summary_df.filter(col("total_watch_minutes").isNull()).show()

# Ensure all users have watched at least one show
user_summary_df.filter(col("shows_watched") <= 0).show()
 ```
### Explanation

- **[user_summary_df](ca://s?q=Explain_user_summary_df):** Final Gold Layer dataset containing user-level engagement metrics.  
- **printSchema():** Confirms schema correctness and data types of all columns.  
- **count():** Validates total number of records produced in the Gold Layer.  

**Optional Validations:**
- Check for **null values** in `total_watch_minutes`.  
- Ensure **shows_watched** is greater than zero for all users.  

The **final Gold Layer output** should not have **null metrics** or **invalid show counts**, ensuring the dataset is **clean, reliable, and ready for analytics, reporting, and dashboarding**.

 ### Step 11: Save Gold Layer Locally

```python
# Save the final Gold Layer dataset locally as CSV using Pandas
# This is a temporary workaround for Windows Hadoop/winutils issues
user_summary_df.toPandas().to_csv(
    r"C:\Users\jovit\OneDrive\Documents\GitHub\data-engineering-90day-challenge-\01.Netflix Recommendation Engine\01.-data\03.curated\gold\user_summary.csv",
    index=False
)
 ```
### Explanation

- **[user_summary_df](ca://s?q=Explain_user_summary_df):** Final Gold Layer dataset containing user-level engagement metrics.  
- **toPandas().to_csv():** Converts the PySpark DataFrame to Pandas and saves it as a CSV file locally.  
- **Local Path:** Saves the file under the `gold` folder in the curated data directory.  

In **production environments**, the Gold Layer would typically be saved as **Parquet, Delta, or written into a data warehouse** for scalability and performance.  
In this **local Windows setup**, CSV is used temporarily because Spark write requires **Hadoop/winutils configuration** on Windows.

---
## 04. Product Company Style Interview Questions & Answers

**Q1. Why should Day 10 use Silver Layer data instead of Bronze Layer data?**  
Because **[Bronze Layer](ca://s?q=Explain_Bronze_Layer_in_data_engineering)** data is raw and may contain duplicates, nulls, invalid values, and inconsistent types.  
**[Silver Layer](ca://s?q=Explain_Silver_Layer_in_data_engineering)** data is cleaned and validated, so it is safer for business transformations.

**Q2. What type of join did we use and why?**  
We used **[inner join](ca://s?q=Explain_inner_join_in_PySpark)** because the final summary should include only valid users with valid activity and valid content records.

**Q3. What happens if a user_id exists in activity but not in users?**  
With an inner join, that record is removed from the final output. In production, unmatched records may also be sent to a **reject or quarantine table** for investigation.

**Q4. Why select only required columns before joining?**  
It reduces memory usage, network shuffle, and execution time. This is a common **[Spark optimization](ca://s?q=Explain_Spark_optimization_techniques)** technique.

**Q5. What is shuffle in Spark joins?**  
**[Shuffle](ca://s?q=Explain_shuffle_in_Spark)** is the movement of data across partitions or nodes so Spark can match join keys or aggregate groups. Large shuffles can slow down Spark jobs.

**Q6. Why use countDistinct(show_id) instead of count(show_id)?**  
Because a user may watch the same show multiple times. **[countDistinct()](ca://s?q=Explain_countDistinct_in_PySpark)** gives the number of unique shows watched.

**Q7. What is the difference between groupBy() and agg()?**  
- **[groupBy()](ca://s?q=Explain_groupBy_in_PySpark):** Defines the grouping level.  
- **[agg()](ca://s?q=Explain_agg_in_PySpark):** Defines the calculations to perform on each group.  

Example:  
```python
.groupBy("user_id").agg(spark_sum("watch_minutes"))
```

**Q8. What is Gold Layer?**  
The **[Gold Layer](ca://s?q=Explain_Gold_Layer_in_data_engineering)** contains business-ready datasets created from cleaned **[Silver Layer](ca://s?q=Explain_Silver_Layer_in_data_engineering)** data. These datasets are used for **dashboards, reporting, analytics, and machine learning**.

**Q9. What production issues can happen during joins?**  
Common issues:  
- **[data skew](ca://s?q=Explain_data_skew_in_Spark)**  
- large shuffle  
- duplicate keys  
- missing join keys  
- wrong join type  
- schema mismatch  
- memory pressure  

**Q10. How can Spark joins be optimized?**  
Common techniques:  
- Select required columns before join  
- Filter data before join  
- **[Broadcast](ca://s?q=Explain_broadcast_join_in_Spark)** small dimension tables  
- Partition large datasets by join keys  
- Avoid unnecessary wide transformations  
- Cache reusable DataFrames  

---

## 05. Summary  

Day 10 focused on **Spark transformations and business logic**.  

You used:  
- **[join()](ca://s?q=Explain_join_function_in_PySpark)**  
- **[groupBy()](ca://s?q=Explain_groupBy_in_PySpark)**  
- **[agg()](ca://s?q=Explain_agg_in_PySpark)**  
- **[sum()](ca://s?q=Explain_sum_in_PySpark)**  
- **[countDistinct()](ca://s?q=Explain_countDistinct_in_PySpark)**  

You created:  
- **[user_summary_df](ca://s?q=Explain_user_summary_df)**  

This is the **first Gold Layer dataset** in your **Netflix ETL project**.
