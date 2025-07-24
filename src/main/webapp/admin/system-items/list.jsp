<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage System Items - benhVienLmao</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  <style>
    /* Enhanced container styling */
    .container {
      max-width: 1400px;
      padding: 30px;
    }
    /* Header styling */
    h2 {
      color: #28a745;
      font-weight: 700;
      margin-bottom: 20px;
    }
    /* Add New Item button */
    .btn-add-new {
      background-color: #28a745;
      border-color: #28a745;
      padding: 10px 20px;
      font-weight: 600;
      transition: background-color 0.3s, transform 0.2s;
    }
    .btn-add-new:hover {
      background-color: #218838;
      transform: translateY(-2px);
    }
    /* Search form styling */
    .search-table {
      background-color: #f8f9fa;
      border: 2px solid #28a745;
      border-radius: 15px;
      padding: 20px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }
    .search-table td {
      padding: 10px;
    }
    .search-table td:first-child {
      color: #28a745;
      font-weight: 600;
      font-size: 1.1rem;
      text-align: right;
      width: 30%;
    }
    .search-table td:last-child {
      width: 70%;
    }
    .search-table .form-control, .search-table .form-select {
      border: 1px solid #28a745;
      font-size: 1rem;
      height: 38px;
      border-radius: 8px;
    }
    .search-table .btn {
      padding: 8px 20px;
      font-size: 1rem;
      border-radius: 8px;
    }
    /* Table styling */
    .table-container {
      border-radius: 15px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }
    .table {
      margin-bottom: 0;
    }
    .table thead th {
      background-color: #28a745;
      color: white;
      font-weight: 600;
      padding: 12px;
      text-align: center;
    }
    .table tbody tr {
      transition: background-color 0.2s;
    }
    .table tbody tr:hover {
      background-color: #f1f8f1;
    }
    .table td {
      vertical-align: middle;
      padding: 12px;
      text-align: center;
    }
    .table .roles-column {
      max-width: 200px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    /* Action buttons */
    .btn-action {
      padding: 6px 12px;
      font-size: 0.9rem;
      margin: 0 5px;
      border-radius: 8px;
      transition: transform 0.2s;
    }
    .btn-action:hover {
      transform: translateY(-2px);
    }
    /* Responsive adjustments */
    @media (max-width: 768px) {
      .search-table {
        padding: 15px;
      }
      .search-table td:first-child {
        font-size: 1rem;
        text-align: left;
      }
      .search-table .form-control, .search-table .form-select {
        font-size: 0.9rem;
        height: 35px;
      }
      .table td, .table th {
        font-size: 0.9rem;
        padding: 8px;
      }
      .btn-action {
        font-size: 0.8rem;
        padding: 5px 10px;
      }
      .table .roles-column {
        max-width: 150px;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <h2>Manage System Items</h2>
  <a href="${pageContext.request.contextPath}/admin/system-items?action=add" class="btn btn-add-new mb-4">
    <i class="fas fa-plus me-2"></i>Add New Item
  </a>

  <!-- Search Form -->
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
        <td colspan="2" class="text-center">
          <button type="submit" class="btn btn-primary me-2"><i class="fas fa-search me-2"></i>Search</button>
          <a href="${pageContext.request.contextPath}/admin/system-items?action=list" class="btn btn-secondary">
            <i class="fas fa-undo me-2"></i>Reset
          </a>
        </td>
      </tr>
    </table>
  </form>
  <!-- End Search Form -->

  <div class="table-container">
    <table class="table table-bordered mb-0">
      <thead>
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
          <td class="roles-column">
            <c:forEach var="role" items="${itemRolesMap[item.itemId]}">
              <span class="badge bg-info text-dark">${role.roleName}</span>
            </c:forEach>
            <c:if test="${empty itemRolesMap[item.itemId]}">
              <span class="text-muted">None</span>
            </c:if>
          </td>
          <td>
            <a href="${pageContext.request.contextPath}/admin/system-items?action=edit&id=${item.itemId}"
               class="btn btn-primary btn-action"><i class="fas fa-edit me-1"></i>Edit</a>
            <a href="${pageContext.request.contextPath}/admin/system-items?action=delete&id=${item.itemId}"
               class="btn btn-danger btn-action" onclick="return confirm('Are you sure?')"><i class="fas fa-trash me-1"></i>Delete</a>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>