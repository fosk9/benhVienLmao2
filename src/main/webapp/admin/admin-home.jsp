<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard - benhVienLmao</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  <style>
    .admin-card {
      transition: transform 0.2s;
    }
    .admin-card:hover {
      transform: translateY(-5px);
    }
    .admin-header {
      background-color: #28a745;
      color: white;
    }
  </style>
</head>
<body>
<div class="container-fluid">
  <!-- Header -->
  <header class="admin-header py-3 mb-4">
    <div class="container d-flex justify-content-between align-items-center">
      <h1 class="h3 mb-0">Admin Dashboard</h1>
      <div>
        <span class="me-3">Welcome, ${fullName}</span>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-light btn-sm">Logout</a>
      </div>
    </div>
  </header>

  <!-- Main Content -->
  <div class="container">
    <h2 class="mb-4">Admin Features</h2>
    <div class="row">
      <c:forEach var="feature" items="${adminFeatures}">
        <div class="col-md-4 col-sm-6 mb-4">
          <div class="card admin-card h-100">
            <div class="card-body text-center">
              <h5 class="card-title">${feature.itemName}</h5>
              <p class="card-text">Access ${feature.itemName} functionality.</p>
              <a href="${pageContext.request.contextPath}/${feature.itemUrl}" class="btn btn-success">Go to ${feature.itemName}</a>
            </div>
          </div>
        </div>
      </c:forEach>
      <c:if test="${empty adminFeatures}">
        <div class="col-12">
          <div class="alert alert-info">No features available for your role.</div>
        </div>
      </c:if>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>