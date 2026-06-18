# 📅 Week 2 — Netflix User Activity ETL Pipeline

## Week 2 Overview
This week focuses on building a **production-style ETL pipeline** using PySpark and Azure services, mimicking what Data Engineers at product-based companies (Microsoft, Amazon, Netflix, Uber) are expected to deliver.  

You’ll move beyond syntax practice into **real-world project execution**: ingesting data, validating quality, transforming records, orchestrating pipelines, and optimizing performance.

---
## 01. Day 1 Overview -PySpark Fundamentals
Day 1 marks the start of the **Netflix User Activity ETL Pipeline** project.  
The focus is on setting up the development environment and ensuring all required tools are installed and configured correctly. 
- Spark Session
- Data frames
- Schema Interface
- CSV Integration

**Objective:**  
- Install and configure Python, PySpark, Java/JVM  
- Set environment variables (`JAVA_HOME`, `PATH`)  
- Verify SparkSession creation  
- Prepare the foundation for ETL development  

**Deliverable:**  
- Working SparkSession (`NetflixETL`)  
- Verified toolchain (Python, PySpark, Java, VS Code, Jupyter Notebook)

---

## 02. Tool Purpose Summary

| Tool              | Why We Use It                                |
|-------------------|----------------------------------------------|
| Python            | Write ETL and data processing logic          |
| PySpark           | Process large datasets efficiently           |
| Java/JVM          | Runtime required for Spark Engine            |
| SparkSession      | Entry point to Spark                         |
| VS Code           | Development environment                      |
| Jupyter Notebook  | Interactive development and testing          |
| pip               | Install and manage Python packages           |

----
## Tools Used and Why We Use Them

---

### 1. Python
**Why are we using Python?**  
Python is the primary programming language for Data Engineering because it provides:
- Easy data manipulation  
- ETL development  
- Automation  
- Integration with big data tools  

**In This Project:**  
- Write PySpark code  
- Build ETL logic  
- Process Netflix user activity data  

**Industry Usage:**  
Extensively used in Microsoft, Amazon, Netflix, Uber, Airbnb.

---

### 2. PySpark
**Why are we using PySpark?**  
Real-world product companies process millions or billions of records. PySpark enables:
- Distributed processing  
- Parallel execution  
- Large-scale ETL  
- Big data analytics  

**In This Project:**  
- Read datasets  
- Clean data  
- Transform records  
- Join datasets  
- Build aggregations  

**Example:**
```python
df.groupBy("country").count()
```

## Why Not Pandas?

## Key Differences

| Feature         | Pandas                  | PySpark                          |
|-----------------|-------------------------|----------------------------------|
| Processing      | Single Machine          | Distributed Processing           |
| Data Size       | Small to Medium         | Large to Massive                 |
| Memory Usage    | Entire dataset in RAM   | Distributed across nodes         |
| Performance     | Faster for small data   | Better for big data workloads    |
| Scalability     | Limited                 | Highly scalable                  |
| Execution       | Local machine           | Cluster environment              |
| Use Case        | Data Analysis           | ETL Pipelines & Big Data         |
| Data Structure  | Pandas DataFrame        | Spark DataFrame                  |

---
### 3. Java (JVM)

**Why are we using Java?**  
Apache Spark is built in Scala and runs on the JVM. PySpark is only a Python wrapper.  

**Without Java:** Spark cannot start.  

**Example Error:**  
`JAVA_HOME is not set`

---
### 4. SparkSession

**Why are we using SparkSession?**  
SparkSession is the entry point to Spark. Without it, Spark cannot:  
- Read files  
- Create DataFrames  
- Execute transformations
  
 **Example** 
```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("NetflixETL") \
    .getOrCreate()
```
**In This Project**

- Creates the Spark application  
- Manages resources  
- Connects Python to the Spark Engine
---
### 5. VS Code

**Why are we using VS Code?**  
Provides:  
- Notebook support  
- Python support  
- Git integration  
- Debugging capabilities  

**In This Project:**  
- Writing PySpark code  
- Running notebooks  
- Managing project files  

**Why Not Jupyter Notebook?**  
VS Code combines **Code + Notebooks + GitHub + Terminal** in one application.

---

### 6. Jupyter Notebook (.ipynb)

**Why are we using Notebooks?**  
Allows iterative development. Data Engineers use notebooks for:  
- Exploration  
- Testing  
- Prototyping  

**In This Project:**  
- Test PySpark transformations  
- Inspect DataFrames  
- Validate ETL logic  

----
### 7. pip

**Why are we using pip?**  
pip is Python's package manager.

**In This Project:**  
Install PySpark:
```bash
pip install pyspark
```
**Benefit:** 
Easy installation and management of dependencies.

---
## 03. Code Snippets & Demonstration

### 3.1 Verification of Installed tools and libraries

#### Step 1: Verify Python installation
```python
python --version
```
**Output:** Python 3.14.5

