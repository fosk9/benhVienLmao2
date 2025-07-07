<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Edit Page Content - benhVienLmao</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<div class="container mt-5">
  <h2>Edit Page Content</h2>
  <form action="${pageContext.request.contextPath}/admin/page-content" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="edit">
    <input type="hidden" name="id" value="${content.contentId}">
    <input type="hidden" name="pageName" value="${pageName}">
    <div class="mb-3">
      <label for="pageName" class="form-label">Page Name</label>
      <input type="text" class="form-control" id="pageName" name="pageName" value="${content.pageName}" required>
    </div>
    <div class="mb-3">
      <label for="contentKey" class="form-label">Content Key</label>
      <input type="text" class="form-control" id="contentKey" name="contentKey" value="${content.contentKey}" required>
    </div>
    <div class="mb-3">
      <label for="contentValue" class="form-label">Content Value</label>
      <textarea class="form-control" id="contentValue" name="contentValue" rows="4" required>${content.contentValue}</textarea>
    </div>
    <div class="mb-3">
      <label for="imageFile" class="form-label">Background Image</label>
      <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*">
      <c:if test="${not empty content.imageUrl}">
        <img src="${pageContext.request.contextPath}/${content.imageUrl}" alt="Current Image" width="100" class="mt-2">
        <input type="hidden" name="existingImageUrl" value="${content.imageUrl}">
      </c:if>
    </div>
    <div class="mb-3">
      <label for="videoUrl" class="form-label">Video URL</label>
      <input type="text" class="form-control" id="videoUrl" name="videoUrl" value="${content.videoUrl}" placeholder="e.g., https://www.youtube.com/watch?v=...">
    </div>
    <div class="mb-3">
      <label for="buttonUrl" class="form-label">Button URL</label>
      <input type="text" class="form-control" id="buttonUrl" name="buttonUrl" value="${content.buttonUrl}" placeholder="e.g., book-appointment">
    </div>
    <div class="mb-3">
      <label for="buttonText" class="form-label">Button Text</label>
      <input type="text" class="form-control" id="buttonText" name="buttonText" value="${content.buttonText}" placeholder="e.g., Explore Dental Services">
    </div>
    <div class="mb-3">
      <label for="isActive" class="form-label">Active</label>
      <select class="form-select" id="isActive" name="isActive">
        <option value="true" ${content.isActive ? 'selected' : ''}>Yes</option>
        <option value="false" ${!content.isActive ? 'selected' : ''}>No</option>
      </select>
    </div>
    <button type="submit" class="btn btn-success">Save Changes</button>
    <a href="${pageContext.request.contextPath}/admin/page-content?pageName=${pageName}" class="btn btn-secondary">Cancel</a>
  </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>