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
    item_type     VARCHAR(50) NOT NULL CHECK (item_type IN ('Feature', 'Navigation'))
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
    emergency_contact NVARCHAR(255)
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
    payment_id           INT PRIMARY KEY IDENTITY (1,1),
    appointment_id       INT,                               -- Có thể NULL nếu payment chưa liên kết với appointment
    amount               DECIMAL(18, 2) NOT NULL,           -- Sử dụng DECIMAL cho tiền tệ
    method               NVARCHAR(50),                      -- Phương thức thanh toán (e.g., "QR_CODE")
    status               NVARCHAR(50) NOT NULL,             -- Trạng thái thanh toán (e.g., "PENDING", "PAID")
    pay_content          NVARCHAR(MAX),                     -- Nội dung thanh toán/mô tả
    payos_transaction_id VARCHAR(255) UNIQUE,               -- ID giao dịch từ PayOS (để update)
    payos_order_code     VARCHAR(255) UNIQUE,               -- Order code từ PayOS (có thể là mã đặt lịch)
    payos_signature      NVARCHAR(MAX),                     -- Chữ ký từ PayOS
    raw_response_json    NVARCHAR(MAX),                     -- Lưu trữ toàn bộ JSON response gốc
    created_at           DATETIME2 DEFAULT GETDATE(),       -- Thời gian tạo giao dịch
    paid_at              DATETIME2,                         -- Thời gian thanh toán thành công

    -- Khóa ngoại tới Appointments (nếu appointment_id có thể NULL, cần kiểm tra lại logic nghiệp vụ)
    FOREIGN KEY (appointment_id) REFERENCES Appointments (appointment_id)
);
GO
-- Có thể cần thêm index cho các cột tìm kiếm để cải thiện hiệu suất
CREATE INDEX IX_Payments_AppointmentId ON Payments (appointment_id);
CREATE INDEX IX_Payments_Status ON Payments (status);
CREATE INDEX IX_Payments_CreatedAt ON Payments (created_at);

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
CREATE TABLE PageContent (
    content_id INT PRIMARY KEY IDENTITY(1,1),
    page_name VARCHAR(50) NOT NULL,
    content_key VARCHAR(100) NOT NULL,
    content_value NVARCHAR(MAX) NOT NULL,
    is_active BIT DEFAULT 1,
    image_url NVARCHAR(255) NULL,
    video_url NVARCHAR(255) NULL,
    button_url NVARCHAR(255) NULL,
    button_text NVARCHAR(255) NULL,
    UNIQUE (page_name, content_key)
);
GO

-- Insert sample Roles
INSERT INTO Roles (role_name)
VALUES ('Doctor'),
       ('Receptionist'),
       ('Admin'),
       ('Manager'),
       ('Patient'),
	   ('Guest');
GO

