    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Manager Dashboard - Hospital Management System</title>

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
              <a href="${pageContext.request.contextPath}/manager-dashboard" class="nav-link active">
                <i class="fas fa-tachometer-alt"></i>
                <span>Dashboard</span>
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/update-user-role" class="nav-link">
                <i class="fas fa-users-cog"></i>
                <span>User Management</span>
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/add-doctor-form" class="nav-link">
                <i class="fas fa-users"></i>
                <span>Add Staff
                </span>
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/assign-doctor-schedule" class="nav-link">
                <i class="fas fa-calendar-alt"></i>
                <span>Doctor Schedules</span>
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/blog-dashboard" class="nav-linkStaff Overview (0)
">
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
                <h1>Manager Dashboard</h1>
                <p class="page-subtitle">Hospital Management Overview</p>
              </div>
            </div>
          </div>
        </div>
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
        <!-- Content Body -->
        <div class="content-body">
          <!-- Stats Cards -->
          <div class="stats-grid">
            <div class="stat-card">
              <div class="stat-card-content">
                <div class="stat-info">
                  <h3 class="stat-blue">${totalStaff}</h3>
                  <p>Total Staff</p>
                </div>
                <div class="stat-icon stat-blue">
                  <i class="fas fa-users"></i>
                </div>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-card-content">
                <div class="stat-info">
                  <h3 class="stat-green">${activeDoctors}</h3>
                  <p>Active Doctors</p>
                </div>
                <div class="stat-icon stat-green">
                  <i class="fas fa-user-md"></i>
                </div>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-card-content">
                <div class="stat-info">
                  <h3 class="stat-orange">${todayAppointments}</h3>
                  <p>Today's Appointments</p>
                </div>
                <div class="stat-icon stat-orange">
                  <i class="fas fa-calendar-check"></i>
                </div>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-card-content">
                <div class="stat-info">
                  <h3 class="stat-purple">${pendingAppointments}</h3>
                  <p>Pending Requests</p>
                </div>
                <div class="stat-icon stat-purple">
                  <i class="fas fa-clock"></i>
                </div>
              </div>
            </div>
          </div>

          <!-- Filter Section -->
          <div class="filter-section">
            <form method="get" action="${pageContext.request.contextPath}/manager-dashboard">
              <div class="filter-row-improved" style="display: grid;grid-template-columns: 2fr 1fr 1fr;gap: 30px;align-items: end">
                <div class="search-group">
                  <label>Search Staff</label>
                  <div class="search-wrapper">
                    <i class="fas fa-search"></i>
                    <input type="text" class="form-control" id="searchInput" name="keyword"
                           placeholder="Search by name, department, or role..."
                           value="">
                  </div>
                </div>
                <select name="status" class="form-control mr-2">
                  <option value="">All Status</option>
                  <option value="Working" ${status == 'Working' ? 'selected' : ''}>Working</option>
                  <option value="OnLeave" ${status == 'OnLeave' ? 'selected' : ''}>OnLeave</option>
                    <option value="Inactive" ${status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                </select>
                <div class="filter-button-row">
                  <button type="submit" class="btn-hospital btn-primary btn-filter" style="padding: 12px 60px">
                    <i class="fas fa-filter mr-2"></i>Filter
                  </button>
                </div>
              </div>
            </form>
          </div>

          <!-- Staff Management Table -->
          <div class="hospital-table">
            <div class="table-header">
              <h3>Staff Overview (${totalStaff})</h3>
              <a href="${pageContext.request.contextPath}/add-doctor-form" class="btn-hospital btn-success btn-sm">
                <i class="fas fa-user-plus mr-1"></i>Add Staff
              </a>
            </div>
            <table id="staffTable">
              <thead>
              <tr>
                <th>Staff Member</th>
                <th>Role</th>
                <th>Status</th>
                <th>Contact</th>
                <th>Actions</th>
              </tr>
              </thead>
              <tbody>
              <c:choose>
                <c:when test="${not empty employeeList}">
                  <c:forEach var="e" items="${employeeList}">
                    <tr>
                      <td>
                        <div class="user-info d-flex align-items-center">
                          <div class="user-avatar mr-2">
                            <c:choose>
                              <c:when test="${not empty e.employee.employeeAvaUrl}">
                                <img src="${e.employee.employeeAvaUrl}" alt="Avatar"
                                     style="width:32px;height:32px;border-radius:50%;">
                              </c:when>
                              <c:otherwise>
                                <div class="avatar-circle">${fn:substring(e.employee.fullName, 0, 1)}</div>
                              </c:otherwise>
                            </c:choose>
                          </div>
                          <div>
                            <strong>${e.employee.fullName}</strong><br/>
                            ID: ${e.employee.employeeId}
                          </div>
                        </div>
                      </td>

                      <td>
                        <c:choose>
                          <c:when test="${e.employee.roleId == 1}">
                            <span class="role-badge role-doctor">Doctor</span>
                          </c:when>
                          <c:when test="${e.employee.roleId == 2}">
                            <span class="role-badge role-assistant">Receptionist</span>
                          </c:when>
                          <c:otherwise>
                            <span class="role-badge role-manager">Other</span>
                          </c:otherwise>
                        </c:choose>
                      </td>


                      <td>
                        <c:choose>
                          <c:when test="${e.statusToday eq 'Working'}">
                            <span class="badge badge-success">Working</span>
                          </c:when>
                          <c:when test="${e.statusToday eq 'OnLeave'}">
                            <span class="badge badge-warning">OnLeave</span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge badge-danger">Inactive</span>
                          </c:otherwise>
                        </c:choose>
                      </td>

                      <td>
                        <div style="font-size: 13px;">
                          <i class="fas fa-phone mr-1"></i>${e.employee.phone}<br/>
                          <i class="fas fa-envelope mr-1"></i>${e.employee.email}
                        </div>
                      </td>

                      <td>
                        <div class="btn-group" role="group">
                          <a href="${pageContext.request.contextPath}/staff-detail?id=${e.employee.employeeId}" class="btn-hospital btn-primary btn-sm" title="View Details">
                            <i class="fas fa-eye"></i>
                          </a>
                          <a href="${pageContext.request.contextPath}/staff-edit?id=${e.employee.employeeId}" class="btn-hospital btn-sm" title="Edit">
                            <i class="fas fa-edit"></i>
                          </a>
                          <a href="view-doctor-schedule?doctorId=${e.employee.employeeId}" class="btn-hospital btn-sm" title="Schedule">
                            <i class="fas fa-calendar"></i>
                          </a>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="5" class="text-center">
                      <div class="empty-state">
                        <i class="fas fa-users"></i>
                        <h3>No staff members found</h3>
                        <p>Try adjusting your search criteria or <a href="#">add a new staff member</a></p>
                      </div>
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
              </tbody>
            </table>

            <!-- Pagination -->
            <div class="pagination flex mt-3">
              <c:if test="${totalPage > 1}">
                <c:set var="baseLink" value="manager-dashboard?keyword=${fn:escapeXml(keyword)}&status=${status}" />

                <c:if test="${currentPage > 1}">
                  <a href="${baseLink}&page=${currentPage - 1}" class="btn-hospital">« Previous</a>
                </c:if>

                <c:forEach begin="1" end="${totalPage}" var="i">
                  <a href="${baseLink}&page=${i}"
                     class="btn-hospital ${i == currentPage ? 'btn-primary' : ''}">${i}</a>
                </c:forEach>

                <c:if test="${currentPage < totalPage}">
                  <a href="${baseLink}&page=${currentPage + 1}" class="btn-hospital">Next »</a>
                </c:if>
              </c:if>
            </div>

          </div>
        </div>
    <!-- jQuery and Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <script>
      // Navigation active state
      $('.nav-link').click(function(e) {
        if ($(this).attr('href') === '#') {
          e.preventDefault();
        }
        $('.nav-link').removeClass('active');
        $(this).addClass('active');
      });

      // Mobile responsive
      $(window).resize(function() {
        if ($(window).width() <= 768) {
          $('.sidebar').addClass('mobile');
        } else {
          $('.sidebar').removeClass('mobile');
        }
      }).trigger('resize');

      // Filter functionality
      function filterStaff() {
        const searchTerm = $('#searchInput').val().toLowerCase();
        const selectedDepartment = $('#departmentFilter').val();
        const selectedRole = $('#roleFilter').val();

        let visibleCount = 0;

        $('#staffTableBody tr').each(function() {
          const row = $(this);
          const name = row.data('name') || '';
          const department = row.data('department') || '';
          const role = row.data('role') || '';

          const matchesSearch = name.includes(searchTerm);
          const matchesDepartment = !selectedDepartment || department == selectedDepartment;
          const matchesRole = !selectedRole || role === selectedRole;

          if (matchesSearch && matchesDepartment && matchesRole) {
            row.show();
            visibleCount++;
          } else {
            row.hide();
          }
        });

        $('#staffCount').text(visibleCount);

        if (visibleCount === 0) {
          $('#emptyState').show();
        } else {
          $('#emptyState').hide();
        }
      }

      // Toggle staff status
      function toggleStaffStatus(staffId, currentStatus) {
        const action = currentStatus === 'active' ? 'deactivate' : 'activate';
        const message = `Are you sure you want to ${action} this staff member?`;

        if (confirm(message)) {
          alert(`Staff ${action}d successfully!`);
          // In real implementation, this would make an AJAX call
        }
      }

      // Bind filter events
      $('#searchInput').on('input', filterStaff);
      $('#departmentFilter, #roleFilter').on('change', filterStaff);

      // Initialize
      $(document).ready(function() {
        filterStaff();

        // Show welcome message for 5 seconds
        setTimeout(function() {
          $('.notice').fadeOut();
        }, 5000);
      });
    </script>
      </div>
    </div>
    </body>
    </html>