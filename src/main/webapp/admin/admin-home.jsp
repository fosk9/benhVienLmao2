<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> <!-- Add this for string functions like contains -->
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard - benhVienLmao</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  <style>
    /* Ensure full height for html and body */
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
    }
    /* Custom styles for sidebar */
    .sidebar {
      border-right: 2px solid #28a745; /* Green border */
      background-color: #f8f9fa;
      width: 250px; /* Fixed narrow width for sidebar */
      height: 100%; /* Full height of the parent */
      flex-shrink: 0; /* Prevent sidebar from shrinking */
    }
    /* Style for navigation links */
    .nav-pills .nav-link.active {
      background-color: #28a745;
      color: white;
    }
    .nav-pills .nav-link {
      color: #28a745;
    }
    .nav-pills .nav-link:hover {
      background-color: #f1f8f1;
    }
    /* Content area styling */
    .content-area {
      flex-grow: 1; /* Take up remaining space */
      height: 100%; /* Full height */
      overflow-y: auto;
    }
    /* Ensure container fills entire viewport */
    .container-fluid-1 {
      display: flex;
      flex-direction: row;
      height: 100vh;
      width: 100%;
    }
  </style>
</head>
<body>
<div class="container-fluid-1 p-0">
  <!-- Flex container for sidebar and content -->
  <div class="sidebar">
    <nav class="nav flex-column nav-pills h-100 py-3">
      <h4 class="px-3 mb-3 text-success">Admin Features</h4>
      <c:forEach var="feature" items="${adminFeatures}">
        <li class="nav-item">
          <c:choose>
            <c:when test="${fn:contains(feature.itemUrl, 'http') or fn:contains(feature.itemUrl, 'https')}">
              <!-- External links (e.g., PayOS): Open in new tab, no iframe loading, no active class dependency on currentPage -->
              <a class="nav-link" href="${feature.itemUrl}" target="_blank">
                  ${feature.itemName}
              </a>
            </c:when>
            <c:otherwise>
              <!-- Internal links: Load via servlet param and iframe as before -->
              <a class="nav-link ${feature.itemUrl eq currentPage ? 'active' : ''}"
                 href="${pageContext.request.contextPath}/admin/home?page=${feature.itemUrl}">
                  ${feature.itemName}
              </a>
            </c:otherwise>
          </c:choose>
        </li>
      </c:forEach>
      <c:if test="${empty adminFeatures}">
        <li class="nav-item">
          <div class="alert alert-info mx-3">No features available for your role.</div>
        </li>
      </c:if>
      <!-- Logout at the bottom -->
      <li class="nav-item mt-auto">
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger w-100">Logout</a>
      </li>
    </nav>
  </div>
  <!-- Part B: Dynamic Content (only for internal pages) -->
  <div class="content-area">
    <c:if test="${not empty currentPage and not fn:contains(currentPage, 'http') and not fn:contains(currentPage, 'https')}">
      <iframe src="${pageContext.request.contextPath}/${currentPage}"
              width="100%" height="100%" frameborder="0" style="border: none;"></iframe>
    </c:if>
    <c:if test="${empty currentPage}">
      <div class="d-flex justify-content-center align-items-center h-100">
        <div class="alert alert-info">Select a feature from the sidebar.</div>
      </div>
    </c:if>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>