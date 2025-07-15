<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Edit User - benhVienLmao</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<div class="container mt-5">
  <h2>Edit User</h2>
  <form action="${pageContext.request.contextPath}/admin/manageEmployees" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="edit">
    <input type="hidden" name="id" value="${user.employeeId}">
    <div class="mb-3">
      <label for="fullName" class="form-label">Full Name</label>
      <input type="text" class="form-control" id="fullName" name="fullName" value="${user.fullName}" required>
    </div>
    <div class="mb-3">
      <label for="username" class="form-label">Username</label>
      <input type="text" class="form-control" id="username" name="username" value="${user.username}" required>
    </div>
    <div class="mb-3">
      <label for="password" class="form-label">Password (leave blank to keep current)</label>
      <input type="password" class="form-control" id="password" name="password">
    </div>
    <div class="mb-3">
      <label for="email" class="form-label">Email</label>
      <input type="email" class="form-control" id="email" name="email" value="${user.email}">
    </div>
    <div class="mb-3">
      <label for="phone" class="form-label">Phone</label>
      <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}">
    </div>
    <div class="mb-3">
      <label for="roleId" class="form-label">Role</label>
      <select class="form-select" id="roleId" name="roleId" required>
        <c:forEach var="role" items="${roles}">
          <option value="${role.roleId}" ${role.roleId == user.roleId ? 'selected' : ''}>${role.roleName}</option>
        </c:forEach>
      </select>
    </div>
    <div class="mb-3">
      <label for="employeeAvaUrl" class="form-label">Avatar</label>
      <input type="file" class="form-control" id="employeeAvaUrl" name="employeeAvaUrl" accept=".jpg,.jpeg,.png">
      <c:if test="${not empty user.employeeAvaUrl}">
        <img src="${pageContext.request.contextPath}/${user.employeeAvaUrl}" style="max-width:50px;"/>
        <input type="hidden" name="existingAvaUrl" value="${user.employeeAvaUrl}">
      </c:if>
    </div>
    <button type="submit" class="btn btn-success">Save Changes</button>
    <a href="${pageContext.request.contextPath}/admin/manageEmployees?action=list" class="btn btn-secondary">Cancel</a>
  </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>