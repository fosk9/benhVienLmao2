-- DROP & CREATE DATABASE
Use master
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

-- Users (base authentication table, with login_as)
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    login_as VARCHAR(50) NOT NULL CHECK (login_as IN ('Employee', 'Patient'))
);
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

-- Employees (updated to use role_id)
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    full_name NVARCHAR(255),
    dob DATE,
    gender CHAR(1),
    email VARCHAR(100),
    phone VARCHAR(20),
    role_id INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Users(user_id),
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);
GO

-- Specializations (for DoctorDetails dependency)
CREATE TABLE Specializations (
    specialization_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL
);
GO

-- DoctorDetails
CREATE TABLE DoctorDetails (
    doctor_id INT PRIMARY KEY,
    license_number VARCHAR(100),
    specialization_id INT,
    work_schedule TEXT,
    rating DECIMAL(3,2) CHECK (rating BETWEEN 1.00 AND 5.00),
    FOREIGN KEY (doctor_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (specialization_id) REFERENCES Specializations(specialization_id)
);
GO

-- AdminDetails
CREATE TABLE AdminDetails (
    admin_id INT PRIMARY KEY,
    note NVARCHAR(255),
    FOREIGN KEY (admin_id) REFERENCES Employees(employee_id)
);
GO

-- ReceptionistDetails
CREATE TABLE ReceptionistDetails (
    receptionist_id INT PRIMARY KEY,
    description NVARCHAR(255),
    FOREIGN KEY (receptionist_id) REFERENCES Employees(employee_id)
);
GO

-- Patients
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    full_name NVARCHAR(255),
    dob DATE,
    gender CHAR(1),
    email VARCHAR(100),
    phone VARCHAR(20),
    address NVARCHAR(255),
    insurance_number VARCHAR(100),
    emergency_contact NVARCHAR(255),
    FOREIGN KEY (patient_id) REFERENCES Users(user_id)
);
GO

-- Appointments (without type column)
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY IDENTITY(1,1),
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME,
    status VARCHAR(50) CHECK (status IN ('Pending', 'Confirmed', 'Completed', 'Cancelled')),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Employees(employee_id)
);
GO

-- Trigger for Appointments to enforce doctor_id role
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

-- TestRequests
CREATE TABLE TestRequests (
    test_id INT PRIMARY KEY IDENTITY(1,1),
    appointment_id INT,
    test_type VARCHAR(100),
    request_notes TEXT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);
GO

-- Results
CREATE TABLE Results (
    result_id INT PRIMARY KEY IDENTITY(1,1),
    test_id INT,
    result_text TEXT,
    conclusion TEXT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (test_id) REFERENCES TestRequests(test_id)
);
GO

-- Feedbacks
CREATE TABLE Feedbacks (
    feedback_id INT PRIMARY KEY IDENTITY(1,1),
    appointment_id INT,
    patient_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id),
    FOREIGN KEY (patient_id) REFERENCES Users(user_id)
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

-- Trigger for DoctorShifts to enforce doctor_id role
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

-- Consultation Registrations (for guests, no foreign keys)
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