-- Insert sample SystemItems
INSERT INTO SystemItems (item_name, item_url, display_order, item_type)
VALUES
    ('Book Appointment', 'book-appointment', NULL, 'Feature'),
    ('View Prescription', 'view-prescription', NULL, 'Feature'),
    ('Manage Employees', 'admin/manageEmployees', NULL, 'Feature'),
    ('Manage Patients', 'admin/managePatients', NULL, 'Feature'),
    ('View Statistics', 'admin/statistics', NULL, 'Feature'),
    ('Approve Doctor Shifts', 'admin/shift-approval', NULL, 'Feature'),
    ('Teeth Whitening', 'book-appointment?appointmentTypeId=3', 1, 'Feature'),
    ('Dental Checkup', 'book-appointment?appointmentTypeId=1', 2, 'Feature'),
    ('Tooth Extraction', 'book-appointment?appointmentTypeId=6', 3, 'Feature'),
    ('Home', 'index', 1, 'Navigation'),
    ('About', 'about.html', 2, 'Navigation'),
    ('Dental Services', 'services.html', 3, 'Navigation'),
    ('Blog', 'blog', 4, 'Navigation'),
    ('Blog Details', 'blog-detail.jsp', 5, 'Navigation'),
    ('Contact', 'contact.html', 6, 'Navigation'),
    ('Manage System Items', 'admin/system-items', NULL, 'Feature'),
    ('Manage System Contents', 'admin/contents', NULL, 'Feature'),
    ('Admin Home', 'admin/home', NULL, 'Navigation'),
    ('Add New Content', 'admin/content/add', NULL, 'Navigation'),
    -- Patient-specific navigation items
    ('Appointments', 'appointments', 1, 'Navigation'),
    ('Treatment History', 'treatment/history', 2, 'Navigation'),
    ('Services', 'appointment/list', 3, 'Navigation'),
    ('Account', '', 4, 'Navigation'),
    ('Logout', 'logout', 5, 'Navigation'),
    ('My Profile', 'MyProfile', 99, 'Navigation'),
    ('Change Password', 'change-password', 7, 'Navigation'),
    ('Book Appointment', 'book-appointment', 8, 'Navigation'),
	('Search for service','appointment/list', 4, 'Navigation'),
	('Manage Payment', 'https://my.payos.vn/', 6, 'Feature');
GO

-- Insert sample RoleSystemItems
INSERT INTO RoleSystemItems (role_id, item_id)
VALUES 
    (1, 1),  -- Doctor: Book Appointment
    (1, 2),  -- Doctor: View Prescription
    (1, 7),  -- Doctor: Teeth Whitening
    (1, 8),  -- Doctor: Dental Checkup
    (1, 9),  -- Doctor: Tooth Extraction
    (3, 3),  -- Admin: Manage Employees
    (3, 4),  -- Admin: Manage Patients
    (3, 5),  -- Admin: View Statistics
    (3, 6),  -- Admin: Approve Doctor Shifts
    (3, 16), -- Admin: Manage System Items
    (3, 17), -- Admin: Manage System Contents
    (3, 18), -- Admin: Admin Home
    (3, 19), -- Admin: Add New Content
    (4, 6),  -- Manager: Approve Doctor Shifts
	(3, 29), -- Admin: Manage payment history
	(4, 29), -- Manager: Manage payment history
    -- Patient-specific mappings (role_id = 5 for Patient)
    (5, 13), -- Patient: Blog
    (5, 20), -- Patient: Appointments
    (5, 21), -- Patient: Treatment History
    (5, 22), -- Patient: Services
    (5, 24), -- Patient: Logout
    (5, 25), -- Patient: My Profile
    (5, 26), -- Patient: Change Password
    (5, 27), -- Patient: Book Appointment
	(5, 28),
    (5, 23), -- Patient: Account
	--Guest mapping (role_id = 0 for not login)
	(6, 13),
	(6, 22),
	(6, 27),
	(6, 28);
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

