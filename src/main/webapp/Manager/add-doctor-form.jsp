<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Doctor/Staff - Hospital Admin</title>

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
                    <a href="${pageContext.request.contextPath}/manager/staff-management" class="nav-link active">
                        <i class="fas fa-users"></i>
                        <span>Staff Management</span>
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
                        <h1>Add New Doctor/Staff</h1>
                        <p class="page-subtitle">Create new doctor or staff member account</p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/update-user-role" class="btn-hospital btn-secondary">
                            <i class="fas fa-arrow-left mr-2"></i>Back to User Management
                        </a>
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
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle mr-2"></i>${errorMessage}
                </div>
            </c:if>

            <!-- Add Doctor Form -->
            <div class="card">
                <div class="card-header">
                    <h3><i class="fas fa-user-plus mr-2"></i>Staff Information</h3>
                </div>
                <div class="card-body">
                    <form id="addDoctorForm" action="add-doctor-form" method="post" enctype="multipart/form-data">
                        <div class="row">
                            <!-- Personal Information Section -->
                            <div class="col-md-6">
                                <h5 class="section-title">Personal Information</h5>

                                <div class="form-group">
                                    <label for="fullName">Full Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="fullName" name="fullName"
                                           value="${param.fullName}" required>
                                </div>

                                <div class="form-group">
                                    <label for="email">Email Address <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="email" name="email"
                                           value="${param.email}" required>
                                </div>

                                <div class="form-group">
                                    <label for="phone">Phone Number <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control" id="phone" name="phone"
                                           value="${param.phone}" required>
                                </div>

                                <div class="form-group">
                                    <label for="dateOfBirth">Date of Birth</label>
                                    <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth"
                                           value="${param.dateOfBirth}">
                                </div>

                                <div class="form-group">
                                    <label for="gender">Gender</label>
                                    <select class="form-control" id="gender" name="gender">
                                        <option value="">Select Gender</option>
                                        <option value="M" <c:if test="${param.gender == 'M'}">selected</c:if>>Male</option>
                                        <option value="F" <c:if test="${param.gender == 'F'}">selected</c:if>>Female</option>
                                        <option value="O" <c:if test="${param.gender == 'O'}">selected</c:if>>Other</option>
                                    </select>
                                </div>

                            </div>

                            <!-- Professional Information Section -->
                            <div class="col-md-6">
                                <h5 class="section-title">Professional Information</h5>
                                <input type="hidden" name="role" value="doctor" />

                                <div class="form-group">
                                    <label>Specialist?</label><br>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="specialist" id="specialistYes" value="true"
                                               <c:if test="${param.specialist == 'true'}">checked</c:if>>
                                        <label class="form-check-label" for="specialistYes">Yes</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="specialist" id="specialistNo" value="false"
                                               <c:if test="${param.specialist == 'false' || empty param.specialist}">checked</c:if>>
                                        <label class="form-check-label" for="specialistNo">No</label>
                                    </div>
                                </div>


                                <div class="form-group" id="licenseGroup">
                                    <label for="licenseNumber">Medical License Number</label>
                                    <input type="text" class="form-control" id="licenseNumber" name="licenseNumber"
                                           value="${param.licenseNumber}">
                                </div>

                                <div class="form-group">
                                    <label for="profileImage">Profile Image</label>
                                    <input type="file" class="form-control-file" id="profileImage" name="profileImage"
                                           accept="image/*">
                                    <small class="form-text text-muted">Upload a profile picture (optional)</small>
                                </div>
                            </div>
                        </div>

                        <!-- Account Settings Section -->
                        <div class="row mt-4">
                            <div class="col-12">
                                <h5 class="section-title">Account Settings</h5>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="username">Username <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="username" name="username"
                                           value="${param.username}" required>
                                    <small class="form-text text-muted">Username for system login</small>
                                </div>

                                <div class="form-group">
                                    <label for="password">Password <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" id="password" name="password" required>
                                    <small class="form-text text-muted">Minimum 8 characters</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="confirmPassword">Confirm Password <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                </div>
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions mt-4">
                            <button type="submit" class="btn-hospital btn-primary">
                                <i class="fas fa-save mr-2"></i>Create Account
                            </button>
                            <button type="reset" class="btn-hospital btn-secondary">
                                <i class="fas fa-undo mr-2"></i>Reset Form
                            </button>
                            <a href="${pageContext.request.contextPath}/update-user-role" class="btn-hospital">
                                <i class="fas fa-times mr-2"></i>Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    $(document).ready(function() {
        // Show/hide fields based on role selection
        $('#role').change(function() {
            var selectedRole = $(this).val();

            if (selectedRole === 'doctor') {
                $('#specializationGroup').show();
                $('#licenseGroup').show();
                $('#specialization').attr('required', true);
                $('#licenseNumber').attr('required', true);
            } else {
                $('#specializationGroup').hide();
                $('#licenseGroup').hide();
                $('#specialization').removeAttr('required');
                $('#licenseNumber').removeAttr('required');
            }
        });

        // Password confirmation validation
        $('#confirmPassword').on('keyup', function() {
            var password = $('#password').val();
            var confirmPassword = $(this).val();

            if (password !== confirmPassword) {
                $(this).addClass('is-invalid');
                if (!$(this).next('.invalid-feedback').length) {
                    $(this).after('<div class="invalid-feedback">Passwords do not match</div>');
                }
            } else {
                $(this).removeClass('is-invalid');
                $(this).next('.invalid-feedback').remove();
            }
        });

        // Form validation
        $('#addDoctorForm').on('submit', function(e) {
            var password = $('#password').val();
            var confirmPassword = $('#confirmPassword').val();

            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                return false;
            }

            if (password.length < 8) {
                e.preventDefault();
                alert('Password must be at least 8 characters long!');
                return false;
            }
        });

        // Initialize role-specific fields
        $('#role').trigger('change');
    });
</script>

<style>
    .section-title {
        color: #2c3e50;
        border-bottom: 2px solid #3498db;
        padding-bottom: 5px;
        margin-bottom: 20px;
    }

    .form-actions {
        border-top: 1px solid #dee2e6;
        padding-top: 20px;
    }

    .card {
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        border: none;
    }

    .card-header {
        background-color: #f8f9fa;
        border-bottom: 1px solid #dee2e6;
    }

    .text-danger {
        color: #dc3545 !important;
    }

    .is-invalid {
        border-color: #dc3545;
    }

    .invalid-feedback {
        display: block;
        color: #dc3545;
        font-size: 0.875em;
        margin-top: 0.25rem;
    }
</style>

</body>
</html>