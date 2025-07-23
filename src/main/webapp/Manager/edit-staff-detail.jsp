<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Staff Details - Hospital Management System</title>

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

        .info-content {
            flex: 1;
        }

        .info-content h6 {
            font-size: 0.875rem;
            color: #64748b;
            margin: 0 0 0.25rem 0;
            font-weight: 500;
        }

        .info-content .form-control {
            font-size: 1rem;
            color: #1a202c;
            font-weight: 600;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 0.5rem 0.75rem;
        }

        .info-content .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .back-button {
            margin-bottom: 1rem;
        }

        .action-buttons {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #e2e8f0;
        }

        .avatar-upload {
            position: relative;
            display: inline-block;
        }

        .avatar-upload-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.5);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s;
            cursor: pointer;
        }

        .avatar-upload:hover .avatar-upload-overlay {
            opacity: 1;
        }

        .avatar-upload-overlay i {
            color: white;
            font-size: 1.5rem;
        }

        #avatarInput {
            display: none;
        }

        .required {
            color: #e53e3e;
        }

        .form-group label {
            font-weight: 600;
            color: #4a5568;
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
                        <h1>Edit Staff Details</h1>
                        <p class="page-subtitle">Modify information for ${employee.fullName}</p>
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
                <a href="${pageContext.request.contextPath}/staff-detail?id=${employee.employeeId}" class="btn-hospital btn-secondary">
                    <i class="fas fa-arrow-left mr-1"></i>Back to Details
                </a>
            </div>

            <!-- Edit Form -->
            <form action="${pageContext.request.contextPath}/staff-edit" method="post" enctype="multipart/form-data" id="editStaffForm">
                <input type="hidden" name="employeeId" value="${employee.employeeId}">
                <!-- Staff Profile Header -->
                <div class="staff-detail-card">
                    <div class="staff-profile-header">
                        <div class="row">
                            <div class="col-md-3 text-center">
                                <div class="avatar-upload">
                                    <input type="file" id="avatarInput" name="avatarFile" style="display: none;" accept="image/*" onchange="previewAvatar(event)">
                                    <input type="hidden" name="currentAvatar" value="${employee.employeeAvaUrl}">

                                    <c:choose>
                                        <c:when test="${not empty employee.employeeAvaUrl}">
                                            <img src="${pageContext.request.contextPath}/${employee.employeeAvaUrl}"
                                                 alt="Avatar" class="staff-avatar-large" id="avatarPreview">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="" alt="Avatar" class="staff-avatar-large" id="avatarPreview" style="display: none;">
                                            <div class="avatar-circle-large" id="avatarInitial">${fn:substring(employee.fullName, 0, 1)}</div>
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="avatar-upload-overlay" onclick="document.getElementById('avatarInput').click()">
                                        <i class="fas fa-camera"></i>
                                    </div>
                                </div>

                                <input type="file" id="avatarInput" name="avatar" accept="image/*" onchange="previewAvatar(this)">

                                <div class="mt-3">
                                    <div class="form-group">
                                        <label for="accStatus">Account Status</label>
                                        <select class="form-control" id="accStatus" name="accStatus">
                                            <option value="1" ${employee.accStatus == 1 ? 'selected' : ''}>Active</option>
                                            <option value="0" ${employee.accStatus == 0 ? 'selected' : ''}>Inactive</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-9">
                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="form-group">
                                            <label for="fullName">Full Name <span class="required">*</span></label>
                                            <input type="text" class="form-control" id="fullName" name="fullName"
                                                   value="${employee.fullName}" required>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="roleId">Role <span class="required">*</span></label>
                                            <select class="form-control" id="roleId" name="roleId" required>
                                                <option value="1" ${employee.roleId == 1 ? 'selected' : ''}>Doctor</option>
                                                <option value="2" ${employee.roleId == 2 ? 'selected' : ''}>Receptionist</option>
                                                <option value="3" ${employee.roleId == 3 ? 'selected' : ''}>Admin</option>
                                                <option value="4" ${employee.roleId == 4 ? 'selected' : ''}>Manager</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="info-item">
                                            <div class="info-icon">
                                                <i class="fas fa-user"></i>
                                            </div>
                                            <div class="info-content">
                                                <h6>Username <span class="required">*</span></h6>
                                                <input type="text" class="form-control" name="username"
                                                       value="${employee.username}" readonly>
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
                                <h6>Date of Birth <span class="required">*</span></h6>
                                <input type="date" class="form-control" name="dob"
                                       value="${employee.dob}" required>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fas fa-venus-mars"></i>
                            </div>
                            <div class="info-content">
                                <h6>Gender <span class="required">*</span></h6>
                                <select class="form-control" name="gender" required>
                                    <option value="M" ${employee.gender == 'M' ? 'selected' : ''}>Male</option>
                                    <option value="F" ${employee.gender == 'F' ? 'selected' : ''}>Female</option>
                                    <option value="O" ${employee.gender == 'O' ? 'selected' : ''}>Other</option>
                                </select>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="info-content">
                                <h6>Account Created</h6>
                                <input type="text" class="form-control"
                                       value="<fmt:formatDate value='${employee.createdAt}' pattern="MMMM dd, yyyy 'at' HH:mm" />"
                                       readonly>
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
                                <h6>Phone Number <span class="required">*</span></h6>
                                <input type="tel" class="form-control" name="phone"
                                       value="${employee.phone}" required
                                       pattern="[0-9]{10,15}" title="Please enter a valid phone number">
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <div class="info-content">
                                <h6>Email Address <span class="required">*</span></h6>
                                <input type="email" class="form-control" name="email"
                                       value="${employee.email}" required>
                            </div>
                        </div>
                    </div>

                    <!-- Professional Information -->
                    <div class="info-section">
                        <h5 class="info-section-title">
                            <i class="fas fa-briefcase"></i>
                            Professional Information
                        </h5>

                        <div id="doctorFields" style="display: ${employee.roleId == 1 ? 'block' : 'none'};">
                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="fas fa-id-card"></i>
                                </div>
                                <div class="info-content">
                                    <h6>License Number</h6>
                                    <input type="text" class="form-control" name="licenseNumber"
                                           value="${doctorDetails.licenseNumber != null ? doctorDetails.licenseNumber : ''}">
                                </div>
                            </div>

                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="fas fa-user-md"></i>
                                </div>
                                <div class="info-content">
                                    <h6>Is Specialist</h6>
                                    <select class="form-control" name="isSpecialist">
                                        <option value="true" ${doctorDetails != null && doctorDetails.specialist ? "selected" : ""}>Yes</option>
                                        <option value="false" ${doctorDetails != null && !doctorDetails.specialist ? "selected" : ""}>No</option>
                                    </select>
                                </div>
                            </div>

                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="fas fa-shield-alt"></i>
                                </div>
                                <div class="info-content">
                                    <h6>Account Status</h6>
                                    <input type="text" class="form-control"
                                           value="${employee.accStatus == 1 ? 'Active' : 'Inactive'}" readonly>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <div class="row">
                        <div class="col-md-12">
                            <button type="submit" class="btn-hospital btn-primary mr-2">
                                <i class="fas fa-save mr-1"></i>Save Changes
                            </button>
                            <button type="reset" class="btn-hospital btn-secondary mr-2">
                                <i class="fas fa-undo mr-1"></i>Reset Form
                            </button>
                            <a href="${pageContext.request.contextPath}/staff-detail?id=${employee.employeeId}" class="btn-hospital btn-outline-secondary">
                                <i class="fas fa-times mr-1"></i>Cancel
                            </a>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- jQuery and Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    function previewAvatar(event) {
        const file = event.target.files[0];
        const preview = document.getElementById("avatarPreview");
        const initial = document.getElementById("avatarInitial");

        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.style.display = "block";
                if (initial) {
                    initial.style.display = "none";
                }
            };
            reader.readAsDataURL(file);
        }
    }
