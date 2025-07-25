<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Schedule Management - Hospital Admin</title>

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
    <div class="sidebar d-flex flex-column">
        <!-- Hospital Header -->
        <div class="hospital-header p-3">
            <div class="hospital-logo d-flex align-items-center">
                <div class="hospital-icon mr-2">
                    <a href="${pageContext.request.contextPath}/manager-dashboard">
                        <i class="fas fa-user-tie fa-2x"></i>
                    </a>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/manager-dashboard" style="text-decoration: none;">
                        <h4 class="hospital-title mb-0">Manager Portal</h4>
                        <small class="hospital-subtitle text-muted">Hospital Management</small>
                    </a>
                </div>
            </div>
        </div>

        <!-- Navigation Menu -->
        <nav class="nav-menu flex-grow-1">
            <ul class="nav flex-column px-3">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/manager-dashboard" class="nav-link">
                        <i class="fas fa-tachometer-alt"></i> <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/update-user-role" class="nav-link">
                        <i class="fas fa-users-cog"></i> <span>User Management</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/hospital-statistics" class="nav-link">
                        <i class="fas fa-chart-bar"></i> <span>Revenue Report</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/add-doctor-form" class="nav-link">
                        <i class="fas fa-user-plus"></i> <span>Add Staff</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/assign-doctor-schedule" class="nav-link active">
                        <i class="fas fa-calendar-alt"></i> <span>Doctor Schedules</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/unassigned-appointments" class="nav-link">
                        <i class="fas fa-calendar-times"></i> <span>Unassigned Appointments</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/request-leave-list" class="nav-link">
                        <i class="fas fa-user-clock"></i> <span>Leave Requests</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/blog-dashboard" class="nav-link">
                        <i class="fas fa-podcast"></i> <span>Blog Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/change-history-log" class="nav-link">
                        <i class="fas fa-history"></i> <span>Change History</span>
                    </a>
                </li>
            </ul>
        </nav>

        <!-- Logout at bottom -->
        <div class="logout-section mt-auto px-3 pb-3">
            <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger">
                <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
            </a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Content Header -->
        <div class="content-header">
            <div class="page-header">
                <div style="display: flex; align-items: center; justify-content: space-between;">
                    <div>
                        <h1>Doctor Schedule Management</h1>
                        <p class="page-subtitle">Assign and manage work schedules for doctors</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Content Body -->
        <div class="content-body">
            <!-- Success/Error Messages -->
            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success">${sessionScope.success}</div>
                <c:remove var="success" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger">${sessionScope.error}</div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-card-content">
                        <div class="stat-info">
                            <h3 class="stat-blue">${appointmentsToday != null ? appointmentsToday : 0}</h3>
                            <p>Today's Appointments</p>
                        </div>
                        <div class="stat-icon stat-blue">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-content">
                        <div class="stat-info">
                            <h3 class="stat-green">${totalStaff != null ? totalStaff : 0}</h3>
                            <p>Total Staff</p>
                        </div>
                        <div class="stat-icon stat-green">
                            <i class="fas fa-users"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-content">
                        <div class="stat-info">
                            <h3 class="stat-orange">${fn:length(scheduleList) != null ? fn:length(scheduleList) : 0}</h3>
                            <p>Total Doctor</p>
                        </div>
                        <div class="stat-icon stat-orange">
                            <i class="fas fa-user-nurse"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-content">
                        <div class="stat-info">
                            <h3 class="stat-purple">${activeDoctors != null ? activeDoctors : 0}</h3>
                            <p>Active Doctors</p>
                        </div>
                        <div class="stat-icon stat-purple">
                            <i class="fas fa-user-md"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Section -->
            <form action="assign-doctor-schedule" method="get">
                <div class="filter-section">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Search</label>
                                <div class="search-wrapper">
                                    <i class="fas fa-search"></i>
                                    <input type="text" class="form-control" name="keyword" id="keyword"
                                           value="${param.keyword}"
                                           placeholder="Search by doctor name">
                                </div>
                            </div>
                        </div>

                        <!-- Status Today -->
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Status Today</label>
                                <select class="form-control" name="status">
                                    <option value="">All</option>
                                    <option value="Working" ${param.status == 'Working' ? 'selected' : ''}>Working</option>
                                    <option value="Pending" ${param.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                    <option value="Leave" ${param.status == 'Leave' ? 'selected' : ''}>Leave</option>
                                    <option value="Rejected" ${param.status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                                    <option value="NoSchedule" ${param.status == 'NoSchedule' ? 'selected' : ''}>No Schedule</option>
                                </select>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group">
                                <label>&nbsp;</label>
                                <button type="submit" class="btn-hospital btn-primary btn-filter form-control">
                                    <i class="fas fa-filter mr-2"></i>Filter
                                </button>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group" style="margin-top: 23px;">
                                <a href="assign-doctor-schedule" class="btn btn-secondary form-control mt-1" style="gap:22px;">Reset</a>
                            </div>
                        </div>
                    </div>
                </div>
            </form>

            <!-- Schedule Table -->
            <div class="hospital-table">
                <div class="table-header">
                    <h3>Doctor Schedules (<span id="scheduleCount">${fn:length(scheduleList)}</span>)</h3>
                </div>

                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>Doctor</th>
                        <th>Total Working Days (This Month)</th>
                        <th>Status Today</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="schedule" items="${scheduleList}">
                        <tr>
                            <td>
                                <div class="user-info">
                                    <div class="user-avatar">
                                            ${fn:substring(schedule.doctorName, 0, 1)}
                                            ${fn:length(schedule.doctorName) > 0 && fn:indexOf(schedule.doctorName, ' ') > 0
                                                    ? fn:substring(schedule.doctorName, fn:indexOf(schedule.doctorName, ' ') + 1, fn:indexOf(schedule.doctorName, ' ') + 2)
                                                    : ''}
                                    </div>
                                    <div class="user-details">
                                        <h4>${schedule.doctorName}</h4>
                                        <p>${schedule.doctorEmail}</p>
                                    </div>
                                </div>
                            </td>
                            <td><strong>${schedule.workingDaysThisMonth}</strong></td>
                            <td>
                                <c:forEach var="entry" items="${schedule.statusPerSlotToday}">
                                    <c:set var="slot" value="${entry.key}" />
                                    <c:set var="status" value="${entry.value}" />
                                    <c:choose>
                                        <c:when test="${status == 'Working'}">
                                            <span class="badge badge-published">${slot}: Working</span>
                                        </c:when>
                                        <c:when test="${status == 'PendingLeave'}">
                                            <span class="badge badge-category">${slot}: Pending</span>
                                        </c:when>
                                        <c:when test="${status == 'Leave'}">
                                            <span class="badge badge-draft">${slot}: Leave</span>
                                        </c:when>
                                        <c:when test="${status == 'Rejected'}">
                                            <span class="badge badge-danger">${slot}: Rejected</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-secondary">${slot}: No Schedule</span>
                                        </c:otherwise>
                                    </c:choose><br/>
                                </c:forEach>
                            </td>

                            <td>
                                <a href="view-doctor-schedule?doctorId=${schedule.doctorId}" class="btn btn-sm btn-primary">
                                    <i class="fas fa-eye mr-1"></i> View
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <!-- Empty State -->
                <c:if test="${empty scheduleList}">
                    <div class="empty-state">
                        <i class="fas fa-calendar-times"></i>
                        <h3>No schedules found</h3>
                    </div>
                </c:if>

            <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination-container mt-4 text-center">
                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="assign-doctor-schedule?page=${currentPage - 1}&keyword=${fn:escapeXml(param.keyword)}&dateFrom=${fn:escapeXml(param.dateFrom)}&dateTo=${fn:escapeXml(param.dateTo)}">«</a>
                                    </li>
                                </c:if>

                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link"
                                           href="assign-doctor-schedule?page=${i}&keyword=${fn:escapeXml(param.keyword)}&dateFrom=${fn:escapeXml(param.dateFrom)}&dateTo=${fn:escapeXml(param.dateTo)}">${i}</a>
                                    </li>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="assign-doctor-schedule?page=${currentPage + 1}&keyword=${fn:escapeXml(param.keyword)}&dateFrom=${fn:escapeXml(param.dateFrom)}&dateTo=${fn:escapeXml(param.dateTo)}">»</a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    // Predefined shift times
    const shiftTimes = {
        'MORNING': { start: '06:00', end: '14:00' },
        'AFTERNOON': { start: '14:00', end: '22:00' },
        'EVENING': { start: '18:00', end: '02:00' },
        'NIGHT': { start: '22:00', end: '06:00' }
    };

    // Update shift times when shift type changes (Add modal)
    function updateShiftTimes() {
        const shiftType = document.getElementById('shiftType').value;
        const startTime = document.getElementById('startTime');
        const endTime = document.getElementById('endTime');

        if (shiftTimes[shiftType]) {
            startTime.value = shiftTimes[shiftType].start;
            endTime.value = shiftTimes[shiftType].end;
            startTime.readOnly = true;
            endTime.readOnly = true;
        } else {
            startTime.readOnly = false;
            endTime.readOnly = false;
            if (shiftType === '') {
                startTime.value = '';
                endTime.value = '';
            }
        }
    }

    // Update shift times when shift type changes (Edit modal)
    function updateEditShiftTimes() {
        const shiftType = document.getElementById('editShiftType').value;
        const startTime = document.getElementById('editStartTime');
        const endTime = document.getElementById('editEndTime');

        if (shiftTimes[shiftType]) {
            startTime.value = shiftTimes[shiftType].start;
            endTime.value = shiftTimes[shiftType].end;
            startTime.readOnly = true;
            endTime.readOnly = true;
        } else {
            startTime.readOnly = false;
            endTime.readOnly = false;
            if (shiftType === '') {
                startTime.value = '';
                endTime.value = '';
            }
        }
    }

    // Toggle recurring options
    document.getElementById('recurring').addEventListener('change', function() {
        const recurringOptions = document.getElementById('recurringOptions');
        recurringOptions.style.display = this.checked ? 'block' : 'none';
    });

    // Set minimum date to today
    document.addEventListener('DOMContentLoaded', function() {
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('scheduleDate').setAttribute('min', today);
        document.getElementById('editScheduleDate').setAttribute('min', today);
    });
</script>

</body>
</html>