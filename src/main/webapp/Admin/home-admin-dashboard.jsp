<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hospital Admin Dashboard</title>

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
                    <a href="home-admin-dashboard.jsp">
                        <i class="fas fa-stethoscope"></i>
                    </a>
                </div>
                <div>
                    <a href="home-admin-dashboard.jsp">
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
                    <a href="home-admin-dashboard.jsp" class="nav-link">
                        <i class="fas fa-home"></i>
                        <span>Home</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/update-user-role" class="nav-link">
                        <i class="fas fa-users-cog"></i>
                        <span>User Management</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/blog-dashboard" class="nav-link">
                        <i class="fas fa-blog"></i>
                        <span>Blog</span>
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
            <div class="page-header d-flex justify-content-between align-items-center">
                <h1>Patient Management</h1>
                <div class="d-flex align-items-center">
                    <!-- Search Box -->
                    <div class="search-box mr-3">
                        <input type="search" placeholder="Search patients...">
                        <button class="btn-hospital btn-primary">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                    <a href="#" class="page-title-action">
                        <i class="fas fa-plus mr-2"></i>Add New Patient
                    </a>
                </div>
            </div>
        </div>

        <!-- Content Body -->
        <div class="content-body">
            <!-- Notice -->
            <div class="notice">
                <p><strong>Notice:</strong> The system has been updated with new features.
                    <a href="#">View details</a> | <a href="#">Close notice</a></p>
            </div>

            <!-- Subsubsub Navigation -->
            <ul class="subsubsub">
                <li><a href="#" class="current">All <span class="count">(1,234)</span></a></li>
                <li><a href="#">In Treatment <span class="count">(89)</span></a></li>
                <li><a href="#">Discharged <span class="count">(1,145)</span></a></li>
                <li><a href="#">Waiting <span class="count">(45)</span></a></li>
                <li><a href="#">Need Update <span class="count">(12)</span></a></li>
            </ul>

            <!-- Table -->
            <div class="hospital-table">
                <!-- Table Navigation Top -->
                <div class="tablenav">
                    <div class="actions">
                        <select name="action">
                            <option value="-1">Bulk Actions</option>
                            <option value="activate">Activate</option>
                            <option value="deactivate">Deactivate</option>
                            <option value="export">Export Excel</option>
                            <option value="delete">Delete</option>
                        </select>
                        <button class="btn-hospital">Apply</button>
                    </div>
                    <div class="actions">
                        <select name="status">
                            <option value="">All Status</option>
                            <option value="active">In Treatment</option>
                            <option value="discharged">Discharged</option>
                            <option value="waiting">Waiting</option>
                        </select>
                        <button class="btn-hospital">Filter</button>
                    </div>
                    <div class="tablenav-pages">
                        <span class="displaying-num">1,234 patients</span>
                    </div>
                </div>

                <!-- Patients Table -->
                <table>
                    <thead>
                    <tr>
                        <th class="check-column">
                            <input type="checkbox" id="cb-select-all">
                        </th>
                        <th>Patient ID</th>
                        <th>Full Name</th>
                        <th>Date of Birth</th>
                        <th>Gender</th>
                        <th>Phone Number</th>
                        <th>Status</th>
                        <th>Admission Date</th>
                        <th>Attending Doctor</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td class="check-column">
                            <input type="checkbox" name="patient_ids[]" value="1">
                        </td>
                        <td><strong>PT001234</strong></td>
                        <td>
                            <strong>John Smith</strong><br>
                            <small>johnsmith@email.com</small>
                        </td>
                        <td>15/03/1985</td>
                        <td>Male</td>
                        <td>0123456789</td>
                        <td><span class="badge badge-success">In Treatment</span></td>
                        <td>10/12/2024</td>
                        <td>Dr. Sarah Johnson</td>
                    </tr>
                    <tr>
                        <td class="check-column">
                            <input type="checkbox" name="patient_ids[]" value="2">
                        </td>
                        <td><strong>PT001235</strong></td>
                        <td>
                            <strong>Emily Davis</strong><br>
                            <small>emilydavis@email.com</small>
                        </td>
                        <td>22/07/1992</td>
                        <td>Female</td>
                        <td>0987654321</td>
                        <td><span class="badge badge-info">Discharged</span></td>
                        <td>08/12/2024</td>
                        <td>Dr. Michael Brown</td>
                    </tr>
                    <tr>
                        <td class="check-column">
                            <input type="checkbox" name="patient_ids[]" value="3">
                        </td>
                        <td><strong>PT001236</strong></td>
                        <td>
                            <strong>Robert Wilson</strong><br>
                            <small>robertwilson@email.com</small>
                        </td>
                        <td>05/11/1978</td>
                        <td>Male</td>
                        <td>0369852147</td>
                        <td><span class="badge badge-warning">Waiting</span></td>
                        <td>12/12/2024</td>
                        <td>Dr. Lisa Anderson</td>
                    </tr>
                    </tbody>
                </table>

                <!-- Table Navigation Bottom -->
                <div class="tablenav">
                    <div class="actions">
                        <select name="action2">
                            <option value="-1">Bulk Actions</option>
                            <option value="activate">Activate</option>
                            <option value="deactivate">Deactivate</option>
                            <option value="export">Export Excel</option>
                            <option value="delete">Delete</option>
                        </select>
                        <button class="btn-hospital">Apply</button>
                    </div>
                    <div class="tablenav-pages">
                        <span class="displaying-num">Showing 1-20 of 1,234 patients</span>
                        <div class="pagination-links">
                            <a href="#" class="btn-hospital">‹ Previous</a>
                            <span class="current-page">1</span>
                            <a href="#" class="btn-hospital">Next ›</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mt-4">
                <p class="text-muted"><em>Hospital Management System - Hospital Admin Dashboard</em></p>
            </div>
        </div>
    </div>
</div>

<!-- jQuery and Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    // Select all functionality
    $('#cb-select-all').change(function() {
        $('input[name="patient_ids[]"]').prop('checked', this.checked);
    });

    // Mobile responsive
    $(window).resize(function() {
        if ($(window).width() <= 768) {
            $('.sidebar').addClass('mobile');
        } else {
            $('.sidebar').removeClass('mobile');
        }
    }).trigger('resize');

    // Navigation active state
    $('.nav-link').click(function(e) {
        // Only preventDefault if href is '#'
        if ($(this).attr('href') === '#') {
            e.preventDefault();
        }
        $('.nav-link').removeClass('active');
        $(this).addClass('active');
    });
</script>
</body>
</html>
