# 🎌 AniVerse-DB: Anime Tracker Database Project

![MySQL Version](https://img.shields.io/badge/MySQL-8.0-blue.svg?logo=mysql)
![Python Version](https://img.shields.io/badge/Python-3.10-blue.svg?logo=python)

This repository contains the complete database implementation for **AniVerse**, a conceptual anime list tracking platform (similar to *MyAnimeList*).
Developed as the final project for the **Introduction to Databases (DCC011)** course at **UFMG**.

The project focuses on **robust relational schema design**, **3NF normalization**, **SQL DDL/DML implementation**, and **query performance analysis**.

---

## 📜 Table of Contents

* [✨ Key Features](#-key-features)
* [🛠️ Technology Stack](#%EF%B8%8F-technology-stack)
* [🏗️ Database Schema](#-database-schema)

  * [📘 EER Diagram](#eer-diagram)
  * [🧩 Table Descriptions](#table-descriptions)
* [📂 File Structure](#-file-structure)
* [🚀 Setup and Usage](#-setup-and-usage)

  * [🧱 Prerequisites](#prerequisites)
  * [1️⃣ Database Creation](#1-database-creation)
  * [2️⃣ Run Test Data (Optional)](#2-run-test-data-optional)
  * [3️⃣ Run Performance Analysis](#3-run-performance-analysis)
* [🔐 Database Access](#-database-access)
* [📊 Query Performance Analysis](#-query-performance-analysis)

---

## ✨ Key Features

The schema supports the core functionalities of a modern anime tracking platform:

* **User Management:** User registration and profiles.
* **Anime Cataloging:** Detailed anime information with studio relations (`ESTUDIO`).
* **Personalized Tracking:** Custom user lists (`LISTA_USUARIO`) with status, rating, and episode progress.
* **Review System:** User-written reviews linked to `USUARIO` and `ANIME`.
* **Normalized Design:** Fully normalized (3NF), eliminating redundancy and ensuring data integrity.

---

## 🛠️ Technology Stack

| Category                 | Tools                             |
| :----------------------- | :-------------------------------- |
| **Database**             | MySQL Server 8.0                  |
| **IDE & Design**         | MySQL Workbench                   |
| **Analysis & Scripting** | Python 3 (Google Colab / Jupyter) |
| **Connector**            | `mysql-connector-python`          |
| **Data Handling**        | `pandas`                          |

---

## 🏗️ Database Schema

The schema was designed in **Third Normal Form (3NF)** to ensure consistency and scalability.
ER-to-relational mapping follows formal academic standards.

### 📘 EER Diagram

*(Insert your exported diagram PNG/PDF here)*

> 🖼️ *EER Diagram generated with MySQL Workbench*

### 🧩 Table Descriptions

| Table               | Purpose                                                    |
| :------------------ | :--------------------------------------------------------- |
| **`USUARIO`**       | Stores user profile information (ID, username, email).     |
| **`ESTUDIO`**       | Animation studio details (ID, name, founding year).        |
| **`ANIME`**         | Main anime catalog. Linked to `ESTUDIO` via FK.            |
| **`REVIEW`**        | User reviews linked to `USUARIO` and `ANIME`.              |
| **`ANIME_GENERO`**  | Handles M:N relationships for anime genres.                |
| **`LISTA_USUARIO`** | Core M:N table linking users and anime with tracking data. |

---

## 📂 File Structure

```
📦 AniVerse-DB
├── 📄 01_criacao_esquema.sql                     # DDL: creates full schema (tables, FKs, constraints)
├── 📄 02_testes_e_amostras.sql                   # DML: sample/test data to validate schema
├── 📘 TP2_Implementacao_Consultas_Animes.ipynb   # Notebook for data loading (DML), all 10 analysis queries, and performance benchmarking.
└── 🪶 README.md                                  # You’re reading it now :)
```

---

## 🚀 Setup and Usage

Follow these steps to replicate the project and run your analysis.

### 🧱 Prerequisites

Make sure you have:

* ✅ **MySQL Server 8.0+**
* ✅ **MySQL Workbench** or equivalent client
* ✅ **Python 3.x** with:

  ```bash
  pip install pandas mysql-connector-python
  ```

---

### 1️⃣ Database Creation

1. Open **MySQL Workbench** and connect to your MySQL instance.
2. Open the file `01_criacao_esquema.sql`.
3. Run the script (⚡ Execute All).
   → This creates the full `animes_db` schema with all tables and constraints.

---

### 2️⃣ Run Test Data (Optional)

1. Open `02_testes_e_amostras.sql` in MySQL Workbench.
2. Execute the entire script.
3. Verify the data:

   ```sql
   SELECT * FROM USUARIO;
   SELECT * FROM ANIME;
   ```

---

### 3️⃣ Run Performance Analysis

1. Open the notebook `TP2_Implementacao_Consultas_Animes.ipynb` in **Google Colab** or **Jupyter**.
2. In the first cell (*Configuração do Ambiente*), update:

   ```python
   DB_HOST = "your_host"
   DB_USER = "your_username"
   DB_PASSWORD = "your_password"
   DB_NAME = "animes_db"
   ```
3. Run all cells sequentially (`Runtime > Run all`).

The notebook will:

🔌 Connect to your MySQL instance.
🚛 Populate the database with a large volume of synthetic data (DML).
⚙️ Execute all 10 required analysis queries, each in at least two different formulations.
⏱️ Measure and benchmark the execution time of each query (averaged over 5 runs to avoid cold-start issues).
📈 Display the results and timings in formatted tables for easy comparison.

---

## 🔐 Database Access

For academic integrity and data security reasons, **the original populated database (with full test dataset)** is **not publicly accessible**.

> 📨 If you would like to explore the original dataset or connect to the remote instance used for benchmarking, please **contact me directly** for access credentials.
> Sensitive information (e.g., passwords or host details) will only be shared upon verified request for educational purposes.

---

## 📊 Query Performance Analysis

Performance tests are detailed in the Jupyter notebook.
Each query is analyzed in two or more formulations to evaluate SQL efficiency.

**Metrics & Methodology**

* ⏱️ Each query runs 5 times (average execution time recorded).
* 🧮 Topics include:

  * Simple projections and selections
  * 2-table and 3+ table joins
  * Aggregations with `GROUP BY`, `HAVING`, and nested subqueries
  * Query optimization and indexing impact

---
