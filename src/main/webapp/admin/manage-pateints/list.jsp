<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage Patients - benhVienLmao</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<header class="admin-header py-3 mb-4">
  <div class="container d-flex justify-content-between align-items-center">
    <a href="${pageContext.request.contextPath}/admin/home" class="btn btn-light btn-sm">Home</a>
    <div>
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-light btn-sm">Logout</a>
    </div>
  </div>
</header>
<body>
<div class="container mt-5">
  <h2>Manage Patients</h2>
  <a href="${pageContext.request.contextPath}/admin/managePatients?action=add" class="btn btn-success mb-3">Add New Patient</a>

  <!-- Search Form -->
  <form class="mb-4" method="get" action="${pageContext.request.contextPath}/admin/managePatients">
    <input type="hidden" name="action" value="list">
    <table class="search-table">
      <tr>
        <td>Name</td>
        <td><input type="text" class="form-control" name="searchName" value="${param.searchName}"></td>
      </tr>
      <tr>
        <td>Email</td>
        <td><input type="text" class="form-control" name="searchEmail" value="${param.searchEmail}"></td>
      </tr>
      <tr>
        <td>Username</td>
        <td><input type="text" class="form-control" name="searchUsername" value="${param.searchUsername}"></td>
      </tr>
      <tr>
        <td>Gender</td>
        <td>
          <select class="form-select" name="searchGender">
            <option value="">All</option>
            <option value="M" ${param.searchGender == 'M' ? 'selected' : ''}>Male</option>
            <option value="F" ${param.searchGender == 'F' ? 'selected' : ''}>Female</option>
          </select>
        </td>
      </tr>
      <tr>
        <td style="text-align:center;"><button type="submit" class="btn btn-primary">Search</button></td>
        <td style="text-align:center;"><a href="${pageContext.request.contextPath}/admin/managePatients?action=list" class="btn btn-secondary">Reset</a></td>
      </tr>
    </table>
  </form>
  <!-- End Search Form -->

  <div class="card">
    <div class="card-body p-0">
      <table class="table table-bordered mb-0">
        <thead class="table-light">
          <tr>
            <th>ID</th>
            <th>Avatar</th>
            <th>Full Name</th>
            <th>Username</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Gender</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach var="user" items="${users}">
          <tr>
            <td>${user.patientId}</td>
            <td>
              <c:if test="${not empty user.patientAvaUrl}">
                <img src="${pageContext.request.contextPath}/${user.patientAvaUrl}" style="max-width:40px;"/>
              </c:if>
            </td>
            <td>${user.fullName}</td>
            <td>${user.username}</td>
            <td>${user.email}</td>
            <td>${user.phone}</td>
            <td>
              <c:choose>
                <c:when test="${user.gender == 'M'}">Male</c:when>
                <c:when test="${user.gender == 'F'}">Female</c:when>
                <c:otherwise></c:otherwise>
              </c:choose>
            </td>
            <td>
              <a href="${pageContext.request.contextPath}/admin/managePatients?action=edit&id=${user.patientId}" class="btn btn-primary btn-sm">Edit</a>
              <a href="${pageContext.request.contextPath}/admin/managePatients?action=delete&id=${user.patientId}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</a>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty users}">
          <tr>
            <td colspan="8" class="text-center">No patients found.</td>
          </tr>
        </c:if>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Pagination controls -->
  <c:if test="${totalPages > 1}">
    <nav>
      <ul class="pagination">
        <li class="page-item <c:if test='${currentPage == 1}'>disabled</c:if>">
          <a class="page-link" href="?action=list&page=${currentPage - 1}">Previous</a>
        </li>
        <c:forEach begin="1" end="${totalPages}" var="i">
          <li class="page-item <c:if test='${currentPage == i}'>active</c:if>">
            <a class="page-link" href="?action=list&page=${i}">${i}</a>
          </li>
        </c:forEach>
        <li class="page-item <c:if test='${currentPage == totalPages}'>disabled</c:if>">
          <a class="page-link" href="?action=list&page=${currentPage + 1}">Next</a>
        </li>
      </ul>
    </nav>
  </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>