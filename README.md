# University Data Analytics: SQL Logic Lab 🎓

This repository contains a collection of complex SQL queries designed to solve management and analytical problems within a university database schema. 

## 🚀 Learning Journey: Mastering Subqueries
This project represents a significant milestone in my SQL journey. While working on these tasks, I focused heavily on transitioning from simple queries to **complex Subqueries and Nested Logic**. 

You will find examples of:
- **Scalar and Correlated Subqueries**: Used for dynamic filtering (e.g., comparing group ratings against specific group averages).
- **Advanced Aggregations**: Implementing `HAVING` and `GROUP BY` to handle multi-layered data relationships.
- **Financial & Academic Analytics**: Calculating departmental funds, teacher wage rates, and student performance metrics.

---
## 📊 Database Schema
Below is the Entity-Relationship (ER) diagram illustrating the structure of the university database used for these queries. It displays all tables, primary keys (PK), foreign keys (FK), and relationships.


<img width="1272" height="797" alt="image" src="https://github.com/user-attachments/assets/62219485-3d4e-4fbb-8a78-31422969e813" />



## 📋 Task List & Logic Breakdowns

The queries solve the following 10 business logic scenarios:

1.  **Building Finance**: Identifying buildings where total department financing exceeds $100,000.
2.  **Software Dev Scheduling**: Filtering 5th-year groups with high lecture density (>10 double periods) in the first week.
3.  **Comparative Rating**: Finding groups that outperform the "D221" group average.
4.  **Wage Benchmarking**: Listing teachers earning above the average rate of all professors.
5.  **Curator Oversight**: Identifying groups managed by multiple curators.
6.  **Performance Bottom-line**: Finding groups whose rating is lower than the minimum of all 5th-year groups.
7.  **Departmental Fund Analysis**: Comparing faculty financing against the "Computer Science" department's total fund.
8.  **Lecture Leadership**: Identifying the subject-teacher pairs with the highest lecture volume.
9.  **Efficiency Metrics**: Finding the subject with the absolute minimum number of lectures delivered.
10. **Departmental Overview**: Calculating total students and subjects for the Software Development department.

## 🛠️ Tech Stack
- **Database Engine:** Microsoft SQL Server (T-SQL)
- **Concepts:** Inner/Left Joins, Subqueries, Aggregate Functions (SUM, AVG, COUNT, MIN/MAX).

---
*This is a living documentation of my progress in SQL mastery. Feedback and suggestions are always welcome!*
