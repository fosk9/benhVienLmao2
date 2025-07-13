<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>System Announcements - Hospital Admin</title>

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
          <a href="Admin/home-admin-dashboard.jsp">
            <i class="fas fa-stethoscope"></i>
          </a>
        </div>
        <div>
          <a href="Admin/home-admin-dashboard.jsp" style="text-decoration: none;">
            <h2 class="hospital-title">Hospital Admin</h2>
            <p class="hospital-subtitle">Hospital Management</p>
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
            <span>Home</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/blog-dashboard" class="nav-link">
            <i class="fas fa-blog"></i>
            <span>Blog</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/system-announcements" class="nav-link active">
            <i class="fas fa-bullhorn"></i>
            <span>Announcements</span>
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
            <h1>System Announcements</h1>
            <p class="page-subtitle">Create and manage notifications for users and roles</p>
          </div>
          <button type="button" class="btn-hospital btn-primary" data-toggle="modal" data-target="#createAnnouncementModal">
            <i class="fas fa-plus mr-2"></i>Create New Announcement
          </button>
        </div>
      </div>
    </div>

    <!-- Content Body -->
    <div class="content-body">
      <!-- Stats Cards -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-blue">${totalAnnouncements}</h3>
              <p>Total Announcements</p>
            </div>
            <div class="stat-icon stat-blue">
              <i class="fas fa-bullhorn"></i>
            </div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-green">${activeAnnouncements}</h3>
              <p>Active</p>
            </div>
            <div class="stat-icon stat-green">
              <i class="fas fa-check-circle"></i>
            </div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-yellow">${scheduledAnnouncements}</h3>
              <p>Scheduled</p>
            </div>
            <div class="stat-icon stat-yellow">
              <i class="fas fa-clock"></i>
            </div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-red">${expiredAnnouncements}</h3>
              <p>Expired</p>
            </div>
            <div class="stat-icon stat-red">
              <i class="fas fa-times-circle"></i>
            </div>
          </div>
        </div>
      </div>

      <!-- Filter Section -->
      <div class="filter-section">
        <form method="get" action="${pageContext.request.contextPath}/system-announcements">
          <div class="filter-row">
            <div class="form-group">
              <label>Search</label>
              <div class="search-wrapper">
                <i class="fas fa-search"></i>
                <input type="text" class="form-control" id="searchInput" name="keyword"
                       placeholder="Search by title or content..."
                       value="${keyword != null ? keyword : ''}">
              </div>
            </div>
            <div class="form-group">
              <label>Target Role</label>
              <select class="form-control" id="roleFilter" name="targetRole" onchange="this.form.submit()">
                <option value="">All Roles</option>
                <option value="ALL" <c:if test="${selectedRole == 'ALL'}">selected</c:if>>All Users</option>
                <option value="DOCTOR" <c:if test="${selectedRole == 'DOCTOR'}">selected</c:if>>Doctors</option>
                <option value="NURSE" <c:if test="${selectedRole == 'NURSE'}">selected</c:if>>Nurses</option>
                <option value="ADMIN" <c:if test="${selectedRole == 'ADMIN'}">selected</c:if>>Administrators</option>
                <option value="PATIENT" <c:if test="${selectedRole == 'PATIENT'}">selected</c:if>>Patients</option>
                <option value="STAFF" <c:if test="${selectedRole == 'STAFF'}">selected</c:if>>Staff</option>
              </select>
            </div>
            <div class="form-group">
              <label>Status</label>
              <select class="form-control" id="statusFilter" name="status" onchange="this.form.submit()">
                <option value="">All Status</option>
                <option value="ACTIVE" <c:if test="${selectedStatus == 'ACTIVE'}">selected</c:if>>Active</option>
                <option value="SCHEDULED" <c:if test="${selectedStatus == 'SCHEDULED'}">selected</c:if>>Scheduled</option>
                <option value="EXPIRED" <c:if test="${selectedStatus == 'EXPIRED'}">selected</c:if>>Expired</option>
                <option value="DRAFT" <c:if test="${selectedStatus == 'DRAFT'}">selected</c:if>>Draft</option>
              </select>
            </div>
            <div class="form-group">
              <label>Priority</label>
              <select class="form-control" id="priorityFilter" name="priority" onchange="this.form.submit()">
                <option value="">All Priorities</option>
                <option value="HIGH" <c:if test="${selectedPriority == 'HIGH'}">selected</c:if>>High</option>
                <option value="MEDIUM" <c:if test="${selectedPriority == 'MEDIUM'}">selected</c:if>>Medium</option>
                <option value="LOW" <c:if test="${selectedPriority == 'LOW'}">selected</c:if>>Low</option>
              </select>
            </div>
          </div>
        </form>
        <c:if test="${not empty errorMessage}">
          <div class="alert alert-warning mt-3">${errorMessage}</div>
        </c:if>
      </div>

      <!-- Announcements Table -->
      <div class="blog-table-container">
        <div class="table-header">
          <h3>Announcements List (<span id="announcementCount"><c:out value="${fn:length(announcementList)}"/></span>)</h3>
        </div>
        <table class="blog-table" id="announcementTable">
          <thead>
          <tr>
            <th>Title</th>
            <th>Target Role</th>
            <th>Priority</th>
            <th>Status</th>
            <th>Created Date</th>
            <th>Expires</th>
            <th>Recipients</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody id="announcementTableBody">
          <c:forEach var="announcement" items="${announcementList}">
            <tr data-role="${announcement.targetRole}" data-title="${fn:toLowerCase(announcement.title)}"
                data-status="${announcement.status}" data-priority="${announcement.priority}">
              <td>
                <div class="announcement-title">
                  <strong>${announcement.title}</strong>
                  <c:if test="${announcement.priority == 'HIGH'}">
                    <i class="fas fa-exclamation-triangle text-danger ml-1" title="High Priority"></i>
                  </c:if>
                </div>
                <small class="text-muted">${fn:substring(announcement.content, 0, 50)}...</small>
              </td>
              <td>
                <span class="badge badge-info">
                  <c:choose>
                    <c:when test="${announcement.targetRole == 'ALL'}">All Users</c:when>
                    <c:otherwise>${announcement.targetRole}</c:otherwise>
                  </c:choose>
                </span>
              </td>
              <td>
                <span class="badge
                  <c:choose>
                    <c:when test='${announcement.priority == "HIGH"}'>badge-danger</c:when>
                    <c:when test='${announcement.priority == "MEDIUM"}'>badge-warning</c:when>
                    <c:otherwise>badge-secondary</c:otherwise>
                  </c:choose>">
                    ${announcement.priority}
                </span>
              </td>
              <td>
                <span class="badge
                  <c:choose>
                    <c:when test='${announcement.status == "ACTIVE"}'>badge-success</c:when>
                    <c:when test='${announcement.status == "SCHEDULED"}'>badge-primary</c:when>
                    <c:when test='${announcement.status == "EXPIRED"}'>badge-secondary</c:when>
                    <c:otherwise>badge-warning</c:otherwise>
                  </c:choose>">
                    ${announcement.status}
                </span>
              </td>
              <td><fmt:formatDate value="${announcement.createdDate}" pattern="dd/MM/yyyy HH:mm"/></td>
              <td>
                <c:choose>
                  <c:when test="${announcement.expiryDate != null}">
                    <fmt:formatDate value="${announcement.expiryDate}" pattern="dd/MM/yyyy"/>
                  </c:when>
                  <c:otherwise>
                    <span class="text-muted">No expiry</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <span class="badge badge-light">${announcement.recipientCount}</span>
                <c:if test="${announcement.readCount > 0}">
                  <small class="text-success d-block">${announcement.readCount} read</small>
                </c:if>
              </td>
              <td>
                <div class="btn-group" role="group">
                  <button type="button" class="btn-hospital btn-primary btn-sm" title="View Details"
                          onclick="viewAnnouncement(${announcement.id})">
                    <i class="fas fa-eye"></i>
                  </button>
                  <button type="button" class="btn-hospital btn-sm" title="Edit"
                          onclick="editAnnouncement(${announcement.id})">
                    <i class="fas fa-edit"></i>
                  </button>
                  <c:if test="${announcement.status == 'DRAFT' || announcement.status == 'SCHEDULED'}">
                    <button type="button" class="btn-hospital btn-sm text-success" title="Publish"
                            onclick="publishAnnouncement(${announcement.id})">
                      <i class="fas fa-paper-plane"></i>
                    </button>
                  </c:if>
                  <c:if test="${announcement.status == 'ACTIVE'}">
                    <button type="button" class="btn-hospital btn-sm text-warning" title="Deactivate"
                            onclick="deactivateAnnouncement(${announcement.id})">
                      <i class="fas fa-pause"></i>
                    </button>
                  </c:if>
                  <button type="button" class="btn-hospital btn-sm text-danger" title="Delete"
                          onclick="deleteAnnouncement(${announcement.id})">
                    <i class="fas fa-trash"></i>
                  </button>
                </div>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>

        <!-- Pagination -->
        <div class="pagination">
          <c:if test="${currentPage > 1}">
            <a href="${pageContext.request.contextPath}/system-announcements?page=${currentPage - 1}" class="btn-hospital">
              &laquo; Previous
            </a>
          </c:if>

          <c:forEach var="i" begin="1" end="${totalPages}" varStatus="status">
            <a href="${pageContext.request.contextPath}/system-announcements?page=${i}"
               class="btn-hospital <c:if test="${i == currentPage}">btn-primary</c:if>">
                ${i}
            </a>
          </c:forEach>

          <c:if test="${currentPage < totalPages}">
            <a href="${pageContext.request.contextPath}/system-announcements?page=${currentPage + 1}" class="btn-hospital">
              Next &raquo;
            </a>
          </c:if>
        </div>

        <div class="empty-state" id="emptyState" style="display: none;">
          <i class="fas fa-bullhorn"></i>
          <h3>No announcements found</h3>
          <p>Try changing the filter or search keywords</p>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Create Announcement Modal -->
