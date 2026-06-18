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

| Pandas           | PySpark                  |
|------------------|--------------------------|
| Single machine   | Distributed              |
| Memory limited   | Handles large datasets   |
| Good for analysis| Good for ETL pipelines   |

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

# Step 1: Install PySpark
```bash
pip install pyspark
```

# Step 2: Create SparkSession
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("NetflixETL") \
    .getOrCreate()

print(spark.version)   # Verify Spark version

# Step 3: Verify Python installation
python --version
# Output: Python 3.14.5

# Step 4: Verify PySpark installation
python -m pip show pyspark
# Output: pyspark 4.1.2

# Step 5: Verify Java installation
java -version

# Step 6: Configure Environment Variables
# Example:
JAVA_HOME = C:\Program Files\Java\jdk-17
PATH = %JAVA_HOME%\bin
