<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage Page Content - benhVienLmao</title>
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
  <h2>Manage Page Content</h2>
  <a href="${pageContext.request.contextPath}/admin/contents?action=add" class="btn btn-success mb-3">Add New Content</a>

  <!-- Search Form -->
  <form class="mb-4" method="get" action="${pageContext.request.contextPath}/admin/contents">
    <input type="hidden" name="action" value="list">
    <table class="search-table">
      <tr>
        <td>Page Name</td>
        <td><input type="text" class="form-control" name="searchPageName" value="${param.searchPageName}"></td>
      </tr>
      <tr>
        <td>Content Key</td>
        <td><input type="text" class="form-control" name="searchKey" value="${param.searchKey}"></td>
      </tr>
      <tr>
        <td>Content Value</td>
        <td><input type="text" class="form-control" value="${param.searchValue}"></td>
      </tr>
      <tr>
        <td>Active</td>
        <td>
          <select class="form-select" name="searchActive">
            <option value="">All</option>
            <option value="true" ${param.searchActive == 'true' ? 'selected' : ''}>Active</option>
            <option value="false" ${param.searchActive == 'false' ? 'selected' : ''}>Inactive</option>
          </select>
        </td>
      </tr>
      <tr>
        <td>Video URL</td>
        <td><input type="text" class="form-control" name="searchVideoUrl" value="${param.searchVideoUrl}"></td>
      </tr>
      <tr>
        <td>Button URL</td>
        <td><input type="text" class="form-control" name="searchButtonUrl" value="${param.searchButtonUrl}"></td>
      </tr>
      <tr>
        <td>Button Text</td>
        <td><input type="text" class="form-control" name="searchButtonText" value="${param.searchButtonText}"></td>
      </tr>
      <tr>
        <td style="text-align:center;"><button type="submit" class="btn btn-primary">Search</button></td>
        <td style="text-align:center;"><a href="${pageContext.request.contextPath}/admin/contents?action=list" class="btn btn-secondary">Reset</a></td>
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
            <th>Page Name</th>
            <th>Content Key</th>
            <th>Content Value</th>
            <th>Active</th>
            <th>Image</th>
            <th>Video URL</th>
            <th>Button URL</th>
            <th>Button Text</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach var="content" items="${contents}">
          <tr>
            <td>${content.contentId}</td>
            <td>${content.pageName}</td>
            <td>${content.contentKey}</td>
            <td>
              <div style="max-width:300px; white-space:pre-line; word-break:break-word;">
                ${content.contentValue}
              </div>
            </td>
            <td>
              <c:choose>
                <c:when test="${content.active}"><span class="badge bg-success">Active</span></c:when>
                <c:otherwise><span class="badge bg-secondary">Inactive</span></c:otherwise>
              </c:choose>
            </td>
            <td>
              <c:if test="${not empty content.imageUrl}">
                <img src="${pageContext.request.contextPath}/${content.imageUrl}" style="max-width:50px;"/>
              </c:if>
            </td>
            <td>
              <c:if test="${not empty content.videoUrl}">
                <a href="${content.videoUrl}" target="_blank">Video</a>
              </c:if>
            </td>
            <td>
              <c:if test="${not empty content.buttonUrl}">
                <a href="${content.buttonUrl}" target="_blank">${content.buttonUrl}</a>
              </c:if>
            </td>
            <td>${content.buttonText}</td>
            <td>
              <a href="${pageContext.request.contextPath}/admin/contents?action=edit&id=${content.contentId}" class="btn btn-primary btn-sm">Edit</a>
              <a href="${pageContext.request.contextPath}/admin/contents?action=delete&id=${content.contentId}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</a>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty contents}">
          <tr>
            <td colspan="10" class="text-center">No content found.</td>
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