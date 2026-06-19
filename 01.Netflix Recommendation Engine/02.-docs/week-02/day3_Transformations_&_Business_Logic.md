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

## Usage Today
- **user_activity + users** → Enrich activity records with user details  
- **user_activity + netflix_titles** → Add content metadata to activity records  

This operation is the foundation for building the **Gold Layer dataset**, enabling **aggregation and analytics** across multiple dimensions.
