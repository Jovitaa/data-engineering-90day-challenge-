# Week 02 - Day 05: Spark Scalability Concepts

## 01. Overview

In this exercise, **Spark scalability concepts** were explored using the **Netflix Recommendation Engine datasets**.  
The objective was to understand how Spark achieves **high performance and scalability** through:

- [Distributed Computing](ca://s?q=Explain_distributed_computing_in_Spark)  
- [Partitioning](ca://s?q=Partitioning_in_Spark)  
- [Lazy Evaluation](ca://s?q=Explain_lazy_evaluation_in_Spark)  
- [Caching](ca://s?q=Cache_vs_persist_in_Spark)  
- [Optimized Joins](ca://s?q=Broadcast_join_in_Spark)

### Implementation Layers

- **Bronze Layer** → Raw activity dataset  
- **Silver Layer** → Enriched activity dataset with `watch_hours`  
- **Users Dataset** → Dimension table for join operations  

### Focus

The notebook focused on **understanding Spark execution behaviour** rather than building business logic.  
Key emphasis was placed on how Spark internally handles:

- [Execution Plans](ca://s?q=Explain_Spark_execution_plan)  
- [Shuffle Operations](ca://s?q=Explain_shuffle_in_Spark)  
- [Parallelism](ca://s?q=Parallelism_in_Spark)  
- [Performance Optimization](ca://s?q=Spark_performance_optimization_techniques)

---
## 02. Concepts Used

### 2.1 [Why Spark is Scalable](ca://s?q=Why_is_Spark_scalable)

Spark is scalable because it distributes data into **partitions** and processes those partitions in **parallel** across multiple executors.

**Traditional Pandas processing:**
Single Machine
↓
Single CPU
↓
Limited Memory

**Spark processing:**
Driver
↓
Multiple Executors
↓
Multiple Partitions
↓
Parallel Processing

**Benefits:**
- Distributed processing  
- Parallel execution  
- Fault tolerance  
- In-memory computation  

---

### 2.2 [Driver vs Executor](ca://s?q=Driver_vs_Executor_in_Spark)

**Driver**  
The Driver is the central coordinator of a Spark application.  

**Responsibilities:**
- Creates SparkSession  
- Builds execution plans  
- Schedules tasks  
- Coordinates executors  

**Executor**  
Executors perform actual computations.  

**Responsibilities:**
- Execute tasks  
- Process partitions  
- Cache data  
- Return results to Driver  

**Architecture:**
Driver
|
+------------+
|            |
Executor1   Executor2
|            |
Part1       Part2

---

### 2.3 [Partitioning](ca://s?q=Explain_Spark_Partition)

Partitioning divides a dataset into **logical chunks** that Spark can process independently.

**Example:**
```python
bronze_activity_df.rdd.getNumPartitions()
```
### Benefits of [Partitioning](ca://s?q=Explain_Spark_Partition)

- Enables parallelism  
- Improves scalability  
- Distributes workload  

### Observation
More partitions allow more concurrent tasks.

---

### Caveats
- **Too Few Partitions → Poor Parallelism**  
- **Too Many Partitions → Scheduling Overhead**

---

### 2.4 [Lazy Evaluation](ca://s?q=Explain_lazy_evaluation_in_Spark)

Spark does not execute transformations immediately.  

Instead, transformations are recorded until an **Action** is triggered:
Transformation
↓
Transformation
↓
Transformation
↓
Action

Spark builds a **Directed Acyclic Graph (DAG)** of operations and waits until an Action is called to execute the plan.

**Benefits:**
- Query optimization  
- Reduced computation  
- Better performance  

---

### 2.5 [Transformations vs Actions](ca://s?q=Transformations_vs_Actions_in_Spark)

**Transformations**  
Transformations create new DataFrames but do not trigger execution.  

**Examples:**
- filter()  
- select()  
- join()  
- groupBy()  
- withColumn()  

**Code Example:**
```python
filtered_activity_df = bronze_activity_df.filter(
    col("watch_minutes") > 100
)
```
➡ No execution occurs here.
### Actions

[Actions](ca://s?q=Actions_in_Spark) trigger execution and return results.

**Examples:**
- count()  
- show()  
- collect()  
- write()
  
**Code Example:**
```python
filtered_activity_df.count()
)
```

---

### 2.6 [Shuffle](ca://s?q=Explain_shuffle_in_Spark)

Shuffle occurs when Spark **redistributes data between partitions**.  

**Operations causing Shuffle:**
- groupBy()  
- join()  
- distinct()  
- repartition()  

**Why Shuffle is expensive:**
- Network I/O  
- Disk I/O  
- Serialization  

---

### 2.7 [Cache vs Persist](ca://s?q=Cache_vs_Persist_in_Spark)

**Cache**  
Stores DataFrame in memory.  

```python
df.cache()
```

---

### 2.8 [Broadcast Join](ca://s?q=Broadcast_join_in_Spark)

Broadcast Join is used when joining a **large table** with a **small table**.

**Example:**
```python
activity_users_df = silver_activity_df.join(
    broadcast(users_df),
    "user_id",
    "inner"
)
```
**Without Broadcast:**
Large Table
+ 
Large Table
= 
Heavy Shuffle

**With Broadcast:**
Large Table
+ 
Broadcast Small Table
= 
No Large Shuffle

### Benefits of [Broadcast Join](ca://s?q=Broadcast_join_in_Spark)

- Faster joins  
- Less network traffic  
- Better performance

### 2.9 [Hash-Based Processing in Spark](ca://s?q=Hash_Based_Processing_in_Spark)

Spark frequently uses **Hash Algorithms** internally for aggregations, partitioning, and joins because hash lookups are very fast (average **O(1)** complexity).

### HashAggregate

During aggregation operations such as:

```python
bronze_activity_df.groupBy(
    "user_id"
).agg(
    F.sum("watch_minutes")
)
```
#### Spark uses: [HashAggregate](ca://s?q=HashAggregate_in_Spark)

**Observed in Physical Plan:**

```python
HashAggregate
    ↓
Exchange hashpartitioning(user_id, 200)
    ↓
HashAggregate
```
### How it works
- `user_id = 1 → Hash Bucket A`  
- `user_id = 2 → Hash Bucket B`  
- `user_id = 3 → Hash Bucket C`  

Spark stores partial aggregation results inside hash tables before combining them during the final aggregation phase.

### Benefits of [Hash-Based Processing](ca://s?q=Hash_Based_Processing_in_Spark)
- Fast lookups  
- Fast grouping  
- Reduced memory consumption  
- Efficient distributed aggregation  

#### [Hash Partitioning](ca://s?q=Hash_Partitioning_in_Spark)

During shuffle operations Spark uses:
```python
Exchange hashpartitioning(user_id, 200)
```
####  Meaning
Spark computes:
```python
hash(user_id)
```
Then determines:
```python
partition = hash(user_id) % number_of_partitions
```
#### Example
- `hash(1) % 200 = Partition 15`  
- `hash(2) % 200 = Partition 67`  
- `hash(3) % 200 = Partition 144`  

#### Guarantee
- Same `user_id` → Same partition  
- Required for:  
  - [groupBy](ca://s?q=groupBy_in_Spark)  
  - [joins](ca://s?q=Joins_in_Spark)  
  - [aggregations](ca://s?q=Aggregations_in_Spark)  

#### [BroadcastHashJoin](ca://s?q=BroadcastHashJoin_in_Spark)

When performing:

```python
activity_users_df = silver_activity_df.join(
    broadcast(users_df),
    "user_id"
)
```
Spark uses: **BroadcastHashJoin**

#### Observed in Physical Plan:
```python
BroadcastHashJoin
```
#### How it works
**Step 1:**  
Small `users_df` table is broadcast to all executors.  

**Step 2:**  
Spark builds an in-memory hash table:  
- `user_id → user information`  
- Example:  
  - `1 → John`  
  - `2 → Sarah`  
  - `3 → Mike`  

**Step 3:**  
Each executor performs **O(1) hash lookups** for matching records.  

### Benefits of [BroadcastHashJoin](ca://s?q=BroadcastHashJoin_in_Spark)
- No large shuffle  
- Fast join performance  
- Reduced network traffic

---

## 03. Code Snippets / Demonstration

### Step 1: [Lazy Evaluation](ca://s?q=Explain_lazy_evaluation_in_Spark)

```python
filtered_activity_df = bronze_activity_df.filter(
    col("watch_minutes") > 100
)
```
#### Explanation of [Lazy Evaluation](ca://s?q=Explain_lazy_evaluation_in_Spark)

- Transformation created  
- No execution performed  
- Spark builds a **Directed Acyclic Graph (DAG)**  

### Step 2: [Action](ca://s?q=Actions_in_Spark)

```python
filtered_count = filtered_activity_df.count()
```
#### Explanation of [Action](ca://s?q=Actions_in_Spark)

- `count()` is an **Action**  
- Spark executes all previous transformations

### Step 3: [Partitioning](ca://s?q=Explain_Spark_Partition)

```python
bronze_activity_df.rdd.getNumPartitions()
```
#### Explanation of [Partitioning](ca://s?q=Explain_Spark_Partition)

- Checks the current partition count  
- Helps understand how Spark distributes the dataset across executors

### Step 4: [Repartition](ca://s?q=Repartition_in_Spark)

```python
repartitioned_activity_df = bronze_activity_df.repartition(4)
```
#### Explanation of [Repartition](ca://s?q=Repartition_in_Spark)

- Creates 4 partitions  
- Improves parallelism  
- Causes **Shuffle**  

### Step 5: [Shuffle Demonstration](ca://s?q=Shuffle_in_Spark)

```python
user_watch_summary_df = bronze_activity_df.groupBy(
    "user_id"
).agg(
    F.sum("watch_minutes").alias(
        "total_watch_minutes"
    )
)

# Execution Plan
user_watch_summary_df.explain(True)
```
**Observed:**
```python
Exchange hashpartitioning(user_id, 200)
```
#### [Interpretation](ca://s?q=Interpretation_of_HashPartitioning_in_Spark)
```python
Spark computes `hash(user_id)`  
       ↓  
Determines target partition  
       ↓  
Moves records to that partition  
       ↓  
Performs final aggregation  
```
This is the exact mechanism Spark used during the `groupBy("user_id")` operation in the **Netflix pipeline**.  
#### Meaning of [Shuffle](ca://s?q=Shuffle_in_Spark)

- Spark moved records across partitions so rows belonging to the same `user_id` could be aggregated together  
- This data movement is called **Shuffle**



### Step 6: [Gold Aggregation](ca://s?q=Gold_layer_in_Spark)

```python
user_summary_df = silver_activity_df.groupBy(
    "user_id"
).agg(
    F.sum("watch_minutes")
        .alias("total_watch_minutes"),

    F.sum("watch_hours")
        .alias("total_watch_hours")
)
```
#### Purpose of [Gold Aggregation](ca://s?q=Gold_layer_in_Spark)

- Create a business-ready **Gold dataset**  
- Provides aggregated user-level metrics for **analytics**, **dashboards**, and **reporting**

### Step 7: [Cache Demonstration](ca://s?q=Cache_in_Spark)

```python
user_summary_df.cache()

user_summary_df.count()

user_summary_df.is_cached  
```
**Result:**
```python
True
```
#### Meaning of [Cache](ca://s?q=Cache_in_Spark)

- Data is stored in memory  
- Reused without recomputation  

### Step 8: [Broadcast Join Demonstration](ca://s?q=Broadcast_join_in_Spark)

```python
activity_users_df = silver_activity_df.join(
    broadcast(users_df),
    "user_id",
    "inner"
)

# Verification
activity_users_df.explain(True)
```
**Observed:**
```python
BroadcastHashJoin
```
#### Meaning of [Broadcast Join](ca://s?q=Broadcast_join_in_Spark)

- Spark broadcasted `users_df` to all executors  
- Avoided expensive shuffle operations

---

## 04. Product Company Style Interview Questions & Answers

**Q1. [Why is Spark scalable?](ca://s?q=Why_is_Spark_scalable)**  
Spark distributes data across partitions and executors, enabling parallel processing across multiple machines.  

**Q2. [What is Lazy Evaluation?](ca://s?q=Explain_lazy_evaluation_in_Spark)**  
Spark delays execution of transformations until an action is triggered, allowing optimization of the execution plan.  

**Q3. [Difference between Transformation and Action?](ca://s?q=Difference_between_Transformation_and_Action)**  
- Transformation → creates a new DataFrame and is lazily evaluated  
- Action → triggers execution and returns results  

**Q4. [What causes Spark Shuffle?](ca://s?q=What_causes_a_Shuffle_in_Spark)**  
Operations such as `groupBy`, `join`, `distinct`, and `repartition` cause Spark to redistribute data across partitions.  

**Q5. [Why is Shuffle expensive?](ca://s?q=Why_is_Shuffle_expensive_in_Spark)**  
Shuffle involves network communication, disk I/O, and serialization, making it one of the most expensive Spark operations.  

**Q6. [What is Partitioning?](ca://s?q=Explain_Spark_Partition)**  
Partitioning divides a dataset into smaller logical chunks that can be processed independently in parallel.  

**Q7. [Difference between Repartition and Coalesce?](ca://s?q=Repartition_vs_Coalesce_in_Spark)**  
- Repartition → increases or decreases partitions and causes shuffle  
- Coalesce → reduces partitions with minimal shuffle  

**Q8. [Difference between Cache and Persist?](ca://s?q=Difference_between_Cache_and_Persist_in_Spark)**  
- Cache → stores data in memory using `MEMORY_ONLY`  
- Persist → allows different storage levels such as `MEMORY_AND_DISK` or `DISK_ONLY`  

**Q9. [Why use Broadcast Join?](ca://s?q=Why_use_Broadcast_Join_in_Spark)**  
Broadcast Join avoids shuffling a large dataset by distributing a small table to all executors.  

**Q10. [How do you verify Broadcast Join?](ca://s?q=Verify_Broadcast_Join_in_Spark)**  
Use:  
```python
df.explain(True)
```
Look for: **BroadcastHashJoin**
in the Physical Plan.

**Q11. [Hash-Based Algorithms in Spark](ca://s?q=Hash_Based_Algorithms_in_Spark)**

Spark commonly uses:

- **[HashAggregate](ca://s?q=HashAggregate_in_Spark)**  
  Used in `groupBy` and aggregations.  

- **[HashPartitioning](ca://s?q=HashPartitioning_in_Spark)**  
  Used during shuffle operations.  

- **[BroadcastHashJoin](ca://s?q=BroadcastHashJoin_in_Spark)**  
  Used when joining a large table with a small broadcasted table.  

#### Why Spark uses these algorithms
These algorithms help Spark achieve scalable distributed processing with:  
- Efficient partitioning  
- Fast aggregation  
- Optimized join operations

---

## 05. [Summary](ca://s?q=Spark_Scalability_Summary)

### Key Learnings
- [Spark scales](ca://s?q=Why_is_Spark_scalable) via distributed processing and partitioning.  
- [Driver](ca://s?q=Driver_vs_Executor_in_Spark) coordinates, [Executors](ca://s?q=Driver_vs_Executor_in_Spark) compute.  
- [Transformations](ca://s?q=Difference_between_Transformation_and_Action) are lazy, [Actions](ca://s?q=Difference_between_Transformation_and_Action) trigger execution.  
- [Repartition](ca://s?q=Repartition_vs_Coalesce_in_Spark) changes partition count (shuffle).  
- [groupBy](ca://s?q=groupBy_in_Spark) introduces shuffle.  
- [Cache](ca://s?q=Cache_in_Spark) improves performance for reused datasets.  
- [Broadcast Join](ca://s?q=Broadcast_join_in_Spark) optimizes joins.  
- Execution plans (`explain(True)`) reveal:  
  - Shuffle → `Exchange hashpartitioning`  
  - Broadcast optimization → `BroadcastHashJoin`  
