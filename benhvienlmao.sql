-- DROP & CREATE DATABASE
USE master
GO

IF DB_ID('benhvienlmao') IS NOT NULL
    BEGIN
        ALTER DATABASE benhvienlmao SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
        DROP DATABASE benhvienlmao;
    END
CREATE DATABASE benhvienlmao;
GO

USE benhvienlmao;
GO

-- Roles (for access control)
CREATE TABLE Roles
(
    role_id   INT PRIMARY KEY IDENTITY (1,1),
    role_name VARCHAR(50) UNIQUE NOT NULL
);
GO

-- Features (for access control)
CREATE TABLE Features
(
    feature_id   INT PRIMARY KEY IDENTITY (1,1),
    feature_name NVARCHAR(255) NOT NULL
);
GO

-- RoleFeatures (maps roles to features)
CREATE TABLE RoleFeatures
(
    id         INT PRIMARY KEY IDENTITY (1,1),
    role_id    INT,
    feature_id INT,
    FOREIGN KEY (role_id) REFERENCES Roles (role_id),
    FOREIGN KEY (feature_id) REFERENCES Features (feature_id)
);
GO

-- Employees (removed specialization_id)
CREATE TABLE Employees
(
    employee_id       INT PRIMARY KEY IDENTITY (1,1),
    username          VARCHAR(100) UNIQUE NOT NULL,
    password_hash     VARCHAR(255)        NOT NULL,
    full_name         NVARCHAR(255),
    dob               DATE,
    gender            CHAR(1),
    email             VARCHAR(100),
    phone             VARCHAR(20),
    role_id           INT                 NOT NULL,
    employee_ava_url  NVARCHAR(255),
    FOREIGN KEY (role_id) REFERENCES Roles (role_id)
);
GO

-- Employee History
CREATE TABLE EmployeeHistory
(
    history_id  INT PRIMARY KEY IDENTITY (1,1),
    employee_id INT,
    role_id     INT,
    date        DATE,
    FOREIGN KEY (employee_id) REFERENCES Employees (employee_id),
    FOREIGN KEY (role_id) REFERENCES Roles (role_id)
);
GO

-- Doctor Details (added is_specialist, removed work_schedule)
CREATE TABLE DoctorDetails
(
    doctor_id      INT PRIMARY KEY,
    license_number VARCHAR(100),
    is_specialist  BIT DEFAULT 0,
    rating         DECIMAL(3, 2) CHECK (rating BETWEEN 1.00 AND 5.00),
    FOREIGN KEY (doctor_id) REFERENCES Employees (employee_id)
);
GO

-- Patients
CREATE TABLE Patients
(
    patient_id        INT PRIMARY KEY IDENTITY (1,1),
    username          VARCHAR(100) UNIQUE NOT NULL,
    password_hash     VARCHAR(255)        NOT NULL,
    full_name         NVARCHAR(255),
    dob               DATE,
    gender            CHAR(1),
    email             VARCHAR(100),
    phone             VARCHAR(20),
    address           NVARCHAR(255),
    patient_ava_url   NVARCHAR(255),
    insurance_number  VARCHAR(100),
    emergency_contact NVARCHAR(255)
);
GO

-- Blog Types
CREATE TABLE BlogType
(
    type_id   TINYINT PRIMARY KEY,
    type_name NVARCHAR(10)
);
GO

-- Blogs
CREATE TABLE Blog
(
    blog_id         INT PRIMARY KEY IDENTITY (1,1),
    blog_name       NVARCHAR(255),
    content         NVARCHAR(MAX),
    image           NVARCHAR(MAX),
    author          NVARCHAR(255),
    date            DATE,
    type_id         TINYINT,
    selected_banner TINYINT CHECK (selected_banner IN (0, 1)) DEFAULT 0,
    FOREIGN KEY (type_id) REFERENCES BlogType (type_id)
);
GO

-- Comments
CREATE TABLE Comment
(
    comment_id INT PRIMARY KEY IDENTITY (1,1),
    content    NVARCHAR(MAX),
    date       DATE,
    blog_id    INT,
    patient_id INT,
    FOREIGN KEY (blog_id) REFERENCES Blog (blog_id),
    FOREIGN KEY (patient_id) REFERENCES Patients (patient_id)
);
GO

