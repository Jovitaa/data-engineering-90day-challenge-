# Week-02 / Day-3 Documentation

## 01. Overview
Azure Data Lake Storage (ADLS) is Microsoft's cloud-based storage solution designed for large-scale analytics workloads.  
Data Engineers use Data Lakes to store **raw**, **processed**, and **business-ready** data for reporting, machine learning, and downstream analytics.

In this exercise, two common Data Lake architectures were implemented:

- **Traditional Data Lake Architecture**  
  Raw → Processed → Curated  

- **Medallion Architecture**  
  Bronze → Silver → Gold  

**Objective:** Understand how enterprise data platforms organize data as it moves through different stages of quality and business value.

---

## 02. Concepts Used

### **[Azure Data Lake Storage](ca://s?q=Explain_Azure_Data_Lake_Storage)**
- Scalable storage system optimized for analytics workloads.
- **Benefits:**
  - Stores structured & unstructured data
  - Supports petabyte-scale storage
  - Integrates with ADF, Databricks, Synapse, Power BI
  - Supports hierarchical folder structures

### **Traditional Data Lake Architecture**
- **Raw Layer:** Stores source data exactly as received.  
  Example: `netflix_titles.csv`, `users.csv`, `user_activity.csv`
- **Processed Layer:** Stores cleaned and validated data.  
  Operations: remove duplicates, handle nulls, standardize types.  
  Example: `clean_titles.csv`, `clean_users.csv`, `clean_activity.csv`
- **Curated Layer:** Stores business-ready datasets.  
  Example: `user_summary.csv`

### **Medallion Architecture**
- **Bronze Layer:** Raw source data → Bronze = Raw  
- **Silver Layer:** Cleaned and validated data → Silver = Processed  
- **Gold Layer:** Aggregated, business-ready datasets → Gold = Curated  

### **[Data Lake vs Data Warehouse](ca://s?q=Data_Lake_vs_Data_Warehouse)**
| Data Lake | Data Warehouse |
|-----------|----------------|
| Stores raw + processed data | Stores structured business data |
| Schema-on-read | Schema-on-write |
| Supports ML & analytics | Supports reporting & BI |
| Low-cost storage | Query-optimized storage |

---

## 03. Code Snippets / Demonstration

### **Validate Folder Structure**
```python
from pathlib import Path

BASE_PATH = Path(
    r"C:\Users\jovit\OneDrive\Documents\GitHub\data-engineering-90day-challenge-"
    r"\01.Netflix Recommendation Engine\01.-data"
)

required_folders = [
    "01.traditional_architecture/01.raw",
    "01.traditional_architecture/02.processed",
    "01.traditional_architecture/03.curated",

    "02.medallion_architecture/01.bronze",
    "02.medallion_architecture/02.silver",
    "02.medallion_architecture/03.gold",
]

for folder in required_folders:
    folder_path = BASE_PATH / folder
    if folder_path.exists():
        print(f"FOUND: {folder}")
    else:
        print(f"MISSING: {folder}")
```

## Explanation

- **BASE_PATH:** Defines root data directory.  
- **required_folders:** Lists all required folders.  
- **folder_path.exists():** Validates folder existence.  
- **print(...):** Confirms setup success.  

---

## Architecture Mapping

- **Traditional:** Raw → Processed → Curated  
- **Medallion:** Bronze → Silver → Gold  

**Mapping:**  
- Raw = Bronze  
- Processed = Silver  
- Curated = Gold  

---

## 04. Product Company Style Interview Q&A

**Q1. What is ADLS?**  
ADLS is Microsoft’s scalable cloud storage for big data analytics, integrating with Databricks, ADF, Synapse, Power BI.

**Q2. Difference between Raw, Processed, Curated?**  
- Raw → unmodified source data  
- Processed → cleaned & validated  
- Curated → business-ready datasets  

**Q3. Explain Bronze, Silver, Gold layers.**  
- Bronze → raw data  
- Silver → cleaned/transformed  
- Gold → aggregated business datasets  

**Q4. Why no transformations in Raw/Bronze?**  
Raw/Bronze is the source of truth. Modifying risks data loss and complicates troubleshooting.

**Q5. Data Lake vs Data Warehouse?**  
- Data Lake → raw + semi-structured + structured, ML/analytics  
- Data Warehouse → structured, optimized for BI/reporting  

**Q6. What architecture does Databricks use?**  
Medallion (Bronze → Silver → Gold)

**Q7. Why is Medallion popular?**  
It improves:  
- Data quality  
- Data lineage  
- Scalability  
- Governance  
- Reusability  

---

## 05. Summary

Day 3 focused on **enterprise Data Lake architectures**:

- Traditional: Raw → Processed → Curated  
- Medallion: Bronze → Silver → Gold  

**Key Learnings:**  
- ADLS fundamentals  
- Data Lake organization patterns  
- Data Lake vs Data Warehouse differences  
- Folder hierarchy design  
- Medallion concepts  
- Enterprise storage practices  

**Deliverables:**  
- ✓ Traditional Architecture Folder Structure  
- ✓ Medallion Architecture Folder Structure  
- ✓ Validation Script  
- ✓ Documentation  
- ✓ Interview Prep Notes  
