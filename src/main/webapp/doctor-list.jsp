<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor List</title>
    <jsp:include page="common-css.jsp"/>
</head>
<body>

<jsp:include page="header.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">Doctor List</h2>

    <!-- Search / Filter / Sort Form -->
    <form method="get" action="DoctorList" class="row g-3 mb-4">

        <div class="col-md-2">
            <input type="number" name="recordsPerPage" class="form-control" min="1" max="100"
                   placeholder="Records per page" value="${param.recordsPerPage != null ? param.recordsPerPage : 10}">
        </div>

        <div class="col-md-3">
            <input type="text" name="search" class="form-control"
                   placeholder="Search by name or email..." value="${param.search != null ? param.search : ''}">
        </div>
        <div class="col-md-2">
            <select name="gender" class="form-select">
                <option value="" ${empty param.gender ? 'selected' : ''}>Filter by gender</option>
                <option value="M" ${param.gender == 'M' ? 'selected' : ''}>Male</option>
                <option value="F" ${param.gender == 'F' ? 'selected' : ''}>Female</option>
            </select>
        </div>
        <div class="col-md-3">
            <select name="specialization" class="form-select">
                <option value="" ${empty param.specialization ? 'selected' : ''}>Filter by specialization</option>
                <c:forEach var="spec" items="${specializations}">
                    <option value="${spec.specializationId}" ${param.specialization == spec.specializationId.toString() ? 'selected' : ''}>
                            ${spec.name}
                    </option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-2">
            <select name="sortBy" class="form-select">
                <option value="" ${empty param.sortBy ? 'selected' : ''}>Sort by</option>
                <option value="full_name" ${param.sortBy == 'full_name' ? 'selected' : ''}>Full Name</option>
                <option value="dob" ${param.sortBy == 'dob' ? 'selected' : ''}>Date of Birth</option>
                <option value="email" ${param.sortBy == 'email' ? 'selected' : ''}>Email</option>
            </select>
        </div>
        <div class="col-md-2">
            <select name="sortDir" class="form-select">
                <option value="asc" ${param.sortDir == 'asc' ? 'selected' : ''}>Ascending</option>
                <option value="desc" ${param.sortDir == 'desc' ? 'selected' : ''}>Descending</option>
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
    <c:if test="${totalPages > 1}">
        <nav class="mt-4">
            <ul class="pagination justify-content-center">
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <c:url var="pageUrl" value="DoctorList">
                            <c:param name="page" value="${i}"/>
                            <c:param name="recordsPerPage" value="${recordsPerPage}"/>
                            <c:param name="search" value="${param.search}"/>
                            <c:param name="gender" value="${param.gender}"/>
                            <c:param name="specialization" value="${param.specialization}"/>
                            <c:param name="sortBy" value="${param.sortBy}"/>
                            <c:param name="sortDir" value="${param.sortDir}"/>
                        </c:url>
                        <a class="page-link" href="${pageUrl}">${i}</a>
                    </li>
                </c:forEach>
            </ul>
        </nav>
    </c:if>

</div>

<jsp:include page="footer.jsp"/>
<jsp:include page="common-scripts.jsp"/>

</body>
</html>