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
    updated_at          DATETIME,
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


-- Insert Roles
-- Defines the roles used for access control in the benhVienLmao system
INSERT INTO Roles (role_name)
VALUES 
    ('Doctor'),      -- role_id = 1
    ('Receptionist'),-- role_id = 2
    ('Admin'),       -- role_id = 3
    ('Manager'),     -- role_id = 4
    ('Patient'),     -- role_id = 5
    ('Guest');       -- role_id = 6
GO

-- Insert SystemItems
-- Defines navigation and feature items accessible in the system, numbered for clarity
INSERT INTO SystemItems (item_name, item_url, display_order, item_type)
VALUES 
    -- Navigation Items (Public and General)
    ('Home', 'index', 1, 'Navigation'),                                    -- item_id = 1
    ('About', 'about.html', 2, 'Navigation'),                              -- item_id = 2
    ('Dental Services', 'services.html', 3, 'Navigation'),                 -- item_id = 3
    ('Blog', 'blog', 4, 'Navigation'),                                    -- item_id = 4
    ('Blog Details', 'blog-detail.jsp', 5, 'Navigation'),                  -- item_id = 5
    ('Contact', 'contact.html', 6, 'Navigation'),                          -- item_id = 6

    -- Feature Items (Public and General)
    ('Book Appointment', 'book-appointment', NULL, 'Feature'),             -- item_id = 7
    ('Teeth Whitening', 'book-appointment?appointmentTypeId=3', 1, 'Feature'), -- item_id = 8
    ('Dental Checkup', 'book-appointment?appointmentTypeId=1', 2, 'Feature'),  -- item_id = 9
    ('Tooth Extraction', 'book-appointment?appointmentTypeId=6', 3, 'Feature'), -- item_id = 10
    ('Search for Service', 'appointment/list', 4, 'Feature'),              -- item_id = 11

    -- Doctor-Specific Items
    ('Doctor Dashboard', 'doctor-home', 1, 'Navigation'),                  -- item_id = 12
    ('View Prescription', 'view-prescription', NULL, 'Feature'),           -- item_id = 13

    -- Admin-Specific Items
    ('Admin Home', 'admin/home', NULL, 'Navigation'),                      -- item_id = 14
    ('Manage Employees', 'admin/manageEmployees', NULL, 'Navigation'),     -- item_id = 15
    ('Manage Patients', 'admin/managePatients', NULL, 'Navigation'),       -- item_id = 16
    ('Manage System Items', 'admin/system-items', NULL, 'Feature'),        -- item_id = 17
    ('Manage System Contents', 'admin/contents', NULL, 'Feature'),         -- item_id = 18
    ('Add New Content', 'admin/content/add', NULL, 'Navigation'),          -- item_id = 19
    ('View Logs', 'admin/logs', NULL, 'Feature'),                         -- item_id = 20
    ('Manage Appointment Type', 'admin/appointments', NULL, 'Feature'),    -- item_id = 21
    ('Manage Payment', 'https://my.payos.vn/', NULL, 'Feature'),           -- item_id = 22

    -- Patient-Specific Items
    ('Appointments', 'appointments', 1, 'Navigation'),                     -- item_id = 23
    ('Treatment History', 'treatment/history', 2, 'Navigation'),           -- item_id = 24
    ('Services', 'appointment/list', 3, 'Navigation'),                     -- item_id = 25
    ('Account', '', 4, 'Navigation'),                                     -- item_id = 26
    ('My Profile', 'MyProfile', 99, 'Navigation'),                         -- item_id = 27
    ('Change Password', 'change-password', 7, 'Navigation'),               -- item_id = 28
    ('Book Appointment (Patient)', 'book-appointment', 8, 'Navigation'),   -- item_id = 29
    ('Logout', 'logout', 5, 'Navigation');                                -- item_id = 30
GO

