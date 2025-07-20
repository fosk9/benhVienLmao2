<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage Users - benhVienLmao</title>
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
  <h2>Manage Users</h2>
  <a href="${pageContext.request.contextPath}/admin/manageEmployees?action=add" class="btn btn-success mb-3">Add New User</a>

  <!-- Search Form -->
  <form class="mb-4" method="get" action="${pageContext.request.contextPath}/admin/manageEmployees">
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
        <td>Role</td>
        <td>
          <select class="form-select" name="searchRoleId">
            <option value="">All</option>
            <c:forEach var="role" items="${roles}">
              <option value="${role.roleId}" ${param.searchRoleId == role.roleId ? 'selected' : ''}>${role.roleName}</option>
            </c:forEach>
          </select>
        </td>
      </tr>
      <tr>
        <td style="text-align:center;"><button type="submit" class="btn btn-primary">Search</button></td>
        <td style="text-align:center;"><a href="${pageContext.request.contextPath}/admin/manageEmployees?action=list" class="btn btn-secondary">Reset</a></td>
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
            <th>Role</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach var="user" items="${users}">
          <tr>
            <td>${user.employeeId}</td>
            <td>
              <c:if test="${not empty user.employeeAvaUrl}">
                <img src="${pageContext.request.contextPath}/${user.employeeAvaUrl}" style="max-width:40px;"/>
              </c:if>
            </td>
            <td>${user.fullName}</td>
            <td>${user.username}</td>
            <td>${user.email}</td>
            <td>${user.phone}</td>
            <td>
              <c:forEach var="role" items="${roles}">
                <c:if test="${role.roleId == user.roleId}">${role.roleName}</c:if>
              </c:forEach>
            </td>
            <td>
              <a href="${pageContext.request.contextPath}/admin/manageEmployees?action=edit&id=${user.employeeId}" class="btn btn-primary btn-sm">Edit</a>
              <a href="${pageContext.request.contextPath}/admin/manageEmployees?action=delete&id=${user.employeeId}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</a>
              <a href="${pageContext.request.contextPath}/admin/manageEmployees?action=history&id=${user.employeeId}" class="btn btn-info btn-sm">History</a>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty users}">
          <tr>
            <td colspan="8" class="text-center">No users found.</td>
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