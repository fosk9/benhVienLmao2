<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Patient List</title>

    <jsp:include page="doctor-common-css.jsp"/>

    <style>
        .search-container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
            margin: 20px 0;
            padding: 20px;
            background-color: #f8f8f8;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .search-fields {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: center;
            align-items: center;
            width: 100%;
        }

        .search-fields select,
        .search-fields input,
        .search-fields button {
            padding: 12px;
            font-size: 16px;
            border-radius: 5px;
            border: 1px solid #ddd;
            width: 220px;
        }

        .search-btn {
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
            padding: 12px 20px;
            font-size: 16px;
            border-radius: 5px;
        }

        .search-btn:hover {
            background-color: #45a049;
        }

        .table-container {
            width: 100%;
            display: flex;
            justify-content: center;
            padding: 20px;
        }

        table {
            width: 80%; /* Adjust width as needed */
            border-collapse: collapse;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        th, td {
            padding: 15px;
            border: 1px solid #ddd;
            font-family: 'Arial', sans-serif;
            color: #333;
        }

        th {
            background-color: #f4f4f4;
            font-weight: bold;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        /* Pagination Styles */
        .pagination {
            margin-top: 20px;
            display: flex;
            justify-content: center;
        }

        .pagination a {
            padding: 5px 10px;
            margin: 0 2px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            font-size: 16px;
        }

        .pagination a:hover {
            background-color: #45a049;
        }

        .pagination .active {
            background-color: #234821;
        }

        .pagination .disabled {
            background-color: #ddd;
            cursor: not-allowed;
        }
    </style>
    <script>
        function validateForm() {
            // Lấy giá trị từ các trường tìm kiếm
            var fullName = document.getElementById("fullName").value.trim();
            var insuranceNumber = document.getElementById("insuranceNumber").value.trim();

            // Xử lý khoảng trắng thừa trong fullName (Thay các khoảng trắng liên tiếp thành một khoảng trắng duy nhất)
            fullName = fullName.replace(/\s+/g, ' ');

            // Kiểm tra nếu fullName không có khoảng trắng liên tiếp và không bắt đầu/kết thúc với khoảng trắng
            document.getElementById("fullName").value = fullName;

            // Kiểm tra và xử lý khoảng trắng trong số bảo hiểm (loại bỏ tất cả khoảng trắng chỉ có trong chuỗi)
            var formattedInsuranceNumber = insuranceNumber.replace(/\s+/g, '');

            // Loại bỏ khoảng trắng ở đầu và cuối của số bảo hiểm
            var trimmedInsuranceNumber = insuranceNumber.trim();

            // Nếu số bảo hiểm có khoảng trắng ở giữa, loại bỏ chúng và hiển thị lại
            document.getElementById("insuranceNumber").value = trimmedInsuranceNumber;

            // Kiểm tra và thông báo lỗi nếu không có số bảo hiểm hợp lệ
            if (formattedInsuranceNumber !== trimmedInsuranceNumber) {
                alert("Insurance number cannot have spaces.");
                return false; // Không gửi form khi số bảo hiểm có khoảng trắng
            }

            // Nếu mọi thứ hợp lệ, form sẽ được gửi
            return true;
        }
    </script>
</head>

<body>

<jsp:include page="doctor-header.jsp"/>
<div class="section-tittle mb-30 text-center">
    <h2>Closest Appointments</h2>
    <p>Hello, ${doctor.fullName} </p>
</div>
<!-- Form tìm kiếm -->
<div class="search-container">
    <form action="doctor-home" method="get" onsubmit="return validateForm()">
        <div class="search-fields">
            <input type="text" name="fullName" id="fullName" value="${fullName}" placeholder="Search by Full Name">
            <input type="text" name="insuranceNumber" id="insuranceNumber" value="${insuranceNumber}" placeholder="Search by INS">
            <select name="typeName">
                <option value="">Select Appointment Type</option>
                <option value="General Checkup" ${typeName == 'General Checkup' ? 'selected' : ''}>General Checkup</option>
                <option value="Cardiology Consultation" ${typeName == 'Cardiology Consultation' ? 'selected' : ''}>
                    Cardiology Consultation
                </option>
                <option value="Gastroenterology Consultation" ${typeName == 'Gastroenterology Consultation' ? 'selected' : ''}>
                    Gastroenterology Consultation
                </option>
                <option value="Orthopedic Consultation" ${typeName == 'Orthopedic Consultation' ? 'selected' : ''}>
                    Orthopedic Consultation
                </option>
                <option value="Neurology Consultation" ${typeName == 'Neurology Consultation' ? 'selected' : ''}>Neurology
                    Consultation
                </option>
                <option value="Mental Health Consultation" ${typeName == 'Mental Health Consultation' ? 'selected' : ''}>
                    Mental Health Consultation
                </option>
                <option value="Psychotherapy Session" ${typeName == 'Psychotherapy Session' ? 'selected' : ''}>Psychotherapy
                    Session
                </option>
                <option value="Psychiatric Evaluation" ${typeName == 'Psychiatric Evaluation' ? 'selected' : ''}>Psychiatric
                    Evaluation
                </option>
                <option value="Stress and Anxiety Management" ${typeName == 'Stress and Anxiety Management' ? 'selected' : ''}>
                    Stress and Anxiety Management
                </option>
                <option value="Depression Counseling" ${typeName == 'Depression Counseling' ? 'selected' : ''}>Depression
                    Counseling
                </option>
                <option value="Periodic Health Checkup" ${typeName == 'Periodic Health Checkup' ? 'selected' : ''}>Periodic
                    Health Checkup
                </option>
                <option value="Gynecology Consultation" ${typeName == 'Gynecology Consultation' ? 'selected' : ''}>
                    Gynecology Consultation
                </option>
                <option value="Pediatric Consultation" ${typeName == 'Pediatric Consultation' ? 'selected' : ''}>Pediatric
                    Consultation
                </option>
                <option value="Ophthalmology Consultation" ${typeName == 'Ophthalmology Consultation' ? 'selected' : ''}>
                    Ophthalmology Consultation
                </option>
                <option value="ENT Consultation" ${typeName == 'ENT Consultation' ? 'selected' : ''}>ENT Consultation
                </option>
                <option value="On-Demand Consultation" ${typeName == 'On-Demand Consultation' ? 'selected' : ''}>On-Demand
                    Consultation
                </option>
                <option value="Emergency Consultation" ${typeName == 'Emergency Consultation' ? 'selected' : ''}>Emergency
                    Consultation
                </option>
            </select>
            <select name="timeSlot">
                <option value="">Select Time Slot</option>
                <option value="Morning" ${timeSlot == 'Morning' ? 'selected' : ''}>Morning</option>
                <option value="Afternoon" ${timeSlot == 'Afternoon' ? 'selected' : ''}>Afternoon</option>
                <option value="Evening" ${timeSlot == 'Evening' ? 'selected' : ''}>Evening</option>
            </select>
            <button type="submit" class="search-btn">Search</button>
        </div>
    </form>
</div>

<div class="table-container">
    <table border="1">
        <thead>
        <tr>
            <th>Number</th>
            <th>Full Name</th>
            <th>Insurance Number</th>
            <th>Appointment Type</th>
            <th>Appointment Date</th>
            <th>Time Slot</th>
            <th>Status</th>
            <th>View</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="appointment" items="${appointments}">
            <tr>
                <td>${appointments.indexOf(appointment) + 1 + startIndex}</td> <!-- Số thứ tự tổng quát -->
                <td>${appointment.patient.fullName}</td>
                <td>${appointment.patient.insuranceNumber}</td>
                <td>${appointment.appointmentType.typeName}</td>
                <td>
                    <fmt:formatDate value="${appointment.appointmentDate}" pattern="dd/MM/yyyy"/>
                </td>
                <td>${appointment.timeSlot}</td>
                <td>${appointment.status}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/view-detail?id=${appointment.appointmentId}" class="btn btn-primary">Detail</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<!-- Pagination Controls -->
<div class="pagination">
    <c:forEach var="i" begin="1" end="${totalPages}">
        <c:choose>
            <c:when test="${i == currentPage}">
                <!-- Khi trang hiện tại, đánh dấu là active và giữ lại các tham số tìm kiếm -->
                <a href="doctor-home?page=${i}&fullName=${fullName}&insuranceNumber=${insuranceNumber}&typeName=${typeName}&timeSlot=${timeSlot}" class="active">${i}</a>
            </c:when>
            <c:otherwise>
                <!-- Các trang còn lại, giữ lại các tham số tìm kiếm -->
                <a href="doctor-home?page=${i}&fullName=${fullName}&insuranceNumber=${insuranceNumber}&typeName=${typeName}&timeSlot=${timeSlot}">${i}</a>
            </c:otherwise>
        </c:choose>
    </c:forEach>
</div>


<jsp:include page="doctor-footer.jsp"/>
<jsp:include page="doctor-common-scripts.jsp"/>

</body>
</html>
