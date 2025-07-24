<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage Appointment Types - benhVienLmao</title>
  <!-- Bootstrap CSS for consistent styling -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  <!-- Custom admin CSS for green theme inspired by Thu Cuc hospital -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
  <style>
    /* Enhanced container styling */
    .container {
      max-width: 1200px;
      padding: 30px;
    }
    /* Header styling */
    h2 {
      color: #28a745;
      font-weight: 700;
      margin-bottom: 20px;
    }
    /* Add New button */
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
      width: 20%;
    }
    .search-table td:last-child {
      width: 80%;
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
    /* Pagination styling */
    .pagination {
      justify-content: center;
      margin-top: 20px;
    }
    .page-item.active .page-link {
      background-color: #28a745;
      border-color: #28a745;
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
      .btn-action {
        font-size: 0.8rem;
        padding: 5px 10px;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <!-- Page title -->
  <h2>Manage Appointment Types</h2>

  <!-- Success/Error messages -->
  <c:if test="${not empty successMessage}">
    <div class="alert alert-success" role="alert">
        ${successMessage}
    </div>
  </c:if>
  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger" role="alert">
        ${errorMessage}
    </div>
  </c:if>

  <!-- Add New button -->
  <a href="${pageContext.request.contextPath}/admin/appointments?action=add" class="btn btn-add-new mb-4">
    <i class="fas fa-plus me-2"></i>Add New Appointment Type
  </a>

  <!-- Search Form -->
  <form class="mb-4" method="get" action="${pageContext.request.contextPath}/admin/appointments">
    <input type="hidden" name="action" value="list">
    <table class="search-table">
      <tr>
        <td>Name</td>
        <td><input type="text" class="form-control" name="searchName" value="${searchName}"></td>
      </tr>
      <tr>
        <td>Price Range (VND)</td>
        <td>
          <div class="row">
            <div class="col-md-6">
              <input type="number" class="form-control" name="priceFrom" placeholder="From" value="${priceFrom}">
            </div>
            <div class="col-md-6">
              <input type="number" class="form-control" name="priceTo" placeholder="To" value="${priceTo}">
            </div>
          </div>
        </td>
      </tr>
      <tr>
        <td>Sort By</td>
        <td>
          <select class="form-select" name="sortBy">
            <option value="" ${empty sortBy ? 'selected' : ''}>Default</option>
            <option value="priceDesc" ${sortBy == 'priceDesc' ? 'selected' : ''}>Price (High to Low)</option>
            <option value="priceAsc" ${sortBy == 'priceAsc' ? 'selected' : ''}>Price (Low to High)</option>
            <option value="newest" ${sortBy == 'newest' ? 'selected' : ''}>Newest to Oldest</option>
            <option value="alphabetical" ${sortBy == 'alphabetical' ? 'selected' : ''}>Alphabetical (A-Z)</option>
          </select>
        </td>
      </tr>
      <tr>
        <td colspan="2" class="text-center">
          <button type="submit" class="btn btn-primary me-2"><i class="fas fa-search me-2"></i>Search</button>
          <a href="${pageContext.request.contextPath}/admin/appointments?action=list" class="btn btn-secondary">
            <i class="fas fa-undo me-2"></i>Reset
          </a>
        </td>
      </tr>
    </table>
  </form>

  <!-- Appointment Types Table -->
  <div class="table-container">
    <table class="table table-bordered mb-0">
      <thead>
      <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Description</th>
        <th>Price (VND)</th>
        <th>Actions</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="type" items="${appointmentTypes}">
        <tr>
          <td>${type.appointmentTypeId}</td>
          <td>${type.typeName}</td>
          <td>${type.description}</td>
          <td>${type.price}</td>
          <td>
            <a href="${pageContext.request.contextPath}/admin/appointments?action=edit&id=${type.appointmentTypeId}"
               class="btn btn-primary btn-action"><i class="fas fa-edit me-1"></i>Edit</a>
            <a href="${pageContext.request.contextPath}/admin/appointments?action=delete&id=${type.appointmentTypeId}&page=${currentPage}&searchName=${searchName}&priceFrom=${priceFrom}&priceTo=${priceTo}&sortBy=${sortBy}"
               class="btn btn-danger btn-action" onclick="return confirm('Are you sure you want to delete this appointment type?')">
              <i class="fas fa-trash me-1"></i>Delete</a>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty appointmentTypes}">
        <tr>
          <td colspan="5" class="text-center">No appointment types found.</td>
        </tr>
      </c:if>
      </tbody>
    </table>
  </div>

  <!-- Pagination -->
  <nav aria-label="Page navigation">
    <ul class="pagination">
      <c:if test="${currentPage > 1}">
        <li class="page-item">
          <a class="page-link" href="${pageContext.request.contextPath}/admin/appointments?action=list&page=${currentPage - 1}&searchName=${searchName}&priceFrom=${priceFrom}&priceTo=${priceTo}&sortBy=${sortBy}">Previous</a>
        </li>
      </c:if>
      <c:forEach begin="1" end="${totalPages}" var="i">
        <li class="page-item ${currentPage == i ? 'active' : ''}">
          <a class="page-link" href="${pageContext.request.contextPath}/admin/appointments?action=list&page=${i}&searchName=${searchName}&priceFrom=${priceFrom}&priceTo=${priceTo}&sortBy=${sortBy}">${i}</a>
        </li>
      </c:forEach>
      <c:if test="${currentPage < totalPages}">
        <li class="page-item">
          <a class="page-link" href="${pageContext.request.contextPath}/admin/appointments?action=list&page=${currentPage + 1}&searchName=${searchName}&priceFrom=${priceFrom}&priceTo=${priceTo}&sortBy=${sortBy}">Next</a>
        </li>
      </c:if>
    </ul>
  </nav>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>