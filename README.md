# 🎌 AniVerse-DB: Anime Tracker Database Project

![MySQL Version](https://img.shields.io/badge/MySQL-8.0-blue.svg?logo=mysql)
![Python Version](https://img.shields.io/badge/Python-3.10-blue.svg?logo=python)

This repository contains the complete database implementation for **AniVerse**, a conceptual anime list tracking platform (similar to *MyAnimeList*).
Developed as the final project for the **Introduction to Databases (DCC011)** course at **UFMG**.

The project focuses on **robust relational schema design**, **3NF normalization**, **SQL DDL/DML implementation**, and **query performance analysis**.

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

| Category | Tools |
| :--- | :--- |
| **Database** | MySQL Server 8.0 |
| **Cloud Hosting** | **Railway.app** |
| **IDE & Design** | MySQL Workbench |
| **Analysis & Scripting** | Python 3 (Google Colab / Jupyter) |
| **Connector** | `mysql-connector-python` |
| **Data Handling** | `pandas` |

---

## 🏗️ Database Schema

The schema was designed in **Third Normal Form (3NF)** to ensure consistency and scalability.
ER-to-relational mapping follows formal academic standards.

### 📘 EER Diagram

<img width="708" height="612" alt="diagrama_EER_imagem" src="https://github.com/user-attachments/assets/f38c2097-c720-4fdd-8d12-53985fc1d44c" />

> 🖼️ *EER Diagram generated with MySQL Workbench*

### 🧩 Table Descriptions

| Table | Purpose |
| :--- | :--- |
| **`USUARIO`** | Stores user profile information (ID, username, email). |
| **`ESTUDIO`** | Animation studio details (ID, name, founding year). |
| **`ANIME`** | Main anime catalog. Linked to `ESTUDIO` via FK. |
| **`REVIEW`** | User reviews linked to `USUARIO` and `ANIME`. |
| **`ANIME_GENERO`** | Handles M:N relationships for anime genres. |
| **`LISTA_USUARIO`** | Core M:N table linking users and anime with tracking data. |

---

## 📂 File Structure

```text
📦 AniVerse-DB
├── 📄 01_criacao_esquema.sql                # DDL: creates full schema (tables, FKs, constraints)
├── 📄 02_testes_e_amostras.sql                # DML: sample/test data to validate schema
├── 📘 TP2_Implementacao_Consultas_Animes.ipynb # Notebook for data loading (DML), all 10 analysis queries, and performance benchmarking.
└── 🪶 README.md                             # You’re reading it now :)
````

-----

## 🚀 Setup and Connection

There are two ways to work with this project:

1.  **Connect to the live, shared cloud database** (Recommended for the team/professor).
2.  **Create a local replication** (If you want your own separate copy).

-----

### 🟢 Option 1: Connect to the Live Cloud DB (Recommended)

The project's main database is hosted on **Railway.app**, allowing the team and professor to access the same consistent dataset — also compatible with **Google Colab**.

#### 1\. Connect with MySQL Workbench

1.  Open MySQL Workbench and click the **`+`** icon to create a new connection.
2.  You will need the following credentials:
      * `Hostname`
      * `Port`
      * `Username`
      * `Password`
      * `Default Schema` (Database Name)
3.  **To get these credentials, please contact Amanda Fernandes directly.**
4.  Click **"Test Connection"**, enter the password, and save.
    You can now browse the live cloud database.

#### 2\. Run Performance Analysis (Google Colab / Jupyter)

1.  Open the notebook `TP2_Implementacao_Consultas_Animes.ipynb`.
2.  In the first code cell (*Configuração do Ambiente*), enter the credentials provided:

<!-- end list -->

```python
# Credentials for the Railway.app hosted database
DB_HOST = "your_host_from_railway"
DB_USER = "your_username_from_railway"
DB_PASSWORD = "your_password_from_railway"
DB_NAME = "your_database_name_from_railway"
DB_PORT = "your_port_from_railway"
```

-----

### ⚙️ Option 2: Replicate the Project Locally (Advanced)

If you want to create your own local version of the database:

#### Prerequisites

Make sure you have the following installed:

  * **MySQL Server** and **MySQL Workbench**
  * **Python 3.x** with the following libraries:
    ```bash
    pip install mysql-connector-python pandas
    ```
  * **Jupyter Notebook** or access to **Google Colab** for analysis

#### Database Creation

1.  Connect to your `localhost` instance in MySQL Workbench.
2.  Open the file `01_criacao_esquema.sql`.
3.  Modify the script for local use:
      * Uncomment (or add):
        ```sql
        CREATE SCHEMA IF NOT EXISTS animes_db;
        ```
      * Replace:
        ```sql
        USE railway;
        ```
      * with:
        ```sql
        USE animes_db;
        ```
4.  Run the entire script (⚡ icon) to create the schema on your local machine.

#### Run Test Data & Analysis

1.  Open `02_testes_e_amostras.sql` and replace:
    ```sql
    USE railway;
    ```
    with:
    ```sql
    USE animes_db;
    ```
2.  Execute the script to populate the tables.
3.  Follow the same Performance Analysis steps, but use your local credentials, for example:

<!-- end list -->

```python
DB_HOST = "localhost"
DB_USER = "root"
DB_PASSWORD = "your_password"
DB_NAME = "animes_db"
DB_PORT = "3306"
```

-----

## 📊 Query Performance Analysis

Performance tests are detailed in the Jupyter notebook.
Each query was executed in two or more formulations to evaluate SQL efficiency.

### 📈 Metrics & Methodology

  * Each query runs 5 times (average execution time recorded).
  * Benchmarks focus on:
      * Simple projections and selections
      * 2-table and 3+ table joins
      * Aggregations with `GROUP BY`, `HAVING`, and nested subqueries
      * Query optimization and indexing impact

-----

### 👩🏽‍💻 Authors

  * Amanda Fernandes Alves
  * Carolina Vilazante Portella

### 📚 Course

  * Introduction to Databases (DCC011) — UFMG

### 🌐 Hosted on

  * Railway.app

### 🙌🏽 Acknowledgments

Special thanks to the UFMG Database Department for providing the learning foundation for this project.
And to all contributors and peers who inspired the development of AniVerse-DB.
