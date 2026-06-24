# Week 02 - Day 12: Azure Data Factory (ADF) Fundamentals

## 1. Overview

The objective of Day 12 was to learn Azure Data Factory (ADF) fundamentals and implement the first cloud-based ingestion pipeline for the Netflix Recommendation Engine project.

Until this stage, data processing had been performed locally using PySpark. However, production Data Engineering environments require automated ingestion, scheduling, orchestration, and monitoring of data movement between systems.

To address this, Azure Data Factory was introduced as the orchestration layer responsible for moving data and automating workflows.

### Topics covered:
- Azure Data Factory Architecture  
- Linked Services  
- Datasets  
- Copy Activity  
- Pipelines  
- Triggers  
- ADLS Gen2 Integration  
- Storage Account Configuration  
- Monitoring and Validation  

A working ADF pipeline was successfully implemented and executed.

---

## 2. Why Azure Data Factory Was Needed

In real-world Data Engineering projects, data does not arrive through manual uploads and manual script execution.

For a Netflix-style analytics platform:
```python
Applications  
      ↓  
Raw Data  
      ↓  
Data Lake  
      ↓  
Transformations  
      ↓  
Analytics & Reporting
```
## Data movement must be:

- Automated  
- Reliable  
- Repeatable  
- Monitorable  

### Azure Data Factory solves this problem by providing:
- Data movement  
- Workflow orchestration  
- Scheduling  
- Monitoring  
- Pipeline automation  

### Interview Answer:
ADF is a cloud-based orchestration service used to automate and manage data movement and workflow execution across multiple systems.

---

## 3. What is Azure Data Factory?

Azure Data Factory (ADF) is Microsoft's cloud-native data integration and orchestration service.

### Its primary responsibilities are:
- Moving data between systems  
- Scheduling workflows  
- Orchestrating activities  
- Monitoring execution  

ADF is not designed for large-scale data transformations.

Instead:

**ADF**  
= Data Movement & Orchestration  

**Spark / Databricks**  
= Data Processing & Transformation  

### Typical Production Architecture:
```python
Source System  
      ↓  
ADF  
      ↓  
ADLS Bronze  
      ↓  
PySpark / Databricks  
      ↓  
Silver  
      ↓  
Gold
```
![Architecture](../../05-architecture/images/adf_ingestion_architecture.png)
---

## 4. Storage Account Creation

### Why a Storage Account Was Needed
Before storing any files in Azure, a storage account must be created.

The Storage Account acts as the top-level resource that manages:
- Containers  
- Files  
- Security  
- Access Control  
- Encryption  

### Created:
**netflixadlsdev**

### Interview Answer:
A Storage Account is the foundational Azure resource that provides storage services such as Blob Storage and ADLS Gen2.

---

## 5. Why ADLS Gen2 Was Chosen

The Netflix project requires:
- Data lake architecture  
- Folder hierarchy  
- Spark integration  
- Large-scale analytics  

Standard Blob Storage is designed primarily for object storage.

### ADLS Gen2 extends Blob Storage by adding:
- Hierarchical Namespace  
- Directories  
- File system semantics  
- Analytics optimization  

### Architecture created:
- bronze  
- silver  
- gold  

### Interview Answer:
ADLS Gen2 is preferred for analytics workloads because it combines Blob Storage scalability with hierarchical namespace support required by Spark and Data Engineering platforms.

---

## 6. Storage Account Concepts Learned

### Hierarchical Namespace (HNS)  
**Why It Was Needed**  

The project architecture required folders such as:  
- bronze/  
- silver/  
- gold/  

This requires file-system behavior.  

Without HNS:  
- Folder operations are limited  
- ADLS Gen2 functionality is unavailable  

### Configuration:
Enable Hierarchical Namespace = **True**  

### Interview Answer:
Hierarchical Namespace converts Blob Storage into ADLS Gen2 by enabling directories and file-system semantics.

### Performance Tier  
**Selected:** Standard  

**Reason:**  
- Cost-effective  
- Suitable for most workloads  
- Appropriate for learning environments  

### Access Tier  
**Selected:** Hot  

**Reason:**  
Files are accessed frequently during development and testing.  

### Secure Transfer  
**Selected:** Enabled  

**Purpose:**  
- HTTPS-only communication  
- Secure data transfer  

### Encryption  
**Selected:** Microsoft Managed Keys  

**Purpose:**  
Azure automatically encrypts data at rest without requiring manual key management.

