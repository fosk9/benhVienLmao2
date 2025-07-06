<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý Quyền Người Dùng - Hospital Admin</title>

  <!-- Bootstrap 4 CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen-Sans, Ubuntu, Cantarell, "Helvetica Neue", sans-serif;
      background-color: #f8f9fa;
      margin: 0;
    }

    /* Main Layout */
    .hospital-admin {
      display: flex;
      min-height: 100vh;
    }

    /* Sidebar */
    .sidebar {
      width: 280px;
      background: #ffffff;
      border-right: 1px solid #e9ecef;
      position: fixed;
      top: 0;
      left: 0;
      bottom: 0;
      overflow-y: auto;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }

    /* Hospital Logo Header */
    .hospital-header {
      padding: 24px 20px;
      border-bottom: 1px solid #e9ecef;
      background: #ffffff;
    }

    .hospital-logo {
      display: flex;
      align-items: center;
      margin-bottom: 8px;
    }

    .hospital-icon {
      width: 48px;
      height: 48px;
      background: #4285f4;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 12px;
    }

    .hospital-icon i {
      color: white;
      font-size: 24px;
    }

    .hospital-title {
      font-size: 20px;
      font-weight: 600;
      color: #1f2937;
      margin: 0;
    }

    .hospital-subtitle {
      color: #6b7280;
      font-size: 14px;
      margin: 0;
      margin-top: 4px;
    }

    /* Navigation Menu */
    .nav-menu {
      padding: 16px 0;
    }

    .nav-menu ul {
      margin: 0;
      padding: 0;
      list-style: none;
    }

    .nav-menu li {
      margin: 0;
    }

    .nav-menu a {
      display: flex;
      align-items: center;
      padding: 12px 20px;
      color: #6b7280;
      text-decoration: none;
      font-size: 15px;
      font-weight: 500;
      transition: all 0.2s ease;
      border-left: 3px solid transparent;
    }

    .nav-menu a:hover {
      background-color: #f3f4f6;
      color: #374151;
      text-decoration: none;
    }

    .nav-menu a.active {
      background-color: #dbeafe;
      color: #1d4ed8;
      border-left-color: #1d4ed8;
    }

    .nav-menu i {
      width: 20px;
      margin-right: 12px;
      font-size: 18px;
      text-align: center;
    }

    /* Main Content */
    .main-content {
      margin-left: 280px;
      flex: 1;
      background: #f8f9fa;
      min-height: 100vh;
    }

    .content-header {
      background: #ffffff;
      padding: 20px 24px;
      border-bottom: 1px solid #e9ecef;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }

    .content-body {
      padding: 24px;
    }

    /* Page Header */
    .page-header h1 {
      font-size: 28px;
      font-weight: 600;
      color: #1f2937;
      margin: 0;
    }

    .page-subtitle {
      color: #6b7280;
      font-size: 16px;
      margin-top: 4px;
    }

    /* Stats Cards */
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 24px;
      margin-bottom: 32px;
    }

    .stat-card {
      background: #ffffff;
      padding: 24px;
      border-radius: 12px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      border: 1px solid #e9ecef;
    }

    .stat-card-content {
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .stat-info h3 {
      font-size: 32px;
      font-weight: 700;
      margin: 0;
      margin-bottom: 4px;
    }

    .stat-info p {
      font-size: 14px;
      font-weight: 500;
      color: #6b7280;
      margin: 0;
    }

    .stat-icon {
      width: 48px;
      height: 48px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .stat-icon i {
      font-size: 24px;
    }

    .stat-blue { color: #4285f4; background: #e3f2fd; }
    .stat-green { color: #10b981; background: #d1fae5; }
    .stat-orange { color: #f59e0b; background: #fef3c7; }
    .stat-purple { color: #8b5cf6; background: #ede9fe; }

    /* Filter Section */
    .filter-section {
      background: #ffffff;
      padding: 24px;
      border-radius: 12px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      border: 1px solid #e9ecef;
      margin-bottom: 24px;
    }

    .filter-row {
      display: grid;
      grid-template-columns: 2fr 1fr 1fr auto;
      gap: 16px;
      align-items: end;
    }

    /* User Table */
    .user-table-container {
      background: #ffffff;
      border-radius: 12px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      border: 1px solid #e9ecef;
      overflow: hidden;
    }

    .table-header {
      padding: 20px 24px;
      border-bottom: 1px solid #e9ecef;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .table-header h3 {
      font-size: 18px;
      font-weight: 600;
      color: #1f2937;
      margin: 0;
    }

    .user-table {
      width: 100%;
      border-collapse: collapse;
    }

    .user-table th {
      background: #f8f9fa;
      padding: 16px 20px;
      text-align: left;
      font-weight: 600;
      color: #374151;
      font-size: 14px;
      border-bottom: 1px solid #e9ecef;
    }

    .user-table td {
      padding: 16px 20px;
      border-bottom: 1px solid #f3f4f6;
      vertical-align: middle;
    }

    .user-table tr:hover {
      background: #f9fafb;
    }

    .user-info {
      display: flex;
      align-items: center;
    }

    .user-avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      background: #e5e7eb;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 12px;
      font-weight: 600;
      color: #6b7280;
    }

    .user-details h4 {
      font-size: 14px;
      font-weight: 600;
      color: #1f2937;
      margin: 0 0 4px 0;
    }

    .user-details p {
      font-size: 12px;
      color: #6b7280;
      margin: 0;
    }

    /* Role Badges */
    .role-badge {
      display: inline-block;
      padding: 6px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 500;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .role-patient {
      background: #f3f4f6;
      color: #374151;
    }

    .role-doctor {
      background: #d1fae5;
      color: #065f46;
    }

    .role-assistant {
      background: #dbeafe;
      color: #1e40af;
    }

    .role-manager {
      background: #fef3c7;
      color: #92400e;
    }

    /* Role Select */
    .role-select {
      padding: 8px 12px;
      border: 1px solid #d1d5db;
      border-radius: 6px;
      font-size: 14px;
      background: #ffffff;
      min-width: 120px;
    }

    .role-select:focus {
      outline: none;
      border-color: #4285f4;
      box-shadow: 0 0 0 3px rgba(66, 133, 244, 0.1);
    }

    /* Buttons */
    .btn-hospital {
      display: inline-flex;
      align-items: center;
      padding: 8px 16px;
      font-size: 14px;
      font-weight: 500;
      border-radius: 8px;
      border: 1px solid #d1d5db;
      background: #ffffff;
      color: #374151;
      text-decoration: none;
      cursor: pointer;
      transition: all 0.2s ease;
      margin-right: 8px;
    }

    .btn-hospital:hover {
      background: #f9fafb;
      border-color: #9ca3af;
      text-decoration: none;
      color: #374151;
    }

    .btn-primary {
      background: #4285f4;
      border-color: #4285f4;
      color: #ffffff;
    }

    .btn-primary:hover {
      background: #3367d6;
      border-color: #3367d6;
      color: #ffffff;
    }

    .btn-success {
      background: #10b981;
      border-color: #10b981;
      color: #ffffff;
    }

    .btn-success:hover {
      background: #059669;
      border-color: #059669;
      color: #ffffff;
    }

    .btn-sm {
      padding: 6px 12px;
      font-size: 12px;
    }

    /* Form Controls */
    .form-control {
      width: 100%;
      height: auto;
      padding: 12px 16px;
      border: 1px solid #d1d5db;
      border-radius: 8px;
      font-size: 14px;
      transition: all 0.2s ease;
      background: #ffffff;
    }

    .form-control:focus {
      outline: none;
      border-color: #4285f4;
      box-shadow: 0 0 0 3px rgba(66, 133, 244, 0.1);
    }

    .form-group {
      margin-bottom: 16px;
    }

    .form-group label {
      display: block;
      margin-bottom: 6px;
      font-weight: 600;
      color: #374151;
      font-size: 14px;
    }

    /* Search Input */
    .search-wrapper {
      position: relative;
    }

    .search-wrapper i {
      position: absolute;
      left: 12px;
      top: 50%;
      transform: translateY(-50%);
      color: #9ca3af;
    }

    .search-wrapper input {
      padding-left: 40px;
    }

    /* Status Indicators */
    .status-indicator {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      display: inline-block;
      margin-right: 8px;
    }

    .status-online { background: #10b981; }
    .status-offline { background: #6b7280; }

    /* Alerts */
    .alert {
      padding: 16px;
      margin-bottom: 24px;
      border: 1px solid transparent;
      border-radius: 8px;
      font-size: 14px;
    }

    .alert-success {
      color: #065f46;
      background-color: #d1fae5;
      border-color: #a7f3d0;
    }

    .alert-danger {
      color: #991b1b;
      background-color: #fee2e2;
      border-color: #fecaca;
    }

    .alert-warning {
      color: #92400e;
      background-color: #fef3c7;
      border-color: #fde68a;
    }

    /* Modal Styles */
    .modal-content {
      border-radius: 12px;
      border: none;
      box-shadow: 0 10px 25px rgba(0,0,0,0.15);
    }

    .modal-header {
      border-bottom: 1px solid #e9ecef;
      padding: 20px 24px;
    }

    .modal-body {
      padding: 24px;
    }

    .modal-footer {
      border-top: 1px solid #e9ecef;
      padding: 16px 24px;
    }

    /* Empty State */
    .empty-state {
      text-align: center;
      padding: 48px 24px;
    }

    .empty-state i {
      font-size: 48px;
      color: #9ca3af;
      margin-bottom: 16px;
    }

    .empty-state h3 {
      font-size: 18px;
      font-weight: 600;
      color: #1f2937;
      margin-bottom: 8px;
    }

    .empty-state p {
      color: #6b7280;
      margin: 0;
    }

    /* Responsive */
    @media screen and (max-width: 768px) {
      .sidebar {
        width: 60px;
      }

      .main-content {
        margin-left: 60px;
      }

      .hospital-header {
        padding: 16px 12px;
      }

      .hospital-title,
      .hospital-subtitle {
        display: none;
      }

      .nav-menu a {
        padding: 16px 12px;
        justify-content: center;
      }

      .nav-menu span {
        display: none;
      }

      .nav-menu i {
        margin-right: 0;
      }

      .stats-grid {
        grid-template-columns: 1fr;
      }

      .filter-row {
        grid-template-columns: 1fr;
      }

      .content-body {
        padding: 16px;
      }

      .user-table-container {
        overflow-x: auto;
      }

      .user-table {
        min-width: 800px;
      }
    }
  </style>
</head>
<body>
<div class="hospital-admin">
  <!-- Sidebar -->
  <div class="sidebar">
    <!-- Hospital Header -->
    <div class="hospital-header">
      <div class="hospital-logo">
        <div class="hospital-icon">
          <a href="Admin/home-admin-dashboard.jsp">
            <i class="fas fa-stethoscope"></i>
          </a>
        </div>
        <div>
          <a href="Admin/home-admin-dashboard.jsp" style="text-decoration: none;">
            <h2 class="hospital-title">Hospital Admin</h2>
            <p class="hospital-subtitle">Quản lý bệnh viện</p>
          </a>
        </div>
      </div>
    </div>

    <!-- Navigation Menu -->
    <nav class="nav-menu">
      <ul>
        <li>
          <a href="Admin/home-admin-dashboard.jsp" class="nav-link">
            <i class="fas fa-home"></i>
            <span>Trang chủ</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/update-user-role" class="nav-link active">
            <i class="fas fa-users-cog"></i>
            <span>Quản lý quyền</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/blog-dashboard" class="nav-link">
            <i class="fas fa-blog"></i>
            <span>Blog</span>
          </a>
        </li>
        <li>
          <a href="#" class="nav-link">
            <i class="fas fa-podcast"></i>
            <span>Post</span>
          </a>
        </li>
        <li>
          <a href="#" class="nav-link">
            <i class="fas fa-cog"></i>
            <span>Cài đặt</span>
          </a>
        </li>
      </ul>
    </nav>
  </div>

  <!-- Main Content -->
  <div class="main-content">
    <!-- Content Header -->
    <div class="content-header">
      <div class="page-header">
        <div style="display: flex; align-items: center; justify-content: space-between;">
          <div>
            <h1>Quản lý Quyền Người Dùng</h1>
            <p class="page-subtitle">Thay đổi quyền từ bệnh nhân thành bác sĩ/trợ lý/quản lý</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Content Body -->
    <div class="content-body">
      <!-- Success/Error Messages -->
      <c:if test="${not empty successMessage}">
        <div class="alert alert-success">
          <i class="fas fa-check-circle mr-2"></i>${successMessage}
        </div>
      </c:if>
      <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">
          <i class="fas fa-exclamation-circle mr-2"></i>${errorMessage}
        </div>
      </c:if>

      <!-- Stats Cards -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-blue">${totalUsers}</h3>
              <p>Tổng người dùng</p>
            </div>
            <div class="stat-icon stat-blue">
              <i class="fas fa-users"></i>
            </div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-green">${totalDoctors}</h3>
              <p>Bác sĩ</p>
            </div>
            <div class="stat-icon stat-green">
              <i class="fas fa-user-md"></i>
            </div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-orange">${totalReceptionists}</h3>
              <p>Trợ lý</p>
            </div>
            <div class="stat-icon stat-orange">
              <i class="fas fa-user-nurse"></i>
            </div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-purple">${totalPatients}</h3>
              <p>Bệnh nhân</p>
            </div>
            <div class="stat-icon stat-purple">
              <i class="fas fa-procedures"></i>
            </div>
          </div>
        </div>
      </div>

      <form id="roleUpdateForm" action="update-user-role" method="get">
      <!-- Filter Section -->
      <div class="filter-section">
        <div class="filter-row">
          <div class="form-group">
            <label>Tìm kiếm</label>
            <div class="search-wrapper">
              <i class="fas fa-search"></i>
              <input type="text" class="form-control" name="keyword" id="keyword"
                     value="${param.search != null ? param.search : ''}" placeholder="Tìm kiếm theo tên, email hoặc số điện thoại...">
            </div>
          </div>

          <!-- Lọc theo quyền -->
          <div class="form-group">
            <label>Quyền</label>
            <select class="form-control" name="role">
              <option value="">Tất cả vai trò</option>
              <!-- Thêm thủ công "Patient" -->
              <option value="patient"
                      <c:if test="${param.role == 'patient'}">selected</c:if>>
                Patient
              </option>
              <c:forEach var="r" items="${allRoles}">
                <option value="${fn:toLowerCase(r.roleName)}"
                        <c:if test="${param.role == fn:toLowerCase(r.roleName)}">selected</c:if>>
                    ${r.roleName}
                </option>
              </c:forEach>
            </select>
          </div>

            <!-- Lọc theo trạng thái -->
          <div class="form-group">
            <label>Trạng thái</label>
            <select class="form-control" name="status" >
              <option value="">Tất cả</option>
              <option value="1" <c:if test="${param.status == '1'}">selected</c:if>>Hoạt động</option>
              <option value="0" <c:if test="${param.status == '0'}">selected</c:if>>Dừng hoạt động</option>
            </select>
          </div>

          <!-- Nút lọc -->
          <div class="form-group" style="margin-bottom: 20px">
            <label style="visibility: hidden;">Lọc</label>
            <button type="submit" class="btn-hospital btn-primary w-100">
              <i class="fas fa-filter mr-1"></i>Lọc
            </button>
          </div>

        </div>
      </div>
      </form>

      <!-- User Table -->
      <div class="user-table-container">
        <div class="table-header">
          <h3>Danh sách người dùng (<span id="userCount">${totalUsers}</span>)</h3>
          <div>
            <button class="btn-hospital btn-sm" onclick="clearSelection()">
              <i class="fas fa-times mr-1"></i>Bỏ chọn
            </button>
            <button type="submit" class="btn-hospital btn-sm btn-success">
              <i class="fas fa-save mr-1"></i>Lưu thay đổi
            </button>
          </div>
        </div>
        <!-- FORM CẬP NHẬT - DÙNG POST -->
        <form id="roleUpdateForm" action="update-user-role" method="post">
        <table class="user-table" id="userTable">
            <thead>
            <tr>
              <th>Người dùng</th>
              <th>Quyền hiện tại</th>
              <th>Quyền mới</th>
              <th>Trạng thái</th>
              <th>Trạng thái mới</th>
              <th>Ngày tham gia</th>
              <th>Thao tác</th>
            </tr>
            </thead>
            <tbody id="userTableBody">
            <c:forEach var="u" items="${userList}">
              <tr data-role="${fn:toLowerCase(u.roleName)}"
                  data-status="${u.accStatus}"
                  data-name="${fn:toLowerCase(u.fullName)}"
                  data-email="${fn:toLowerCase(u.email)}">

                <td>
                  <div class="user-info">
                    <div class="user-avatar">
                        ${fn:substring(u.fullName, 0, 1)}${fn:substring(u.fullName, fn:indexOf(u.fullName, ' ') + 1, fn:indexOf(u.fullName, ' ') + 2)}
                    </div>
                    <div class="user-details">
                      <h4>${u.fullName}</h4>
                      <p>${u.email} • ${u.phone}</p>
                    </div>
                  </div>
                </td>

                <td>
                  <span class="role-badge role-${fn:toLowerCase(u.roleName)}">${u.roleName}</span>
                </td>

                <td>
                  <select class="form-control" name="newRole_${u.userID}">
                    <c:forEach var="r" items="${allRoles}">
                      <option value="${fn:toLowerCase(r.roleName)}" <c:if test="${r.roleName == u.roleName}">selected</c:if>>
                          ${r.roleName}
                      </option>
                    </c:forEach>
                  </select>
                </td>

                <td>
            <span class="status-badge status-${u.accStatus == 1 ? 'active' : 'inactive'}">
              <c:choose>
                <c:when test="${u.accStatus == 1}">Hoạt động</c:when>
                <c:otherwise>Dừng hoạt động</c:otherwise>
              </c:choose>
            </span>
                </td>

                <td>
                  <select class="form-control" name="newStatus_${u.userID}">
                    <option value="1" <c:if test="${u.accStatus == 1}">selected</c:if>>Hoạt động</option>
                    <option value="0" <c:if test="${u.accStatus == 0}">selected</c:if>>Dừng hoạt động</option>
                  </select>
                </td>

                <td>
                  <fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy"/>
                </td>

                <td>
                  <div class="d-flex gap-1">
                    <!-- Nút Lưu -->
                    <button type="submit" class="btn-hospital btn-sm btn-success" name="action" value="update_${u.userID}">
                      <i class="fas fa-save mr-1"></i>Lưu
                    </button>

                    <!-- Nút Xóa -->
                    <button type="submit" class="btn-hospital btn-sm btn-danger"
                            name="action" value="delete_${u.userID}"
                            onclick="return confirm('Xác nhận xóa ${u.fullName}?');">
                      <i class="fas fa-trash mr-1"></i>Xóa
                    </button>
                  </div>
                </td>

              </tr>
            </c:forEach>
            </tbody>
          </table>
        </form>

        <!-- PHÂN TRANG -->
        <div class="pagination-container mt-4 text-center">
          <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
              <c:if test="${currentPage > 1}">
                <li class="page-item">
                  <a class="page-link"
                     href="update-user-role?page=${currentPage - 1
                       }&keyword=${fn:escapeXml(param.keyword)}&role=${fn:escapeXml(param.role)}&status=${fn:escapeXml(param.status)}">«</a>
                </li>
              </c:if>

              <c:forEach var="i" begin="1" end="${totalPages}">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                  <a class="page-link"
                     href="update-user-role?page=${i
                       }&keyword=${fn:escapeXml(param.keyword)}&role=${fn:escapeXml(param.role)}&status=${fn:escapeXml(param.status)}">${i}</a>
                </li>
              </c:forEach>

              <c:if test="${currentPage < totalPages}">
                <li class="page-item">
                  <a class="page-link"
                     href="update-user-role?page=${currentPage + 1
                       }&keyword=${fn:escapeXml(param.keyword)}&role=${fn:escapeXml(param.role)}&status=${fn:escapeXml(param.status)}">»</a>
                </li>
              </c:if>
            </ul>
          </nav>
        </div>


        <!-- Empty State (hidden by default) -->
        <div class="empty-state" id="emptyState" style="display: none;">
          <i class="fas fa-users"></i>
          <h3>Không tìm thấy người dùng nào</h3>
          <p>Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm</p>
        </div>
      </div>
    </div>
  </div>
</div>


<!-- Confirmation Modal for Role Update -->
<div class="modal fade" id="confirmModal" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Xác nhận thay đổi quyền</h5>
        <button type="button" class="close" data-dismiss="modal">
          <span>&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p>Bạn có chắc chắn muốn thay đổi quyền cho <span id="selectedCount">0</span> người dùng đã chọn?</p>
        <div class="alert alert-warning">
          <i class="fas fa-exclamation-triangle mr-2"></i>
          Thay đổi quyền sẽ ảnh hưởng đến khả năng truy cập của người dùng vào hệ thống.
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn-hospital" data-dismiss="modal">Hủy</button>
        <button type="button" class="btn-hospital btn-primary" onclick="confirmRoleUpdate()">
          <i class="fas fa-save mr-2"></i>Xác nhận
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Xác nhận xóa tài khoản</h5>
        <button type="button" class="close" data-dismiss="modal">
          <span>&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p>Bạn có chắc chắn muốn xóa tài khoản của <strong id="deleteUserName"></strong>?</p>
        <div class="alert alert-danger">
          <i class="fas fa-exclamation-triangle mr-2"></i>
          <strong>Cảnh báo:</strong> Hành động này không thể hoàn tác. Tất cả dữ liệu liên quan đến tài khoản này sẽ bị xóa vĩnh viễn.
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn-hospital" data-dismiss="modal">Hủy</button>
        <button type="button" class="btn-hospital btn-danger" onclick="confirmDeleteUser()">
          <i class="fas fa-trash mr-2"></i>Xóa tài khoản
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
