<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Add System Item - benhVienLmao</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<div class="container mt-5">
  <h2>Add New System Item</h2>
  <form action="${pageContext.request.contextPath}/admin/system-items" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="add">
    <div class="mb-3">
      <label for="itemName" class="form-label">Name</label>
      <input type="text" class="form-control" id="itemName" name="itemName" required>
    </div>
    <div class="mb-3">
      <label for="itemUrl" class="form-label">URL</label>
      <input type="text" class="form-control" id="itemUrl" name="itemUrl">
    </div>
    <div class="mb-3">
      <label for="imageFile" class="form-label">Image</label>
      <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*">
    </div>
    <div class="mb-3">
      <label for="isActive" class="form-label">Active</label>
      <select class="form-select" id="isActive" name="isActive">
        <option value="true">Yes</option>
        <option value="false">No</option>
      </select>
    </div>
    <div class="mb-3">
      <label for="displayOrder" class="form-label">Display Order</label>
      <input type="number" class="form-control" id="displayOrder" name="displayOrder">
    </div>
    <div class="mb-3">
      <label for="parentItemId" class="form-label">Parent Item</label>
      <select class="form-select" id="parentItemId" name="parentItemId">
        <option value="">None</option>
        <c:forEach var="item" items="${allItems}">
          <option value="${item.itemId}">${item.itemName}</option>
        </c:forEach>
      </select>
    </div>
    <div class="mb-3">
      <label for="itemType" class="form-label">Type</label>
      <select class="form-select" id="itemType" name="itemType" required>
        <option value="Feature">Feature</option>
        <option value="Navigation">Navigation</option>
      </select>
    </div>
    <button type="submit" class="btn btn-success">Add Item</button>
    <a href="${pageContext.request.contextPath}/admin/system-items" class="btn btn-secondary">Cancel</a>
  </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>