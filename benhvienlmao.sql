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

-- SystemItems (merged Features and NavigationItems, removed parent_item_id)
CREATE TABLE SystemItems
(
    item_id       INT PRIMARY KEY IDENTITY (1,1),
    item_name     NVARCHAR(255) NOT NULL,
    item_url      NVARCHAR(255),
    display_order INT,
    item_type     VARCHAR(50)   NOT NULL CHECK (item_type IN ('Feature', 'Navigation'))
);
GO

-- RoleSystemItems (maps roles to system items for access control)
CREATE TABLE RoleSystemItems
(
    id      INT PRIMARY KEY IDENTITY (1,1),
    role_id INT,
    item_id INT,
    FOREIGN KEY (role_id) REFERENCES Roles (role_id),
    FOREIGN KEY (item_id) REFERENCES SystemItems (item_id) ON DELETE CASCADE
);
GO

-- Employees
CREATE TABLE Employees
(
    employee_id      INT PRIMARY KEY IDENTITY (1,1),
    username         VARCHAR(100) UNIQUE NOT NULL,
    password_hash    VARCHAR(255)        NOT NULL,
    full_name        NVARCHAR(255),
    dob              DATE,
    gender           CHAR(1),
    email            VARCHAR(100),
    phone            VARCHAR(20),
    role_id          INT                 NOT NULL,
    employee_ava_url NVARCHAR(255),
    created_at       DATETIME DEFAULT GETDATE(),
    acc_status       BIT      DEFAULT 1,
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

-- Doctor Details
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
    emergency_contact NVARCHAR(255),
    created_at        DATETIME DEFAULT GETDATE(),
    acc_status        BIT      DEFAULT 1
);
GO

-- Category
CREATE TABLE Category
(
    category_id   TINYINT PRIMARY KEY IDENTITY (1,1),
    category_name NVARCHAR(100) NOT NULL
);
GO

-- Blog
CREATE TABLE Blog
(
    blog_id          INT PRIMARY KEY IDENTITY (1,1),
    blog_name        NVARCHAR(255) NOT NULL,
    blog_sub_content NVARCHAR(500),
    content          NVARCHAR(MAX) NOT NULL,
    blog_img         NVARCHAR(500),
    author           NVARCHAR(255),
    date             DATETIME DEFAULT GETDATE(),
    category_id      TINYINT,
    selected_banner  BIT      DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES Category (category_id)
);
GO

-- Comment
CREATE TABLE Comment
(
    comment_id INT PRIMARY KEY IDENTITY (1,1),
    blog_id    INT           NOT NULL,
    patient_id INT           NOT NULL,
    content    NVARCHAR(MAX) NOT NULL,
    date       DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (blog_id) REFERENCES Blog (blog_id),
    FOREIGN KEY (patient_id) REFERENCES Patients (patient_id)
);
GO

-- AppointmentType
CREATE TABLE AppointmentType
(
    appointmenttype_id INT PRIMARY KEY IDENTITY (1,1),
    type_name          NVARCHAR(100)  NOT NULL,
    description        NVARCHAR(255),
    price              DECIMAL(12, 2) NOT NULL
);
GO

-- Appointments
CREATE TABLE Appointments
(
    appointment_id      INT PRIMARY KEY IDENTITY (1,1),
    patient_id          INT,
    doctor_id           INT,
    appointmenttype_id  INT NOT NULL,
    appointment_date    DATE,
    time_slot           VARCHAR(20) CHECK (time_slot IN ('Morning', 'Afternoon', 'Evening')),
    requires_specialist BIT      DEFAULT 0,
    status              VARCHAR(50) CHECK (status IN ('Unpay', 'Pending', 'Confirmed', 'Completed', 'Cancelled')),
    created_at          DATETIME DEFAULT GETDATE(),
    updated_at          DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (patient_id) REFERENCES Patients (patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Employees (employee_id),
    FOREIGN KEY (appointmenttype_id) REFERENCES AppointmentType (appointmenttype_id)
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
    status         VARCHAR(50) CHECK (status IN ('Pending', 'Paid', 'Refunded', 'Cancel')),
    pay_content    VARCHAR(255),
    created_at     DATETIME DEFAULT GETDATE(),
    paid_at        DATETIME,
    FOREIGN KEY (appointment_id) REFERENCES Appointments (appointment_id)
);
GO

-- Doctor Shifts
CREATE TABLE DoctorShifts
(
    shift_id     INT PRIMARY KEY IDENTITY (1,1),
    doctor_id    INT  NOT NULL,
    shift_date   DATE NOT NULL,
    time_slot    VARCHAR(20) CHECK (time_slot IN ('Morning', 'Afternoon', 'Evening', 'Night')),
    status       VARCHAR(20) CHECK (status IN ('Working', 'PendingLeave', 'Leave', 'Rejected')) DEFAULT 'Working',
    manager_id   INT,
    requested_at DATETIME,
    approved_at  DATETIME,
    FOREIGN KEY (doctor_id) REFERENCES Employees (employee_id),
    FOREIGN KEY (manager_id) REFERENCES Employees (employee_id)
);

GO

-- PageContent
CREATE TABLE PageContent
(
    content_id    INT PRIMARY KEY IDENTITY (1,1),
    page_name     VARCHAR(50)   NOT NULL,
    content_key   VARCHAR(100)  NOT NULL,
    content_value NVARCHAR(MAX) NOT NULL,
    is_active     BIT DEFAULT 1,
    image_url     NVARCHAR(255) NULL,
    video_url     NVARCHAR(255) NULL,
    button_url    NVARCHAR(255) NULL,
    button_text   NVARCHAR(255) NULL,
    UNIQUE (page_name, content_key)
);
GO

-- ChangeHistory
CREATE TABLE ChangeHistory
(
    change_id        INT IDENTITY (1,1) PRIMARY KEY,
    manager_id       INT          NOT NULL, -- ID người thực hiện (từ Employees)
    manager_name     VARCHAR(100) NOT NULL, -- Tên người thực hiện
    target_user_id   INT          NOT NULL, -- ID người bị ảnh hưởng (employee/patient ID)
    target_user_name VARCHAR(100) NOT NULL, -- Tên người bị ảnh hưởng
    target_source    VARCHAR(50)  NOT NULL, -- Employee / Patient / Schedule / ...
    action           VARCHAR(100) NOT NULL, -- CREATE / UPDATE / DELETE / ROLE_CHANGE...
    change_time      DATETIME DEFAULT CURRENT_TIMESTAMP
);
Go

CREATE TABLE LogSystem (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NULL,
    patient_id INT NULL,
    user_name NVARCHAR(255),
    role_name NVARCHAR(50),
    action NVARCHAR(255),
    log_level VARCHAR(10),
    created_at DATETIME DEFAULT GETDATE()
);