<div class="modal fade" id="createAnnouncementModal" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Create New Announcement</h5>
        <button type="button" class="close" data-dismiss="modal">
          <span>&times;</span>
        </button>
      </div>
      <form action="${pageContext.request.contextPath}/system-announcements/create" method="post">
        <div class="modal-body">
          <div class="form-group">
            <label for="announcementTitle">Title *</label>
            <input type="text" class="form-control" id="announcementTitle" name="title" required>
          </div>

          <div class="form-group">
            <label for="announcementContent">Content *</label>
            <textarea class="form-control" id="announcementContent" name="content" rows="4" required></textarea>
          </div>

          <div class="row">
            <div class="col-md-6">
              <div class="form-group">
                <label for="targetRole">Target Role *</label>
                <select class="form-control" id="targetRole" name="targetRole" required>
                  <option value="">Select Target</option>
                  <option value="ALL">All Users</option>
                  <option value="DOCTOR">Doctors</option>
                  <option value="NURSE">Nurses</option>
                  <option value="ADMIN">Administrators</option>
                  <option value="PATIENT">Patients</option>
                  <option value="STAFF">Staff</option>
                </select>
              </div>
            </div>
            <div class="col-md-6">
              <div class="form-group">
                <label for="priority">Priority *</label>
                <select class="form-control" id="priority" name="priority" required>
                  <option value="LOW">Low</option>
                  <option value="MEDIUM" selected>Medium</option>
                  <option value="HIGH">High</option>
                </select>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-md-6">
              <div class="form-group">
                <label for="startDate">Start Date</label>
                <input type="datetime-local" class="form-control" id="startDate" name="startDate">
                <small class="form-text text-muted">Leave empty to publish immediately</small>
              </div>
            </div>
            <div class="col-md-6">
              <div class="form-group">
                <label for="expiryDate">Expiry Date</label>
                <input type="datetime-local" class="form-control" id="expiryDate" name="expiryDate">
                <small class="form-text text-muted">Leave empty for no expiry</small>
              </div>
            </div>
          </div>

          <div class="form-check">
            <input type="checkbox" class="form-check-input" id="sendEmail" name="sendEmail" value="true">
            <label class="form-check-label" for="sendEmail">
              Send email notification to recipients
            </label>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
          <button type="submit" name="action" value="draft" class="btn btn-outline-primary">Save as Draft</button>
          <button type="submit" name="action" value="publish" class="btn btn-primary">Publish Now</button>
        </div>
      </form>
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
  function filterAnnouncements() {
    const searchTerm = $('#searchInput').val().toLowerCase();
    const roleFilter = $('#roleFilter').val();
    const statusFilter = $('#statusFilter').val();
    const priorityFilter = $('#priorityFilter').val();

    let visibleCount = 0;

    $('#announcementTableBody tr').each(function() {
      const $row = $(this);
      const title = $row.data('title');
      const role = $row.data('role');
      const status = $row.data('status');
      const priority = $row.data('priority');

      let show = true;

      if (searchTerm && !title.includes(searchTerm)) {
        show = false;
      }

      if (roleFilter && role !== roleFilter) {
        show = false;
      }

      if (statusFilter && status !== statusFilter) {
        show = false;
      }

      if (priorityFilter && priority !== priorityFilter) {
        show = false;
      }

      if (show) {
        $row.show();
        visibleCount++;
      } else {
        $row.hide();
      }
    });

    $('#announcementCount').text(visibleCount);

    if (visibleCount === 0) {
      $('#emptyState').show();
      $('#announcementTable').hide();
    } else {
      $('#emptyState').hide();
      $('#announcementTable').show();
    }
  }

  // Announcement actions
  function viewAnnouncement(id) {
    window.location.href = `${pageContext.request.contextPath}/system-announcements/view?id=${id}`;
  }

  function editAnnouncement(id) {
    window.location.href = `${pageContext.request.contextPath}/system-announcements/edit?id=${id}`;
  }

  function publishAnnouncement(id) {
    if (confirm('Are you sure you want to publish this announcement?')) {
      $.post(`${pageContext.request.contextPath}/system-announcements/publish`, {id: id}, function(response) {
        if (response.success) {
          location.reload();
        } else {
          alert('Error publishing announcement: ' + response.message);
        }
      });
    }
  }

  function deactivateAnnouncement(id) {
    if (confirm('Are you sure you want to deactivate this announcement?')) {
      $.post(`${pageContext.request.contextPath}/system-announcements/deactivate`, {id: id}, function(response) {
        if (response.success) {
          location.reload();
        } else {
          alert('Error deactivating announcement: ' + response.message);
        }
      });
    }
  }

  function deleteAnnouncement(id) {
    if (confirm('Are you sure you want to delete this announcement? This action cannot be undone.')) {
      $.post(`${pageContext.request.contextPath}/system-announcements/delete`, {id: id}, function(response) {
        if (response.success) {
          $(`tr:has([onclick*="${id}"])`).fadeOut(300, function() {
            $(this).remove();
            updateAnnouncementCount();
          });
        } else {
          alert('Error deleting announcement: ' + response.message);
        }
      });
    }
  }

  // Update announcement count
  function updateAnnouncementCount() {
    const count = $('#announcementTableBody tr:visible').length;
    $('#announcementCount').text(count);
  }

  // Bind filter events
  $('#searchInput, #roleFilter, #statusFilter, #priorityFilter').on('input change', filterAnnouncements);

  // Initialize
  $(document).ready(function() {
    updateAnnouncementCount();

    // Set minimum date for start and expiry date inputs
    const now = new Date();
    const nowString = now.toISOString().slice(0, 16);
    $('#startDate, #expiryDate').attr('min', nowString);
  });
</script>

</body>
</html>