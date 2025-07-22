<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Details - Hospital Management System</title>

    <!-- Bootstrap 4 CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- Hospital Admin CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/hospital-admin.css">

    <style>
        .staff-detail-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }

        .staff-profile-header {
            padding: 2rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .staff-avatar-large {
            width: 120px;
            height: 120px;
            border-radius: 12px;
            object-fit: cover;
            border: 4px solid white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .avatar-circle-large {
            width: 120px;
            height: 120px;
            border-radius: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
            font-weight: bold;
            border: 4px solid white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .info-section {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 1.5rem;
        }

        .info-section-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1a202c;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e2e8f0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f7fafc;
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-icon {
            width: 40px;
            height: 40px;
            background: #f1f5f9;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #64748b;
            margin-right: 1rem;
        }

        .info-content h6 {
            font-size: 0.875rem;
            color: #64748b;
            margin: 0 0 0.25rem 0;
            font-weight: 500;
        }

        .info-content p {
            font-size: 1rem;
            color: #1a202c;
            margin: 0;
            font-weight: 600;
        }

        .back-button {
            margin-bottom: 1rem;
        }

        .action-buttons {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #e2e8f0;
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
                    <a href="${pageContext.request.contextPath}/update-user-role" class="nav-link">
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
                        <h1>Staff Details</h1>
                        <p class="page-subtitle">Detailed information for ${employee.fullName}</p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/staff-edit?id=${employee.employeeId}" class="btn-hospital btn-primary mr-2">
                            <i class="fas fa-edit mr-1"></i>Edit Staff
                        </a>
                        <a href="${pageContext.request.contextPath}/view-doctor-schedule?doctorId=${employee.employeeId}" class="btn-hospital btn-secondary">
                            <i class="fas fa-calendar mr-1"></i>View Schedule
                        </a>
                    </div>
                </div>
            </div>
        </div>
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
        <!-- Content Body -->
        <div class="content-body">
            <!-- Back Button -->
            <div class="back-button">
                <a href="${pageContext.request.contextPath}/manager-dashboard" class="btn-hospital btn-secondary">
                    <i class="fas fa-arrow-left mr-1"></i>Back to Dashboard
                </a>
            </div>

            <!-- Staff Profile Header -->
            <div class="staff-detail-card">
                <div class="staff-profile-header">
                    <div class="row">
                        <div class="col-md-3 text-center">

                            <c:choose>
                                <c:when test="${not empty employee.employeeAvaUrl}">
                                    <img src="${pageContext.request.contextPath}/${employee.employeeAvaUrl}" alt="Avatar" class="staff-avatar-large">
                                </c:when>
                                <c:otherwise>
                                    <div class="avatar-circle-large">${fn:substring(employee.fullName, 0, 1)}</div>
                                </c:otherwise>
                            </c:choose>

                            <div class="mt-3">
                                <c:choose>
                                    <c:when test="${employee.accStatus == 1}">
                                        <span class="badge badge-success badge-lg" >Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger badge-lg">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="col-md-9">
                            <div class="d-flex align-items-center mb-3">
                                <h2 class="mb-0 mr-3">${employee.fullName}</h2>
                                <c:choose>
                                    <c:when test="${employee.roleId == 1}">
                                        <span class="role-badge role-doctor">Doctor</span>
                                    </c:when>
                                    <c:when test="${employee.roleId == 2}">
                                        <span class="role-badge role-assistant">Receptionist</span>
                                    </c:when>
                                    <c:when test="${employee.roleId == 3}">
                                        <span class="role-badge role-manager">Admin</span>
                                    </c:when>
                                    <c:when test="${employee.roleId == 4}">
                                        <span class="role-badge role-manager">Manager</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="role-badge role-manager">Staff</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="fas fa-id-card"></i>
                                        </div>
                                        <div class="info-content">
                                            <h6>Employee ID</h6>
                                            <p>${employee.employeeId}</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="fas fa-user"></i>
                                        </div>
                                        <div class="info-content">
                                            <h6>Username</h6>
                                            <p>${employee.username}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Information Grid -->
            <div class="info-grid">
                <!-- Personal Information -->
                <div class="info-section">
                    <h5 class="info-section-title">
                        <i class="fas fa-user"></i>
                        Personal Information
                    </h5>

                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-calendar"></i>
                        </div>
                        <div class="info-content">
                            <h6>Date of Birth</h6>
                            <p>
                                <fmt:parseDate value="${employee.dob}" pattern="yyyy-MM-dd" var="dobDate" />
                                <fmt:formatDate value="${dobDate}" pattern="MMMM dd, yyyy" />
                            </p>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-venus-mars"></i>
                        </div>
                        <div class="info-content">
                            <h6>Gender</h6>
                            <p>
                                <c:choose>
                                    <c:when test="${employee.gender == 'M'}">Male</c:when>
                                    <c:when test="${employee.gender == 'F'}">Female</c:when>
                                    <c:otherwise>Other</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="info-content">
                            <h6>Account Created</h6>
                            <p>
                                <fmt:formatDate value="${employee.createdAt}" pattern="MMMM dd, yyyy 'at' HH:mm" />
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Contact Information -->
                <div class="info-section">
                    <h5 class="info-section-title">
                        <i class="fas fa-address-book"></i>
                        Contact Information
                    </h5>

                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-phone"></i>
                        </div>
                        <div class="info-content">
                            <h6>Phone Number</h6>
                            <p>${employee.phone}</p>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div class="info-content">
                            <h6>Email Address</h6>
                            <p>${employee.email}</p>
                        </div>
                    </div>
                </div>

                <!-- Professional Information -->
                <div class="info-section">
                    <h5 class="info-section-title">
                        <i class="fas fa-briefcase"></i>
                        Professional Information
                    </h5>

                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-user-tag"></i>
                        </div>
                        <div class="info-content">
                            <h6>Role</h6>
                            <p>
                                <c:choose>
                                    <c:when test="${employee.roleId == 1}">Doctor</c:when>
                                    <c:when test="${employee.roleId == 2}">Receptionist</c:when>
                                    <c:when test="${employee.roleId == 3}">Admin</c:when>
                                    <c:when test="${employee.roleId == 4}">Manager</c:when>
                                    <c:otherwise>Staff</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div class="info-content">
                            <h6>Account Status</h6>
                            <p>
                                <c:choose>
                                    <c:when test="${employee.accStatus == 1}">
                                        <span class="badge badge-success">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>

                    <!-- Nếu là Doctor, hiển thị thêm thông tin chuyên môn -->
                    <c:if test="${employee.roleId == 1}">
                        <!-- License Number -->
                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fas fa-id-card"></i>
                            </div>
                            <div class="info-content">
                                <h6>License Number</h6>
                                <p>${doctorDetails.licenseNumber}</p>
                            </div>
                        </div>

                        <!-- Is Specialist -->
                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <div class="info-content">
                                <h6>Is Specialist</h6>
                                <p>
                                    <c:choose>
                                        <c:when test="${doctorDetails.specialist}">Yes</c:when>
                                        <c:otherwise>No</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </c:if>

                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-key"></i>
                        </div>
                        <div class="info-content">
                            <h6>Role ID</h6>
                            <p>${employee.roleId}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <div class="row">
                    <div class="col-md-12">
                        <a href="${pageContext.request.contextPath}/staff-edit?id=${employee.employeeId}" class="btn-hospital btn-primary mr-2">
                            <i class="fas fa-edit mr-1"></i>Edit Information
                        </a>
                        <a href="${pageContext.request.contextPath}/view-doctor-schedule?doctorId=${employee.employeeId}" class="btn-hospital btn-secondary mr-2">
                            <i class="fas fa-calendar mr-1"></i>Manage Schedule
                        </a>
                        <c:if test="${employee.roleId == 1}">
                            <a href="${pageContext.request.contextPath}/doctor-appointments?doctorId=${employee.employeeId}" class="btn-hospital btn-info mr-2">
                                <i class="fas fa-calendar-check mr-1"></i>View Appointments
                            </a>
                        </c:if>
                    </div>
                </div>
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

    $(document).ready(function() {
        // Add any specific functionality for staff detail view
        console.log('Staff detail view loaded');
    });
</script>
</body>
</html>