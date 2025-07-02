<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Add Page Content - benhVienLmao</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<div class="container mt-5">
  <h2>Add New Page Content</h2>
  <form action="${pageContext.request.contextPath}/admin/contents" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="add">
    <!-- Page Name input -->
    <div class="mb-3">
      <label for="pageName" class="form-label">Page Name</label>
      <input type="text" class="form-control" id="pageName" name="pageName" value="${content.pageName}" required placeholder="e.g. index, about, contact">
    </div>
    <div class="mb-3">
      <label for="contentKey" class="form-label">Content Key</label>
      <input type="text" class="form-control" id="contentKey" name="contentKey" required>
    </div>
    <div class="mb-3">
      <label for="contentValue" class="form-label">Content Value</label>
      <textarea class="form-control" id="contentValue" name="contentValue"></textarea>
    </div>
    <div class="mb-3">
      <label for="isActive" class="form-label">Active</label>
      <select class="form-select" id="isActive" name="isActive">
        <option value="true">Active</option>
        <option value="false">Inactive</option>
      </select>
    </div>
    <div class="mb-3">
      <label for="imageFile" class="form-label">Image</label>
      <input type="file" class="form-control" id="imageFile" name="imageFile" accept=".jpg,.jpeg,.png">
      <c:if test="${not empty imageError}">
        <div class="text-danger">${imageError}</div>
      </c:if>
    </div>
    <div class="mb-3">
      <label for="videoUrl" class="form-label">Video URL</label>
      <input type="text" class="form-control" id="videoUrl" name="videoUrl">
    </div>
    <div class="mb-3">
      <label for="buttonUrl" class="form-label">Button URL</label>
      <input type="text" class="form-control" id="buttonUrl" name="buttonUrl">
    </div>
    <div class="mb-3">
      <label for="buttonText" class="form-label">Button Text</label>
      <input type="text" class="form-control" id="buttonText" name="buttonText">
    </div>
    <button type="submit" class="btn btn-success">Add Content</button>
    <a href="${pageContext.request.contextPath}/admin/contents?action=list" class="btn btn-secondary">Cancel</a>
  </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>