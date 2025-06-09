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

-- Bảng danh mục (Category)
CREATE TABLE Category (
    category_id TINYINT PRIMARY KEY IDENTITY(1,1),
    category_name NVARCHAR(100) NOT NULL
);
GO

-- Bảng Blog (bài viết)
CREATE TABLE Blog (
    blog_id         INT PRIMARY KEY IDENTITY(1,1),
    blog_name       NVARCHAR(255) NOT NULL,     -- Tiêu đề bài viết
    blog_sub_content NVARCHAR(500),              -- Nội dung tóm tắt
    content         NVARCHAR(MAX) NOT NULL,     -- Nội dung đầy đủ
    blog_img        NVARCHAR(500),              -- Đường dẫn hình ảnh
    author          NVARCHAR(255),              -- Tên tác giả
    date            DATETIME DEFAULT GETDATE(), -- Ngày đăng
    category_id     TINYINT,                    -- Danh mục
    selected_banner BIT DEFAULT 0,              -- Có hiển thị nổi bật không (1 là có)

    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);
GO

-- Bảng Comment (bình luận bài viết)
CREATE TABLE Comment (
    comment_id INT PRIMARY KEY IDENTITY(1,1),
    blog_id    INT NOT NULL,             -- Bài viết được bình luận
    patient_id INT NOT NULL,             -- Người bình luận
    content    NVARCHAR(MAX) NOT NULL,   -- Nội dung bình luận
    date       DATETIME DEFAULT GETDATE(),  -- Ngày bình luận

    FOREIGN KEY (blog_id) REFERENCES Blog(blog_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);
GO





CREATE TABLE AppointmentType
(
    appointmenttype_id INT PRIMARY KEY IDENTITY(1,1),
    type_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255),
    price DECIMAL(12, 2) NOT NULL
);