-- Insert sample Appointments
INSERT INTO Appointments (patient_id, doctor_id, appointmenttype_id, appointment_date, time_slot, status)
VALUES
    -- Doctor 1 - 2025-06-23 Morning
    (1, 1, 1, '2025-06-23', 'Morning', 'Confirmed'),
    (2, 1, 1, '2025-06-23', 'Morning', 'Confirmed'),
    -- Doctor 1 - 2025-06-23 Afternoon
    (3, 1, 1, '2025-06-23', 'Afternoon', 'Confirmed'),
    -- Doctor 1 - 2025-06-24 Afternoon
    (4, 1, 1, '2025-06-24', 'Afternoon', 'Confirmed'),
    -- Doctor 1 - 2025-06-25 Evening
    (5, 1, 1, '2025-06-25', 'Evening', 'Confirmed'),
    -- Doctor 1 - 2025-06-27 Morning
    (6, 1, 1, '2025-06-27', 'Morning', 'Confirmed'),
    -- Doctor 2 - 2025-06-23 Afternoon
    (7, 2, 1, '2025-06-23', 'Afternoon', 'Confirmed'),
    -- Doctor 2 - 2025-06-24 Morning
    (8, 2, 1, '2025-06-24', 'Morning', 'Confirmed'),
    -- Doctor 2 - 2025-06-25 Morning
    (9, 2, 1, '2025-06-25', 'Morning', 'Confirmed'),
    -- Doctor 2 - 2025-06-28 Morning
    (10, 2, 1, '2025-06-28', 'Morning', 'Confirmed'),
    -- Doctor 2 - 2025-06-29 Morning
    (11, 2, 1, '2025-06-29', 'Morning', 'Confirmed'),
    -- Doctor 1: Completed appointments
    (1, 1, 1, '2025-06-10', 'Morning', 'Completed'),
    (2, 1, 2, '2025-06-11', 'Afternoon', 'Completed'),
    (3, 1, 3, '2025-06-12', 'Evening', 'Completed'),
    -- Additional completed appointments for patient 1
    (1, 1, 2, '2025-06-15', 'Morning', 'Completed'),
    (1, 2, 1, '2025-06-17', 'Afternoon', 'Completed'),
    (1, 2, 3, '2025-06-20', 'Evening', 'Completed');
GO

-- Insert sample Diagnoses
INSERT INTO Diagnoses (appointment_id, notes)
VALUES (12, N'General check-up. Patient is healthy. No issues detected.'),
       (13, N'Tartar removal. Slight plaque buildup found.'),
       (14, N'Teeth whitening with laser. Teeth slightly sensitive after treatment.');
GO

-- Insert sample Prescriptions
INSERT INTO Prescriptions (appointment_id, medication_details)
VALUES (12, N'No medication needed.'),
       (13, N'Antiseptic mouthwash, use twice a day.'),
       (14, N'Paracetamol 500mg if needed for pain, do not exceed 3 tablets per day.');
GO

-- Insert sample Treatment
INSERT INTO Treatment (appointment_id, treatment_type, treatment_notes)
VALUES (12, N'General Check-up', N'No treatment required. Periodic monitoring only.'),
       (13, N'Teeth Cleaning', N'Tartar removed and teeth polished.'),
       (14, N'Teeth Whitening', N'Laser technology used at the clinic.');
GO

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
       (3, 2, N'Bài viết này rất dễ hiểu, tôi sẽ thay đổi chế độ ăn uống cho phù hợp với bệnh tiểu đường của mình.', '2025-06-25 16:25:00.000'),
       (3, 3, N'Cảm ơn bài viết, tôi sẽ tìm hiểu thêm về các thực phẩm phù hợp cho bệnh nhân tiểu đường.', '2025-06-26 17:30:00.000'),
       (4, 4, N'Điều trị ung thư ngày nay đã có nhiều tiến bộ, tôi rất hy vọng vào những phương pháp điều trị mới.', '2025-06-27 10:20:00.000'),
       (4, 1, N'Tôi rất muốn tìm hiểu thêm về các phương pháp điều trị ung thư hiện đại.', '2025-06-28 08:55:00.000'),
       (5, 1, N'Chăm sóc người cao tuổi rất quan trọng, tôi sẽ áp dụng các lời khuyên này cho ông bà của tôi.', '2025-06-29 12:10:00.000'),
       (5, 4, N'Bài viết rất bổ ích, tôi sẽ áp dụng chế độ dinh dưỡng cho người cao tuổi.', '2025-06-30 14:40:00.000');
GO

