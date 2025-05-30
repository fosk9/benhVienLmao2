<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - Patient</title>
    <jsp:include page="common-css.jsp"/>
</head>
<body>

<jsp:include page="header.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">My Profile (Patient)</h2>

    <form method="post" action="UpdateMyProfile">
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
            <label>Email</label>
            <input type="email" class="form-control" value="${patient.email}" disabled/>
        </div>

        <div class="mb-3">
            <label>Full Name</label>
            <input type="text" class="form-control" name="fullName" value="${patient.fullName}"/>
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

        <button type="submit" class="btn btn-success">Update My Profile</button>
    </form>
</div>

<jsp:include page="footer.jsp"/>
<jsp:include page="common-scripts.jsp"/>
</body>
</html>
