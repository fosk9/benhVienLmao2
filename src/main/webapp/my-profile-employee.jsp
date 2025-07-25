<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="no-js" lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile - Employee</title>
    <jsp:include page="common-css.jsp"/>
</head>
<body>

<jsp:include page="header.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">My Profile (Employee)</h2>

    <c:if test="${not empty message}">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
                ${message}
        </div>
    </c:if>

    <!-- Avatar display -->
    <div class="mb-4 text-center">
        <c:choose>
            <c:when test="${not empty employee.employeeAvaUrl}">
                <img src="${employee.employeeAvaUrl}" alt="Avatar" class="img-thumbnail"
                     style="width: 150px; height: 150px; object-fit: cover;">
            </c:when>
            <c:otherwise>
                <img src="assets/img/default-avatar.png" alt="Default Avatar" class="img-thumbnail"
                     style="width: 150px; height: 150px;">
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Avatar upload form -->
    <form method="post" action="UpdateEmployeeAvatar" enctype="multipart/form-data" class="mb-4 text-center">
        <input type="file" name="avatar" accept="image/*" required>
        <input type="hidden" name="employeeId" value="${employee.employeeId}"/>
        <button type="submit" class="genric-btn success circle mt-2">Update Avatar</button>
    </form>

    <form method="post" action="UpdateMyProfileEmployee">
        <input type="hidden" name="employeeId" value="${employee.employeeId}"/>
        <input type="hidden" name="employee_ava_url" value="${employee.employeeAvaUrl}"/>

        <div class="row">
            <div class="col-md-6">
                <div class="mb-3">
                    <label>Username</label>
                    <input type="text" class="form-control" value="${employee.username}" disabled/>
                </div>

                <div class="mb-3">
                    <label>Password</label>
                    <input type="password" class="form-control" value="${employee.passwordHash}" disabled/>
                </div>

                <div class="mb-3">
                    <label>Date of Birth</label>
                    <input type="date" class="form-control" name="dob" value="${employee.dob}"/>
                </div>

                <div class="mb-3">
                    <label>Phone</label>
                    <input type="text" class="form-control" name="phone" value="${employee.phone}"/>
                </div>
            </div>

            <div class="col-md-6">
                <div class="mb-3">
                    <label>Email</label>
                    <input type="email" class="form-control" value="${employee.email}" disabled/>
                </div>

                <div class="mb-3">
                    <label>Full Name</label>
                    <input type="text" class="form-control" name="fullName" value="${employee.fullName}"/>
                </div>

                <div class="mb-3">
                    <label>Gender</label>
                    <select class="form-select" name="gender">
                        <option value="M" ${employee.gender == 'M' ? 'selected' : ''}>Male</option>
                        <option value="F" ${employee.gender == 'F' ? 'selected' : ''}>Female</option>
                        <option value="O" ${employee.gender == 'O' ? 'selected' : ''}>Other</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="text-center mt-4">
            <button type="submit" class="genric-btn success circle">Update My Profile</button>
        </div>
    </form>

    <!-- Extra action -->
    <div class="text-center mt-4">
        <a href="change-password" class="genric-btn success circle">Change Password</a>
    </div>
</div>

<jsp:include page="footer.jsp"/>
<jsp:include page="common-scripts.jsp"/>
</body>
</html>
