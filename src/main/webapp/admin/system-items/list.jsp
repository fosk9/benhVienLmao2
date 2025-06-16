<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage System Items - benhVienLmao</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<div class="container mt-5">
  <h2>Manage System Items</h2>
  <a href="${pageContext.request.contextPath}/admin/system-items?action=add" class="btn btn-success mb-3">Add New Item</a>
  <table class="table table-bordered">
    <thead>
    <tr>
      <th>ID</th>
      <th>Name</th>
      <th>URL</th>
      <th>Image</th>
      <th>Active</th>
      <th>Display Order</th>
      <th>Parent ID</th>
      <th>Type</th>
      <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="item" items="${items}">
      <tr>
        <td>${item.itemId}</td>
        <td>${item.itemName}</td>
        <td>${item.itemUrl}</td>
        <td>
          <c:if test="${not empty item.imageUrl}">
            <img src="${pageContext.request.contextPath}/${item.imageUrl}" alt="${item.itemName}" width="50">
          </c:if>
        </td>
        <td>${item.active ? 'Yes' : 'No'}</td>
        <td>${item.displayOrder}</td>
        <td>${item.parentItemId}</td>
        <td>${item.itemType}</td>
        <td>
          <a href="${pageContext.request.contextPath}/admin/system-items?action=edit&id=${item.itemId}" class="btn btn-primary btn-sm">Edit</a>
          <a href="${pageContext.request.contextPath}/admin/system-items?action=delete&id=${item.itemId}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</a>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>