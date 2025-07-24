<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Role Management - Hospital Admin</title>

  <!-- Bootstrap 4 CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <!-- Hospital Admin CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Manager/css/hospital-admin.css">
</head>
<body>
<div class="hospital-admin">
  <!-- Sidebar -->
  <div class="sidebar">
    <!-- Hospital Header -->
    <div class="hospital-header">
      <div class="hospital-logo">
        <div class="hospital-icon">
          <a href="${pageContext.request.contextPath}/manager-dashboard">
            <i class="fas fa-user-tie"></i>
          </a>
        </div>
        <div>
          <a href="${pageContext.request.contextPath}/manager-dashboard" style="text-decoration: none;">
            <h2 class="hospital-title">Manager Portal</h2>
            <p class="hospital-subtitle">Hospital Management</p>
          </a>
        </div>
      </div>
    </div>

    <!-- Navigation Menu -->
    <nav class="nav-menu">
      <ul>
        <li>
          <a href="${pageContext.request.contextPath}/manager-dashboard" class="nav-link">
            <i class="fas fa-tachometer-alt"></i>
            <span>Dashboard</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/update-user-role" class="nav-link active">
            <i class="fas fa-users-cog"></i>
            <span>User Management</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/add-doctor-form" class="nav-link">
            <i class="fas fa-users"></i>
            <span>Add Staff</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/assign-doctor-schedule" class="nav-link">
            <i class="fas fa-calendar-alt"></i>
            <span>Doctor Schedules</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/blog-dashboard" class="nav-link">
            <i class="fas fa-podcast"></i>
            <span>Blog Dashboard</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/change-history-log" class="nav-link">
            <i class="fas fa-history"></i>
            <span>Change History</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/logout" class="nav-link">
            <i class="fas fa-sign-out-alt"></i>
            <span>Logout</span>
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
            <h1>User Role Management</h1>
            <p class="page-subtitle">Change roles from patient to doctor/assistant/manager</p>
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
          <c:remove var="successMessage" scope="session"/>
        </div>
      </c:if>
      <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">
          <i class="fas fa-exclamation-circle mr-2"></i>${errorMessage}
          <c:remove var="errorMessage" scope="session"/>
        </div>
      </c:if>

      <!-- Stats Cards -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-blue">${totalUsers}</h3>
              <p>Total Users</p>
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
              <p>Doctors</p>
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
              <p>Assistants</p>
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
              <p>Patients</p>
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
          <div class="filter-row-improved">
            <div class="form-group search-group">
              <label>Search</label>
              <div class="search-wrapper">
                <i class="fas fa-search"></i>
                <input type="text" class="form-control" name="keyword" id="keyword"
                       value="${param.search != null ? param.search : ''}"
                       placeholder="Search by name, email or phone number...">
              </div>
            </div>

            <div class="form-group">
              <label>Role</label>
              <select class="form-control" name="role">
                <option value="">All Roles</option>
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

            <div class="form-group">
              <label>Status</label>
              <select class="form-control" name="status">
                <option value="">All</option>
                <option value="1" <c:if test="${param.status == '1'}">selected</c:if>>Active</option>
                <option value="0" <c:if test="${param.status == '0'}">selected</c:if>><I></I>nactive</option>
              </select>
            </div>
            <div class="filter-button-row">
              <button type="submit" class="btn-hospital btn-primary btn-filter" style="margin-bottom: 27px">
                <i class="fas fa-filter mr-2"></i>Filter
              </button>
            </div>
          </div>
        </div>
      </form>

      <!-- User Table -->
      <div class="user-table-container">
        <div class="table-header">
          <h3>User List (<span id="userCount">${totalUsersByFilter}</span>)</h3>
        </div>
        <!-- UPDATE FORM - USE POST -->
        <form id="roleUpdateForm" action="update-user-role" method="post">
          <table class="user-table" id="userTable">
            <thead>
            <tr>
              <th>User</th>
              <th>Current Role</th>
              <th>New Role</th>
              <th>Status</th>
              <th>New Status</th>
              <th>Join Date</th>
              <th>Actions</th>
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

                <input type="hidden" name="source_${u.userID}"
                       value="${fn:toLowerCase(u.roleName) == 'patient' ? 'patient' : 'employee'}" />

                <td>
                  <c:choose>
                    <c:when test="${empty u.roleName || fn:toLowerCase(u.roleName) == 'patient'}">
                      <span class="text-muted">Không áp dụng</span>
                    </c:when>
                    <c:otherwise>
                      <select class="form-control" name="newRole_${u.userID}">
                        <c:forEach var="r" items="${allRoles}">
                          <option value="${fn:toLowerCase(r.roleName)}"
                                  <c:if test="${r.roleName == u.roleName}">selected</c:if>>
                              ${r.roleName}
                          </option>
                        </c:forEach>
                      </select>
                    </c:otherwise>
                  </c:choose>
                </td>


                <td>
            <span class="status-badge status-${u.accStatus == 1 ? 'active' : 'inactive'}">
              <c:choose>
                <c:when test="${u.accStatus == 1}">Active</c:when>
                <c:otherwise>Inactive</c:otherwise>
              </c:choose>
            </span>
                </td>

                <td>
                  <select class="form-control" name="newStatus_${u.userID}">
                    <option value="1" <c:if test="${u.accStatus == 1}">selected</c:if>>Active</option>
                    <option value="0" <c:if test="${u.accStatus == 0}">selected</c:if>>Inactive</option>
                  </select>
                </td>

                <td>
                  <fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy"/>
                </td>

                <td>
                  <div class="d-flex gap-1">
                    <!-- Save Button -->
                    <button type="submit" class="btn-hospital btn-sm btn-success" name="action" value="update_${u.userID}">
                      <i class="fas fa-save mr-1"></i>Save
                    </button>

                    <!-- Delete Button -->
                    <button type="submit" class="btn-hospital btn-sm btn-danger"
                            name="action" value="delete_${u.userID}"
                            onclick="return confirm('Confirm delete ${u.fullName}?');">
                      <i class="fas fa-trash mr-1"></i>Delete
                    </button>
                  </div>
                </td>

              </tr>
            </c:forEach>
            </tbody>
          </table>
        </form>

        <!-- PAGINATION -->
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
          <h3>No users found</h3>
          <p>Try changing the filter or search keywords</p>
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
        <h5 class="modal-title">Confirm Role Change</h5>
        <button type="button" class="close" data-dismiss="modal">
          <span>&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p>Are you sure you want to change roles for <span id="selectedCount">0</span> selected users?</p>
        <div class="alert alert-warning">
          <i class="fas fa-exclamation-triangle mr-2"></i>
          Role changes will affect users' access to the system.
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn-hospital" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn-hospital btn-primary" onclick="confirmRoleUpdate()">
          <i class="fas fa-save mr-2"></i>Confirm
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
        <h5 class="modal-title">Confirm Account Deletion</h5>
        <button type="button" class="close" data-dismiss="modal">
          <span>&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p>Are you sure you want to delete the account of <strong id="deleteUserName"></strong>?</p>
        <div class="alert alert-danger">
          <i class="fas fa-exclamation-triangle mr-2"></i>
          <strong>Warning:</strong> This action cannot be undone. All data related to this account will be permanently deleted.
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn-hospital" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn-hospital btn-danger" onclick="confirmDeleteUser()">
          <i class="fas fa-trash mr-2"></i>Delete Account
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
