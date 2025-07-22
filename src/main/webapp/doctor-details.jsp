<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor Details</title>
    <jsp:include page="common-css.jsp"/>
</head>
<body>

<jsp:include page="doctor-header.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">Doctor Details</h2>
    <a href="DoctorList" class="btn btn-outline-primary">Back to List</a>

    <!-- Message Notification -->
    <c:if test="${not empty message}">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
                ${message}
        </div>
    </c:if>

    <c:if test="${not empty doctor}">
        <div class="mb-4 text-center">
            <c:choose>
                <c:when test="${not empty doctor.employeeAvaUrl}">
                    <img src="${doctor.employeeAvaUrl}" alt="Avatar" class="img-thumbnail"
                         style="width: 150px; height: 150px; object-fit: cover;">
                </c:when>
                <c:otherwise>
                    <img src="assets/img/default-avatar.png" alt="Default Avatar" class="img-thumbnail"
                         style="width: 150px; height: 150px;">
                </c:otherwise>
            </c:choose>
        </div>

        <form action="update-doctor-details" method="post">
            <input type="hidden" name="employeeId" value="${doctor.employeeId}"/>
            <input type="hidden" name="employeeAvaUrl" value="${doctor.employeeAvaUrl}"/>
            <input type="hidden" name="roleId" value="${doctor.roleId}"/>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label>Username</label>
                    <input type="text" class="form-control" value="${doctor.username}" readonly/>
                    <input type="hidden" name="username" value="${doctor.username}"/>
                </div>

                <div class="col-md-6 mb-3">
                    <label>Password</label>
                    <input type="password" class="form-control" value="${doctor.passwordHash}" readonly/>
                    <input type="hidden" name="passwordHash" value="${doctor.passwordHash}"/>
                </div>

                <div class="col-md-6 mb-3">
                    <label>Email</label>
                    <input type="email" class="form-control" value="${doctor.email}" readonly/>
                    <input type="hidden" name="email" value="${doctor.email}"/>
                </div>

                <div class="col-md-6 mb-3">
                    <label>Full Name</label>
                    <input type="text" class="form-control" name="fullName" value="${doctor.fullName}" required/>
                    <c:if test="${not empty fieldErrors.fullName}">
                        <small class="text-danger">${fieldErrors.fullName}</small>
                    </c:if>
                </div>

                <div class="col-md-6 mb-3">
                    <label>Date of Birth</label>
                    <input type="date" class="form-control" name="dob" value="${doctor.dob}"/>
                    <c:if test="${not empty fieldErrors.dob}">
                        <small class="text-danger">${fieldErrors.dob}</small>
                    </c:if>
                </div>

                <div class="col-md-6 mb-3">
                    <label>Gender</label>
                    <select class="form-select" name="gender">
                        <option value="M" ${doctor.gender == 'M' ? 'selected' : ''}>Male</option>
                        <option value="F" ${doctor.gender == 'F' ? 'selected' : ''}>Female</option>
                        <option value="O" ${doctor.gender == 'O' ? 'selected' : ''}>Other</option>
                    </select>
                </div>

                <div class="col-md-6 mb-3">
                    <label>Phone</label>
                    <input type="text" class="form-control" name="phone" value="${doctor.phone}"/>
                    <c:if test="${not empty fieldErrors.phone}">
                        <small class="text-danger">${fieldErrors.phone}</small>
                    </c:if>
                </div>
                <div class="col-md-6 mb-3">
                    <label>License Number</label>
                    <input type="text" class="form-control" name="licenseNumber" value="${doctorDetail.licenseNumber}"
                           required/>
                    <c:if test="${not empty fieldErrors.fullName}">
                        <small class="text-danger">${fieldErrors.licenseNumber}</small>
                    </c:if>
                </div>

                <div class="col-md-6 mb-3">
                    <label>Is Specialist</label><br>
                    <input type="checkbox" name="isSpecialist" ${doctorDetail.specialist ? "checked" : ""}/> Yes
                </div>

                <div class="col-md-6 mb-3">
                    <label>Rating</label>
                    <input type="number" class="form-control" name="rating" step="0.01" min="1.00" max="5.00"
                           value="${doctorDetail.rating}" readonly/>
                </div>

            </div>

            <div class="d-flex gap-3 mt-4">
                <button type="submit" class="btn btn-success">Update Doctor Details</button>
            </div>
        </form>
    </c:if>

    <c:if test="${empty doctor}">
        <div class="alert alert-warning">Doctor not found.</div>
    </c:if>
</div>

<jsp:include page="footer.jsp"/>
<jsp:include page="common-scripts.jsp"/>
</body>
</html>