-- Insert RoleSystemItems
-- Maps roles to SystemItems for role-based access control
INSERT INTO RoleSystemItems (role_id, item_id)
VALUES 
    -- Doctor (role_id = 1) Permissions
    (1, 12), -- Doctor Dashboard (doctor-home)
    (1, 13), -- View Prescription (view-prescription)
    (1, 27), -- My Profile (MyProfile)
    (1, 28), -- Change Password (change-password)
    (1, 30), -- Logout (logout)

    -- Admin (role_id = 3) Permissions
    (3, 14), -- Admin Home (admin/home)
    (3, 15), -- Manage Employees (admin/manageEmployees)
    (3, 16), -- Manage Patients (admin/managePatients)
    (3, 17), -- Manage System Items (admin/system-items)
    (3, 18), -- Manage System Contents (admin/contents)
    (3, 19), -- Add New Content (admin/content/add)
    (3, 20), -- View Logs (admin/logs)
    (3, 21), -- Manage Appointment Type (admin/appointments)
    (3, 22), -- Manage Payment[](https://my.payos.vn/)

    -- Manager (role_id = 4) Permissions
    (4, 21), -- Manage Appointment Type (admin/appointments)
    (4, 22), -- Manage Payment[](https://my.payos.vn/)

    -- Patient (role_id = 5) Permissions
    (5, 4),  -- Blog (blog)
    (5, 5),  -- Blog Details (blog-detail.jsp)
    (5, 23), -- Appointments (appointments)
    (5, 24), -- Treatment History (treatment/history)
    (5, 25), -- Services (appointment/list)
    (5, 26), -- Account
    (5, 27), -- My Profile (MyProfile)
    (5, 28), -- Change Password (change-password)
    (5, 29), -- Book Appointment (Patient) (book-appointment)
    (5, 30), -- Logout (logout)

    -- Guest (role_id = 6) Permissions
    (6, 4),  -- Blog (blog)
    (6, 5),  -- Blog Details (blog-detail.jsp)
    (6, 7),  -- Book Appointment (book-appointment)
    (6, 8),  -- Teeth Whitening (book-appointment?appointmentTypeId=3)
    (6, 9),  -- Dental Checkup (book-appointment?appointmentTypeId=1)
    (6, 10), -- Tooth Extraction (book-appointment?appointmentTypeId=6)
    (6, 11), -- Search for Service (appointment/list)
    (6, 25); -- Services (appointment/list)
GO

-- Insert sample Patients
INSERT INTO Patients (username, password_hash, full_name, dob, gender, email, phone, address, insurance_number,
                      emergency_contact)
VALUES ('john_doe', '123456', N'John Doe', '1990-05-10', 'M', 'john@example.com', '0901234567',
        N'123 Nguyễn Trãi, Hà Nội', 'INS12345', N'Jane Doe - 0912345678'),
       ('nguyenlan', 'abcdef', N'Nguyễn Lan', '1995-08-15', 'F', 'lan@example.com', '0987654321',
        N'456 Lê Lợi, Đà Nẵng', 'INS67890', N'Nguyễn Văn An - 0909876543'),
       ('tranbaominh', '654321', N'Trần Bảo Minh', '1988-03-25', 'M', 'minhtran@example.com', '0938123456',
        N'789 Phan Đình Phùng, TP.HCM', 'INS11223', N'Lê Thị Hoa - 0922334455'),
       ('lethanhha', '112233', N'Lê Thanh Hà', '1992-12-05', 'F', 'ha.le@example.com', '0944556677',
        N'101 Lý Thường Kiệt, Huế', 'INS44556', N'Ngô Quốc Dũng - 0977998855'),
       ('phamthutrang', 'pass123', N'Phạm Thu Trang', '1999-07-22', 'F', 'trangpham@example.com', '0911223344',
        N'99 Trần Hưng Đạo, Nha Trang', 'INS99887', N'Phạm Đức Anh - 0933445566'),
       ('phamquang', 'pq123', N'Phạm Quang', '1991-01-10', 'M', 'quang.pham@example.com', '0912000001',
        N'12 Lý Chính Thắng, Hà Nội', 'INS55501', N'Nguyễn Hà - 0912333444'),
       ('dothanhtruc', 'dttruc', N'Đỗ Thanh Trúc', '1996-02-12', 'F', 'truc.do@example.com', '0912000002',
        N'15 Pasteur, Đà Nẵng', 'INS55502', N'Lê Quang - 0922333444'),
       ('hoangminhduc', 'hmd123', N'Hoàng Minh Đức', '1993-07-08', 'M', 'duc.hoang@example.com', '0912000003',
        N'99 Trần Phú, TP.HCM', 'INS55503', N'Phạm Lan - 0932333444'),
       ('tranthikieu', 'tk123', N'Trần Thị Kiều', '1997-05-22', 'F', 'kieu.tran@example.com', '0912000004',
        N'71 Lê Văn Sỹ, Biên Hòa', 'INS55504', N'Trịnh Hùng - 0942333444'),
       ('nguyenthihong', 'nth456', N'Nguyễn Thị Hồng', '1990-03-30', 'F', 'hong.nguyen@example.com', '0912000005',
        N'52 Nguyễn Tri Phương, Huế', 'INS55505', N'Lê Minh - 0952333444'),
       ('letrungkieu', 'ltk789', N'Lê Trung Kiều', '1994-09-09', 'M', 'kieu.le@example.com', '0912000006',
        N'18 Hoàng Văn Thụ, Hải Phòng', 'INS55506', N'Ngô Bình - 0962333444'),
       ('phamthanhnga', 'ptn111', N'Phạm Thanh Nga', '1992-11-11', 'F', 'nga.pham@example.com', '0912000007',
        N'64 Nguyễn Huệ, Nha Trang', 'INS55507', N'Lý Hương - 0972333444');
GO

-- Insert sample Employees
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

-- Insert sample Doctor Details
INSERT INTO DoctorDetails (doctor_id, license_number, is_specialist, rating)
VALUES (1, 'LIC12345', 1, 4.5),
       (2, 'LIC23456', 0, 4.7),
       (3, 'LIC34567', 1, 4.3),
       (4, 'LIC45678', 0, 4.8);
GO

-- Insert dental AppointmentType with 2025 Vietnam market prices
INSERT INTO AppointmentType (type_name, description, price)
VALUES ('Dental Checkup', 'Routine dental examination and consultation', 200000.00),
       ('Teeth Cleaning', 'Professional scaling and polishing', 800000.00),
       ('Teeth Whitening', 'Laser or home kit teeth whitening', 3000000.00),
       ('Composite Filling', 'Filling for small cavities using composite resin', 400000.00),
       ('Inlay/Onlay Filling', 'Aesthetic filling for larger cavities', 2000000.00),
       ('Tooth Extraction', 'Simple tooth removal', 900000.00),
       ('Wisdom Tooth Extraction', 'Surgical removal of wisdom teeth', 3500000.00),
       ('Root Canal Treatment', 'Treatment for infected tooth roots', 5000000.00),
       ('Porcelain Veneer', 'Cosmetic veneer for chipped or stained teeth', 8400000.00),
       ('Zirconia Crown', 'Durable crown for damaged teeth', 7000000.00),
       ('Single Dental Implant', 'Titanium implant with crown for one tooth', 27500000.00),
       ('All-on-4 Implants', 'Full-arch restoration with 4 implants per arch', 117600000.00),
       ('Orthodontic Consultation', 'Consultation for braces or aligners', 1800000.00),
       ('Traditional Braces', 'Metal braces for teeth alignment', 36000000.00),
       ('Invisalign', 'Clear aligners for discreet teeth alignment', 72000000.00);
GO

-- Appointments Sample with created_at, updated_at
INSERT INTO Appointments (patient_id, doctor_id, appointmenttype_id, appointment_date, time_slot, status, created_at,
                          updated_at)
VALUES
-- Doctor 1
(1, 1, 3, '2025-07-22', 'Morning', 'Completed', '2025-07-20', '2025-07-21'),
(2, 1, 5, '2025-07-23', 'Afternoon', 'Confirmed', '2025-07-21', '2025-07-23'),
(3, 1, 7, '2025-07-24', 'Morning', 'Confirmed', '2025-07-20', '2025-07-24'),
(4, 1, 1, '2025-07-25', 'Evening', 'Completed', '2025-07-21', '2025-07-25'),
(5, 1, 2, '2025-07-26', 'Afternoon', 'Confirmed', '2025-07-22', '2025-07-27'),
(6, 1, 4, '2025-07-27', 'Evening', 'Confirmed', '2025-07-22', '2025-07-28'),
(7, 1, 6, '2025-07-28', 'Morning', 'Completed', '2025-07-23', '2025-07-28'),
(8, 1, 8, '2025-07-29', 'Afternoon', 'Confirmed', '2025-07-23', '2025-07-30'),
(9, 1, 9, '2025-07-30', 'Evening', 'Confirmed', '2025-07-25', '2025-07-30'),
(10, 1, 10, '2025-07-31', 'Morning', 'Confirmed', '2025-07-26', '2025-08-01'),
(11, 1, 11, '2025-08-01', 'Afternoon', 'Completed', '2025-07-28', '2025-08-01'),
(12, 1, 12, '2025-08-02', 'Evening', 'Confirmed', '2025-07-29', '2025-08-02'),
(1, 1, 13, '2025-08-03', 'Morning', 'Confirmed', '2025-08-01', '2025-08-03'),
(2, 1, 14, '2025-08-04', 'Afternoon', 'Completed', '2025-08-01', '2025-08-04'),
(3, 1, 1, '2025-08-05', 'Evening', 'Confirmed', '2025-08-02', '2025-08-05'),

-- Doctor 2
(4, 2, 2, '2025-07-22', 'Afternoon', 'Confirmed', '2025-07-20', '2025-07-22'),
(5, 2, 3, '2025-07-23', 'Morning', 'Confirmed', '2025-07-21', '2025-07-23'),
(6, 2, 4, '2025-07-24', 'Evening', 'Completed', '2025-07-22', '2025-07-24'),
(7, 2, 5, '2025-07-25', 'Morning', 'Confirmed', '2025-07-22', '2025-07-25'),
(8, 2, 6, '2025-07-26', 'Evening', 'Completed', '2025-07-23', '2025-07-26'),
(9, 2, 7, '2025-07-27', 'Morning', 'Confirmed', '2025-07-24', '2025-07-27'),
(10, 2, 8, '2025-07-28', 'Afternoon', 'Completed', '2025-07-25', '2025-07-28'),
(11, 2, 9, '2025-07-29', 'Evening', 'Confirmed', '2025-07-26', '2025-07-29'),
(12, 2, 10, '2025-07-30', 'Morning', 'Confirmed', '2025-07-27', '2025-07-30'),
(1, 2, 11, '2025-07-31', 'Afternoon', 'Confirmed', '2025-07-28', '2025-08-01'),
(2, 2, 12, '2025-08-01', 'Evening', 'Completed', '2025-07-29', '2025-08-01'),
(3, 2, 13, '2025-08-02', 'Morning', 'Confirmed', '2025-07-30', '2025-08-02'),
(4, 2, 14, '2025-08-03', 'Afternoon', 'Confirmed', '2025-07-30', '2025-08-03'),
(5, 2, 1, '2025-08-04', 'Evening', 'Completed', '2025-08-01', '2025-08-04'),
(6, 2, 2, '2025-08-05', 'Morning', 'Confirmed', '2025-08-02', '2025-08-05'),

-- Doctor 3 (tháng 6)
(7, 3, 3, '2025-06-10', 'Morning', 'Confirmed', '2025-06-08', '2025-06-10'),
(8, 3, 4, '2025-06-12', 'Afternoon', 'Completed', '2025-06-09', '2025-06-12'),
(9, 3, 5, '2025-06-14', 'Evening', 'Confirmed', '2025-06-10', '2025-06-14'),
(10, 3, 6, '2025-06-16', 'Morning', 'Confirmed', '2025-06-11', '2025-06-16'),
(11, 3, 7, '2025-06-18', 'Afternoon', 'Completed', '2025-06-12', '2025-06-18'),
(12, 3, 8, '2025-06-20', 'Evening', 'Confirmed', '2025-06-13', '2025-06-20');

INSERT INTO Diagnoses (appointment_id, notes, created_at)
VALUES (1, 'Flu', '2025-01-05'),
       (2, 'Toothache', '2025-02-10'),
       (3, 'Back Pain', '2025-03-12'),
       (4, 'Myopia', '2025-04-03'),
       (5, 'Flu', '2025-05-09'),
       (6, 'Fracture', '2025-06-01'),
       (7, 'Headache', '2025-06-15'),
       (8, 'Flu', '2025-07-02'),
       (9, 'Toothache', '2025-07-05'),
       (10, 'Myopia', '2025-07-10'),
       (11, 'Flu', '2025-07-15'),
       (12, 'Back Pain', '2025-07-20');

-- Insert sample Category
INSERT INTO Category (category_name)
VALUES ('Khám bệnh'),
       ('Bệnh lý'),
       ('Chăm sóc sức khỏe'),
       ('Phòng ngừa bệnh');
GO

-- Insert sample Blog
INSERT INTO Blog (blog_name, blog_sub_content, content, blog_img, author, date, category_id)
VALUES (N'Khám bệnh định kỳ',
        N'Khám bệnh định kỳ giúp phát hiện sớm các bệnh lý nguy hiểm.',
        N'Khám bệnh định kỳ là một phần quan trọng trong việc duy trì sức khỏe. Việc kiểm tra sức khỏe hàng năm giúp phát hiện sớm các bệnh lý như tiểu đường, cao huyết áp, bệnh tim mạch, và ung thư...',
        N'kham-suc-khoe-dinh-ky-la-gi.jpg',
        N'TS.BS Lê Văn C',
        '2025-06-21 00:00:00.000',
        1),
       (N'Phòng ngừa bệnh tim mạch',
        N'Các phương pháp phòng ngừa bệnh tim mạch đơn giản và hiệu quả.',
        N'Bệnh tim mạch hiện nay đang ngày càng gia tăng. Để phòng ngừa bệnh này, chúng ta cần thực hiện chế độ ăn uống lành mạnh, tập thể dục thường xuyên và kiểm soát huyết áp...',
        N'phong-ngua-tim-mach.jpg',
        N'Nguyễn Thị A',
        '2025-06-22 00:00:00.000',
        4),
       (N'Chế độ ăn uống cho bệnh nhân tiểu đường',
        N'Chế độ ăn uống phù hợp giúp kiểm soát bệnh tiểu đường hiệu quả.',
        N'Đối với bệnh nhân tiểu đường, chế độ ăn uống rất quan trọng. Việc lựa chọn thực phẩm có chỉ số đường huyết thấp và kiêng các món ăn có nhiều đường là rất cần thiết...',
        N'che-do-dinh-duong-phu-hop.jpg',
        N'TS.BS Trần Thị B',
        '2025-06-23 00:00:00.000',
        2),
       (N'Điều trị ung thư',
        N'Tổng quan về phương pháp điều trị ung thư hiện đại.',
        N'Ung thư là một trong những bệnh lý nguy hiểm và có thể gây tử vong. Tuy nhiên, các phương pháp điều trị ung thư hiện nay ngày càng phát triển và mang lại nhiều hy vọng cho bệnh nhân...',
        N'20201013_tri-ung-thu-1.jpg',
        N'Lê Thị C',
        '2025-06-24 00:00:00.000',
        2),
       (N'Chăm sóc sức khỏe người cao tuổi',
        N'Những lời khuyên về chăm sóc sức khỏe cho người cao tuổi.',
        N'Chăm sóc sức khỏe cho người cao tuổi là một công việc cần thiết. Chế độ dinh dưỡng hợp lý, tập thể dục nhẹ nhàng và việc kiểm tra sức khỏe thường xuyên sẽ giúp người cao tuổi sống khỏe mạnh...',
        N'cham-soc-nguoi-gia.jpg',
        N'Nguyễn Minh D',
        '2025-06-25 00:00:00.000',
        3);
GO

-- Insert sample Comment
INSERT INTO Comment (blog_id, patient_id, content, date)
VALUES (1, 1, N'Bài viết rất hữu ích, tôi sẽ đi khám bệnh định kỳ ngay.', '2025-06-21 10:30:00.000'),
       (1, 2, N'Khám bệnh định kỳ thực sự rất quan trọng, tôi sẽ chủ động đi khám mỗi năm.', '2025-06-22 14:15:00.000'),
       (2, 3, N'Bài viết này giúp tôi hiểu hơn về cách phòng ngừa bệnh tim, cảm ơn bác sĩ.', '2025-06-23 09:00:00.000'),
       (2, 4, N'Tôi sẽ thay đổi chế độ ăn uống của mình để phòng ngừa bệnh tim mạch.', '2025-06-24 11:45:00.000'),
       (3, 2, N'Bài viết này rất dễ hiểu, tôi sẽ thay đổi chế độ ăn uống cho phù hợp với bệnh tiểu đường của mình.',
        '2025-06-25 16:25:00.000'),
       (3, 3, N'Cảm ơn bài viết, tôi sẽ tìm hiểu thêm về các thực phẩm phù hợp cho bệnh nhân tiểu đường.',
        '2025-06-26 17:30:00.000'),
       (4, 4, N'Điều trị ung thư ngày nay đã có nhiều tiến bộ, tôi rất hy vọng vào những phương pháp điều trị mới.',
        '2025-06-27 10:20:00.000'),
       (4, 1, N'Tôi rất muốn tìm hiểu thêm về các phương pháp điều trị ung thư hiện đại.', '2025-06-28 08:55:00.000'),
       (5, 1, N'Chăm sóc người cao tuổi rất quan trọng, tôi sẽ áp dụng các lời khuyên này cho ông bà của tôi.',
        '2025-06-29 12:10:00.000'),
       (5, 4, N'Bài viết rất bổ ích, tôi sẽ áp dụng chế độ dinh dưỡng cho người cao tuổi.', '2025-06-30 14:40:00.000');
GO

-- DoctorShifts from 22/07/2025 to 05/08/2025 (no Night slot)
INSERT INTO DoctorShifts (doctor_id, shift_date, time_slot, status)
VALUES
-- Doctor 1
(1, '2025-07-22', 'Morning', 'Working'),
(1, '2025-07-23', 'Afternoon', 'Working'),
(1, '2025-07-24', 'Morning', 'PendingLeave'),
(1, '2025-07-25', 'Evening', 'Working'),
(1, '2025-07-26', 'Morning', 'Leave'),
(1, '2025-07-27', 'Afternoon', 'Working'),
(1, '2025-07-28', 'Evening', 'Working'),
(1, '2025-07-29', 'Morning', 'Rejected'),
(1, '2025-07-30', 'Afternoon', 'Working'),
(1, '2025-07-31', 'Morning', 'Working'),
(1, '2025-08-01', 'Afternoon', 'Working'),
(1, '2025-08-02', 'Evening', 'Working'),
(1, '2025-08-03', 'Morning', 'Working'),
(1, '2025-08-04', 'Afternoon', 'Working'),
(1, '2025-08-05', 'Morning', 'PendingLeave'),

-- Doctor 2
(2, '2025-07-22', 'Afternoon', 'Working'),
(2, '2025-07-23', 'Morning', 'Working'),
(2, '2025-07-24', 'Evening', 'Leave'),
(2, '2025-07-25', 'Morning', 'Working'),
(2, '2025-07-26', 'Afternoon', 'PendingLeave'),
(2, '2025-07-27', 'Morning', 'Working'),
(2, '2025-07-28', 'Evening', 'Working'),
(2, '2025-07-29', 'Afternoon', 'Working'),
(2, '2025-07-30', 'Morning', 'Working'),
(2, '2025-07-31', 'Evening', 'Working'),
(2, '2025-08-01', 'Morning', 'Rejected'),
(2, '2025-08-02', 'Afternoon', 'Working'),
(2, '2025-08-03', 'Morning', 'Working'),
(2, '2025-08-04', 'Evening', 'Working'),
(2, '2025-08-05', 'Afternoon', 'Working'),

-- Doctor 3
(3, '2025-07-22', 'Evening', 'Working'),
(3, '2025-07-23', 'Morning', 'PendingLeave'),
(3, '2025-07-24', 'Afternoon', 'Working'),
(3, '2025-07-25', 'Morning', 'Working'),
(3, '2025-07-26', 'Evening', 'Rejected'),
(3, '2025-07-27', 'Morning', 'Leave'),
(3, '2025-07-28', 'Afternoon', 'Working'),
(3, '2025-07-29', 'Evening', 'Working'),
(3, '2025-07-30', 'Morning', 'Working'),
(3, '2025-07-31', 'Afternoon', 'Working'),
(3, '2025-08-01', 'Evening', 'Working'),
(3, '2025-08-02', 'Morning', 'Working'),
(3, '2025-08-03', 'Afternoon', 'Working'),
(3, '2025-08-04', 'Morning', 'PendingLeave'),
(3, '2025-08-05', 'Afternoon', 'Working');

-- Insert sample PageContent for pactHome (services.jsp)
INSERT INTO PageContent (page_name, content_key, content_value, is_active, image_url, video_url, button_url,
                         button_text)
VALUES ('index', 'site_title', 'Dental Care | benhVienLmao', 1, NULL, NULL, NULL, NULL),
       ('index', 'preloader_image', '', 1, 'assets/img/logo/loder.png', NULL, NULL, NULL),
       ('index', 'header_logo', '', 1, 'assets/img/logo/logo.png', NULL, NULL, NULL),
       ('index', 'header_login_button', 'Login', 1, NULL, NULL, 'login.jsp', 'Login'),
       ('index', 'header_register_button', 'Register', 1, NULL, NULL, 'register.jsp', 'Register'),
       ('index', 'slider1_caption', 'Smile with Confidence', 1, 'assets/img/slider1.jpg',
        'https://www.youtube.com/watch?v=up68UAfH0d0', 'book-appointment', 'Explore Dental Services'),
       ('index', 'slider1_subcaption', 'Transform your smile with our expert dental care services', 1,
        'assets/img/slider1.jpg', 'https://www.youtube.com/watch?v=up68UAfH0d0', 'book-appointment',
        'Explore Dental Services'),
       ('index', 'slider2_caption', 'Healthy Teeth, Happy Life', 1, 'assets/img/slider2.jpg',
        'https://www.youtube.com/watch?v=up68UAfH0d0', 'book-appointment', 'Book an Appointment'),
       ('index', 'slider2_subcaption', 'Comprehensive dental solutions for all ages', 1, 'assets/img/slider2.jpg',
        'https://www.youtube.com/watch?v=up68UAfH0d0', 'book-appointment', 'Book an Appointment'),
       ('index', 'daily_dental_updates_title', 'Daily Dental Updates', 1, NULL, NULL, NULL, NULL),
       ('index', 'daily_dental_updates_subtitle', 'Stay informed with the latest tips and news for a healthy smile', 1,
        NULL, NULL, NULL, NULL),
       ('index', 'perfect_smile_title', 'Perfect Smile, Made Simple', 1, NULL, NULL, NULL, NULL),
       ('index', 'perfect_smile_subtitle', 'Experience top-notch dental care tailored to your needs', 1, NULL, NULL,
        NULL, NULL),
       ('index', 'perfect_smile_description',
        'Our team of skilled dentists uses the latest technology to ensure your dental health and comfort. From routine check-ups to advanced treatments, we’ve got you covered.',
        1, NULL, NULL, NULL, NULL),
       ('index', 'about_image', '', 1, 'assets/img/gallery/about.png', NULL, NULL, NULL),
       ('index', 'about_icon1', '', 1, 'assets/img/icon/about1.svg', NULL, NULL, NULL),
       ('index', 'about_icon2', '', 1, 'assets/img/icon/about2.svg', NULL, NULL, NULL),
       ('index', 'want_to_work_title', 'Bright Smile Healthy Teeth', 1, NULL, NULL, NULL, NULL),
       ('index', 'want_to_work_subtitle', 'Discover personalized dental care that makes you smile', 1, NULL, NULL, NULL,
        NULL),
       ('index', 'want_to_work_button', 'Explore Services', 1, NULL, NULL, 'appointment/list', 'Explore Services'),
       ('index', 'service_description_6', 'Explore our Teeth Whitening services for a healthier smile.', 1, NULL, NULL,
        NULL, NULL),
       ('index', 'service_description_7', 'Explore our Dental Checkup services for a healthier smile.', 1, NULL, NULL,
        NULL, NULL),
       ('index', 'service_description_8', 'Explore our Tooth Extraction services for a healthier smile.', 1, NULL, NULL,
        NULL, NULL),
       ('index', 'video_section', '', 1, NULL, 'https://www.youtube.com/watch?v=up68UAfH0d0', NULL, NULL),
       ('index', 'about_law_title', '100% Satisfaction Guaranteed', 1, NULL, NULL, NULL, NULL),
       ('index', 'about_law_subtitle', 'Your perfect smile is our priority', 1, NULL, NULL, NULL, NULL),
       ('index', 'about_law_button', 'Book a Dental Appointment', 1, NULL, NULL, 'book-appointment',
        'Book a Dental Appointment'),
       ('index', 'about_law_image', '', 1, 'assets/img/gallery/about2.png', NULL, NULL, NULL),
       ('index', 'footer_logo', '', 1, 'assets/img/logo/logo2_footer.png', NULL, NULL, NULL),
       ('index', 'footer_social_twitter', '', 1, NULL, NULL, '#', 'Twitter'),
       ('index', 'footer_social_facebook', '', 1, NULL, NULL, 'https://bit.ly/sai4ull', 'Facebook'),
       ('index', 'footer_social_pinterest', '', 1, NULL, NULL, '#', 'Pinterest'),
       ('index', 'footer_newsletter_title', 'Subscribe to Our Newsletter', 1, NULL, NULL, NULL, NULL),
       ('index', 'footer_newsletter_form', 'Email Address', 1, NULL, NULL,
        'https://spondonit.us12.list-manage.com/subscribe/post?u=1462626880ade1ac87bd9c93a&id=92a4423d01', NULL),
       ('index', 'footer_newsletter_button', 'Subscribe', 1, NULL, NULL, NULL, 'Subscribe'),
       ('index', 'footer_newsletter_subtitle', 'Stay updated with the latest dental care tips and promotions.', 1, NULL,
        NULL, NULL, NULL),
       ('index', 'footer_copyright',
        'Copyright &copy; All rights reserved | This template is made with <i class="fa fa-heart" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>',
        1, NULL, NULL, NULL, NULL),
       ('index', 'scroll_up_button', 'Go to Top', 1, NULL, NULL, '#', NULL),
       ('pactHome', 'site_title', 'Health | Template', 1, NULL, NULL, NULL, NULL),
       ('pactHome', 'favicon', '', 1, 'assets/img/favicon.ico', NULL, NULL, NULL),
       ('pactHome', 'preloader_image', '', 1, 'assets/img/logo/loder.png', NULL, NULL, NULL),
       ('pactHome', 'header_logo', '', 1, 'assets/img/logo/logo.png', NULL, '/pactHome', NULL),
       ('pactHome', 'slider_caption', 'Hello ${patient.firstName}', 1, NULL, NULL, NULL, NULL),
       ('pactHome', 'slider_subcaption', 'Register for a health check-up to receive exclusive offers', 1, NULL, NULL,
        NULL, NULL),
       ('pactHome', 'want_to_work_title', 'Happy mind <br>Healthy life', 1, NULL, NULL, NULL, NULL),
       ('pactHome', 'want_to_work_subtitle',
        'Are you experiencing any of the following issues?<br> Register early to receive offers', 1, NULL, NULL, NULL,
        NULL),
       ('pactHome', 'want_to_work_button', 'Use Services', 1, NULL, NULL, 'appointment/list', 'Use Services'),
       ('pactHome', 'service_icon_7', '', 1, 'assets/img/icon/services1.svg', NULL, NULL, NULL), -- Teeth Whitening
       ('pactHome', 'service_title_7', 'Comprehensive General Checkup', 1, NULL, NULL,
        'book-appointment?type=General Checkup', 'Comprehensive General Checkup'),
       ('pactHome', 'service_description_7',
        'Feeling off or overdue for a health screening? Our thorough checkup assesses your overall wellness to catch issues early.',
        1, NULL, NULL, NULL, NULL),
       ('pactHome', 'service_button_7', '', 1, NULL, NULL, 'book-appointment?type=General Checkup', NULL),
       ('pactHome', 'service_icon_8', '', 1, 'assets/img/icon/services2.svg', NULL, NULL, NULL), -- Dental Checkup
       ('pactHome', 'service_title_8', 'Mental Health Support', 1, NULL, NULL,
        'book-appointment?type=Mental Health Consultation', 'Mental Health Support'),
       ('pactHome', 'service_description_8',
        'Struggling with stress, anxiety, or low mood? Book a consultation with our compassionate mental health specialists.',
        1, NULL, NULL, NULL, NULL),
       ('pactHome', 'service_button_8', '', 1, NULL, NULL, 'book-appointment?type=Mental Health Consultation', NULL),
       ('pactHome', 'service_icon_9', '', 1, 'assets/img/icon/services3.svg', NULL, NULL, NULL), -- Tooth Extraction
       ('pactHome', 'service_title_9', 'Routine Health Monitoring', 1, NULL, NULL,
        'book-appointment?type=Periodic Health Checkup', 'Routine Health Monitoring'),
       ('pactHome', 'service_description_9',
        'Stay proactive about your health. Schedule a periodic checkup to monitor your well-being and secure peace of mind.',
        1, NULL, NULL, NULL, NULL),
       ('pactHome', 'service_button_9', '', 1, NULL, NULL, 'book-appointment?type=Periodic Health Checkup', NULL),
       ('pactHome', 'video_background', '', 1, 'assets/img/gallery/video-bg.png', NULL, NULL, NULL),
       ('pactHome', 'video_url', '', 1, NULL, 'https://www.youtube.com/watch?v=up68UAfH0d0', NULL, NULL),
       ('pactHome', 'testimonial1_quote',
        'I am very satisfied with the hospital''s entire process, thorough and professional.', 1, NULL, NULL, NULL,
        NULL),
       ('pactHome', 'testimonial1_author', 'Nguyen Thi Mai', 1, NULL, NULL, NULL, NULL),
       ('pactHome', 'testimonial1_role', 'Homemaker', 1, NULL, NULL, NULL, NULL),
       ('pactHome', 'testimonial1_image', '', 1, 'assets/img/icon/quotes-sign.png', NULL, NULL, NULL),
       ('pactHome', 'testimonial1_author_image', '', 1, 'assets/img/icon/testimonial.png', NULL, NULL, NULL),
       ('pactHome', 'testimonial2_quote',
        'I detected my illness early and received timely treatment, thanks to the team of expert doctors.', 1, NULL,
        NULL, NULL, NULL),
       ('pactHome', 'testimonial2_author', 'Le Minh Quan', 1, NULL, NULL, NULL, NULL),
       ('pactHome', 'testimonial2_role', 'IT Professional', 1, NULL, NULL, NULL, NULL),
       ('pactHome', 'testimonial2_image', '', 1, 'assets/img/icon/quotes-sign.png', NULL, NULL, NULL),
       ('pactHome', 'testimonial2_author_image', '', 1, 'assets/img/icon/testimonial.png', NULL, NULL, NULL),
       ('pactHome', 'about_law_title', '100% Satisfaction Guaranteed.', 1, NULL, NULL, NULL, NULL),
       ('pactHome', 'about_law_description',
        'Over 1,000 customers visit daily and are seen immediately because they booked early', 1, NULL, NULL, NULL,
        NULL),
       ('pactHome', 'about_law_button', 'Book Appointment', 1, NULL, NULL, 'book-appointment', 'Book Appointment'),
       ('pactHome', 'about_law_image', '', 1, 'assets/img/gallery/about2.png', NULL, NULL, NULL),
       ('pactHome', 'footer_logo', '', 1, 'assets/img/logo/logo2_footer.png', NULL, NULL, NULL),
       ('pactHome', 'footer_menu_home', 'Home', 1, NULL, NULL, '/pactHome', 'Home'),
       ('pactHome', 'footer_menu_about', 'About', 1, NULL, NULL, '/about', 'About'),
       ('pactHome', 'footer_menu_services', 'Services', 1, NULL, NULL, '/services', 'Services'),
       ('pactHome', 'footer_menu_blog', 'Blog', 1, NULL, NULL, '/blog', 'Blog'),
       ('pactHome', 'footer_menu_contact', 'Contact', 1, NULL, NULL, '/contact', 'Contact'),
       ('pactHome', 'footer_social_twitter', '', 1, NULL, NULL, '#', 'Twitter'),
       ('pactHome', 'footer_social_facebook', '', 1, NULL, NULL, 'https://bit.ly/sai4ull', 'Facebook'),
       ('pactHome', 'footer_social_pinterest', '', 1, NULL, NULL, '#', 'Pinterest'),
       ('pactHome', 'footer_copyright', 'Group 3 - SE1903 - SWP391 Summer2025', 1, NULL, NULL, NULL, NULL),
       ('pactHome', 'scroll_up_title', 'Go to Top', 1, NULL, NULL, '#', NULL);
GO


INSERT INTO ChangeHistory (manager_id, manager_name, target_user_id, target_user_name, target_source, action,
                           change_time)
VALUES
-- Hành động cập nhật quyền
(101, 'Nguyen Van A', 201, 'Le Thi B', 'employee', 'Update Role', GETDATE()),

-- Hành động xoá tài khoản
(102, 'Tran Thi C', 202, 'Pham Van D', 'patient', 'Delete User', DATEADD(DAY, -1, GETDATE())),

-- Hành động khôi phục tài khoản
(103, 'Hoang Van E', 203, 'Nguyen Van F', 'employee', 'Reactivate User', DATEADD(DAY, -2, GETDATE())),

-- Hành động tạm khoá tài khoản
(104, 'Le Thi G', 204, 'Tran Thi H', 'patient', 'Deactivate User', DATEADD(HOUR, -5, GETDATE())),

-- Hành động phân quyền admin
(105, 'Pham Van I', 205, 'Hoang Van K', 'employee', 'Promote to Admin', DATEADD(DAY, -10, GETDATE()));

INSERT INTO Payments (appointment_id, amount, method, status, pay_content, created_at, paid_at)
VALUES
-- Doctor 1
(1, 100000, 'Cash', 'Paid', 'General Checkup', '2025-07-21', '2025-07-22'),
(2, 150000, 'Card', 'Paid', 'Dental Cleaning', '2025-07-22', '2025-07-23'),
(3, 200000, 'Cash', 'Paid', 'Specialist Consultation', '2025-07-23', '2025-07-24'),
(4, 250000, 'Momo', 'Paid', 'Eye Exam', '2025-07-24', '2025-07-25'),
(5, 180000, 'Card', 'Paid', 'General Checkup', '2025-07-25', '2025-07-26'),
(6, 500000, 'Cash', 'Paid', 'Emergency Visit', '2025-07-26', '2025-07-27'),
(7, 160000, 'Card', 'Paid', 'ENT Checkup', '2025-07-27', '2025-07-28'),
(8, 190000, 'Momo', 'Paid', 'X-Ray Service', '2025-07-28', '2025-07-29'),
(9, 220000, 'Cash', 'Paid', 'Cardiology', '2025-07-29', '2025-07-30'),
(10, 300000, 'Card', 'Paid', 'General Checkup', '2025-07-30', '2025-07-31'),
(11, 350000, 'Cash', 'Paid', 'Ultrasound', '2025-07-31', '2025-08-01'),
(12, 280000, 'Card', 'Paid', 'Specialist Consultation', '2025-08-01', '2025-08-02'),
(13, 260000, 'Momo', 'Paid', 'Eye Exam', '2025-08-02', '2025-08-03'),
(14, 170000, 'Cash', 'Paid', 'ENT Checkup', '2025-08-03', '2025-08-04'),
(15, 230000, 'Card', 'Paid', 'General Checkup', '2025-08-04', '2025-08-05'),

-- Doctor 2
(16, 210000, 'Cash', 'Paid', 'Cardiology', '2025-07-21', '2025-07-22'),
(17, 150000, 'Card', 'Paid', 'General Checkup', '2025-07-22', '2025-07-23'),
(18, 180000, 'Cash', 'Paid', 'Dental Cleaning', '2025-07-23', '2025-07-24'),
(19, 250000, 'Momo', 'Paid', 'Eye Exam', '2025-07-24', '2025-07-25'),
(20, 300000, 'Cash', 'Paid', 'Emergency Visit', '2025-07-25', '2025-07-26'),
(21, 400000, 'Card', 'Paid', 'Specialist Consultation', '2025-07-26', '2025-07-27'),
(22, 220000, 'Cash', 'Paid', 'Ultrasound', '2025-07-27', '2025-07-28'),
(23, 180000, 'Card', 'Paid', 'ENT Checkup', '2025-07-28', '2025-07-29'),
(24, 270000, 'Momo', 'Paid', 'X-Ray Service', '2025-07-29', '2025-07-30'),
(25, 290000, 'Cash', 'Paid', 'Cardiology', '2025-07-30', '2025-07-31'),
(26, 310000, 'Card', 'Paid', 'General Checkup', '2025-07-31', '2025-08-01'),
(27, 330000, 'Cash', 'Paid', 'Specialist Consultation', '2025-08-01', '2025-08-02'),
(28, 200000, 'Card', 'Paid', 'Eye Exam', '2025-08-02', '2025-08-03'),
(29, 170000, 'Momo', 'Paid', 'ENT Checkup', '2025-08-03', '2025-08-04'),
(30, 240000, 'Cash', 'Paid', 'General Checkup', '2025-08-04', '2025-08-05');