---

## 7. Containers Created

Containers act as logical storage units inside ADLS Gen2.

### Created:
- bronze  
- silver  
- gold  

### Purpose:
**Bronze**  
Stores raw ingested data.  

**Silver**  
Stores cleaned and transformed data.  

**Gold**  
Stores business-ready datasets and analytics outputs.  

### Interview Question:
**Why use Bronze, Silver, and Gold layers?**  
Because separating raw, cleansed, and curated data improves governance, traceability, and maintainability.  

---

## 8. Linked Service

### Why It Was Needed
Before ADF can access storage, it must know:  
- Where the storage exists  
- How to authenticate  
- How to connect  

A Linked Service provides these connection details.

### Created:
**LS_ADLS_Gen2**

Think of it as:  
**Connection String for Azure Data Factory**

### Interview Answer:
A Linked Service defines the connection and authentication details required for ADF to communicate with external systems.

---

## 9. Dataset

### Why It Was Needed
After connecting to storage, ADF still needs to know which specific file should be processed.

Datasets represent individual data objects.  

Datasets do not store data.  
They simply point to data locations.  

### Created:
**Source Dataset**  
DS_Source_Users  

**Points to:** 
```python
bronze/users.csv
 ```

**Sink Dataset**
```python 
DS_Sink_Users  
```

**Points to:**
```python
bronze/users_copy.csv  
```

### Interview Answer:
A Dataset is a logical representation of a file, folder, table, or object that an activity reads from or writes to.

---

## 10. Copy Activity

### Why It Was Needed
The Linked Service connects systems.  
The Dataset identifies files.  
Neither moves data.  

**Copy Activity** performs the actual data movement.  

### Created:
**Copy_Users_To_Bronze**

### Flow:
```python
users.csv  
      ↓  
Copy Activity  
      ↓  
users_copy.csv  
```

### Interview Answer:
Copy Activity is used to move data between source and destination systems inside ADF.

---

## 11. Why users_copy.csv Was Created

A common question is:  
**Why copy a file to another file in the same container?**

### The answer is:
The purpose was not to create a business deliverable.  
The purpose was to validate the ADF pipeline.  

### Implementation:
```python
**DS_Source_Users** 
        ↓  
bronze/users.csv  

**DS_Sink_Users**  
        ↓  
bronze/users_copy.csv  
```

### This validated:
```python
 Linked Service  
      ↓  
   Dataset  
      ↓  
 Copy Activity  
      ↓  
 Pipeline  
      ↓  
 Trigger  
```

### The successful execution proved that ADF could:
✓ Read data  
✓ Execute a Copy Activity  
✓ Write data  
✓ Run a Pipeline  
✓ Monitor execution  

---

## 12. Why a Sink Dataset Was Required

A Copy Activity always requires:
```python
**Source Dataset**  
      ↓  
**Copy Activity**  
      ↓  
**Sink Dataset**  
```

### ADF must know:
- Where to read data from  
- Where to write data to  

### Without a Sink Dataset:
**Copy Activity**  
✗ Cannot complete  

---

## 13. Can the Same Dataset Be Used as Source and Sink?

**No.**

### Using:
**DS_Source_Users**  

for both source and sink would result in:

**Read:**  
```python
bronze/users.csv  
```

**Write:**
```python
bronze/users.csv  
```

### Conceptually:
```python
users.csv  
      ↓  
Copy Activity  
      ↓  
users.csv  
```

The activity would be attempting to copy a file onto itself.  

This provides no practical value and may result in validation or overwrite issues.  

### Interview Answer:
Source and sink datasets should point to different objects even when they reside within the same storage account.

---

## 14. Pipeline

### Why It Was Needed
Production workflows usually contain multiple activities.

**Example:**
```python
- Copy Data  
      ↓  
- Validate  
      ↓  
- Transform  
      ↓  
- Notify  
```
ADF requires a container to orchestrate these activities.  
That container is called a **Pipeline**.  

### Created:
```python
**Netflix_Bronze_Ingestion**
```

### Pipeline Flow:
```python
**DS_Source_Users**  
        ↓  
**Copy_Users_To_Bronze**  
        ↓  
**DS_Sink_Users**  
```
### Interview Answer:
A Pipeline is a logical container that orchestrates one or more activities.

---

## 15. Publish in ADF

### Why Publish Was Required
ADF resources initially exist in **draft mode**.  

