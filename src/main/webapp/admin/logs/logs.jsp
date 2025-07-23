<%--
  Created by IntelliJ IDEA.
  User: Fosk Jesky
  Date: 7/23/2025
  Time: 12:57 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Admin Logs - benhVienLmao</title>
  <!-- Bootstrap CSS for responsive and styled components -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  <!-- Custom admin CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
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
    /* Real-time log section */
    .realtime-log-container {
      margin-top: 30px;
      border: 2px solid #28a745;
      border-radius: 15px;
      padding: 20px;
      background-color: #f8f9fa;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }
    .realtime-log-container textarea {
      width: 100%;
      border: 1px solid #28a745;
      border-radius: 8px;
      font-size: 1rem;
      padding: 10px;
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
      .realtime-log-container textarea {
        font-size: 0.9rem;
      }
    }
  </style>
</head>
<body>
<!-- Real-time Log Viewer -->
<div class="realtime-log-container">
  <h2>Real-time Log Viewer</h2>
  <jsp:include page="adminLog.jsp"/>
</div>

<div class="container">
  <!-- Page title -->
  <h2>Log System History</h2>

  <!-- Search Form -->
  <form method="get" action="${pageContext.request.contextPath}/admin/logs">
    <table class="search-table">
      <tr>
        <td>Username</td>
        <td><input type="text" class="form-control" name="username" value="${param.username}"></td>
      </tr>
      <tr>
        <td>Date From</td>
        <td><input type="date" class="form-control" name="fromDate" value="${param.fromDate}"></td>
      </tr>
      <tr>
        <td>Date To</td>
        <td><input type="date" class="form-control" name="toDate" value="${param.toDate}"></td>
      </tr>
      <tr>
        <td>Role</td>
        <td>
          <select class="form-select" name="role">
            <option value="">All Roles</option>
            <option value="Patient" ${param.role == 'Patient' ? 'selected' : ''}>Patient</option>
            <option value="Employee" ${param.role == 'Employee' ? 'selected' : ''}>Employee</option>
          </select>
        </td>
      </tr>
      <tr>
        <td>Log Level</td>
        <td>
          <select class="form-select" name="logLevel">
            <option value="">All Levels</option>
            <option value="INFO" ${param.logLevel == 'INFO' ? 'selected' : ''}>INFO</option>
            <option value="WARN" ${param.logLevel == 'WARN' ? 'selected' : ''}>WARN</option>
            <option value="ERROR" ${param.logLevel == 'ERROR' ? 'selected' : ''}>ERROR</option>
            <option value="DEBUG" ${param.logLevel == 'DEBUG' ? 'selected' : ''}>DEBUG</option>
          </select>
        </td>
      </tr>
      <tr>
        <td>Sort Order</td>
        <td>
          <select class="form-select" name="sortOrder">
            <option value="Newest First" ${param.sortOrder == 'Newest First' ? 'selected' : ''}>Newest First</option>
            <option value="Oldest First" ${param.sortOrder == 'Oldest First' ? 'selected' : ''}>Oldest First</option>
          </select>
        </td>
      </tr>
      <tr>
        <td colspan="2" class="text-center">
          <button type="submit" class="btn btn-primary me-2"><i class="fas fa-search me-2"></i>Search</button>
          <a href="${pageContext.request.contextPath}/admin/logs" class="btn btn-secondary">
            <i class="fas fa-undo me-2"></i>Reset
          </a>
        </td>
      </tr>
    </table>
  </form>
  <!-- End Search Form -->

  <!-- Log History Table -->
  <div class="table-container">
    <table class="table table-bordered mb-0">
      <thead>
      <tr>
        <th>ID</th>
        <th>User</th>
        <th>Role</th>
        <th>Action</th>
        <th>Level</th>
        <th>Created At</th>
      </tr>
      </thead>
      <tbody id="logBody">
      <c:forEach var="l" items="${logs}">
        <tr>
          <td>${l.logId}</td>
          <td>${l.userName}</td>
          <td>${l.roleName}</td>
          <td>${l.action}</td>
          <td>${l.logLevel}</td>
          <td>${l.createdAt}</td>
        </tr>
      </c:forEach>
      <c:if test="${empty logs}">
        <tr>
          <td colspan="6" class="text-center">No logs found.</td>
        </tr>
      </c:if>
      </tbody>
    </table>
  </div>

</div>

</body>
</html>