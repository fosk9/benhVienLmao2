    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <title>Approve Leave Request</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Manager/css/hospital-admin.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    </head>
    <style>
        /* Approve Leave Form Styling */
        .card-style {
            background-color: #ffffff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.05);
            transition: all 0.3s ease-in-out;
        }

        .card-style:hover {
            box-shadow: 0 4px 25px rgba(0,0,0,0.08);
        }

        .card-style h5 {
            font-size: 20px;
            font-weight: 600;
            color: #2c3e50;
        }

        .card-style .form-group label {
            font-weight: 600;
            color: #34495e;
        }

        .card-style select.form-control {
            height: 45px;
            font-size: 16px;
            border-radius: 6px;
            border: 1px solid #dcdfe6;
            background-color: #fefefe;
        }

        .card-style select:focus {
            border-color: #409eff;
            box-shadow: 0 0 0 2px rgba(64,158,255,0.2);
        }

        .card-style .list-group-item {
            background-color: #fafafa;
            border: none;
            font-size: 16px;
            padding: 12px 20px;
        }

        .card-style .btn {
            min-width: 120px;
            font-weight: 500;
            font-size: 15px;
            border-radius: 8px;
        }

        .card-style .btn-success {
            background-color: #28a745;
            border: none;
        }

        .card-style .btn-danger {
            background-color: #dc3545;
            border: none;
        }

        .card-style .btn-secondary {
            background-color: #6c757d;
            border: none;
        }

        .card-style .btn:hover {
            opacity: 0.9;
        }

        .alert-warning {
            background-color: #fff3cd;
            border-color: #ffeeba;
            color: #856404;
            font-size: 15px;
            padding: 12px 20px;
            border-radius: 6px;
        }
        .page-header {
            background-color: #ffffff;
            border-bottom: 1px solid #e5e5e5;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }

        .page-header h3 {
            font-size: 24px;
            font-weight: 700;
            color: #2c3e50;
        }

        .page-header p {
            font-size: 15px;
            color: #7f8c8d;
        }

    </style>
    <body style="display: flex; margin: 0; background-color: #f5f7fa;">

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
                    <a href="${pageContext.request.contextPath}/assign-doctor-schedule" class="nav-link">
                        <i class="fas fa-calendar-alt"></i> <span>Doctor Schedules</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/unassigned-appointments" class="nav-link">
                        <i class="fas fa-calendar-times"></i> <span>Unassigned Appointments</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/request-leave-list" class="nav-link active">
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
    <div class="content" style="flex: 1; margin-left: 260px;">
        <div style="margin-left: 20px">
            <div class="page-header shadow-sm bg-white p-4 mb-4 rounded">
                <h3 class="font-weight-bold text-dark mb-1">Approve Leave Request</h3>
                <p class="text-muted mb-0">Review details and approve/reject doctor leave requests.</p>
            </div>
        </div>

        <div class="content-body px-4">
            <div class="card-style p-4">
                <h5 class="mb-4">Shift Information</h5>
                <ul class="list-group mb-4">
                    <li class="list-group-item"><strong>Doctor ID:</strong> ${shift.doctorId}</li>
                    <li class="list-group-item"><strong>Shift Date:</strong> ${shift.shiftDate}</li>
                    <li class="list-group-item"><strong>Time Slot:</strong> ${shift.timeSlot}</li>
                    <li class="list-group-item"><strong>Status:</strong> ${shift.status}</li>
                </ul>

                <form action="approve-leave" method="post">
                    <input type="hidden" name="shiftId" value="${shift.shiftId}">
                    <input type="hidden" name="managerId" value="1"> <%-- TODO: lấy từ session --%>

                    <div class="form-group">
                        <label for="replacementDoctorId"><strong>Replacement Doctor</strong></label>
                        <select name="replacementDoctorId" class="form-control" required>
                            <c:forEach var="doctor" items="${availableDoctors}">
                                <option value="${doctor.employeeId}">
                                        ${doctor.fullName} (ID: ${doctor.employeeId})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <c:if test="${empty availableDoctors}">
                        <div class="alert alert-warning mt-3">
                            ⚠ No available doctors found for this shift. You may only reject this request.
                        </div>
                    </c:if>

                    <div class="mt-4 d-flex justify-content-between">
                        <button type="submit" name="action" value="approve" class="btn btn-success" ${empty availableDoctors ? 'disabled' : ''}>
                            Approve
                        </button>
                        <button type="submit" name="action" value="reject" class="btn btn-danger">Reject</button>
                        <a href="request-leave-list" class="btn btn-secondary">Back</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
    </html>
