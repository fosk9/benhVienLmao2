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
    /* Add New Content button */
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
    .table .content-value {
      max-width: 300px;
      white-space: pre-line;
      word-break: break-word;
      text-align: left;
    }
    .table img {
      max-width: 60px;
      border-radius: 5px;
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
    /* Pagination */
    .pagination {
      margin-top: 20px;
      justify-content: center;
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
      .table img {
        max-width: 40px;
      }
      .btn-action {
        font-size: 0.8rem;
        padding: 5px 10px;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <h2>Manage Page Content</h2>
  <a href="${pageContext.request.contextPath}/admin/contents?action=add" class="btn btn-add-new mb-4">
    <i class="fas fa-plus me-2"></i>Add New Content
  </a>

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
        <td><input type="text" class="form-control" name="searchValue" value="${param.searchValue}"></td>
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
        <td colspan="2" class="text-center">
          <button type="submit" class="btn btn-primary me-2"><i class="fas fa-search me-2"></i>Search</button>
          <a href="${pageContext.request.contextPath}/admin/contents?action=list" class="btn btn-secondary">
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
          <td class="content-value">${content.contentValue}</td>
          <td>
            <c:choose>
              <c:when test="${content.active}"><span class="badge bg-success">Active</span></c:when>
              <c:otherwise><span class="badge bg-secondary">Inactive</span></c:otherwise>
            </c:choose>
          </td>
          <td>
            <c:if test="${not empty content.imageUrl}">
              <img src="${pageContext.request.contextPath}/${content.imageUrl}" alt="Content Image"/>
            </c:if>
          </td>
          <td>
            <c:if test="${not empty content.videoUrl}">
              <a href="${content.videoUrl}" target="_blank" class="text-success"><i class="fas fa-video me-1"></i>Video</a>
            </c:if>
          </td>
          <td>
            <c:if test="${not empty content.buttonUrl}">
              <a href="${content.buttonUrl}" target="_blank" class="text-success">${content.buttonUrl}</a>
            </c:if>
          </td>
          <td>${content.buttonText}</td>
          <td>
            <a href="${pageContext.request.contextPath}/admin/contents?action=edit&id=${content.contentId}"
               class="btn btn-primary btn-action"><i class="fas fa-edit me-1"></i>Edit</a>
            <a href="${pageContext.request.contextPath}/admin/contents?action=delete&id=${content.contentId}"
               class="btn btn-danger btn-action" onclick="return confirm('Are you sure?')"><i class="fas fa-trash me-1"></i>Delete</a>
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

  <!-- Pagination controls -->
  <c:if test="${totalPages > 1}">
    <nav>
      <ul class="pagination justify-content-center">
        <c:if test="${currentPage > 1}">
          <li class="page-item">
            <a class="page-link" href="?page=${currentPage - 1}">Previous</a>
          </li>
        </c:if>
        <c:forEach begin="1" end="${totalPages}" var="i">
          <li class="page-item ${i == currentPage ? 'active' : ''}">
            <a class="page-link" href="?page=${i}">${i}</a>
          </li>
        </c:forEach>
        <c:if test="${currentPage < totalPages}">
          <li class="page-item">
            <a class="page-link" href="?page=${currentPage + 1}">Next</a>
          </li>
        </c:if>
      </ul>
    </nav>

  </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>