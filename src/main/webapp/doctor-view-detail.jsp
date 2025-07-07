<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Appointment Detail</title>
    <jsp:include page="doctor-common-css.jsp"/>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f3f3f3;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 600px;
            margin: 40px auto;
            padding: 25px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #1e1e1e;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px 12px;
            border: 1px solid #e0e0e0;
            vertical-align: middle;
        }

        th {
            background-color: #f8f8f8;
            width: 40%;
            text-align: left;
            font-weight: 600;
        }

        tr:nth-child(even) {
            background-color: #fafafa;
        }

        .button-group {
            display: flex;
            justify-content: center;
            margin-top: 25px;
            gap: 15px;
        }

        .button-group a {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-back {
            background-color: #28a745;
            color: #fff;
        }

        .btn-edit {
            background-color: #007bff;
            color: #fff;
        }

        .btn-back:hover,
        .btn-edit:hover {
            opacity: 0.9;
        }

        .error-message {
            color: red;
            font-weight: bold;
            text-align: center;
        }
    </style>
</head>
<body>
<jsp:include page="doctor-header.jsp"/>

<div class="container">
    <c:if test="${not empty errorMessage}">
        <div class="error-message">
                ${errorMessage}
        </div>
    </c:if>

    <h2>Appointment Detail</h2>
    <table>
        <tr>
            <th>Patient Name</th>
            <td>${appointment.patient.fullName}</td>
        </tr>

        <tr>
            <th>Date of Birth</th>
            <td><fmt:formatDate value="${appointment.patient.dob}" pattern="dd/MM/yyyy"/></td>
        </tr>

        <tr>
            <th>Gender</th>
            <td>${appointment.patient.gender}</td>
        </tr>

        <tr>
            <th>Phone</th>
            <td>${appointment.patient.phone}</td>
        </tr>

        <tr>
            <th>Address</th>
            <td>${appointment.patient.address}</td>
        </tr>

        <tr>
            <th>Insurance Number</th>
            <td>${appointment.patient.insuranceNumber}</td>
        </tr>

        <tr>
            <th>Emergency Contact</th>
            <td>${appointment.patient.emergencyContact}</td>
        </tr>

        <tr>
            <th>Appointment Date</th>
            <td><fmt:formatDate value="${appointment.appointmentDate}" pattern="dd/MM/yyyy"/></td>
        </tr>

        <tr>
            <th>Status</th>
            <td>${appointment.status}</td>
        </tr>

        <tr>
            <th>Appointment Type</th>
            <td>${appointment.appointmentType.typeName}</td>
        </tr>

        <tr>
            <th>Description</th>
            <td>${appointment.appointmentType.description}</td>
        </tr>
    </table>

    <div class="button-group">
        <a href="${pageContext.request.contextPath}/doctor-home" class="btn-back">Back to List</a>
        <a href="${pageContext.request.contextPath}/update-appointment?id=${appointment.appointmentId}" class="btn-edit">Edit</a>
    </div>
</div>

<jsp:include page="doctor-footer.jsp"/>
<jsp:include page="doctor-common-scripts.jsp"/>
</body>
</html>
