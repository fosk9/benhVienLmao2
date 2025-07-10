<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage System Items - benhVienLmao</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
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
  <h2>Manage System Items</h2>
  <a href="${pageContext.request.contextPath}/admin/system-items?action=add" class="btn btn-success mb-3">Add New Item</a>

  <!-- Search Form (styled like content) -->
  <form class="mb-4" method="get" action="${pageContext.request.contextPath}/admin/system-items">
    <input type="hidden" name="action" value="list">
    <table class="search-table">
      <tr>
        <td>Name</td>
        <td><input type="text" class="form-control" name="searchName" value="${param.searchName}"></td>
      </tr>
      <tr>
        <td>URL</td>
        <td><input type="text" class="form-control" name="searchUrl" value="${param.searchUrl}"></td>
      </tr>
      <tr>
        <td>Type</td>
        <td>
          <select class="form-select" name="searchType">
            <option value="">All Types</option>
            <option value="Feature" ${param.searchType == 'Feature' ? 'selected' : ''}>Feature</option>
            <option value="Navigation" ${param.searchType == 'Navigation' ? 'selected' : ''}>Navigation</option>
          </select>
        </td>
      </tr>
      <tr>
        <td style="text-align:center;"><button type="submit" class="btn btn-primary">Search</button></td>
        <td style="text-align:center;"><a href="${pageContext.request.contextPath}/admin/system-items?action=list" class="btn btn-secondary">Reset</a></td>
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
            <th>Name</th>
            <th>URL</th>
            <th>Display Order</th>
            <th>Type</th>
            <th>Roles</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach var="item" items="${items}">
          <tr>
            <td>${item.itemId}</td>
            <td>${item.itemName}</td>
            <td>${item.itemUrl}</td>
            <td>${item.displayOrder}</td>
            <td>${item.itemType}</td>
            <td>
              <c:forEach var="role" items="${itemRolesMap[item.itemId]}">
                <span class="badge bg-info text-dark">${role.roleName}</span>
              </c:forEach>
              <c:if test="${empty itemRolesMap[item.itemId]}">
                <span class="text-muted">None</span>
              </c:if>
            </td>
            <td>
              <a href="${pageContext.request.contextPath}/admin/system-items?action=edit&id=${item.itemId}" class="btn btn-primary btn-sm">Edit</a>
              <a href="${pageContext.request.contextPath}/admin/system-items?action=delete&id=${item.itemId}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</a>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty items}">
          <tr>
            <td colspan="7" class="text-center">No items found.</td>
          </tr>
        </c:if>
        </tbody>
      </table>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>