-- Appointments (restricted to Morning/Afternoon/Evening)
CREATE TABLE Appointments
(
    appointment_id   INT PRIMARY KEY IDENTITY (1,1),
    patient_id       INT,
    doctor_id        INT,
    appointment_type NVARCHAR(100) NOT NULL,
    appointment_date DATE,
    time_slot        VARCHAR(20) CHECK (time_slot IN ('Morning', 'Afternoon', 'Evening')),
	requires_specialist BIT DEFAULT 0,
    status           VARCHAR(50) CHECK (status IN ('Pending', 'Confirmed', 'Completed', 'Cancelled')),
    created_at       DATETIME DEFAULT GETDATE(),
    updated_at       DATETIME,
    FOREIGN KEY (patient_id) REFERENCES Patients (patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Employees (employee_id)
);
GO



-- Diagnoses
CREATE TABLE Diagnoses
(
    diagnosis_id   INT PRIMARY KEY IDENTITY (1,1),
    appointment_id INT,
    notes          TEXT,
    created_at     DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (appointment_id) REFERENCES Appointments (appointment_id)
);
GO

-- Prescriptions
CREATE TABLE Prescriptions
(
    prescription_id    INT PRIMARY KEY IDENTITY (1,1),
    appointment_id     INT,
    medication_details TEXT,
    created_at         DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (appointment_id) REFERENCES Appointments (appointment_id)
);
GO

-- Treatment
CREATE TABLE Treatment
(
    treatment_id    INT PRIMARY KEY IDENTITY (1,1),
    appointment_id  INT,
    treatment_type  VARCHAR(100),
    treatment_notes TEXT,
    created_at      DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (appointment_id) REFERENCES Appointments (appointment_id)
);
GO

-- Feedbacks
CREATE TABLE Feedbacks
(
    feedback_id INT PRIMARY KEY IDENTITY (1,1),
    employee_id INT,
    patient_id  INT,
    rating      INT CHECK (rating BETWEEN 1 AND 5),
    comments    TEXT,
    created_at  DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (employee_id) REFERENCES Employees (employee_id),
    FOREIGN KEY (patient_id) REFERENCES Patients (patient_id)
);
GO

-- Payments
CREATE TABLE Payments
(
    payment_id     INT PRIMARY KEY IDENTITY (1,1),
    appointment_id INT,
    amount         DECIMAL(10, 2),
    method         VARCHAR(50),
    status         VARCHAR(50) CHECK (status IN ('Pending', 'Paid', 'Refunded')),
    payment_date   DATETIME,
    FOREIGN KEY (appointment_id) REFERENCES Appointments (appointment_id)
);
GO

-- Doctor Shifts (Morning/Afternoon/Evening/Night with manager approval)
CREATE TABLE DoctorShifts
(
    shift_id        INT PRIMARY KEY IDENTITY (1,1),
    doctor_id       INT,
    shift_date      DATE,
    time_slot       VARCHAR(20) CHECK (time_slot IN ('Morning', 'Afternoon', 'Evening', 'Night')),
    status          VARCHAR(50) CHECK (status IN ('Scheduled', 'Rest', 'PendingApproval', 'Approved', 'Rejected')) DEFAULT 'Scheduled',
    manager_id      INT,
    requested_at    DATETIME DEFAULT GETDATE(),
    approved_at     DATETIME,
    FOREIGN KEY (doctor_id) REFERENCES Employees (employee_id),
    FOREIGN KEY (manager_id) REFERENCES Employees (employee_id)
);
GO

-- Insert sample Roles (added Manager)
INSERT INTO Roles (role_name)
VALUES ('Doctor'),
       ('Receptionist'),
       ('Admin'),
       ('Manager');
GO

-- Insert sample Features
INSERT INTO Features (feature_name)
VALUES ('Book Appointment'),
       ('View Prescription'),
       ('Manage Users'),
       ('View Statistics'),
       ('Approve Doctor Shifts');
GO

-- Insert sample Blog Types
INSERT INTO BlogType (type_id, type_name)
VALUES (0, N'Blog'),
       (1, N'Banner'),
       (2, N'Footer');
GO

-- Insert sample Patients
INSERT INTO Patients (username, password_hash, full_name, dob, gender, email, phone, address, insurance_number, emergency_contact)
VALUES ('john_doe', '123456', N'John Doe', '1990-05-10', 'M', 'john@example.com', '0901234567', N'123 Nguyễn Trãi, Hà Nội', 'INS12345', N'Jane Doe - 0912345678'),
       ('nguyenlan', 'abcdef', N'Nguyễn Lan', '1995-08-15', 'F', 'lan@example.com', '0987654321', N'456 Lê Lợi, Đà Nẵng', 'INS67890', N'Nguyễn Văn An - 0909876543'),
       ('tranbaominh', '654321', N'Trần Bảo Minh', '1988-03-25', 'M', 'minhtran@example.com', '0938123456', N'789 Phan Đình Phùng, TP.HCM', 'INS11223', N'Lê Thị Hoa - 0922334455'),
       ('lethanhha', '112233', N'Lê Thanh Hà', '1992-12-05', 'F', 'ha.le@example.com', '0944556677', N'101 Lý Thường Kiệt, Huế', 'INS44556', N'Ngô Quốc Dũng - 0977998855'),
       ('phamthutrang', 'pass123', N'Phạm Thu Trang', '1999-07-22', 'F', 'trangpham@example.com', '0911223344', N'99 Trần Hưng Đạo, Nha Trang', 'INS99887', N'Phạm Đức Anh - 0933445566'),
       ('phamquang', 'pq123', N'Phạm Quang', '1991-01-10', 'M', 'quang.pham@example.com', '0912000001', N'12 Lý Chính Thắng, Hà Nội', 'INS55501', N'Nguyễn Hà - 0912333444'),
       ('dothanhtruc', 'dttruc', N'Đỗ Thanh Trúc', '1996-02-12', 'F', 'truc.do@example.com', '0912000002', N'15 Pasteur, Đà Nẵng', 'INS55502', N'Lê Quang - 0922333444'),
       ('hoangminhduc', 'hmd123', N'Hoàng Minh Đức', '1993-07-08', 'M', 'duc.hoang@example.com', '0912000003', N'99 Trần Phú, TP.HCM', 'INS55503', N'Phạm Lan - 0932333444'),
       ('tranthikieu', 'tk123', N'Trần Thị Kiều', '1997-05-22', 'F', 'kieu.tran@example.com', '0912000004', N'71 Lê Văn Sỹ, Biên Hòa', 'INS55504', N'Trịnh Hùng - 0942333444'),
       ('nguyenthihong', 'nth456', N'Nguyễn Thị Hồng', '1990-03-30', 'F', 'hong.nguyen@example.com', '0912000005', N'52 Nguyễn Tri Phương, Huế', 'INS55505', N'Lê Minh - 0952333444'),
       ('letrungkieu', 'ltk789', N'Lê Trung Kiều', '1994-09-09', 'M', 'kieu.le@example.com', '0912000006', N'18 Hoàng Văn Thụ, Hải Phòng', 'INS55506', N'Ngô Bình - 0962333444'),
       ('phamthanhnga', 'ptn111', N'Phạm Thanh Nga', '1992-11-11', 'F', 'nga.pham@example.com', '0912000007', N'64 Nguyễn Huệ, Nha Trang', 'INS55507', N'Lý Hương - 0972333444');
GO

-- Insert sample Employees (added Manager)
INSERT INTO Employees (username, password_hash, full_name, dob, gender, email, phone, role_id)
VALUES ('dr_smith', '123456', N'Dr. John Smith', '1980-03-15', 'M', 'john.smith@hospital.com', '0909000001', 1),
       ('dr_hoa', 'abcdef', N'Dr. Nguyễn Thị Hoa', '1985-06-22', 'F', 'hoa.nguyen@hospital.com', '0909000002', 1),
       ('dr_lee', '654321', N'Dr. David Lee', '1978-12-03', 'M', 'david.lee@hospital.com', '0909000003', 1),
       ('dr_linh', '999999', N'Dr. Phạm Minh Linh', '1990-09-09', 'F', 'linh.pham@hospital.com', '0909000004', 1),
       ('admin01', 'admin123', N'Nguyễn Thị Quản Trị', '1982-01-01', 'F', 'admin01@hospital.com', '0911000001', 3),
       ('recept01', 'recept123', N'Lê Văn Tiếp Tân', '1990-04-12', 'M', 'recept01@hospital.com', '0911000002', 2),
       ('admin02', 'admin456', N'Phạm Văn Admin', '1985-11-20', 'M', 'admin02@hospital.com', '0911000003', 3),
       ('recept02', 'recept456', N'Trần Thị Lễ Tân', '1993-06-30', 'F', 'recept02@hospital.com', '0911000004', 2),
       ('manager01', 'man123', N'Nguyễn Văn Quản Lý', '1975-05-10', 'M', 'manager01@hospital.com', '0912000001', 4);
GO

-- Insert sample Doctor Details (updated with is_specialist)
INSERT INTO DoctorDetails (doctor_id, license_number, is_specialist, rating)
VALUES (1, 'LIC12345', 1, 4.5),
       (2, 'LIC23456', 0, 4.7),
       (3, 'LIC34567', 1, 4.3),
       (4, 'LIC45678', 0, 4.8);
GO

-- Insert sample Appointments (updated time slots)
INSERT INTO Appointments (patient_id, doctor_id, appointment_type, appointment_date, time_slot, status, created_at, updated_at)
VALUES (1, 1, 'General Checkup', '2025-05-30', 'Morning', 'Pending', GETDATE(), GETDATE()),
       (2, 1, 'Cardiology Consultation', '2025-05-10', 'Afternoon', 'Confirmed', GETDATE(), GETDATE()),
       (3, 1, 'Gastroenterology Consultation', '2025-05-29', 'Evening', 'Completed', GETDATE(), GETDATE()),
       (4, 1, 'Orthopedic Consultation', '2025-06-04', 'Morning', 'Cancelled', GETDATE(), GETDATE()),
       (5, 1, 'Neurology Consultation', '2025-06-15', 'Afternoon', 'Pending', GETDATE(), GETDATE()),
       (1, 1, 'Mental Health Consultation', '2025-05-29', 'Morning', 'Completed', GETDATE(), GETDATE()),
       (2, 1, 'Psychotherapy Session', '2025-06-20', 'Evening', 'Pending', GETDATE(), GETDATE()),
       (3, 1, 'Psychiatric Evaluation', '2025-05-15', 'Afternoon', 'Confirmed', GETDATE(), GETDATE()),
       (4, 1, 'Stress and Anxiety Management', '2025-06-09', 'Morning', 'Cancelled', GETDATE(), GETDATE()),
       (5, 1, 'Depression Counseling', '2025-05-29', 'Evening', 'Completed', GETDATE(), GETDATE()),
       (1, 1, 'Periodic Health Checkup', '2025-06-01', 'Morning', 'Pending', GETDATE(), GETDATE()),
       (2, 1, 'Gynecology Consultation', '2025-05-20', 'Afternoon', 'Confirmed', GETDATE(), GETDATE()),
       (3, 1, 'Pediatric Consultation', '2025-05-29', 'Morning', 'Completed', GETDATE(), GETDATE()),
       (4, 1, 'Ophthalmology Consultation', '2025-06-14', 'Evening', 'Cancelled', GETDATE(), GETDATE()),
       (5, 1, 'ENT Consultation', '2025-06-30', 'Afternoon', 'Pending', GETDATE(), GETDATE()),
       (1, 1, 'On-Demand Consultation', '2025-05-30', 'Morning', 'Confirmed', GETDATE(), GETDATE()),
       (2, 1, 'Emergency Consultation', '2025-05-29', 'Evening', 'Completed', GETDATE(), GETDATE()),
       (3, 1, 'General Checkup', '2025-06-18', 'Afternoon', 'Cancelled', GETDATE(), GETDATE()),
       (4, 1, 'Cardiology Consultation', '2025-06-05', 'Morning', 'Pending', GETDATE(), GETDATE()),
       (5, 1, 'Gastroenterology Consultation', '2025-05-25', 'Evening', 'Confirmed', GETDATE(), GETDATE());
GO

-- Insert sample Doctor Shifts (example with rest requests)
INSERT INTO DoctorShifts (doctor_id, shift_date, time_slot, status, manager_id, requested_at)
VALUES (1, '2025-06-01', 'Morning', 'PendingApproval', 9, GETDATE()),
       (1, '2025-06-01', 'Afternoon', 'Scheduled', NULL, GETDATE()),
       (1, '2025-06-01', 'Evening', 'Scheduled', NULL, GETDATE()),
       (1, '2025-06-01', 'Night', 'PendingApproval', 9, GETDATE()),
       (2, '2025-06-02', 'Morning', 'Scheduled', NULL, GETDATE()),
       (2, '2025-06-02', 'Afternoon', 'PendingApproval', 9, GETDATE());
GO