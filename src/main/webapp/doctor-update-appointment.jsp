<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Appointment</title>
    <jsp:include page="doctor-common-css.jsp"/>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f3f3f3;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 700px;
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
            padding: 10px;
            border: 1px solid #ddd;
        }
        th {
            background-color: #f9f9f9;
            text-align: left;
            width: 35%;
        }
        input[type="text"], input[type="date"], select {
            width: 100%;
            padding: 8px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }
        .button-group {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            gap: 15px;
        }
        .button-group button, .button-group a {
            padding: 10px 20px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            text-decoration: none;
        }
        .btn-save {
            background-color: #17a2b8;
            color: white;
        }
        .btn-back {
            background-color: #6c757d;
            color: white;
        }
        .error-message {
            color: red;
            text-align: center;
            font-weight: bold;
        }
    </style>
</head>
<body>
<jsp:include page="doctor-header.jsp"/>
<div class="container">
    <h2>Edit Appointment</h2>

    <c:if test="${not empty errorMessage}">
        <div class="error-message">${errorMessage}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/update-appointment">
        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}" />

        <table>
            <tr><th>Full Name</th><td><input type="text" name="fullName" value="${fullName != null ? fullName : appointment.patient.fullName}" required /></td></tr>
            <tr><th>Date of Birth</th><td><input type="date" name="dob" value="${dob != null ? dob : appointment.patient.dob}" /></td></tr>
            <tr><th>Gender</th><td>
                <select name="gender">
                    <option value="M" ${gender == 'M' ? 'selected' : appointment.patient.gender == 'M' ? 'selected' : ''}>Male</option>
                    <option value="F" ${gender == 'F' ? 'selected' : appointment.patient.gender == 'F' ? 'selected' : ''}>Female</option>
                </select>
            </td></tr>
            <tr><th>Phone</th><td><input type="text" name="phone" value="${phone != null ? phone : appointment.patient.phone}" /></td></tr>
            <tr><th>Address</th><td><input type="text" name="address" value="${address != null ? address : appointment.patient.address}" /></td></tr>
            <tr><th>Insurance Number</th><td><input type="text" name="insuranceNumber" value="${insuranceNumber != null ? insuranceNumber : appointment.patient.insuranceNumber}" /></td></tr>
            <tr><th>Emergency Contact</th><td><input type="text" name="emergencyContact" value="${emergencyContact != null ? emergencyContact : appointment.patient.emergencyContact}" /></td></tr>
            <tr><th>Appointment Date</th><td><input type="date" name="appointmentDate" value="${appointmentDate != null ? appointmentDate : appointment.appointmentDate}" /></td></tr>
            <tr><th>Status</th><td>
                <select name="status">
                    <option value="Pending" ${status == 'Pending' || appointment.status == 'Pending' ? 'selected' : ''}>Pending</option>
                    <option value="Confirmed" ${status == 'Confirmed' || appointment.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                    <option value="Completed" ${status == 'Completed' || appointment.status == 'Completed' ? 'selected' : ''}>Completed</option>
                    <option value="Cancelled" ${status == 'Cancelled' || appointment.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                </select>
            </td></tr>
            <tr>
                <th>Appointment Type</th>
                <td>
                    <select name="appointmentTypeId" required>
                        <c:forEach var="type" items="${appointmentTypes}">
                            <option value="${type.appointmentTypeId}" <c:if test="${type.appointmentTypeId == selectedTypeId}">selected</c:if>>
                                    ${type.typeName}
                            </option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <th>Description</th>
                <td><input type="text" name="typeDescription" value="${typeDescription}" readonly /></td>
            </tr>
        </table>

        <div class="button-group">
            <a href="${pageContext.request.contextPath}/view-detail?id=${appointment.appointmentId}" class="btn-back">Cancel</a>
            <button type="submit" class="btn-save">Save</button>
        </div>

    </form>
</div>
<jsp:include page="doctor-footer.jsp"/>
</body>
</html>
