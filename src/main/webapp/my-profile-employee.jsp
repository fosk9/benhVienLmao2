<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - Employee</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
</head>
<body>

<jsp:include page="header.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">My Profile (Employee)</h2>

    <form method="post" action="UpdateMyProfile">
        <input type="hidden" name="employeeId" value="${employee.employeeId}"/>

        <div class="mb-3">
            <label>Username</label>
            <input type="text" class="form-control" value="${employee.username}" disabled/>
        </div>

        <div class="mb-3">
            <label>Password</label>
            <input type="password" class="form-control" value="${employee.passwordHash}" disabled/>
        </div>

        <div class="mb-3">
            <label>Email</label>
            <input type="email" class="form-control" value="${employee.email}" disabled/>
        </div>

        <div class="mb-3">
            <label>Full Name</label>
            <input type="text" class="form-control" name="fullName" value="${employee.fullName}"/>
        </div>

        <div class="mb-3">
            <label>Date of Birth</label>
            <input type="date" class="form-control" name="dob" value="${employee.dob}"/>
        </div>

        <div class="mb-3">
            <label>Gender</label>
            <select class="form-select" name="gender">
                <option value="M" ${employee.gender == 'M' ? 'selected' : ''}>Male</option>
                <option value="F" ${employee.gender == 'F' ? 'selected' : ''}>Female</option>
                <option value="O" ${employee.gender == 'O' ? 'selected' : ''}>Other</option>
            </select>
        </div>

        <div class="mb-3">
            <label>Phone</label>
            <input type="text" class="form-control" name="phone" value="${employee.phone}"/>
        </div>

        <button type="submit" class="btn btn-success">Update My Profile</button>
    </form>
</div>

<jsp:include page="footer.jsp"/>
<script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>