</script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const roleSelect = document.getElementById("roleId");
        const doctorFields = document.getElementById("doctorFields");

        function toggleDoctorFields() {
            if (roleSelect.value === "1") {
                doctorFields.style.display = "block";
            } else {
                doctorFields.style.display = "none";
            }
        }

        // Gọi khi load và khi thay đổi
        toggleDoctorFields();
        roleSelect.addEventListener("change", toggleDoctorFields);
    });
</script>

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

    // Avatar preview function
    function previewAvatar(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                $('#avatarPreview').html('<img src="' + e.target.result + '" alt="Avatar" class="staff-avatar-large">');
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    // Update role display based on selection
    function updateRoleDisplay() {
        var roleId = $('#roleId').val();
        var roleText = '';
        switch(roleId) {
            case '1': roleText = 'Doctor'; break;
            case '2': roleText = 'Receptionist'; break;
            case '3': roleText = 'Admin'; break;
            case '4': roleText = 'Manager'; break;
            default: roleText = 'Staff';
        }
        $('#roleDisplay').val(roleText);
    }

    // Update status display based on selection
    function updateStatusDisplay() {
        var status = $('#accStatus').val();
        $('#statusDisplay').val(status == '1' ? 'Active' : 'Inactive');
    }

    // Form validation
    function validateForm() {
        var isValid = true;
        var requiredFields = ['fullName', 'username', 'dob', 'gender', 'phone', 'email', 'roleId'];

        requiredFields.forEach(function(field) {
            var input = $('[name="' + field + '"]');
            if (!input.val().trim()) {
                input.addClass('is-invalid');
                isValid = false;
            } else {
                input.removeClass('is-invalid');
            }
        });

        // Email validation
        var email = $('[name="email"]').val();
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (email && !emailRegex.test(email)) {
            $('[name="email"]').addClass('is-invalid');
            isValid = false;
        }

        // Phone validation
        var phone = $('[name="phone"]').val();
        var phoneRegex = /^[0-9]{10,15}$/;
        if (phone && !phoneRegex.test(phone)) {
            $('[name="phone"]').addClass('is-invalid');
            isValid = false;
        }

        return isValid;
    }

    $(document).ready(function() {
        // Initialize displays
        updateRoleDisplay();
        updateStatusDisplay();

        // Update displays when selections change
        $('#roleId').change(updateRoleDisplay);
        $('#accStatus').change(updateStatusDisplay);

        // Form submission
        $('#editStaffForm').submit(function(e) {
            if (!validateForm()) {
                e.preventDefault();
                alert('Please fill in all required fields correctly.');
                return false;
            }

            // Show confirmation
            if (!confirm('Are you sure you want to save these changes?')) {
                e.preventDefault();
                return false;
            }
        });

        // Real-time validation
        $('input, select').on('blur', function() {
            if ($(this).attr('required') && !$(this).val().trim()) {
                $(this).addClass('is-invalid');
            } else {
                $(this).removeClass('is-invalid');
            }
        });

        console.log('Edit staff form loaded');
    });
</script>
</body>
</html>