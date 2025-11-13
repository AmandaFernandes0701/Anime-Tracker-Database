# AniVerse-DB: Anime Tracker Database Project

![MySQL Version](https://img.shields.io/badge/MySQL-8.0-blue.svg?logo=mysql)
![Python Version](https://img.shields.io/badge/Python-3.10-blue.svg?logo=python)

This repository contains the complete database implementation for **AniVerse**, a conceptual anime list tracking platform (similar to MyAnimeList). It was developed as the final project for the **Introduction to Databases course (DCC011) at UFMG**.

The project's core focus is on robust relational schema design (ER mapping, 3NF), DDL/DML implementation, and in-depth SQL query performance analysis.

---

## 📜 Table of Contents

* [Key Features](#-key-features)
* [Technology Stack](#-technology-stack)
* [Database Schema](#-database-schema)
    * [EER Diagram](#eer-diagram)
    * [Table Descriptions](#table-descriptions)
* [File Structure](#-file-structure)
* [Setup and Usage](#-setup-and-usage)
    * [Prerequisites](#prerequisites)
    * [1. Database Creation](#1-database-creation)
    * [2. Run Test Data (Optional)](#2-run-test-data-optional)
    * [3. Run Performance Analysis](#3-run-performance-analysis)
* [Query Performance Analysis](#-query-performance-analysis)

---

## ✨ Key Features

The database schema is designed to support the core functionalities of a modern tracking platform:

* **User Management:** Schema for user registration and profiles.
* **Anime Cataloging:** Stores detailed anime information, including relations to animation studios (`ESTUDIO`).
* **Personalized Tracking:** Users can add anime to their personal lists (`LISTA_USUARIO`) with statuses (`Watching`, `Completed`, `Planned`), ratings, and episode progress.
* **Review System:** Allows users to write and store detailed reviews (`REVIEW`) for any anime.
* **Normalized Design:** Fully normalized (3NF) schema to ensure data integrity, eliminate redundancy, and handle multi-valued attributes (`ANIME_GENERO`).

---

## 🛠️ Technology Stack

This project was built using the following technologies:

* **Database:** MySQL Server 8.0
* **IDE & Design:** MySQL Workbench
* **Analysis & Scripting:** Python 3 (via Google Colab / Jupyter)
* **Connector:** `mysql-connector-python`
* **Data Handling:** `pandas` (for displaying query results)

---

## 🏗️ Database Schema

The schema is designed to be in the Third Normal Form (3NF), ensuring data integrity and minimizing redundancy. The ER-to-Relational mapping follows the methodologies discussed in class.

### EER Diagram

The following EER (Enhanced Entity-Relationship) diagram was reverse-engineered from the final schema using MySQL Workbench.

<br>

> ****
> *(Your exported diagram PNG/PDF goes here)*

<br>

### Table Descriptions

| Table | Purpose |
| :--- | :--- |
| **`USUARIO`** | Stores user profile information (ID, username, email). |
| **`ESTUDIO`** | Stores animation studio details (ID, name, founding year). |
| **`ANIME`** | The main catalog of anime titles. Linked to `ESTUDIO` via a 1:N FK. |
| **`REVIEW`** | Stores user-written reviews. Linked to `USUARIO` and `ANIME`. |
| **`ANIME_GENERO`** | Maps the M:N relationship for anime genres (handles the multi-valued 'genre' attribute). |
| **`LISTA_USUARIO`** | The core M:N table linking `USUARIO` and `ANIME`. Stores tracking data (status, rating, episode progress). |

---

## 📂 File Structure

This repository is organized as follows:
. ├── 01_criacao_esquema.sql ├── 02_testes_e_amostras.sql ├── DCC011_TP2_Analise_Desempenho.ipynb └── README.md

* **`01_criacao_esquema.sql`**: The master DDL script. Running this single file creates the entire `animes_db` schema, including all tables, constraints, and foreign key relationships.
* **`02_testes_e_amostras.sql`**: A DML script with a small set of sample data. Used to verify schema integrity, constraints, and JOINs before running the full analysis.
* **`DCC011_TP2_Analise_Desempenho.ipynb`**: The Google Colab/Jupyter Notebook. This file connects to the database, runs the mass data population (DML), and executes the 10 required performance analysis queries.
* **`README.md`**: This file.

---

## 🚀 Setup and Usage

To replicate this project and run the analysis, follow these steps.

### Prerequisites

* A running instance of **MySQL Server 8.0+**
* **MySQL Workbench** (or any other MySQL client)
* **Python 3.x** (with `pandas` and `mysql-connector-python`)

### 1. Database Creation

1.  Open **MySQL Workbench** and connect to your local or remote MySQL Server.
2.  Open the `01_criacao_esquema.sql` file.
3.  Execute the entire script (⚡ icon). This will create the `animes_db` schema and all its tables.

### 2. Run Test Data (Optional)

1.  Open the `02_testes_e_amostras.sql` file in Workbench.
2.  Execute the script.
3.  You can now run `SELECT` statements (e.g., `SELECT * FROM USUARIO;`) to verify that the tables were populated correctly.

### 3. Run Performance Analysis

1.  Open the `DCC011_TP2_Analise_Desempenho.ipynb` notebook in Google Colab or a local Jupyter instance.
2.  Locate the **"Configuração do Ambiente"** (Environment Setup) cell at the beginning of the notebook.
3.  Update the `DB_HOST`, `DB_USER`, `DB_PASSWORD`, and `DB_NAME` variables to match your database credentials.
4.  Run all cells in the notebook sequentially (`Runtime > Run all`).

The notebook will:
* Connect to your database.
* Populate the tables with a large volume of synthetic data (required for performance testing).
* Execute all 10 analysis queries, each with 2+ formulations.
* Time each execution (averaged over 5 runs) and display the results in formatted tables.

---

## 📊 Query Performance Analysis

The primary goal of this project is documented in the Jupyter Notebook (`.ipynb`). We analyze 10 distinct queries, each formulated in at least two different ways to compare their performance.

* **Metrics:** Each query variant is executed 5 times to mitigate cold-start issues, and the **average execution time** is reported.
* **Analysis Topics Include:**
    * Simple selections and projections.
    * 2-Table Joins (`INNER JOIN` vs. implicit `WHERE` clause).
    * Multi-Table (3+) Joins (`INNER JOIN` vs. nested subqueries).
    * Aggregations (`GROUP BY`, `AVG`, `COUNT`) combined with `JOIN`s and `HAVING` clauses.

---
