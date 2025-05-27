<%--
  Created by IntelliJ IDEA.
  User: ADMIN
  Date: 5/27/2025
  Time: 7:17 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Details</title>
    <jsp:include page="common-css.jsp"/>
</head>
<body>

<jsp:include page="header.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">Patient Details</h2>

    <c:if test="${not empty patient}">
        <form action="UpdatePatientDetails" method="post">
            <input type="hidden" name="patientId" value="${patient.patientId}"/>

            <div class="mb-3">
                <label>Username</label>
                <input type="text" class="form-control" value="${patient.username}" disabled/>
            </div>

            <div class="mb-3">
                <label>Password</label>
                <input type="password" class="form-control" value="${patient.passwordHash}" disabled/>
            </div>

            <div class="mb-3">
                <label>Full Name</label>
                <input type="text" class="form-control" name="fullName" value="${patient.fullName}" required/>
            </div>

            <div class="mb-3">
                <label>Date of Birth</label>
                <input type="date" class="form-control" name="dob" value="${patient.dob}"/>
            </div>

            <div class="mb-3">
                <label>Gender</label>
                <select class="form-select" name="gender">
                    <option value="M" ${patient.gender == 'M' ? 'selected' : ''}>Male</option>
                    <option value="F" ${patient.gender == 'F' ? 'selected' : ''}>Female</option>
                    <option value="O" ${patient.gender == 'O' ? 'selected' : ''}>Other</option>
                </select>
            </div>

            <div class="mb-3">
                <label>Email</label>
                <input type="email" class="form-control" name="email" value="${patient.email}"/>
            </div>

            <div class="mb-3">
                <label>Phone</label>
                <input type="text" class="form-control" name="phone" value="${patient.phone}"/>
            </div>

            <div class="mb-3">
                <label>Address</label>
                <textarea class="form-control" name="address">${patient.address}</textarea>
            </div>

            <div class="mb-3">
                <label>Insurance Number</label>
                <input type="text" class="form-control" name="insuranceNumber" value="${patient.insuranceNumber}"/>
            </div>

            <div class="mb-3">
                <label>Emergency Contact</label>
                <input type="text" class="form-control" name="emergencyContact" value="${patient.emergencyContact}"/>
            </div>

            <div class="d-flex gap-3 mt-4">
                <button type="submit" class="btn btn-success">Update Patient Details</button>
                <a href="DeletePatient?id=${patient.patientId}" class="btn btn-danger"
                   onclick="return confirm('Are you sure you want to delete this patient?');">Delete This Patient</a>
            </div>
        </form>
    </c:if>

    <c:if test="${empty patient}">
        <div class="alert alert-warning">Patient not found.</div>
    </c:if>
</div>

<jsp:include page="footer.jsp"/>
<jsp:include page="common-scripts.jsp"/>
</body>
</html>
