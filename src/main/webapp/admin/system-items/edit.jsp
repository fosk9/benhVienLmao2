<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Edit System Item - benhVienLmao</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<div class="container mt-5">
  <h2>Edit System Item</h2>
  <form action="${pageContext.request.contextPath}/admin/system-items" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="edit">
    <input type="hidden" name="id" value="${item.itemId}">
    <div class="mb-3">
      <label for="itemName" class="form-label">Name</label>
      <input type="text" class="form-control" id="itemName" name="itemName" value="${item.itemName}" required>
    </div>
    <div class="mb-3">
      <label for="itemUrl" class="form-label">URL</label>
      <input type="text" class="form-control" id="itemUrl" name="itemUrl" value="${item.itemUrl}">
    </div>
    <div class="mb-3">
      <label for="imageFile" class="form-label">Image</label>
      <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*">
      <c:if test="${not empty item.imageUrl}">
        <img src="${pageContext.request.contextPath}/${item.imageUrl}" alt="${item.itemName}" width="100" class="mt-2">
        <input type="hidden" name="existingImageUrl" value="${item.imageUrl}">
      </c:if>
    </div>
    <div class="mb-3">
      <label for="isActive" class="form-label">Active</label>
      <select class="form-select" id="isActive" name="isActive">
        <option value="true" ${item.active ? 'selected' : ''}>Yes</option>
        <option value="false" ${!item.active ? 'selected' : ''}>No</option>
      </select>
    </div>
    <div class="mb-3">
      <label for="displayOrder" class="form-label">Display Order</label>
      <input type="number" class="form-control" id="displayOrder" name="displayOrder" value="${item.displayOrder}">
    </div>
    <div class="mb-3">
      <label for="parentItemId" class="form-label">Parent Item</label>
      <select class="form-select" id="parentItemId" name="parentItemId">
        <option value="">None</option>
        <c:forEach var="parent" items="${allItems}">
          <option value="${parent.itemId}" ${parent.itemId == item.parentItemId ? 'selected' : ''}>${parent.itemName}</option>
        </c:forEach>
      </select>
    </div>
    <div class="mb-3">
      <label for="itemType" class="form-label">Type</label>
      <select class="form-select" id="itemType" name="itemType" required>
        <option value="Feature" ${item.itemType == 'Feature' ? 'selected' : ''}>Feature</option>
        <option value="Navigation" ${item.itemType == 'Navigation' ? 'selected' : ''}>Navigation</option>
      </select>
    </div>
    <button type="submit" class="btn btn-success">Save Changes</button>
    <a href="${pageContext.request.contextPath}/admin/system-items" class="btn btn-secondary">Cancel</a>
  </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>