<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage Patients - benhVienLmao</title>
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
    /* Add New Patient button */
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
    .table img {
      max-width: 50px;
      border-radius: 50%;
      object-fit: cover;
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
  <h2>Manage Patients</h2>
  <a href="${pageContext.request.contextPath}/admin/managePatients?action=add" class="btn btn-add-new mb-4">
    <i class="fas fa-user-plus me-2"></i>Add New Patient
  </a>

  <!-- Search Form -->
  <form class="mb-4" method="get" action="${pageContext.request.contextPath}/admin/managePatients">
    <input type="hidden" name="action" value="list">
    <table class="search-table">
      <tr>
        <td>Name</td>
        <td><input type="text" class="form-control" name="searchName" value="${param.searchName}"></td>
      </tr>
      <tr>
        <td>Email</td>
        <td><input type="text" class="form-control" name="searchEmail" value="${param.searchEmail}"></td>
      </tr>
      <tr>
        <td>Username</td>
        <td><input type="text" class="form-control" name="searchUsername" value="${param.searchUsername}"></td>
      </tr>
      <tr>
        <td>Gender</td>
        <td>
          <select class="form-select" name="searchGender">
            <option value="">All</option>
            <option value="M" ${param.searchGender == 'M' ? 'selected' : ''}>Male</option>
            <option value="F" ${param.searchGender == 'F' ? 'selected' : ''}>Female</option>
          </select>
        </td>
      </tr>
      <tr>
        <td colspan="2" class="text-center">
          <button type="submit" class="btn btn-primary me-2"><i class="fas fa-search me-2"></i>Search</button>
          <a href="${pageContext.request.contextPath}/admin/managePatients?action=list" class="btn btn-secondary">
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
        <th>Avatar</th>
        <th>Full Name</th>
        <th>Username</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Gender</th>
        <th>Actions</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="user" items="${users}">
        <tr>
          <td>${user.patientId}</td>
          <td>
            <c:if test="${not empty user.patientAvaUrl}">
              <img src="${pageContext.request.contextPath}/${user.patientAvaUrl}" alt="Patient Avatar"/>
            </c:if>
          </td>
          <td>${user.fullName}</td>
          <td>${user.username}</td>
          <td>${user.email}</td>
          <td>${user.phone}</td>
          <td>
            <c:choose>
              <c:when test="${user.gender == 'M'}"><span class="badge bg-primary">Male</span></c:when>
              <c:when test="${user.gender == 'F'}"><span class="badge bg-pink">Female</span></c:when>
              <c:otherwise><span class="badge bg-secondary">N/A</span></c:otherwise>
            </c:choose>
          </td>
          <td>
            <a href="${pageContext.request.contextPath}/admin/managePatients?action=edit&id=${user.patientId}"
               class="btn btn-primary btn-action"><i class="fas fa-edit me-1"></i>Edit</a>
            <a href="${pageContext.request.contextPath}/admin/managePatients?action=delete&id=${user.patientId}"
               class="btn btn-danger btn-action" onclick="return confirm('Are you sure?')"><i class="fas fa-trash me-1"></i>Delete</a>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty users}">
        <tr>
          <td colspan="8" class="text-center">No patients found.</td>
        </tr>
      </c:if>
      </tbody>
    </table>
  </div>

  <!-- Pagination controls -->
  <c:if test="${totalPages > 1}">
    <nav>
      <ul class="pagination">
        <li class="page-item <c:if test='${currentPage == 1}'>disabled</c:if>">
          <a class="page-link" href="?action=list&page=${currentPage - 1}"><i class="fas fa-chevron-left"></i></a>
        </li>
        <c:forEach begin="1" end="${totalPages}" var="i">
          <li class="page-item <c:if test='${currentPage == i}'>active</c:if>">
            <a class="page-link" href="?action=list&page=${i}">${i}</a>
          </li>
        </c:forEach>
        <li class="page-item <c:if test='${currentPage == totalPages}'>disabled</c:if>">
          <a class="page-link" href="?action=list&page=${currentPage + 1}"><i class="fas fa-chevron-right"></i></a>
        </li>
      </ul>
    </nav>
  </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>