#### Step 2: Verify Java installation
```python
java -version
```
#### Step 3: Configure Environment Variables
**Example:**
JAVA_HOME = C:\Program Files\Java\jdk-17
PATH = %JAVA_HOME%\bin

---
### 3.2 Getting Started with Pyspark 

#### Step 1: Install PySpark
```bash
pip install pyspark
```
**Explanation:** Pyspark is installed using pip, python's package manager.

#### Step 2: Verify PySpark installation
```python
python -m pip show pyspark
```
**Output:** pyspark 4.1.2

#### Step 3: Create SparkSession
```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("NetflixETL") \
    .getOrCreate()
print(spark.version)   # Verify Spark version
```
**Explanation:** Spark point is the entry point to spark session. 

#### Step 4:  Generate Users Dataset with Pandas  
```python
import pandas as pd
import random

# Define countries and subscription types
countries = ["India","USA","UK","Canada","Australia","Germany","France"]
subscription_types = ["Basic","Standard","Premium"]

# Generate 500 users with random country and subscription plan
users = []
for user_id in range(1, 501):
    users.append([
        user_id,
        f"User_{user_id}",
        random.choice(countries),
        random.choice(subscription_types)
    ])

# Convert list to Pandas DataFrame
users_df = pd.DataFrame(users, columns=["user_id","user_name","country","subscription_type"])

# Export to CSV
users_df.to_csv("C:/Users/jovit/Desktop/Netflix_Project/users.csv", index=False)

# Display first 5 records
print(users_df.head())  
```

#### Step 5: Generate User Activity Dataset
```python
import pandas as pd
import random

# Load Netflix titles dataset
netflix = pd.read_csv("C:/Users/jovit/Desktop/Netflix_Project/netflix_titles_clean.csv")

# Extract show IDs
show_ids = netflix["show_id"].tolist()

# Generate 5000 activity records
activities = []
for i in range(1, 5001):
    activities.append([
        i,
        random.randint(1, 500),       # Random user ID
        random.choice(show_ids),      # Random show ID
        random.randint(10, 300)       # Random watch time
    ])

# Convert to DataFrame
activity_df = pd.DataFrame(activities, columns=["activity_id","user_id","show_id","watch_minutes"])

# Export to CSV
activity_df.to_csv("C:/Users/jovit/Desktop/Netflix_Project/user_activity.csv", index=False) 
```
#### Step 6: Read Netflix Titles into PySpark DataFrame
```python
content_df = spark.read.csv(
    "C:/Users/jovit/Desktop/Netflix_Project/netflix_titles_clean.csv",
    header=True,
    inferSchema=True
)

# Inspect schema and sample records
content_df.printSchema()
content_df.show(5)

# Count rows and columns
content_df.count()
len(content_df.columns)
```
#### Step 7: Read Users and Activity into PySpark DataFrames
```python
users_df = spark.read.csv(
    "C:/Users/jovit/Desktop/Netflix_Project/users.csv",
    header=True,
    inferSchema=True
)

activity_df = spark.read.csv(
    "C:/Users/jovit/Desktop/Netflix_Project/user_activity.csv",
    header=True,
    inferSchema=True
)

# Inspect sample records
users_df.show()
activity_df.show()

# Inspect schema
users_df.printSchema()
activity_df.printSchema()
```

---

## 04. Interview Focus QnAs


**Q1: What is the difference between Pandas and PySpark?**  
**A:** Pandas is a Python library for in-memory data analysis on a single machine and is suitable for small to medium datasets.  
PySpark is the Python API for Apache Spark and is designed for distributed processing of large datasets across multiple machines.  
Pandas is commonly used for analysis, while PySpark is widely used in Data Engineering for ETL pipelines and big data processing.

---
**Q2: Why did you use Pandas to create users.csv instead of PySpark?**
**A:** We used Pandas because the objective was to generate small sample datasets for testing. Pandas is lightweight and efficient for creating a few hundred or thousand records. PySpark is designed for distributed processing of large datasets and would introduce unnecessary overhead for simple data generation. Once the datasets were created, PySpark was used for the actual ETL processing and transformations.

---
**Q3: Why do we use index=False in to_csv()?**
**A:** Pandas automatically maintains a row index. By default, to_csv() exports this index as an additional column. Using index=False prevents the index from being written to the file, ensuring that only actual business data columns are stored in the CSV. This avoids unnecessary columns during downstream ETL processing.

---
**Q4: When would you use a Jupyter Notebook instead of a Python script?**
**A:** Jupyter Notebooks are useful for exploration, analysis, debugging, and prototyping because they allow code to be executed interactively. Python scripts are preferred for production ETL pipelines, automation, scheduling, and deployment because they are easier to maintain, version control, and integrate with orchestration tools such as Azure Data Factory and Databricks.

---
**Q5: What is an .ipynb file?**
**A:** An .ipynb file is the notebook file format used by Jupyter. It stores code cells, markdown, outputs, and execution metadata. Although it originated with Jupyter, it can be opened and edited in tools such as VS Code, Google Colab, Azure ML, and JupyterLab.
