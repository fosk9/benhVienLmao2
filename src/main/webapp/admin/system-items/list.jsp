<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage Page Content - benhVienLmao</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<div class="container mt-5">
  <h2>Manage Page Content</h2>
  <a href="${pageContext.request.contextPath}/admin/page-content?action=add&pageName=${pageName}" class="btn btn-success mb-3">Add New Content</a>
  <table class="table table-bordered">
    <thead>
    <tr>
      <th>ID</th>
      <th>Page Name</th>
      <th>Content Key</th>
      <th>Content Value</th>
      <th>Image</th>
      <th>Video URL</th>
      <th>Button URL</th>
      <th>Button Text</th>
      <th>Active</th>
      <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="content" items="${contents}">
      <tr>
        <td>${content.contentId}</td>
        <td>${content.pageName}</td>
        <td>${content.contentKey}</td>
        <td>${content.contentValue}</td>
        <td>
          <c:if test="${not empty content.imageUrl}">
            <img src="${pageContext.request.contextPath}/${content.imageUrl}" alt="Image" width="50">
          </c:if>
        </td>
        <td>${content.videoUrl}</td>
        <td>${content.buttonUrl}</td>
        <td>${content.buttonText}</td>
        <td>${content.isActive ? 'Yes' : 'No'}</td>
        <td>
          <a href="${pageContext.request.contextPath}/admin/page-content?action=edit&id=${content.contentId}&pageName=${pageName}" class="btn btn-primary btn-sm">Edit</a>
          <a href="${pageContext.request.contextPath}/admin/page-content?action=delete&id=${content.contentId}&pageName=${pageName}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</a>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>