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
                    <a href="${pageContext.request.contextPath}/manager/dashboard">
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
                    <a href="${pageContext.request.contextPath}/assign-doctor-schedule" class="nav-link active">
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
                        <h1>Doctor Schedule Management</h1>
                        <p class="page-subtitle">Assign and manage work schedules for doctors</p>
                    </div>
                    <button type="button" class="page-title-action" data-toggle="modal" data-target="#addScheduleModal">
                        <i class="fas fa-plus mr-2"></i>Add New Schedule
                    </button>
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
                            <h3 class="stat-orange">${activeReceptionists != null ? activeReceptionists : 0}</h3>
                            <p>Active Receptionist</p>
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

                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Date Range</label>
                                <div class="row">
                                    <div class="col-md-6">
                                        <input type="date" class="form-control" name="dateFrom" value="${param.dateFrom}" placeholder="From date">
                                    </div>
                                    <div class="col-md-6">
                                        <input type="date" class="form-control" name="dateTo" value="${param.dateTo}" placeholder="To date">
                                    </div>
                                </div>
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

                        <a href="assign-doctor-schedule" class="btn btn-secondary form-control mt-1">Reset</a>
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
                                        <h4>Dr. ${schedule.doctorName}</h4>
                                        <p>${schedule.doctorEmail}</p>
                                    </div>
                                </div>
                            </td>
                            <td><strong>${schedule.workingDaysThisMonth}</strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${schedule.statusToday == 'Working'}">
                                        <span class="badge badge-published">Working</span>
                                    </c:when>
                                    <c:when test="${schedule.statusToday == 'PendingLeave'}">
                                        <span class="badge badge-category">Pending</span>
                                    </c:when>
                                    <c:when test="${schedule.statusToday == 'Leave'}">
                                        <span class="badge badge-draft">Leave</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-secondary">No Schedule</span>
                                    </c:otherwise>
                                </c:choose>
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
                        <p>Try adjusting your search criteria or <a href="#" data-toggle="modal" data-target="#addScheduleModal">create a new schedule</a></p>
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

