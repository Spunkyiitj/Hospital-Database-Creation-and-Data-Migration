
🏥 Hospital Database Creation & Data Migration  
📌 SQL | MySQL | Data Cleaning | Database Design

<p align="center">
  <img src="hospital-database-schema.png" 
       alt="Hospital Database EER Diagram" 
       width="900">
</p>


## 📊 Project Summary

Designed and implemented a normalized relational database system by migrating unstructured Excel data into MySQL, improving data integrity, reducing redundancy, and enabling efficient reporting and analysis.


## 📌 Project Overview

This project transforms an inefficient Excel-based hospital system into a structured MySQL database, improving data consistency, integrity, and reporting capabilities.

## 🚀 Business Impact

- Improved data accuracy by enforcing constraints and validation rules
- Eliminated data redundancy through normalization
- Prevented double bookings and invalid entries using triggers
- Enabled secure data access with role-based control (RBAC)
- Automated monthly revenue reporting for better decision-making

## 🔍 Key Insights

- Structured databases significantly improve data reliability compared to Excel systems
- Enforcing constraints at DB level prevents critical operational errors
- Role-based access improves data security in sensitive domains like healthcare
- SQL procedures can transform raw data into meaningful business reports

## 🚨 Problems Identified in the Existing System
### 1. No Unique Identifiers

There were no guaranteed unique IDs for patients, doctors, departments, or appointments.

### 2. Disconnected Relationships

Appointments existed without enforceable links to valid patients or doctors.

### 3. Invalid and Ambiguous Data

Examples:

Gender values like "X"

Appointment statuses like "On Hold"

Inconsistent date formats

### 4. Double Bookings & Past Appointments

Doctors were occasionally double-booked, and some appointments were scheduled in the past.

### 5. Unrestricted Access to Patient Data

All doctors could see all patient records, regardless of role or department.

### 6. No Department-Level Revenue Reporting

There was no structured way to generate monthly revenue summaries.

## 🛠 Solutions Implemented
### ✔ 1. Structured Relational Schema

Designed normalized tables:

Departments

Doctors

Patients

Appointments

Prescriptions

Bills

LabReports

Implemented:

Primary Keys (Auto Increment)

Foreign Key Constraints

Check Constraints

Default timestamps

This ensured referential integrity and eliminated data redundancy.

### ✔ 2. Data Validation & Standardization

Enforced valid gender values (M, F, O)

Restricted appointment status to (Scheduled, Completed, Cancelled)

Converted inconsistent date formats using STR_TO_DATE

Cleaned and migrated Excel-based hospital data into structured tables

### ✔ 3. Trigger for Appointment Validation

Created a BEFORE INSERT trigger on the Appointments table to:

Prevent scheduling appointments in the past

Prevent double booking of doctors at the same time

This ensures operational reliability at the database level.

### ✔ 4. Role-Based Access Control (RBAC)

Implemented a stored procedure that:

Authenticates doctors using credentials

Allows senior doctors to view all patients within their department

Restricts junior doctors to viewing only their assigned patients

This simulates controlled access to sensitive patient data.

### ✔ 5. Monthly Revenue Reporting

Developed a stored procedure to:

Join Bills, Appointments, Doctors, and Departments

Aggregate billing data

Generate department-wise monthly revenue reports

This converts transactional hospital data into actionable business insights.


## ⚙️ Key Technical Highlights

- Designed normalized schema (up to 3NF)
- Implemented constraints (PK, FK, CHECK)
- Used triggers for real-time validation
- Developed stored procedures for reporting
- Performed data cleaning and transformation

## 🧰 Technologies Used

MySQL

SQL (DDL, DML)

Triggers

Stored Procedures

Data Migration & Cleaning

Multi-table Joins and Aggregations

## 📚 Key Learnings

Designing normalized relational schemas

Enforcing business rules at the database level

Migrating messy Excel data into structured systems

Implementing role-based data access

Writing analytical stored procedures


