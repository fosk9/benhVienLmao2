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

-- SystemItems (merged Features and NavigationItems)
CREATE TABLE SystemItems
(
    item_id        INT PRIMARY KEY IDENTITY (1,1),
    item_name      NVARCHAR(255) NOT NULL,
    item_url       NVARCHAR(255),
    image_url      NVARCHAR(255),
    is_active      BIT DEFAULT 1,
    display_order  INT,
    parent_item_id INT           NULL,
    item_type      VARCHAR(50)   NOT NULL CHECK (item_type IN ('Feature', 'Navigation')),
    FOREIGN KEY (parent_item_id) REFERENCES SystemItems (item_id)
);
GO

-- RoleSystemItems (maps roles to system items for access control)
CREATE TABLE RoleSystemItems
(
    id      INT PRIMARY KEY IDENTITY (1,1),
    role_id INT,
    item_id INT,
    FOREIGN KEY (role_id) REFERENCES Roles (role_id),
    FOREIGN KEY (item_id) REFERENCES SystemItems (item_id)
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
    payment_id     INT PRIMARY KEY IDENTITY (1,1),
    appointment_id INT,
    amount         DECIMAL(10, 2),
    method         VARCHAR(50),
    status         VARCHAR(50) CHECK (status IN ('Pending', 'Paid', 'Refunded')),
    payment_date   DATETIME,
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

    manager_id   INT,      -- Người duyệt đơn nghỉ
    requested_at DATETIME, -- Thời gian xin nghỉ
    approved_at  DATETIME, -- Thời gian duyệt (dù là đồng ý hay từ chối)

    FOREIGN KEY (doctor_id) REFERENCES Employees (employee_id),
    FOREIGN KEY (manager_id) REFERENCES Employees (employee_id)
);
GO

-- Insert sample Roles
INSERT INTO Roles (role_name)
VALUES ('Doctor'),
       ('Receptionist'),
       ('Admin'),
       ('Manager');
GO

-- Insert sample SystemItems (combining Features and NavigationItems)
INSERT INTO SystemItems (item_name, item_url, image_url, is_active, display_order, parent_item_id, item_type)
VALUES ('Book Appointment', 'book-appointment', 'assets/img/icon/book_appointment.png', 1, NULL, NULL, 'Feature'),
       ('View Prescription', 'view-prescription', 'assets/img/icon/prescription.png', 1, NULL, NULL, 'Feature'),
       ('Manage Users', 'admin/users', 'assets/img/icon/manage_users.png', 1, NULL, NULL, 'Feature'),
       ('View Statistics', 'admin/statistics', 'assets/img/icon/statistics.png', 1, NULL, NULL, 'Feature'),
       ('Approve Doctor Shifts', 'admin/shift-approval', 'assets/img/icon/shift_approval.png', 1, NULL, NULL,
        'Feature'),
       ('Teeth Whitening', 'book-appointment?appointmentTypeId=3', 'assets/img/icon/services1.svg', 1, NULL, NULL,
        'Feature'),
       ('Dental Checkup', 'book-appointment?appointmentTypeId=1', 'assets/img/icon/services2.svg', 1, NULL, NULL,
        'Feature'),
       ('Tooth Extraction', 'book-appointment?appointmentTypeId=6', 'assets/img/icon/services3.svg', 1, NULL, NULL,
        'Feature'),
       ('Home', 'index.jsp', NULL, 1, 1, NULL, 'Navigation'),
       ('About', 'about.html', NULL, 1, 2, NULL, 'Navigation'),
       ('Dental Services', 'services.html', NULL, 1, 3, NULL, 'Navigation'),
       ('Blog', 'blog.jsp', NULL, 1, 4, NULL, 'Navigation'),
       ('Blog', 'blog.jsp', NULL, 1, 1, 12, 'Navigation'),
       ('Blog Details', 'blog-detail.jsp', NULL, 1, 2, 12, 'Navigation'),
       ('Element', 'elements.html', NULL, 1, 3, 12, 'Navigation'),
       ('Contact', 'contact.html', NULL, 1, 5, NULL, 'Navigation');
GO

-- Insert sample RoleSystemItems
INSERT INTO RoleSystemItems (role_id, item_id)
VALUES (1, 1), -- Doctor: Book Appointment
       (1, 2), -- Doctor: View Prescription
       (3, 3), -- Admin: Manage Users
       (3, 4), -- Admin: View Statistics
       (4, 5), -- Manager: Approve Doctor Shifts
       (1, 6), -- Doctor: Teeth Whitening
       (1, 7), -- Doctor: Dental Checkup
       (1, 8); -- Doctor: Tooth Extraction
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
(11, 2, 1, '2025-06-29', 'Morning', 'Confirmed');
-- Bác sĩ 1: có 3 ca khám đã hoàn thành
INSERT INTO Appointments (patient_id, doctor_id, appointmenttype_id, appointment_date, time_slot, status)
VALUES (1, 1, 1, '2025-06-10', 'Morning', 'Completed'),
       (2, 1, 2, '2025-06-11', 'Afternoon', 'Completed'),
       (3, 1, 3, '2025-06-12', 'Evening', 'Completed');

INSERT INTO Diagnoses (appointment_id, notes)
VALUES (12, N'General check-up. Patient is healthy. No issues detected.'),
       (13, N'Tartar removal. Slight plaque buildup found.'),
       (14, N'Teeth whitening with laser. Teeth slightly sensitive after treatment.');

INSERT INTO Prescriptions (appointment_id, medication_details)
VALUES (12, N'No medication needed.'),
       (13, N'Antiseptic mouthwash, use twice a day.'),
       (14, N'Paracetamol 500mg if needed for pain, do not exceed 3 tablets per day.');

INSERT INTO Treatment (appointment_id, treatment_type, treatment_notes)
VALUES (12, N'General Check-up', N'No treatment required. Periodic monitoring only.'),
       (13, N'Teeth Cleaning', N'Tartar removed and teeth polished.'),
       (14, N'Teeth Whitening', N'Laser technology used at the clinic.');

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

INSERT INTO DoctorShifts (doctor_id, shift_date, time_slot, status)
VALUES
-- Doctor 1
(1, '2025-06-23', 'Morning', 'Working'),
(1, '2025-06-23', 'Afternoon', 'Working'),
(1, '2025-06-24', 'Morning', 'PendingLeave'),
(1, '2025-06-24', 'Afternoon', 'Working'),
(1, '2025-06-25', 'Morning', 'Leave'),
(1, '2025-06-25', 'Evening', 'Working'),
(1, '2025-06-26', 'Night', 'Rejected'),
(1, '2025-06-27', 'Morning', 'Working'),
(1, '2025-06-28', 'Morning', 'Working'),
(1, '2025-06-29', 'Evening', 'Working'),

-- Doctor 2
(2, '2025-06-23', 'Afternoon', 'Working'),
(2, '2025-06-24', 'Morning', 'Working'),
(2, '2025-06-25', 'Morning', 'Working'),
(2, '2025-06-26', 'Afternoon', 'PendingLeave'),
(2, '2025-06-26', 'Evening', 'Leave'),
(2, '2025-06-27', 'Night', 'Rejected'),
(2, '2025-06-28', 'Morning', 'Working'),
(2, '2025-06-29', 'Morning', 'Working');

