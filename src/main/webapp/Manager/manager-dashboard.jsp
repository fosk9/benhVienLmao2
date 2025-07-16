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
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/hospital-admin.css">
</head>
<body>
<div class="hospital-admin">
  <!-- Sidebar -->
  <div class="sidebar">
    <!-- Hospital Header -->
    <div class="hospital-header">
      <div class="hospital-logo">
        <div class="hospital-icon">
          <a href="${pageContext.request.contextPath}/manager/dashboard">
            <i class="fas fa-user-tie"></i>
          </a>
        </div>
        <div>
          <a href="${pageContext.request.contextPath}/manager/dashboard" style="text-decoration: none;">
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
          <a href="${pageContext.request.contextPath}/manager/dashboard" class="nav-link active">
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
          <a href="${pageContext.request.contextPath}/manager/staff-management" class="nav-link">
            <i class="fas fa-users"></i>
            <span>Staff Management</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/manager/department-management" class="nav-link">
            <i class="fas fa-building"></i>
            <span>Departments</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/assign-doctor-schedule" class="nav-link">
            <i class="fas fa-calendar-alt"></i>
            <span>Doctor Schedules</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/manager/reports" class="nav-link">
            <i class="fas fa-chart-bar"></i>
            <span>Reports</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/manager/resources" class="nav-link">
            <i class="fas fa-boxes"></i>
            <span>Resources</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/manager/settings" class="nav-link">
            <i class="fas fa-cog"></i>
            <span>Settings</span>
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
          <div>
            <a href="${pageContext.request.contextPath}/manager/quick-actions" class="btn-hospital btn-primary">
              <i class="fas fa-plus mr-2"></i>Quick Actions
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- Content Body -->
    <div class="content-body">
      <!-- Welcome Notice -->
      <div class="notice">
        <p><strong>Welcome, Nguyễn Văn Manager!</strong>
          Today is Monday, January 15, 2024.
          You have <strong>8</strong> pending tasks requiring your attention.</p>
      </div>

      <!-- Stats Cards -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-blue">156</h3>
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
              <h3 class="stat-green">42</h3>
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
              <h3 class="stat-orange">89</h3>
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
              <h3 class="stat-purple">15</h3>
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
        <form method="get" action="${pageContext.request.contextPath}/manager/dashboard">
          <div class="filter-row-improved" style="display: grid;grid-template-columns: 2fr 1fr 1fr;gap: 30px;align-items: end">
            <div class="search-group">
              <label>Search Staff/Department</label>
              <div class="search-wrapper">
                <i class="fas fa-search"></i>
                <input type="text" class="form-control" id="searchInput" name="keyword"
                       placeholder="Search by name, department, or role..."
                       value="">
              </div>
            </div>
            <div class="form-group" style="margin-bottom: 0;">
              <label>Role</label>
              <select class="form-control" id="roleFilter" name="role">
                <option value="">All Roles</option>
                <option value="doctor">Doctor</option>
                <option value="nurse">Nurse</option>
                <option value="assistant">Assistant</option>
                <option value="technician">Technician</option>
              </select>
            </div>
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
          <h3>Staff Overview (<span id="staffCount">8</span>)</h3>
          <a href="${pageContext.request.contextPath}/manager/add-staff" class="btn-hospital btn-success btn-sm">
            <i class="fas fa-user-plus mr-1"></i>Add Staff
          </a>
        </div>
        <table id="staffTable">
          <thead>
          <tr>
            <th>Staff Member</th>
            <th>Department</th>
            <th>Role</th>
            <th>Status</th>
            <th>Contact</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody id="staffTableBody">
          <!-- Sample Staff 1 -->
          <tr data-department="1" data-role="doctor" data-name="dr. nguyễn văn an">
            <td>
              <div class="user-info">
                <div class="user-avatar">
                  A
                </div>
                <div class="user-details">
                  <h4>Dr. Nguyễn Văn An</h4>
                  <p>ID: DOC001</p>
                </div>
              </div>
            </td>
            <td>
              <span class="badge badge-category">Cardiology</span>
            </td>
            <td>
              <span class="role-badge role-doctor">Doctor</span>
            </td>
            <td>
              <span class="badge badge-published">Active</span>
            </td>
            <td>
              <div style="font-size: 12px;">
                <div><i class="fas fa-phone mr-1"></i>0901234567</div>
                <div><i class="fas fa-envelope mr-1"></i>dr.an@hospital.com</div>
              </div>
            </td>
            <td>
              <div class="btn-group" role="group">
                <a href="#" class="btn-hospital btn-primary btn-sm" title="View Details">
                  <i class="fas fa-eye"></i>
                </a>
                <a href="#" class="btn-hospital btn-sm" title="Edit">
                  <i class="fas fa-edit"></i>
                </a>
                <a href="#" class="btn-hospital btn-sm" title="Schedule">
                  <i class="fas fa-calendar"></i>
                </a>
                <button type="button" class="btn-hospital btn-sm text-danger" title="Deactivate">
                  <i class="fas fa-user-slash"></i>
                </button>
              </div>
            </td>
          </tr>

          <!-- Sample Staff 2 -->
          <tr data-department="2" data-role="nurse" data-name="trần thị bình">
            <td>
              <div class="user-info">
                <div class="user-avatar">
                  B
                </div>
                <div class="user-details">
                  <h4>Trần Thị Bình</h4>
                  <p>ID: NUR002</p>
                </div>
              </div>
            </td>
            <td>
              <span class="badge badge-category">Emergency</span>
            </td>
            <td>
              <span class="role-badge role-assistant">Nurse</span>
            </td>
            <td>
              <span class="badge badge-published">Active</span>
            </td>
            <td>
              <div style="font-size: 12px;">
                <div><i class="fas fa-phone mr-1"></i>0912345678</div>
                <div><i class="fas fa-envelope mr-1"></i>binh.tran@hospital.com</div>
              </div>
            </td>
            <td>
              <div class="btn-group" role="group">
                <a href="#" class="btn-hospital btn-primary btn-sm" title="View Details">
                  <i class="fas fa-eye"></i>
                </a>
                <a href="#" class="btn-hospital btn-sm" title="Edit">
                  <i class="fas fa-edit"></i>
                </a>
                <a href="#" class="btn-hospital btn-sm" title="Schedule">
                  <i class="fas fa-calendar"></i>
                </a>
                <button type="button" class="btn-hospital btn-sm text-danger" title="Deactivate">
                  <i class="fas fa-user-slash"></i>
                </button>
              </div>
            </td>
          </tr>

          <!-- Sample Staff 3 -->
          <tr data-department="3" data-role="doctor" data-name="dr. lê minh cường">
            <td>
              <div class="user-info">
                <div class="user-avatar">
                  C
                </div>
                <div class="user-details">
                  <h4>Dr. Lê Minh Cường</h4>
                  <p>ID: DOC003</p>
                </div>
              </div>
            </td>
            <td>
              <span class="badge badge-category">Pediatrics</span>
            </td>
            <td>
              <span class="role-badge role-doctor">Doctor</span>
            </td>
            <td>
              <span class="badge badge-draft">On Leave</span>
            </td>
            <td>
              <div style="font-size: 12px;">
                <div><i class="fas fa-phone mr-1"></i>0923456789</div>
                <div><i class="fas fa-envelope mr-1"></i>dr.cuong@hospital.com</div>
              </div>
            </td>
            <td>
              <div class="btn-group" role="group">
                <a href="#" class="btn-hospital btn-primary btn-sm" title="View Details">
                  <i class="fas fa-eye"></i>
                </a>
                <a href="#" class="btn-hospital btn-sm" title="Edit">
                  <i class="fas fa-edit"></i>
                </a>
                <a href="#" class="btn-hospital btn-sm" title="Schedule">
                  <i class="fas fa-calendar"></i>
                </a>
                <button type="button" class="btn-hospital btn-sm text-danger" title="Deactivate">
                  <i class="fas fa-user-slash"></i>
                </button>
              </div>
            </td>
          </tr>

          <!-- Sample Staff 4 -->
          <tr data-department="4" data-role="assistant" data-name="phạm văn dũng">
            <td>
              <div class="user-info">
                <div class="user-avatar">
                  D
                </div>
                <div class="user-details">
                  <h4>Phạm Văn Dũng</h4>
                  <p>ID: ASS004</p>
                </div>
              </div>
            </td>
            <td>
              <span class="badge badge-category">Surgery</span>
            </td>
            <td>
              <span class="role-badge role-assistant">Assistant</span>
            </td>
            <td>
              <span class="badge badge-published">Active</span>
            </td>
            <td>
              <div style="font-size: 12px;">
                <div><i class="fas fa-phone mr-1"></i>0934567890</div>
                <div><i class="fas fa-envelope mr-1"></i>dung.pham@hospital.com</div>
              </div>
            </td>
            <td>
              <div class="btn-group" role="group">
                <a href="#" class="btn-hospital btn-primary btn-sm" title="View Details">
                  <i class="fas fa-eye"></i>
                </a>
                <a href="#" class="btn-hospital btn-sm" title="Edit">
                  <i class="fas fa-edit"></i>
                </a>
                <a href="#" class="btn-hospital btn-sm" title="Schedule">
                  <i class="fas fa-calendar"></i>
                </a>
                <button type="button" class="btn-hospital btn-sm text-danger" title="Deactivate">
                  <i class="fas fa-user-slash"></i>
                </button>
              </div>
            </td>
          </tr>

          <!-- Sample Staff 5 -->
          <tr data-department="5" data-role="technician" data-name="hoàng thị em">
            <td>
              <div class="user-info">
                <div class="user-avatar">
                  E
                </div>
                <div class="user-details">
                  <h4>Hoàng Thị Em</h4>
                  <p>ID: TEC005</p>
                </div>
              </div>
            </td>
            <td>
              <span class="badge badge-category">Radiology</span>
            </td>
            <td>
              <span class="role-badge role-manager">Technician</span>
            </td>
            <td>
              <span class="badge badge-published">Active</span>
            </td>
            <td>
              <div style="font-size: 12px;">
                <div><i class="fas fa-phone mr-1"></i>0945678901</div>
                <div><i class="fas fa-envelope mr-1"></i>em.hoang@hospital.com</div>
              </div>
            </td>
            <td>
              <div class="btn-group" role="group">
                <a href="#" class="btn-hospital btn-primary btn-sm" title="View Details">
                  <i class="fas fa-eye"></i>
                </a>
                <a href="#" class="btn-hospital btn-sm" title="Edit">
                  <i class="fas fa-edit"></i>
                </a>
                <a href="#" class="btn-hospital btn-sm" title="Schedule">
                  <i class="fas fa-calendar"></i>
                </a>
                <button type="button" class="btn-hospital btn-sm text-danger" title="Deactivate">
                  <i class="fas fa-user-slash"></i>
                </button>
              </div>
            </td>
          </tr>

          <!-- Sample Staff 6 -->
          <tr data-department="1" data-role="nurse" data-name="nguyễn thị phương">
            <td>
              <div class="user-info">
                <div class="user-avatar">
                  P
                </div>
                <div class="user-details">
                  <h4>Nguyễn Thị Phương</h4>
                  <p>ID: NUR006</p>
                </div>
              </div>
            </td>
            <td>
              <span class="badge badge-category">Cardiology</span>
            </td>
            <td>
              <span class="role-badge role-assistant">Nurse</span>
            </td>
            <td>
              <span class="badge badge-published">Active</span>
            </td>
            <td>
              <div style="font-size: 12px;">
                <div><i class="fas fa-phone mr-1"></i>0956789012</div>
                <div><i class="fas fa-envelope mr-1"></i>phuong.nguyen@hospital.com</div>
              </div>
            </td>
            <td>
              <div class="btn-group" role="group">
                <a href="#" class="btn-hospital btn-primary btn-sm" title="View Details">
                  <i class="fas fa-eye"></i>
                </a>
                <a href="#" class="btn-hospital btn-sm" title="Edit">
                  <i class="fas fa-edit"></i>
                </a>
                <a href="#" class="btn-hospital btn-sm" title="Schedule">
                  <i class="fas fa-calendar"></i>
                </a>
                <button type="button" class="btn-hospital btn-sm text-danger" title="Deactivate">
                  <i class="fas fa-user-slash"></i>
                </button>
              </div>
            </td>
          </tr>

          <!-- Sample Staff 7 -->
          <tr data-department="2" data-role="doctor" data-name="dr. trần văn quang">
            <td>
              <div class="user-info">
                <div class="user-avatar">
                  Q
                </div>
                <div class="user-details">
                  <h4>Dr. Trần Văn Quang</h4>
                  <p>ID: DOC007</p>
                </div>
              </div>
            </td>
            <td>
              <span class="badge badge-category">Emergency</span>
            </td>
            <td>
              <span class="role-badge role-doctor">Doctor</span>
            </td>
            <td>
              <span class="badge badge-published">Active</span>
            </td>
            <td>
              <div style="font-size: 12px;">
                <div><i class="fas fa-phone mr-1"></i>0967890123</div>
                <div><i class="fas fa-envelope mr-1"></i>dr.quang@hospital.com</div>
              </div>
            </td>
            <td>
              <div class="btn-group" role="group">
                <a href="#" class="btn-hospital btn-primary btn-sm" title="View Details">
                  <i class="fas fa-eye"></i>
                </a>
                <a href="#" class="btn-hospital btn-sm" title="Edit">
                  <i class="fas fa-edit"></i>
                </a>
                <a href="#" class="btn-hospital btn-sm" title="Schedule">
                  <i class="fas fa-calendar"></i>
                </a>
                <button type="button" class="btn-hospital btn-sm text-danger" title="Deactivate">
                  <i class="fas fa-user-slash"></i>
                </button>
              </div>
            </td>
          </tr>

          <!-- Sample Staff 8 -->
          <tr data-department="3" data-role="assistant" data-name="lê thị hương">
            <td>
              <div class="user-info">
                <div class="user-avatar">
                  H
                </div>
                <div class="user-details">
                  <h4>Lê Thị Hương</h4>
                  <p>ID: ASS008</p>
                </div>
              </div>
            </td>
            <td>
              <span class="badge badge-category">Pediatrics</span>
            </td>
            <td>
              <span class="role-badge role-assistant">Assistant</span>
            </td>
            <td>
              <span class="badge badge-draft">Inactive</span>
            </td>
            <td>
              <div style="font-size: 12px;">
                <div><i class="fas fa-phone mr-1"></i>0978901234</div>
                <div><i class="fas fa-envelope mr-1"></i>huong.le@hospital.com</div>
              </div>
            </td>
            <td>
              <div class="btn-group" role="group">
                <a href="#" class="btn-hospital btn-primary btn-sm" title="View Details">
                  <i class="fas fa-eye"></i>
                </a>
                <a href="#" class="btn-hospital btn-sm" title="Edit">
                  <i class="fas fa-edit"></i>
                </a>
                <a href="#" class="btn-hospital btn-sm" title="Schedule">
                  <i class="fas fa-calendar"></i>
                </a>
                <button type="button" class="btn-hospital btn-sm text-danger" title="Deactivate">
                  <i class="fas fa-user-slash"></i>
                </button>
              </div>
            </td>
          </tr>
          </tbody>
        </table>

        <!-- Pagination -->
        <div class="pagination">
          <a href="#" class="btn-hospital">
            &laquo; Previous
          </a>
          <a href="#" class="btn-hospital btn-primary">1</a>
          <a href="#" class="btn-hospital">2</a>
          <a href="#" class="btn-hospital">3</a>
          <a href="#" class="btn-hospital">
            Next &raquo;
          </a>
        </div>

        <!-- Empty State -->
        <div class="empty-state" id="emptyState" style="display: none;">
          <i class="fas fa-users"></i>
          <h3>No staff members found</h3>
          <p>Try adjusting your search criteria or <a href="#">add a new staff member</a></p>
        </div>
      </div>

      <!-- Recent Activities Section -->
      <div class="hospital-table mt-4">
        <div class="table-header">
          <h3>Recent Activities</h3>
          <a href="#" class="btn-hospital btn-sm">
            View All
          </a>
        </div>
        <table>
          <thead>
          <tr>
            <th>Activity</th>
            <th>User</th>
            <th>Department</th>
            <th>Time</th>
          </tr>
          </thead>
          <tbody>
          <tr>
            <td>
              <i class="fas fa-user-plus mr-2 text-success"></i>
              New staff member added
            </td>
            <td>Dr. Nguyễn Văn An</td>
            <td><span class="badge badge-category">Cardiology</span></td>
            <td>09:30</td>
          </tr>
          <tr>
            <td>
              <i class="fas fa-calendar mr-2 text-primary"></i>
              Schedule updated
            </td>
            <td>Trần Thị Bình</td>
            <td><span class="badge badge-category">Emergency</span></td>
            <td>08:45</td>
          </tr>
          <tr>
            <td>
              <i class="fas fa-user-times mr-2 text-warning"></i>
              Staff on leave
            </td>
            <td>Dr. Lê Minh Cường</td>
            <td><span class="badge badge-category">Pediatrics</span></td>
            <td>08:15</td>
          </tr>
          <tr>
            <td>
              <i class="fas fa-edit mr-2 text-info"></i>
              Profile updated
            </td>
            <td>Phạm Văn Dũng</td>
            <td><span class="badge badge-category">Surgery</span></td>
            <td>07:30</td>
          </tr>
          <tr>
            <td>
              <i class="fas fa-check mr-2 text-success"></i>
              Equipment check completed
            </td>
            <td>Hoàng Thị Em</td>
            <td><span class="badge badge-category">Radiology</span></td>
            <td>07:00</td>
          </tr>
          </tbody>
        </table>
      </div>
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

</body>
</html>