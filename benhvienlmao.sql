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
CREATE TABLE Roles (
    role_id INT PRIMARY KEY IDENTITY(1,1),
    role_name VARCHAR(50) UNIQUE NOT NULL
);
GO

-- Features (for access control)
CREATE TABLE Features (
    feature_id INT PRIMARY KEY IDENTITY(1,1),
    feature_name NVARCHAR(255) NOT NULL
);
GO

-- RoleFeatures (maps roles to features)
CREATE TABLE RoleFeatures (
    id INT PRIMARY KEY IDENTITY(1,1),
    role_id INT,
    feature_id INT,
    FOREIGN KEY (role_id) REFERENCES Roles(role_id),
    FOREIGN KEY (feature_id) REFERENCES Features(feature_id)
);
GO

-- Specializations
CREATE TABLE Specializations (
    specialization_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    status NVARCHAR(50) CHECK (status IN ('Active', 'Inactive'))
);
GO

-- Employees
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name NVARCHAR(255),
    dob DATE,
    gender CHAR(1),
    email VARCHAR(100),
    phone VARCHAR(20),
    role_id INT NOT NULL,
    specialization_id INT,
    FOREIGN KEY (role_id) REFERENCES Roles(role_id),
    FOREIGN KEY (specialization_id) REFERENCES Specializations(specialization_id)
);
GO

-- Employee History
CREATE TABLE EmployeeHistory (
    history_id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT,
    role_id INT,
    date DATE,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);
GO

-- Doctor Details
CREATE TABLE DoctorDetails (
    doctor_id INT PRIMARY KEY,
    license_number VARCHAR(100),
    work_schedule TEXT,
    rating DECIMAL(3,2) CHECK (rating BETWEEN 1.00 AND 5.00),
    FOREIGN KEY (doctor_id) REFERENCES Employees(employee_id)
);
GO

-- Patients
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name NVARCHAR(255),
    dob DATE,
    gender CHAR(1),
    email VARCHAR(100),
    phone VARCHAR(20),
    address NVARCHAR(255),
    insurance_number VARCHAR(100),
    emergency_contact NVARCHAR(255)
);
GO

-- Blog Types
CREATE TABLE BlogType (
    type_id TINYINT PRIMARY KEY,
    type_name NVARCHAR(10)
);
GO

-- Blogs
CREATE TABLE Blog (
    blog_id INT PRIMARY KEY IDENTITY(1,1),
    blog_name NVARCHAR(255),
    content NVARCHAR(MAX),
    image NVARCHAR(MAX),
    author NVARCHAR(255),
    date DATE,
    type_id TINYINT,
    selected_banner TINYINT CHECK (selected_banner IN (0, 1)) DEFAULT 0,
    FOREIGN KEY (type_id) REFERENCES BlogType(type_id)
);
GO

-- Comments
CREATE TABLE Comment (
    comment_id INT PRIMARY KEY IDENTITY(1,1),
    content NVARCHAR(MAX),
    date DATE,
    blog_id INT,
    patient_id INT,
    FOREIGN KEY (blog_id) REFERENCES Blog(blog_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);
GO

-- Appointments
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY IDENTITY(1,1),
    patient_id INT,
    doctor_id INT,
	appointment_type NVARCHAR(100) NOT NULL,
    appointment_date DATETIME,
    status VARCHAR(50) CHECK (status IN ('Pending', 'Confirmed', 'Completed', 'Cancelled')),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Employees(employee_id)
);
GO

