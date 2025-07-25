<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Appointment" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Unassigned Appointments - Manager Dashboard</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
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
                    <a href="${pageContext.request.contextPath}/manager-dashboard" class="nav-link ">
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
                <li>
                    <a href="${pageContext.request.contextPath}/export-activity-report" class="nav-link">
                        <i class="fas fa-file-invoice-dollar"></i> <span>Income Report</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/add-doctor-form" class="nav-link">
                        <i class="fas fa-user-plus"></i> <span>Add Staff</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/assign-doctor-schedule" class="nav-link">
                        <i class="fas fa-calendar-alt"></i> <span>Doctor Schedules</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/unassigned-appointments" class="nav-link active">
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
        <div class="content-header">
            <div class="page-header">
                <h1>Unassigned Appointments</h1>
                <p class="page-subtitle">Manage and assign pending appointments</p>
            </div>
        </div>

        <div class="content-body">
            <div class="hospital-table">
                <div class="table-header">
                    <h3>List of Unassigned Appointments</h3>
                </div>
                <div class="table-responsive">
                    <table class="table table-bordered">
                        <thead class="thead-light">
                        <tr>
                            <th>#</th>
                            <th>Patient ID</th>
                            <th>Appointment Date</th>
                            <th>Time Slot</th>
                            <th>Type</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                            if (appointments == null || appointments.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="text-center">
                                <div class="empty-state">
                                    <i class="fas fa-calendar-times"></i>
                                    <h3>No unassigned appointments found</h3>
                                    <p>There are currently no pending appointments.</p>
                                </div>
                            </td>
                        </tr>
                        <% } else {
                            int index = 1;
                            for (Appointment a : appointments) { %>
                        <tr>
                            <td><%= index++ %></td>
                            <td><%= a.getPatientId() %></td>
                            <td><%= a.getAppointmentDate() %></td>
                            <td><%= a.getTimeSlot() %></td>
                            <td><%= a.getAppointmentTypeId() %></td>
                            <td><%= a.getStatus() %></td>
                            <td>
                                <button type="button"
                                        class="btn-hospital btn-primary btn-sm open-assign-modal"
                                        data-id="<%= a.getAppointmentId() %>">
                                    Assign
                                </button>
                            </td>
                        </tr>
                        <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="assignDoctorModal" tabindex="-1" role="dialog" aria-labelledby="assignDoctorModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Assign Doctor</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body" id="assignModalBody">
                <!-- Nội dung form load từ servlet -->
                <div class="text-center text-muted"><i class="fas fa-spinner fa-spin"></i> Loading...</div>
            </div>
        </div>
    </div>
</div>


<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
    $(document).on("click", ".open-assign-modal", function () {
        const appointmentId = $(this).data("id");
        const modalBody = $("#assignModalBody");
        modalBody.html('<div class="text-center text-muted"><i class="fas fa-spinner fa-spin"></i> Loading...</div>');

        $("#assignDoctorModal").modal("show");

        $.ajax({
            url: "<%= request.getContextPath() %>/assign-appointment?id=" + appointmentId,
            method: "GET",
            success: function (data) {
                modalBody.html(data);
            },
            error: function () {
                modalBody.html('<div class="alert alert-danger">Failed to load form. Please try again.</div>');
            }
        });
    });
</script>
</body>
</html>
