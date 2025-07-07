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
    <a href="PatientList" class="btn btn-outline-primary">Back to List</a>

    <c:if test="${not empty message}">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
                ${message}
        </div>
    </c:if>

    <c:if test="${not empty patient}">
        <div class="mb-4 text-center">
            <c:choose>
                <c:when test="${not empty patient.patientAvaUrl}">
                    <img src="${patient.patientAvaUrl}" alt="Avatar" class="img-thumbnail"
                         style="width: 150px; height: 150px; object-fit: cover;">
                </c:when>
                <c:otherwise>
                    <img src="assets/img/default-avatar.png" alt="Default Avatar" class="img-thumbnail"
                         style="width: 150px; height: 150px;">
                </c:otherwise>
            </c:choose>
        </div>

        <form action="UpdatePatientDetails" method="post">
            <input type="hidden" name="patientId" value="${patient.patientId}"/>
            <input type="hidden" name="patient_ava_url" value="${patient.patientAvaUrl}"/>

            <div class="mb-3">
                <label>Username</label>
                <input type="text" name="username" class="form-control" value="${patient.username}" disabled/>
                <input type="hidden" name="username" value="${patient.username}"/>
            </div>

            <div class="mb-3">
                <label>Password</label>
                <input type="password" name="password_hash" class="form-control" value="${patient.passwordHash}"
                       disabled/>
                <input type="hidden" name="password_hash" value="${patient.passwordHash}"/>
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