Creating:  
- Linked Service  
- Dataset  
- Pipeline  

does not automatically deploy them.  

### Workflow:
```python
Create  
      ↓  
Validate  
      ↓  
Publish All  
      ↓  
Execute  
```

### Interview Answer:
Publishing deploys resources from the authoring environment into the live data factory.

----

## 16. Trigger

### Why It Was Needed
Without a Trigger:
```python
Engineer  
      ↓  
Click Run  
      ↓  
Pipeline Executes  
```

Production systems require automation.  

### Implemented:
**Daily_Bronze_Load**

**Type:**  
Schedule Trigger  

**Configuration:**  
Every 1 Day  

**Originally Intended:**  
Event Trigger  

**Example:**
```python
New File Arrives  
      ↓  
Pipeline Starts Automatically  
```

### Interview Answer:
Triggers automate pipeline execution based on schedules or events.  

---

## 17. Architecture Implemented

**Actual Day 12 Architecture:**
```python
Manual Upload  
      ↓  
ADLS Bronze/users.csv  
      ↓  
ADF Pipeline  
      ↓  
ADLS Bronze/users_copy.csv  

This was used only to validate ADF functionality.  
```
---

## 18. Why SHIR Was Deferred

**Original target architecture:**
```python
Local users.csv  
      ↓  
ADF  
      ↓  
ADLS Bronze/users.csv  
```

**Issue:**  
ADF cannot directly access local machine files.  

**To achieve this architecture:**  
Self Hosted Integration Runtime (**SHIR**) must be configured.  

Since SHIR was not yet implemented, the temporary validation approach was used.  
SHIR implementation was deferred to Day 13.  

---

## 19. Errors Encountered and Resolutions

**Error 1**  
Linked Service Connection Failed  

**Reason:**  
Storage Account configuration incompatible with ADLS Gen2.  

**Resolution:**  
Created a new Storage Account with Hierarchical Namespace enabled.  

**Error 2**  
Dataset Validation Error  

**Reason:**  
Dataset pointed to a folder rather than a file.  

**Resolution:**  
Configured explicit file names.  

**Error 3**  
Schema Import Failed  

**Reason:**  
Sink file did not yet exist.  

**Resolution:**  
Set:  
**Import Schema = None**  

**Error 4**  
Local File Access Limitation  

**Reason:**  
ADF cannot access local machine files directly.  

**Resolution:**  
Used manual upload approach and deferred SHIR.  

**Error 5**  
Trigger Not Visible  

**Reason:**  
Resources were not published.  

**Resolution:**  
Used:  
**Publish All**  
before creating the trigger.  

---

## 20. Interview Questions

### 1. Tell me about a Data Factory pipeline you built.
**Situation**  
As part of my Netflix Recommendation Engine project, I needed to automate data ingestion into Azure Data Lake Storage Gen2 instead of relying entirely on manual processing.  

**Task**  
My objective was to understand Azure Data Factory fundamentals and build an ingestion pipeline that could move data successfully while preparing for a future end-to-end Bronze → Silver → Gold architecture.  

**Action**  
I created:  
- ADLS Gen2 Storage Account  
- Bronze, Silver, and Gold containers  
- Linked Service connecting ADF to ADLS  
- Source and Sink Datasets  
- Copy Activity  
- Pipeline named *Netflix_Bronze_Ingestion*  
- Schedule Trigger  

Since Self Hosted Integration Runtime (SHIR) had not yet been implemented, I manually uploaded source files to ADLS and used ADF to copy *users.csv* to *users_copy.csv* to validate the ingestion workflow.  

**Result**  
The pipeline executed successfully and validated:  
- ADF connectivity  
- Dataset configuration  
- Copy Activity execution  
- Pipeline orchestration  
- Trigger configuration  

This established the foundation for implementing SHIR-based ingestion and a complete Bronze → Silver → Gold pipeline.  

---

### 2. Why did you create users_copy.csv?
**Situation**  
While building the first ADF pipeline, I needed a way to verify that the pipeline was functioning correctly.  

**Task**  
The objective was to confirm that ADF could read data, execute activities, and write data successfully.  

**Action**  
I created:  
- DS_Source_Users → *users.csv*  
- DS_Sink_Users → *users_copy.csv*  

and configured a Copy Activity between them.  

**Result**  
The successful creation of *users_copy.csv* proved that:  
- ADF could access ADLS  
- Datasets were configured correctly  
- Copy Activity executed successfully  
- Pipeline orchestration worked as expected  

