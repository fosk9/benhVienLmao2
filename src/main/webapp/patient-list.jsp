<%--
  Created by IntelliJ IDEA.
  User: ADMIN
  Date: 5/27/2025
  Time: 7:16 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Patient List</title>
  <jsp:include page="doctor-common-css.jsp"/>
</head>
<body>

<jsp:include page="doctor-header.jsp"/>

<div class="container mt-5">
  <h2 class="mb-4">Patient List</h2>

  <!-- Filter/Search/Sort Form -->
  <form method="get" action="PatientList" class="row g-3 mb-4">
    <div class="col-md-3">
      <input type="text" name="search" class="form-control"
             placeholder="Search by name or email..."
             value="${param.search}"/>
    </div>

    <div class="col-md-2">
      <select name="gender" class="form-select">
        <option value="">Filter by gender</option>
        <option value="M" ${param.gender == 'M' ? 'selected' : ''}>Male</option>
        <option value="F" ${param.gender == 'F' ? 'selected' : ''}>Female</option>
      </select>
    </div>

    <div class="col-md-3">
      <select name="sortBy" class="form-select">
        <option value="">Sort by</option>
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

    <div class="col-md-2">
      <button type="submit" class="btn btn-primary w-100">Apply</button>
    </div>
  </form>


  <!-- Patient Table -->
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
        <th>Details</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="p" items="${patients}">
        <tr>
          <td>${p.patientId}</td>
          <td>${p.fullName}</td>
          <td><fmt:formatDate value="${p.dob}" pattern="dd/MM/yyyy"/></td>
          <td>
            <c:choose>
              <c:when test="${p.gender == 'M'}">Male</c:when>
              <c:when test="${p.gender == 'F'}">Female</c:when>
              <c:otherwise>Other</c:otherwise>
            </c:choose>
          </td>
          <td>${p.email}</td>
          <td>${p.phone}</td>
          <td>
            <a href="PatientDetails?id=${p.patientId}" class="btn btn-sm btn-outline-info">View</a>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<jsp:include page="doctor-footer.jsp"/>
<jsp:include page="doctor-common-scripts.jsp"/>

</body>
</html>