-- Insert sample DoctorShifts
INSERT INTO DoctorShifts (doctor_id, shift_date, time_slot, status)
VALUES
    -- Doctor 1
    (1, '2025-07-03', 'Morning', 'Working'),
    (1, '2025-07-03', 'Afternoon', 'Working'),
    (1, '2025-07-04', 'Morning', 'PendingLeave'),
    (1, '2025-07-04', 'Afternoon', 'Working'),
    (1, '2025-07-05', 'Morning', 'Leave'),
    (1, '2025-07-05', 'Evening', 'Working'),
    (1, '2025-07-06', 'Night', 'Rejected'),
    (1, '2025-07-07', 'Morning', 'Working'),
    (1, '2025-07-08', 'Morning', 'Working'),
    (1, '2025-07-09', 'Evening', 'Working'),
    -- Doctor 2
    (2, '2025-07-03', 'Afternoon', 'Working'),
    (2, '2025-07-04', 'Morning', 'Working'),
    (2, '2025-07-05', 'Morning', 'Working'),
    (2, '2025-07-06', 'Afternoon', 'PendingLeave'),
    (2, '2025-07-06', 'Evening', 'Leave'),
    (2, '2025-07-07', 'Night', 'Rejected'),
    (2, '2025-07-08', 'Morning', 'Working'),
    (2, '2025-07-09', 'Morning', 'Working');
GO

