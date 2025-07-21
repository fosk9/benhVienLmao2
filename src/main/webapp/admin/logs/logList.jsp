<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>System Logs - benhVienLmao</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  <style>
    /* Container styling */
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
    /* Pagination styling */
    .pagination {
      justify-content: center;
      margin-top: 20px;
    }
    .pagination .page-link {
      color: #28a745;
      border: 1px solid #28a745;
      margin: 0 5px;
      border-radius: 8px;
    }
    .pagination .page-item.active .page-link {
      background-color: #28a745;
      border-color: #28a745;
      color: white;
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
    }
  </style>
</head>
<body>
<div class="container">
  <h2>System Logs</h2>

  <!-- Search Form -->
  <form class="mb-4" method="get" action="${pageContext.request.contextPath}/admin/logs">
    <table class="search-table">
      <tr>
        <td>Username</td>
        <td><input type="text" class="form-control" name="username" value="${param.username}" placeholder="Search by username"></td>
      </tr>
      <tr>
        <td>Date Range</td>
        <td>
          <input type="date" class="form-control d-inline-block w-auto me-2" name="startDate" value="${param.startDate}">
          to
          <input type="date" class="form-control d-inline-block w-auto ms-2" name="endDate" value="${param.endDate}">
        </td>
      </tr>
      <tr>
        <td>Sort Order</td>
        <td>
          <select class="form-select" name="sortOrder">
            <option value="newest" ${param.sortOrder == 'newest' ? 'selected' : ''}>Newest First</option>
            <option value="oldest" ${param.sortOrder == 'oldest' ? 'selected' : ''}>Oldest First</option>
          </select>
        </td>
      </tr>
      <tr>
        <td>Role</td>
        <td>
          <select class="form-select" name="roleName">
            <option value="">All Roles</option>
            <option value="Doctor" ${param.roleName == 'Doctor' ? 'selected' : ''}>Doctor</option>
            <option value="Receptionist" ${param.roleName == 'Receptionist' ? 'selected' : ''}>Receptionist</option>
            <option value="Admin" ${param.roleName == 'Admin' ? 'selected' : ''}>Admin</option>
            <option value="Manager" ${param.roleName == 'Manager' ? 'selected' : ''}>Manager</option>
            <option value="Patient" ${param.roleName == 'Patient' ? 'selected' : ''}>Patient</option>
          </select>
        </td>
      </tr>
      <tr>
        <td>Log Level</td>
        <td>
          <select class="form-select" name="logLevel">
            <option value="">All Levels</option>
            <option value="INFO" ${param.logLevel == 'INFO' ? 'selected' : ''}>INFO</option>
            <option value="ERROR" ${param.logLevel == 'ERROR' ? 'selected' : ''}>ERROR</option>
            <option value="WARN" ${param.logLevel == 'WARN' ? 'selected' : ''}>WARN</option>
          </select>
        </td>
      </tr>
      <tr>
        <td colspan="2" class="text-center">
          <button type="submit" class="btn btn-primary me-2"><i class="fas fa-search me-2"></i>Search</button>
          <a href="${pageContext.request.contextPath}/admin/logs" class="btn btn-secondary"><i class="fas fa-undo me-2"></i>Reset</a>
        </td>
      </tr>
    </table>
  </form>
  <!-- End Search Form -->

  <div class="table-container">
    <table class="table table-bordered mb-0">
      <thead>
      <tr>
        <th>Log ID</th>
        <th>Username</th>
        <th>User ID</th>
        <th>Role</th>
        <th>Action</th>
        <th>Log Level</th>
        <th>Created At</th>
      </tr>
      </thead>
      <tbody id="logTableBody">
      <c:forEach var="log" items="${logs}">
        <tr>
          <td>${log.logId}</td>
          <td>${log.userName}</td>
          <td>
            <c:choose>
              <c:when test="${log.employeeId != null}">${log.employeeId} (Employee)</c:when>
              <c:when test="${log.patientId != null}">${log.patientId} (Patient)</c:when>
              <c:otherwise>System</c:otherwise>
            </c:choose>
          </td>
          <td>${log.roleName}</td>
          <td>${log.action}</td>
          <td>${log.logLevel}</td>
          <td>${log.createdAt}</td>
        </tr>
      </c:forEach>
      <c:if test="${empty logs}">
        <tr>
          <td colspan="7" class="text-center">No logs found.</td>
        </tr>
      </c:if>
      </tbody>
    </table>
  </div>

  <!-- Pagination -->
  <c:if test="${totalPages > 1}">
    <nav aria-label="Page navigation">
      <ul class="pagination">
        <c:if test="${currentPage > 1}">
          <li class="page-item">
            <a class="page-link" href="?page=${currentPage - 1}&username=${param.username}&startDate=${param.startDate}&endDate=${param.endDate}&sortOrder=${param.sortOrder}&roleName=${param.roleName}&logLevel=${param.logLevel}">« Previous</a>
          </li>
        </c:if>
        <c:forEach begin="1" end="${totalPages}" var="i">
          <li class="page-item ${i == currentPage ? 'active' : ''}">
            <a class="page-link" href="?page=${i}&username=${param.username}&startDate=${param.startDate}&endDate=${param.endDate}&sortOrder=${param.sortOrder}&roleName=${param.roleName}&logLevel=${param.logLevel}">${i}</a>
          </li>
        </c:forEach>
        <c:if test="${currentPage < totalPages}">
          <li class="page-item">
            <a class="page-link" href="?page=${currentPage + 1}&username=${param.username}&startDate=${param.startDate}&endDate=${param.endDate}&sortOrder=${param.sortOrder}&roleName=${param.roleName}&logLevel=${param.logLevel}">Next »</a>
          </li>
        </c:if>
      </ul>
    </nav>
  </c:if>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/log-realtime.js"></script>
<script>
  // Initialize WebSocket for real-time updates
  const ws = new WebSocket('ws://' + window.location.host + '${pageContext.request.contextPath}/ws/logs');
  ws.onmessage = function(event) {
    if (event.data === 'new_log') {
      updateLogs(${latestLogId});
    }
  };
</script>
</body>
</html>