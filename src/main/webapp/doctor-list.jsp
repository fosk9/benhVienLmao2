<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor List</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
</head>
<body>

<jsp:include page="header.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">Doctor List</h2>

    <!-- Search / Filter / Sort Form -->
    <form method="get" action="DoctorList" class="row g-3 mb-4">
        <div class="col-md-3">
            <input type="text" name="search" class="form-control" placeholder="Search by name or email...">
        </div>
        <div class="col-md-2">
            <select name="gender" class="form-select">
                <option value="">Filter by gender</option>
                <option value="M">Male</option>
                <option value="F">Female</option>
            </select>
        </div>
        <div class="col-md-3">
            <select name="specialization" class="form-select">
                <option value="">Filter by specialization</option>
                <c:forEach var="spec" items="${specializations}">
                    <option value="${spec.specializationId}">${spec.name}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-2">
            <select name="sortBy" class="form-select">
                <option value="">Sort by</option>
                <option value="full_name">Full Name</option>
                <option value="dob">Date of Birth</option>
                <option value="email">Email</option>
            </select>
        </div>
        <div class="col-md-2">
            <select name="sortDir" class="form-select">
                <option value="asc">Ascending</option>
                <option value="desc">Descending</option>
            </select>
        </div>
        <div class="col-md-12 text-end">
            <button type="submit" class="btn btn-primary">Apply</button>
        </div>
    </form>

    <!-- Doctor Table -->
    <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle text-center">
            <thead class="table-light">
            <tr>
                <th>ID</th>
                <th>Full Name</th>
                <th>Date of Birth</th>
                <th>Gender</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Specialization</th>
                <th>Details</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="doc" items="${doctors}">
                <tr>
                    <td>${doc.employeeId}</td>
                    <td>${doc.fullName}</td>
                    <td><fmt:formatDate value="${doc.dob}" pattern="dd/MM/yyyy"/></td>
                    <td>
                        <c:choose>
                            <c:when test="${doc.gender == 'M'}">Male</c:when>
                            <c:when test="${doc.gender == 'F'}">Female</c:when>
                            <c:otherwise>Other</c:otherwise>
                        </c:choose>
                    </td>
                    <td>${doc.email}</td>
                    <td>${doc.phone}</td>
                    <td>
                        <c:forEach var="spec" items="${specializations}">
                            <c:if test="${spec.specializationId == doc.specializationId}">
                                ${spec.name}
                            </c:if>
                        </c:forEach>
                    </td>
                    <td>
                        <a href="DoctorDetails?id=${doc.employeeId}" class="btn btn-sm btn-outline-info">View</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="footer.jsp"/>
<script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>