The file served as a validation artifact rather than a business deliverable.  

---

### 3. Describe a challenge you faced while implementing ADF.
**Situation**  
While configuring the Linked Service, the connection test failed.  

**Task**  
I needed to establish connectivity between Azure Data Factory and Azure Data Lake Storage Gen2.  

**Action**  
I investigated the error and found that the original storage account configuration was incompatible with ADLS Gen2 requirements.  

I created a new Storage Account with:  
- Hierarchical Namespace enabled  
- ADLS Gen2 configuration supported  

and recreated the required containers.  

**Result**  
The Linked Service connected successfully, allowing the pipeline implementation to continue.  

---

### 4. Tell me about a problem you solved during the project.
**Situation**  
While creating datasets, schema import failed with a *PathNotFound* error.  

**Task**  
I needed to configure the sink dataset correctly and complete the pipeline.  

**Action**  
I analyzed the issue and discovered that the destination file did not yet exist.  

Instead of importing schema from a non-existent file, I configured:  
**Import Schema = None**  

**Result**  
The dataset was created successfully and the pipeline executed without issues.  

---

### 5. Why didn't you ingest directly from your local machine?
**Situation**  
The original architecture required ingestion from local CSV files into ADLS.  

**Task**  
I needed to determine the correct architecture for local-to-cloud ingestion.  

**Action**  
I researched Azure Data Factory connectivity requirements and found that ADF cannot directly access local machine files.  

I identified Self Hosted Integration Runtime (SHIR) as the required component and documented it as the next implementation step.  

As a temporary solution, I uploaded files manually to ADLS and validated the remaining pipeline components.  

**Result**  
The ADF implementation was completed successfully while preserving the intended architecture for future SHIR integration.  

---

### 6. Describe how you automated the pipeline.
**Situation**  
Manual pipeline execution is not scalable in production environments.  

**Task**  
I needed to configure automated execution.  

**Action**  
I created a Schedule Trigger named:  
**Daily_Bronze_Load**  

Configured to run once per day.  
I also researched Event Triggers for future file-arrival-based automation.  

**Result**  
The pipeline could execute automatically without manual intervention, introducing production-style orchestration concepts into the project.  

---

### 7. Why did you choose ADLS Gen2 instead of Blob Storage?
**Situation**  
The project required a storage layer for Bronze, Silver, and Gold architecture.  

**Task**  
I needed a storage solution compatible with analytics workloads and PySpark processing.  

**Action**  
I evaluated ADLS Gen2 capabilities and enabled Hierarchical Namespace support.  

I structured the storage account into:  
- bronze/  
- silver/  
- gold/  

**Result**  
The architecture became aligned with common Data Engineering patterns used in Azure, Databricks, and enterprise analytics platforms.  

---

### 8. What did you learn from this implementation?
**Situation**  
This was my first end-to-end Azure Data Factory implementation.  

**Task**  
I wanted to understand how cloud orchestration integrates with a Data Engineering pipeline.  

**Action**  
I implemented and validated:  
- Storage Account  
- ADLS Gen2  
- Linked Service  
- Dataset  
- Copy Activity  
- Pipeline  
- Publish Process  
- Trigger  

while troubleshooting multiple configuration issues.  

**Result**  
I gained practical understanding of how Azure Data Factory orchestrates ingestion workflows and how it integrates with a future Bronze → Silver → Gold architecture using PySpark.  

---

## 21. Deliverables Status

**Completed ✅**
- Storage Account Creation  
- ADLS Gen2 Configuration  
- Bronze/Silver/Gold Containers  
- Linked Service  
- Source Dataset  
- Sink Dataset  
- Copy Activity  
- Pipeline  
- Publish Process  
- Schedule Trigger  
- Successful Pipeline Execution  
- Monitoring and Validation  
- Pipeline Screenshots  

---

## 22. Key Learning

Day 12 introduced the **orchestration layer** of the Netflix Recommendation Engine project.  

The primary outcome was understanding how Azure Data Factory uses:  
```python
**Linked Service**  
      ↓  
**Dataset**  
      ↓  
**Copy Activity**  
      ↓  
**Pipeline**  
      ↓  
**Trigger**  
```
to automate data movement.  

The implementation successfully validated **Azure Data Factory fundamentals** and prepared the foundation for **SHIR-based ingestion** and the complete **Bronze → Silver → Gold pipeline** planned for Day 13.  
