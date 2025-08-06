# 🏥 BenhVienLmao2 - Dental Care Centel

A Java Web-based Hospital Management System built using Servlet, JSP, and JDBC following the MVC2 architecture. This is a student project developed for learning purposes, simulating core features of a hospital appointment and user management system.

## 🚀 Features

- User login/logout
- Patient management (CRUD)
- Employee management
- Appointment booking
- Role-based access (admin vs. staff)
- Session handling and access control

## 🧰 Technologies Used

- Java Servlet & JSP
- JDBC (SQL Server)
- HTML/CSS (Bootstrap optional)
- JSTL
- SQL Server
- Apache Tomcat 10.x
- NetBeans IDE

## 🏗️ Project Structure
benhVienLmao2/
├── src/
│ ├── controller/ # Servlets (Login, Appointment, CRUD)
│ ├── model/ # JavaBeans (Patient, Appointment, etc.)
│ ├── view/ # DAO classes (PatientDAO, AppointmentDAO)
│ └── utils/ # DBContext and utility helpers
├── web/
│ ├── views/ # JSP pages (login.jsp, home.jsp, list.jsp, etc.)
│ └── WEB-INF/
│ └── web.xml # Servlet configuration and routing
├── lib/ # JDBC driver, JSTL libraries
├── DML.sql # SQL script to initialize database
└── README.md # Project documentation


## 🔗 How It Works (MVC Flow)

1. **View (JSP)** sends a request to a **Controller (Servlet)**.
2. **Servlet** processes logic and interacts with **Model (DAO)**.
3. Data is retrieved from **SQL Server** and sent back to **JSP** for rendering.
4. Session attributes used for login management.

## ⚙️ Setup Instructions

### ✅ Requirements

- Java JDK 17
- NetBeans 16 or IntelliJ IDEA
- Apache Tomcat 10.1+
- SQL Server 2017+ (or compatible)
- JDBC driver for SQL Server
👨‍💻 Author
Nguyễn Hồng Quân
📧 quannhhe181157@fpt.edu.vn
🎓 Student at FPT University (SE - .NET Major)
SWP391 team:
- Nguyen Hong Quan (PM, BA,  Back-end Developer) 
- Nguyen Phi Son (Full stack Developer)
- Pham Huy Hung (QA, Full stack Developer, Database Designer)
- Luu Hai Phong (Full stack Developer)

##📌 Notes
This project is for educational/demo purposes only.
Security and error handling are basic; not production-ready.