-- Insert sample PageContent for pactHome (services.jsp)
INSERT INTO PageContent (page_name, content_key, content_value, is_active, image_url, video_url, button_url, button_text)
VALUES 
	('index', 'site_title', 'Dental Care | benhVienLmao', 1, NULL, NULL, NULL, NULL),
    ('index', 'preloader_image', '', 1, 'assets/img/logo/loder.png', NULL, NULL, NULL),
    ('index', 'header_logo', '', 1, 'assets/img/logo/logo.png', NULL, NULL, NULL),
    ('index', 'header_login_button', 'Login', 1, NULL, NULL, 'login.jsp', 'Login'),
    ('index', 'header_register_button', 'Register', 1, NULL, NULL, 'register.jsp', 'Register'),
    ('index', 'slider1_caption', 'Smile with Confidence', 1, 'assets/img/slider1.jpg', 'https://www.youtube.com/watch?v=up68UAfH0d0', 'book-appointment', 'Explore Dental Services'),
    ('index', 'slider1_subcaption', 'Transform your smile with our expert dental care services', 1, 'assets/img/slider1.jpg', 'https://www.youtube.com/watch?v=up68UAfH0d0', 'book-appointment', 'Explore Dental Services'),
    ('index', 'slider2_caption', 'Healthy Teeth, Happy Life', 1, 'assets/img/slider2.jpg', 'https://www.youtube.com/watch?v=up68UAfH0d0', 'book-appointment', 'Book an Appointment'),
    ('index', 'slider2_subcaption', 'Comprehensive dental solutions for all ages', 1, 'assets/img/slider2.jpg', 'https://www.youtube.com/watch?v=up68UAfH0d0', 'book-appointment', 'Book an Appointment'),
    ('index', 'daily_dental_updates_title', 'Daily Dental Updates', 1, NULL, NULL, NULL, NULL),
    ('index', 'daily_dental_updates_subtitle', 'Stay informed with the latest tips and news for a healthy smile', 1, NULL, NULL, NULL, NULL),
    ('index', 'perfect_smile_title', 'Perfect Smile, Made Simple', 1, NULL, NULL, NULL, NULL),
    ('index', 'perfect_smile_subtitle', 'Experience top-notch dental care tailored to your needs', 1, NULL, NULL, NULL, NULL),
    ('index', 'perfect_smile_description', 'Our team of skilled dentists uses the latest technology to ensure your dental health and comfort. From routine check-ups to advanced treatments, we’ve got you covered.', 1, NULL, NULL, NULL, NULL),
    ('index', 'about_image', '', 1, 'assets/img/gallery/about.png', NULL, NULL, NULL),
    ('index', 'about_icon1', '', 1, 'assets/img/icon/about1.svg', NULL, NULL, NULL),
    ('index', 'about_icon2', '', 1, 'assets/img/icon/about2.svg', NULL, NULL, NULL),
    ('index', 'want_to_work_title', 'Bright Smile Healthy Teeth', 1, NULL, NULL, NULL, NULL),
    ('index', 'want_to_work_subtitle', 'Discover personalized dental care that makes you smile', 1, NULL, NULL, NULL, NULL),
    ('index', 'want_to_work_button', 'Explore Services', 1, NULL, NULL, 'appointment/list', 'Explore Services'),
    ('index', 'service_description_6', 'Explore our Teeth Whitening services for a healthier smile.', 1, NULL, NULL, NULL, NULL),
    ('index', 'service_description_7', 'Explore our Dental Checkup services for a healthier smile.', 1, NULL, NULL, NULL, NULL),
    ('index', 'service_description_8', 'Explore our Tooth Extraction services for a healthier smile.', 1, NULL, NULL, NULL, NULL),
    ('index', 'video_section', '', 1, NULL, 'https://www.youtube.com/watch?v=up68UAfH0d0', NULL, NULL),
    ('index', 'about_law_title', '100% Satisfaction Guaranteed', 1, NULL, NULL, NULL, NULL),
    ('index', 'about_law_subtitle', 'Your perfect smile is our priority', 1, NULL, NULL, NULL, NULL),
    ('index', 'about_law_button', 'Book a Dental Appointment', 1, NULL, NULL, 'book-appointment', 'Book a Dental Appointment'),
    ('index', 'about_law_image', '', 1, 'assets/img/gallery/about2.png', NULL, NULL, NULL),
    ('index', 'footer_logo', '', 1, 'assets/img/logo/logo2_footer.png', NULL, NULL, NULL),
    ('index', 'footer_social_twitter', '', 1, NULL, NULL, '#', 'Twitter'),
    ('index', 'footer_social_facebook', '', 1, NULL, NULL, 'https://bit.ly/sai4ull', 'Facebook'),
    ('index', 'footer_social_pinterest', '', 1, NULL, NULL, '#', 'Pinterest'),
    ('index', 'footer_newsletter_title', 'Subscribe to Our Newsletter', 1, NULL, NULL, NULL, NULL),
    ('index', 'footer_newsletter_form', 'Email Address', 1, NULL, NULL, 'https://spondonit.us12.list-manage.com/subscribe/post?u=1462626880ade1ac87bd9c93a&id=92a4423d01', NULL),
    ('index', 'footer_newsletter_button', 'Subscribe', 1, NULL, NULL, NULL, 'Subscribe'),
    ('index', 'footer_newsletter_subtitle', 'Stay updated with the latest dental care tips and promotions.', 1, NULL, NULL, NULL, NULL),
    ('index', 'footer_copyright', 'Copyright &copy; All rights reserved | This template is made with <i class="fa fa-heart" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>', 1, NULL, NULL, NULL, NULL),
    ('index', 'scroll_up_button', 'Go to Top', 1, NULL, NULL, '#', NULL),
    ('pactHome', 'site_title', 'Health | Template', 1, NULL, NULL, NULL, NULL),
    ('pactHome', 'favicon', '', 1, 'assets/img/favicon.ico', NULL, NULL, NULL),
    ('pactHome', 'preloader_image', '', 1, 'assets/img/logo/loder.png', NULL, NULL, NULL),
    ('pactHome', 'header_logo', '', 1, 'assets/img/logo/logo.png', NULL, '/pactHome', NULL),
    ('pactHome', 'slider_caption', 'Hello ${patient.firstName}', 1, NULL, NULL, NULL, NULL),
    ('pactHome', 'slider_subcaption', 'Register for a health check-up to receive exclusive offers', 1, NULL, NULL, NULL, NULL),
    ('pactHome', 'want_to_work_title', 'Happy mind <br>Healthy life', 1, NULL, NULL, NULL, NULL),
    ('pactHome', 'want_to_work_subtitle', 'Are you experiencing any of the following issues?<br> Register early to receive offers', 1, NULL, NULL, NULL, NULL),
    ('pactHome', 'want_to_work_button', 'Use Services', 1, NULL, NULL, 'appointment/list', 'Use Services'),
    ('pactHome', 'service_icon_7', '', 1, 'assets/img/icon/services1.svg', NULL, NULL, NULL), -- Teeth Whitening
    ('pactHome', 'service_title_7', 'Comprehensive General Checkup', 1, NULL, NULL, 'book-appointment?type=General Checkup', 'Comprehensive General Checkup'),
    ('pactHome', 'service_description_7', 'Feeling off or overdue for a health screening? Our thorough checkup assesses your overall wellness to catch issues early.', 1, NULL, NULL, NULL, NULL),
    ('pactHome', 'service_button_7', '', 1, NULL, NULL, 'book-appointment?type=General Checkup', NULL),
    ('pactHome', 'service_icon_8', '', 1, 'assets/img/icon/services2.svg', NULL, NULL, NULL), -- Dental Checkup
    ('pactHome', 'service_title_8', 'Mental Health Support', 1, NULL, NULL, 'book-appointment?type=Mental Health Consultation', 'Mental Health Support'),
    ('pactHome', 'service_description_8', 'Struggling with stress, anxiety, or low mood? Book a consultation with our compassionate mental health specialists.', 1, NULL, NULL, NULL, NULL),
    ('pactHome', 'service_button_8', '', 1, NULL, NULL, 'book-appointment?type=Mental Health Consultation', NULL),
    ('pactHome', 'service_icon_9', '', 1, 'assets/img/icon/services3.svg', NULL, NULL, NULL), -- Tooth Extraction
    ('pactHome', 'service_title_9', 'Routine Health Monitoring', 1, NULL, NULL, 'book-appointment?type=Periodic Health Checkup', 'Routine Health Monitoring'),
    ('pactHome', 'service_description_9', 'Stay proactive about your health. Schedule a periodic checkup to monitor your well-being and secure peace of mind.', 1, NULL, NULL, NULL, NULL),
    ('pactHome', 'service_button_9', '', 1, NULL, NULL, 'book-appointment?type=Periodic Health Checkup', NULL),
    ('pactHome', 'video_background', '', 1, 'assets/img/gallery/video-bg.png', NULL, NULL, NULL),
    ('pactHome', 'video_url', '', 1, NULL, 'https://www.youtube.com/watch?v=up68UAfH0d0', NULL, NULL),
    ('pactHome', 'testimonial1_quote', 'I am very satisfied with the hospital''s entire process, thorough and professional.', 1, NULL, NULL, NULL, NULL),
    ('pactHome', 'testimonial1_author', 'Nguyen Thi Mai', 1, NULL, NULL, NULL, NULL),
    ('pactHome', 'testimonial1_role', 'Homemaker', 1, NULL, NULL, NULL, NULL),
    ('pactHome', 'testimonial1_image', '', 1, 'assets/img/icon/quotes-sign.png', NULL, NULL, NULL),
    ('pactHome', 'testimonial1_author_image', '', 1, 'assets/img/icon/testimonial.png', NULL, NULL, NULL),
    ('pactHome', 'testimonial2_quote', 'I detected my illness early and received timely treatment, thanks to the team of expert doctors.', 1, NULL, NULL, NULL, NULL),
    ('pactHome', 'testimonial2_author', 'Le Minh Quan', 1, NULL, NULL, NULL, NULL),
    ('pactHome', 'testimonial2_role', 'IT Professional', 1, NULL, NULL, NULL, NULL),
    ('pactHome', 'testimonial2_image', '', 1, 'assets/img/icon/quotes-sign.png', NULL, NULL, NULL),
    ('pactHome', 'testimonial2_author_image', '', 1, 'assets/img/icon/testimonial.png', NULL, NULL, NULL),
    ('pactHome', 'about_law_title', '100% Satisfaction Guaranteed.', 1, NULL, NULL, NULL, NULL),
    ('pactHome', 'about_law_description', 'Over 1,000 customers visit daily and are seen immediately because they booked early', 1, NULL, NULL, NULL, NULL),
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