-- Appointments (restricted to Morning/Afternoon/Evening)
CREATE TABLE Appointments
(
    appointment_id INT PRIMARY KEY IDENTITY(1,1),
    patient_id INT,
    doctor_id INT,
    appointmenttype_id INT NOT NULL,
    appointment_date DATE,
    time_slot VARCHAR(20) CHECK (time_slot IN ('Morning', 'Afternoon', 'Evening')),
    requires_specialist BIT DEFAULT 0,
    status VARCHAR(50) CHECK (status IN ('Unpay', 'Pending', 'Confirmed', 'Completed', 'Cancelled')),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (appointmenttype_id) REFERENCES AppointmentType(appointmenttype_id)
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
-- Insert dental AppointmentType with 2025 Vietnam market prices
INSERT INTO AppointmentType (type_name, description, price)
VALUES 
    ('Dental Checkup', 'Routine dental examination and consultation', 200000.00),
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


-- Insert sample Appointments (updated time slots)
INSERT INTO Appointments (patient_id, doctor_id, appointmenttype_id, appointment_date, time_slot, status, created_at, updated_at)
VALUES 
    (1, 1, 1, '2025-05-30', 'Morning', 'Pending', GETDATE(), GETDATE()),
    (2, 1, 2, '2025-05-10', 'Afternoon', 'Confirmed', GETDATE(), GETDATE()),
    (3, 1, 3, '2025-05-29', 'Evening', 'Completed', GETDATE(), GETDATE()),
    (4, 1, 4, '2025-06-04', 'Morning', 'Cancelled', GETDATE(), GETDATE()),
    (5, 1, 5, '2025-06-15', 'Afternoon', 'Pending', GETDATE(), GETDATE()),
    (1, 1, 6, '2025-05-29', 'Morning', 'Completed', GETDATE(), GETDATE()),
    (2, 1, 7, '2025-06-20', 'Evening', 'Pending', GETDATE(), GETDATE()),
    (3, 1, 8, '2025-05-15', 'Afternoon', 'Confirmed', GETDATE(), GETDATE()),
    (4, 1, 9, '2025-06-09', 'Morning', 'Cancelled', GETDATE(), GETDATE()),
    (5, 1, 10, '2025-05-29', 'Evening', 'Completed', GETDATE(), GETDATE()),
    (1, 1, 11, '2025-06-01', 'Morning', 'Pending', GETDATE(), GETDATE()),
    (2, 1, 12, '2025-05-20', 'Afternoon', 'Confirmed', GETDATE(), GETDATE()),
    (3, 1, 13, '2025-05-29', 'Morning', 'Completed', GETDATE(), GETDATE()),
    (4, 1, 14, '2025-06-14', 'Evening', 'Cancelled', GETDATE(), GETDATE()),
    (5, 1, 15, '2025-06-30', 'Afternoon', 'Pending', GETDATE(), GETDATE()),
    (1, 1, 16, '2025-05-30', 'Morning', 'Confirmed', GETDATE(), GETDATE()),
    (2, 1, 17, '2025-05-29', 'Evening', 'Completed', GETDATE(), GETDATE()),
    (3, 1, 1, '2025-06-18', 'Afternoon', 'Cancelled', GETDATE(), GETDATE()),
    (4, 1, 2, '2025-06-05', 'Morning', 'Pending', GETDATE(), GETDATE()),
    (5, 1, 3, '2025-05-25', 'Evening', 'Confirmed', GETDATE(), GETDATE());
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

-- Dữ liệu mẫu cho bảng Category (thêm các danh mục y tế)
INSERT INTO Category (category_name)
VALUES 
    ('Khám bệnh'),      -- Category ID = 1
    ('Bệnh lý'),        -- Category ID = 2
    ('Chăm sóc sức khỏe'),  -- Category ID = 3
    ('Phòng ngừa bệnh');     -- Category ID = 4

-- Dữ liệu mẫu cho bảng Blog (Thêm bài viết liên quan đến y tế)
INSERT INTO Blog (blog_name, blog_sub_content, content, blog_img, author, date, category_id)
VALUES 
    ('Khám bệnh định kỳ', 
     'Khám bệnh định kỳ giúp phát hiện sớm các bệnh lý nguy hiểm.',
     'Khám bệnh định kỳ là một phần quan trọng trong việc duy trì sức khỏe. Việc kiểm tra sức khỏe hàng năm giúp phát hiện sớm các bệnh lý như tiểu đường, cao huyết áp, bệnh tim mạch, và ung thư...',
     'checkup_regular.jpg', 
     'TS.BS Lê Văn C', 
     '2025-06-21 00:00:00.000', 
     1),  -- Thuộc danh mục "Khám bệnh"
     
    ('Phòng ngừa bệnh tim mạch', 
     'Các phương pháp phòng ngừa bệnh tim mạch đơn giản và hiệu quả.',
     'Bệnh tim mạch hiện nay đang ngày càng gia tăng. Để phòng ngừa bệnh này, chúng ta cần thực hiện chế độ ăn uống lành mạnh, tập thể dục thường xuyên và kiểm soát huyết áp...',
     'heart_disease_prevention.jpg', 
     'Nguyễn Thị A', 
     '2025-06-22 00:00:00.000', 
     4),  -- Thuộc danh mục "Phòng ngừa bệnh"
     
    ('Chế độ ăn uống cho bệnh nhân tiểu đường', 
     'Chế độ ăn uống phù hợp giúp kiểm soát bệnh tiểu đường hiệu quả.',
     'Đối với bệnh nhân tiểu đường, chế độ ăn uống rất quan trọng. Việc lựa chọn thực phẩm có chỉ số đường huyết thấp và kiêng các món ăn có nhiều đường là rất cần thiết...',
     'diabetes_diet.jpg', 
     'TS.BS Trần Thị B', 
     '2025-06-23 00:00:00.000', 
     2),  -- Thuộc danh mục "Bệnh lý"
     
    ('Điều trị ung thư', 
     'Tổng quan về phương pháp điều trị ung thư hiện đại.',
     'Ung thư là một trong những bệnh lý nguy hiểm và có thể gây tử vong. Tuy nhiên, các phương pháp điều trị ung thư hiện nay ngày càng phát triển và mang lại nhiều hy vọng cho bệnh nhân...',
     'cancer_treatment.jpg', 
     'Lê Thị C', 
     '2025-06-24 00:00:00.000', 
     2),  -- Thuộc danh mục "Bệnh lý"
     
    ('Chăm sóc sức khỏe người cao tuổi', 
     'Những lời khuyên về chăm sóc sức khỏe cho người cao tuổi.',
     'Chăm sóc sức khỏe cho người cao tuổi là một công việc cần thiết. Chế độ dinh dưỡng hợp lý, tập thể dục nhẹ nhàng và việc kiểm tra sức khỏe thường xuyên sẽ giúp người cao tuổi sống khỏe mạnh...',
     'elderly_care.jpg', 
     'Nguyễn Minh D', 
     '2025-06-25 00:00:00.000', 
     3);  -- Thuộc danh mục "Chăm sóc sức khỏe"

	 -- Dữ liệu mẫu cho bảng Comment (Thêm bình luận cho các bài viết y tế)
INSERT INTO Comment (blog_id, patient_id, content, date)
VALUES 
    (1, 1, 'Bài viết rất hữu ích, tôi sẽ đi khám bệnh định kỳ ngay.', '2025-06-21 10:30:00.000'),
    (1, 2, 'Khám bệnh định kỳ thực sự rất quan trọng, tôi sẽ chủ động đi khám mỗi năm.', '2025-06-22 14:15:00.000'),
    (2, 3, 'Bài viết này giúp tôi hiểu hơn về cách phòng ngừa bệnh tim, cảm ơn bác sĩ.', '2025-06-23 09:00:00.000'),
    (2, 4, 'Tôi sẽ thay đổi chế độ ăn uống của mình để phòng ngừa bệnh tim mạch.', '2025-06-24 11:45:00.000'),
    (3, 2, 'Bài viết này rất dễ hiểu, tôi sẽ thay đổi chế độ ăn uống cho phù hợp với bệnh tiểu đường của mình.', '2025-06-25 16:25:00.000'),
    (3, 3, 'Cảm ơn bài viết, tôi sẽ tìm hiểu thêm về các thực phẩm phù hợp cho bệnh nhân tiểu đường.', '2025-06-26 17:30:00.000'),
    (4, 4, 'Điều trị ung thư ngày nay đã có nhiều tiến bộ, tôi rất hy vọng vào những phương pháp điều trị mới.', '2025-06-27 10:20:00.000'),
    (4, 1, 'Tôi rất muốn tìm hiểu thêm về các phương pháp điều trị ung thư hiện đại.', '2025-06-28 08:55:00.000'),
    (5, 1, 'Chăm sóc người cao tuổi rất quan trọng, tôi sẽ áp dụng các lời khuyên này cho ông bà của tôi.', '2025-06-29 12:10:00.000'),
    (5, 4, 'Bài viết rất bổ ích, tôi sẽ áp dụng chế độ dinh dưỡng cho người cao tuổi.', '2025-06-30 14:40:00.000');
