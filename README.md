# 🎌 AniVerse-DB: Anime Tracker Database Project

![MySQL Version](https://img.shields.io/badge/MySQL-8.0-blue.svg?logo=mysql)
![Python Version](https://img.shields.io/badge/Python-3.10-blue.svg?logo=python)

This repository contains the complete database implementation for **AniVerse**, a conceptual anime list tracking platform (similar to *MyAnimeList*).
Developed as the final project for the **Introduction to Databases (DCC011)** course at **UFMG**.

The project focuses on **robust relational schema design**, **3NF normalization**, **SQL DDL/DML implementation**, and **query performance analysis**.

---
## 📺 Project Resources & Presentation

Access the visual materials and the final video presentation of the project:

* **🎬 Video Presentation (YouTube):** [Watch Here](https://youtu.be/ABWRkOxzDIk?si=0nLSDA6aimg3X0CO)
* **📊 Slides (Canva):** [View Presentation](https://www.canva.com/design/DAG61vPgsVM/TSbove_DAZB7YUYNo8YG6g/view)
* **📑 Full Report:** Check the `Relatorio_Final_IBD.pdf` file in this repository for the complete documentation.

---

## ✨ Key Features

The schema supports the core functionalities of a modern anime tracking platform:

* **User Management:** User registration and profiles.
* **Anime Cataloging:** Detailed anime information with studio relations (`ESTUDIO`).
* **Personalized Tracking:** Custom user lists (`WATCHLIST`) with status, rating, and episode progress.
* **Review System:** User-written reviews linked to `USUARIO` and `ANIME`.
* **Normalized Design:** Fully normalized (3NF), eliminating redundancy and ensuring data integrity.

---

## 🛠️ Technology Stack

| Category | Tools |
| :--- | :--- |
| **Database Engine** | MySQL Server 8.0 |
| **Cloud Hosting** | **Railway.app** (Initial Development & Collaboration) |
| **IDE & Modeling** | MySQL Workbench |
| **Language** | SQL (DDL, DML, DQL) - ANSI Standards |
| **Performance Analysis** | MySQL Execution Plans (`EXPLAIN ANALYZE`) |
| **Documentation** | LaTeX (Overleaf) & Canva |

---

## 🏗️ Database Schema

The schema was designed in **Third Normal Form (3NF)** to ensure consistency and scalability.
ER-to-relational mapping follows formal academic standards.

### 📘 EER Diagram

<img width="1920" height="1080" alt="Diagrama ER - IBD" src="https://github.com/user-attachments/assets/87e16e1c-5f62-43cb-be89-81ea0c91efd9" />

>*EER Diagram created manually according the discipline - Introduction to Databases (DCC011) - standard*



<img width="546" height="625" alt="image" src="https://github.com/user-attachments/assets/3b123b7b-3198-4ce7-bedf-bc9072a0881a" />

>*EER Diagram generated with MySQL Workbench*

### 🧩 Table Descriptions

| Table | Purpose |
| :--- | :--- |
| **`USUARIO`** | Stores user profile information (ID, username, email). |
| **`ESTUDIO`** | Animation studio details (ID, name, founding year). |
| **`ANIME`** | Main anime catalog. Linked to `ESTUDIO` via FK. |
| **`REVIEW`** | User reviews linked to `USUARIO` and `ANIME`. |
| **`ANIME_GENERO`** | Handles M:N relationships for anime genres. |
| **`WATCHLIST`** | Core M:N table linking users and anime with tracking data. |

---

## 📂 File Structure

```text
📦 AniVerse-DB
├── 📂 inserts/                     # Scripts containing data population instructions
├── 📂 queries/                     # SQL scripts for performance analysis and reports
├── 📄 01_criacao_esquema.sql       # DDL: creates full schema (tables, FKs, constraints)
├── 📄 02_testes_e_amostras.sql     # DML: sample/test data to validate schema
├── 📄 Relatorio_Final_IBD.pdf      # Full academic report with performance conclusions
├── 📄 Slide_Trabalho_IBD.pdf       # Slides of the final presentation
└── 🪶 README.md                    # You’re reading it now :)
```

-----

## 🚀 Setup and Usage

To replicate this project locally or review the database structure:

### Prerequisites
* **MySQL Server 8.0+**
* **MySQL Workbench** (or any SQL client)

### Installation Steps

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/AmandaFernandes0701/Anime-Tracker-Database.git](https://github.com/AmandaFernandes0701/Anime-Tracker-Database.git)
    ```
2.  **Create the Schema:**
    * Open `01_criacao_esquema.sql` in MySQL Workbench.
    * Run the script to create the `animes_db` (or `railway` schema depending on configuration).
3.  **Populate Data:**
    * Run `02_testes_e_amostras.sql` or the scripts inside the `inserts/` folder to load data.
4.  **Run Queries:**
    * Explore the `queries/` folder to test the specific analysis queries used in the project.

-----

## 📊 Query Performance Analysis

The detailed performance analysis, comparing execution times and query optimizations, is documented in the **`Relatorio_Final_IBD.pdf`**.

### 📈 Metrics & Methodology

  * Each query runs 5 times (average execution time recorded).
  * Benchmarks focus on:
      * Simple projections and selections
      * 2-table and 3+ table joins
      * Aggregations with `GROUP BY`, `HAVING`, and nested subqueries
      * Query optimization and indexing impact

-----

### 👩🏽‍💻 Authors

* [![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/amanda-fernandes-software-engineer) Amanda Fernandes Alves
* [![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/carolina-portella-4502281a7) Carolina Vilazante Portella
* [![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/gabriel-camargos-da-silveira-a089241ba/) Gabriel Camargos da Silveira
    
### 👨🏻‍🏫 Professor

* [![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/marcos-andré-goncalves-b153147/) Marcos André Goncalves

### 📚 Course

  * Introduction to Databases (DCC011) — UFMG

### 🌐 Hosted on

  * Railway.app

### 🙌🏽 Acknowledgments

Special thanks to [DCC - UFMG](https://dcc.ufmg.br/) for providing the learning foundation for this project.
And to all contributors and peers who inspired the development of AniVerse-DB.