<!-- Add Schedule Modal -->
<div class="modal fade" id="addScheduleModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-calendar-plus mr-2"></i>Add New Doctor Schedule
                </h5>
                <button type="button" class="close" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <form action="assign-doctor-schedule" method="post">
                <input type="hidden" name="action" value="create">
                <div class="modal-body">
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="doctorId">Doctor <span class="required">*</span></label>
                            <select class="form-control" id="doctorId" name="doctorId" required>
                                <option value="">Select Doctor</option>
                                <c:forEach var="doctor" items="${doctorList}">
                                    <option value="${doctor.userId}">Dr. ${doctor.fullName} - ${doctor.departmentName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group col-md-6">
                            <label for="scheduleDate">Date <span class="required">*</span></label>
                            <input type="date" class="form-control" id="scheduleDate" name="scheduleDate" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label for="shiftType">Shift Type <span class="required">*</span></label>
                            <select class="form-control" id="shiftType" name="shiftType" required onchange="updateShiftTimes()">
                                <option value="">Select Shift</option>
                                <option value="MORNING">Morning Shift</option>
                                <option value="AFTERNOON">Afternoon Shift</option>
                                <option value="EVENING">Evening Shift</option>
                                <option value="NIGHT">Night Shift</option>
                                <option value="CUSTOM">Custom Time</option>
                            </select>
                        </div>

                        <div class="form-group col-md-4">
                            <label for="startTime">Start Time <span class="required">*</span></label>
                            <input type="time" class="form-control" id="startTime" name="startTime" required>
                        </div>

                        <div class="form-group col-md-4">
                            <label for="endTime">End Time <span class="required">*</span></label>
                            <input type="time" class="form-control" id="endTime" name="endTime" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="notes">Notes</label>
                        <textarea class="form-control" id="notes" name="notes" rows="3"
                                  placeholder="Additional notes or special instructions..."></textarea>
                    </div>

                    <div class="form-group">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="recurring" name="recurring">
                            <label class="form-check-label" for="recurring">
                                Create recurring schedule (weekly)
                            </label>
                        </div>
                    </div>

                    <div id="recurringOptions" style="display: none;">
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="recurringWeeks">Number of weeks</label>
                                <input type="number" class="form-control" id="recurringWeeks" name="recurringWeeks"
                                       min="1" max="52" value="4">
                            </div>
                            <div class="form-group col-md-6">
                                <label for="recurringDays">Repeat on days</label>
                                <div class="form-check-group">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="recurringDays" value="1" id="mon">
                                        <label class="form-check-label" for="mon">Mon</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="recurringDays" value="2" id="tue">
                                        <label class="form-check-label" for="tue">Tue</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="recurringDays" value="3" id="wed">
                                        <label class="form-check-label" for="wed">Wed</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="recurringDays" value="4" id="thu">
                                        <label class="form-check-label" for="thu">Thu</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="recurringDays" value="5" id="fri">
                                        <label class="form-check-label" for="fri">Fri</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="recurringDays" value="6" id="sat">
                                        <label class="form-check-label" for="sat">Sat</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="recurringDays" value="0" id="sun">
                                        <label class="form-check-label" for="sun">Sun</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-hospital" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-hospital btn-primary">
                        <i class="fas fa-save mr-2"></i>Create Schedule
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Schedule Modal -->
<div class="modal fade" id="editScheduleModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-calendar-edit mr-2"></i>Edit Doctor Schedule
                </h5>
                <button type="button" class="close" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <form action="assign-doctor-schedule" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="scheduleId" id="editScheduleId">
                <div class="modal-body">
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="editDoctorId">Doctor <span class="required">*</span></label>
                            <select class="form-control" id="editDoctorId" name="doctorId" required>
                                <option value="">Select Doctor</option>
                                <c:forEach var="doctor" items="${doctorList}">
                                    <option value="${doctor.userId}">Dr. ${doctor.fullName} - ${doctor.departmentName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group col-md-6">
                            <label for="editScheduleDate">Date <span class="required">*</span></label>
                            <input type="date" class="form-control" id="editScheduleDate" name="scheduleDate" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label for="editShiftType">Shift Type <span class="required">*</span></label>
                            <select class="form-control" id="editShiftType" name="shiftType" required onchange="updateEditShiftTimes()">
                                <option value="">Select Shift</option>
                                <option value="MORNING">Morning Shift</option>
                                <option value="AFTERNOON">Afternoon Shift</option>
                                <option value="EVENING">Evening Shift</option>
                                <option value="NIGHT">Night Shift</option>
                                <option value="CUSTOM">Custom Time</option>
                            </select>
                        </div>

                        <div class="form-group col-md-4">
                            <label for="editStartTime">Start Time <span class="required">*</span></label>
                            <input type="time" class="form-control" id="editStartTime" name="startTime" required>
                        </div>

                        <div class="form-group col-md-4">
                            <label for="editEndTime">End Time <span class="required">*</span></label>
                            <input type="time" class="form-control" id="editEndTime" name="endTime" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="editStatus">Status <span class="required">*</span></label>
                            <select class="form-control" id="editStatus" name="status" required>
                                <option value="ACTIVE">Active</option>
                                <option value="CANCELLED">Cancelled</option>
                                <option value="COMPLETED">Completed</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="editNotes">Notes</label>
                        <textarea class="form-control" id="editNotes" name="notes" rows="3"
                                  placeholder="Additional notes or special instructions..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-hospital" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-hospital btn-primary">
                        <i class="fas fa-save mr-2"></i>Update Schedule
                    </button>
                </div>
            </form>
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

    // Edit schedule function
    function editSchedule(scheduleId) {
        // This would typically fetch schedule data via AJAX
        // For now, we'll just set the schedule ID
        document.getElementById('editScheduleId').value = scheduleId;

        // In a real implementation, you would fetch the schedule data and populate the form
        // Example AJAX call:
        /*
        $.ajax({
            url: 'get-schedule-details',
            method: 'GET',
            data: { scheduleId: scheduleId },
            success: function(data) {
                document.getElementById('editDoctorId').value = data.doctorId;
                document.getElementById('editScheduleDate').value = data.scheduleDate;
                document.getElementById('editShiftType').value = data.shiftType;
                document.getElementById('editStartTime').value = data.startTime;
                document.getElementById('editEndTime').value = data.endTime;
                document.getElementById('editStatus').value = data.status;
                document.getElementById('editNotes').value = data.notes;
            }
        });
        */
    }

    // Set minimum date to today
    document.addEventListener('DOMContentLoaded', function() {
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('scheduleDate').setAttribute('min', today);
        document.getElementById('editScheduleDate').setAttribute('min', today);
    });

    // Form validation
    document.querySelector('#addScheduleModal form').addEventListener('submit', function(e) {
        const startTime = document.getElementById('startTime').value;
        const endTime = document.getElementById('endTime').value;

        if (startTime && endTime && startTime >= endTime) {
            e.preventDefault();
            alert('End time must be after start time');
            return false;
        }
    });

    document.querySelector('#editScheduleModal form').addEventListener('submit', function(e) {
        const startTime = document.getElementById('editStartTime').value;
        const endTime = document.getElementById('editEndTime').value;

        if (startTime && endTime && startTime >= endTime) {
            e.preventDefault();
            alert('End time must be after start time');
            return false;
        }
    });
</script>

</body>
</html>