-- Trigger: Validate doctor_id has 'Doctor' role
CREATE TRIGGER TRG_CheckDoctorRole_Appointments
ON Appointments
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Employees e ON i.doctor_id = e.employee_id
        JOIN Roles r ON e.role_id = r.role_id
        WHERE r.role_name != 'Doctor'
    )
    BEGIN
        RAISERROR ('doctor_id must reference an employee with role ''Doctor''.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- Diagnoses
CREATE TABLE Diagnoses (
    diagnosis_id INT PRIMARY KEY IDENTITY(1,1),
    appointment_id INT,
    notes TEXT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);
GO

-- Prescriptions
CREATE TABLE Prescriptions (
    prescription_id INT PRIMARY KEY IDENTITY(1,1),
    appointment_id INT,
    medication_details TEXT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);
GO

-- Treatment
CREATE TABLE Treatment (
    treatment_id INT PRIMARY KEY IDENTITY(1,1),
    appointment_id INT,
    treatment_type VARCHAR(100),
    treatment_notes TEXT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);
GO

-- Feedbacks
CREATE TABLE Feedbacks (
    feedback_id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT,
    patient_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);
GO

-- Payments
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    appointment_id INT,
    amount DECIMAL(10,2),
    method VARCHAR(50),
    status VARCHAR(50) CHECK (status IN ('Pending', 'Paid', 'Refunded')),
    payment_date DATETIME,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);
GO

-- Doctor Shifts
CREATE TABLE DoctorShifts (
    shift_id INT PRIMARY KEY IDENTITY(1,1),
    doctor_id INT,
    shift_date DATE,
    shift_time VARCHAR(50), -- Morning / Afternoon / Evening
    status VARCHAR(50) DEFAULT 'Scheduled',
    FOREIGN KEY (doctor_id) REFERENCES Employees(employee_id)
);
GO

-- Trigger: Validate doctor_id in DoctorShifts
CREATE TRIGGER TRG_CheckDoctorRole_DoctorShifts
ON DoctorShifts
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Employees e ON i.doctor_id = e.employee_id
        JOIN Roles r ON e.role_id = r.role_id
        WHERE r.role_name != 'Doctor'
    )
    BEGIN
        RAISERROR ('doctor_id must reference an employee with role ''Doctor''.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- Consultation Registrations (no FK)
CREATE TABLE ConsultationRegistrations (
    registration_id INT PRIMARY KEY IDENTITY(1,1),
    full_name NVARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    dob DATE,
    consultation_needs TEXT,
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- Insert sample Roles
INSERT INTO Roles (role_name) VALUES 
('Doctor'), ('Receptionist'), ('Admin');
GO

-- Insert sample Features
INSERT INTO Features (feature_name) VALUES 
('Book Appointment'), ('View Prescription'), ('Manage Users'), ('View Statistics');
GO

-- Insert sample Blog Types
INSERT INTO BlogType (type_id, type_name) VALUES
(0, N'Blog'),
(1, N'Banner'),
(2, N'Footer');
GO

INSERT INTO Patients (username, password_hash, full_name, dob, gender, email, phone, address, insurance_number, emergency_contact)
VALUES 
('john_doe', '123456', N'John Doe', '1990-05-10', 'M', 'john@example.com', '0901234567', N'123 Nguyễn Trãi, Hà Nội', 'INS12345', N'Jane Doe - 0912345678'),
('nguyenlan', 'abcdef', N'Nguyễn Lan', '1995-08-15', 'F', 'lan@example.com', '0987654321', N'456 Lê Lợi, Đà Nẵng', 'INS67890', N'Nguyễn Văn An - 0909876543'),
('tranbaominh', '654321', N'Trần Bảo Minh', '1988-03-25', 'M', 'minhtran@example.com', '0938123456', N'789 Phan Đình Phùng, TP.HCM', 'INS11223', N'Lê Thị Hoa - 0922334455'),
('lethanhha', '112233', N'Lê Thanh Hà', '1992-12-05', 'F', 'ha.le@example.com', '0944556677', N'101 Lý Thường Kiệt, Huế', 'INS44556', N'Ngô Quốc Dũng - 0977998855'),
('phamthutrang', 'pass123', N'Phạm Thu Trang', '1999-07-22', 'F', 'trangpham@example.com', '0911223344', N'99 Trần Hưng Đạo, Nha Trang', 'INS99887', N'Phạm Đức Anh - 0933445566');
GO

