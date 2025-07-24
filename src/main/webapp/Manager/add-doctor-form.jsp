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
                    <a href="${pageContext.request.contextPath}/add-doctor-form" class="nav-link active">
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
                <li>
                    <a href="${pageContext.request.contextPath}/logout" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Logout</span>
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

            <c:if test="${param.msg == 'created'}">
                <div class="alert alert-success">✅ Account created and email sent successfully!</div>
            </c:if>
            <c:if test="${param.msg == 'created_but_email_failed'}">
                <div class="alert alert-warning">⚠️ Account created, but failed to send email. Please notify the user manually.</div>
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
                                    <label for="roleId">Role</label>
                                    <select class="form-control" id="roleId" name="roleId">
                                        <option value="1" <c:if test="${param.roleId == '1'}">selected</c:if>>Doctor</option>
                                        <option value="2" <c:if test="${param.roleId == '2'}">selected</c:if>>Receptionist</option>
                                        <option value="3" <c:if test="${param.roleId == '3'}">selected</c:if>>Manager</option>
                                    </select>
                                </div>

                                <div class="form-group" id="specialistGroup">
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
    $(document).ready(function () {
        function toggleDoctorFields() {
            var selectedRole = $('#roleId').val();
            if (selectedRole === '1') {
                $('#licenseGroup').show();
                $('input[name="specialist"]').closest('.form-group').show();
            } else {
                $('#licenseGroup').hide();
                $('input[name="specialist"]').closest('.form-group').hide();
            }
        }

        // Gọi hàm ngay khi trang load
        toggleDoctorFields();

        // Gọi lại khi thay đổi
        $('#roleId').change(function () {
            toggleDoctorFields();
        });
    });
</script>

<style>
    #licenseGroup,
    #specialistGroup {
        display: none;
    }

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