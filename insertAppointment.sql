-- Bước 1: Chèn 10 bác sĩ mới vào bảng Employees
DECLARE @i INT = 1;
WHILE @i <= 10
BEGIN
    INSERT INTO Employees (username, password_hash, full_name, dob, gender, email, phone, role_id, specialization_id)
    VALUES (
        CONCAT('dr', @i),
        '123',
        CONCAT(N'Dr. Nguyễn Văn ', @i),
        DATEADD(YEAR, -30, GETDATE()), -- giả định sinh cách đây 30 năm
        'M',
        CONCAT('dr', @i, '@clinic.com'),
        CONCAT('090', FORMAT(@i, '0000000')),
        1, -- role_id = 1 = Doctor
        NULL -- hoặc bạn thay bằng specialization_id nếu có
    );
    SET @i = @i + 1;
END;

-- Bước 2: Tạo 10 lịch hẹn ngẫu nhiên giữa các bác sĩ vừa tạo và bệnh nhân có sẵn
-- Lấy danh sách id bác sĩ vừa chèn
DECLARE @doctor TABLE (id INT);
INSERT INTO @doctor
SELECT employee_id FROM Employees WHERE username LIKE 'dr%';

-- Lấy danh sách bệnh nhân có sẵn
DECLARE @patient TABLE (id INT);
INSERT INTO @patient
SELECT patient_id FROM Patients;

-- Biến hỗ trợ random
DECLARE @dId INT, @pId INT, @dayOffset INT;

-- Lặp 10 lần để tạo lịch hẹn
SET @i = 1;
WHILE @i <= 10
BEGIN
    -- Random doctor_id
    SELECT TOP 1 @dId = id FROM @doctor ORDER BY NEWID();
    -- Random patient_id
    SELECT TOP 1 @pId = id FROM @patient ORDER BY NEWID();
    -- Random ngày hẹn từ ngày hôm nay + 1 đến +10 ngày
    SET @dayOffset = FLOOR(RAND() * 10 + 1);

    INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, created_at)
    VALUES (
        @pId,
        @dId,
        DATEADD(DAY, @dayOffset, GETDATE()),
        'Pending',
        GETDATE()
    );

    SET @i = @i + 1;
END;
