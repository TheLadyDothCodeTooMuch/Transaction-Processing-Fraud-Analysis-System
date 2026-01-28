# Transaction-Processing-Fraud-Analysis-System
This project explores how fraud manifests in daily bank transaction logs. The goal was to take raw, unorganized data, structure it into a formal database format, and uncover hidden stories—such as why certain accounts are targeted or identifying the "prime time" for fraudulent activity.A Python and SQL project that transforms raw banking transaction data into a clean, normalized database.
The ETL pipeline cleans and validates customer, account, merchant, and transaction data, loads it into MSSQL, and enables SQL-based fraud and pattern analysis.

This project demonstrates data engineering, database design, and SQL analytics skills with realistic banking data.

### **The Big Takeaways**

<img width="1608" height="798" alt="image" src="https://github.com/user-attachments/assets/7aa79037-df14-4a10-bee5-17b9e4406e65" />


* **The Targets:** While Checking accounts have the highest volume, **Business and Savings accounts** are higher-risk. Fraud rates for these segments sit at **5.17%** and **5.03%**, respectively.
* **The "Goldilocks" Scams:** Fraudsters appear to favor **Medium-value transactions** (₹10k - ₹50k). This "mid-tier" range accounts for **40.34%** of all fraud, likely because these amounts are high enough to be profitable but low enough to potentially bypass automated bank filters.
* **Where & When:** **Restaurants** are the top merchant category for fraud (16.8% of cases). Suspicious activity peaks on **Wednesday mornings by midnight then in the evenings by 6 PM**.
* **Vulnerable Demographics**: **Seniors** (specifically males in this dataset) are the most frequent targets, with nearly **2,000** fraudulent instances recorded.

### **Technical Workflow**

* **The Blueprint:** Data is organized using a **Snowflake Schema**. A core Fact table for transactions links to Dimension tables for accounts and customers to ensure efficiency and data integrity.
* **The Engine (SQL & Python):** **Python** handled the initial data cleaning, while **SQL** performed the heavy lifting. Queries utilizing window functions calculated the specific fraud incidence rates relative to total volume.
* **The View (Tableau):** The dashboard uses **Logical Relationships** to ensure data remains accurate across all interactive filters, such as age or gender.

### **Tools Used**

| Category | Tools | Purpose |
| --- | --- | --- |
| **Languages** | Python, SQL (T-SQL) | Data cleaning, validation, and complex querying. |
| **Database** | SQL Server / CSV | Storage of the snowflake-structured dataset. |
| **Visualization** | Tableau Public | Interactive dashboarding and trend analysis. |

---

### **See it in Action**

The dashboard features **Dashboard Actions**; clicking on a specific **Age Group** or **Gender** updates the entire page to display the fraud patterns for that specific segment.

**[👉 Check out the Interactive Dashboard on Tableau Public](https://www.google.com/search?q=https://public.tableau.com/your-profile-link-here)**


