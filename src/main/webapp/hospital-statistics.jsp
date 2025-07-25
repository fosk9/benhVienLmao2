<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Revenue Report - Manager Dashboard</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                    <a href="${pageContext.request.contextPath}/hospital-statistics" class="nav-link active">
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
        <div class="content-header">
            <div class="page-header">
                <h1>Revenue Report</h1>
                <p class="page-subtitle">Visualized financial data & insights</p>
            </div>
        </div>
        <div class="content-body">
            <div class="stats-grid mb-4">
                <div class="stat-card">
                    <div class="stat-card-content">
                        <div class="stat-info">
                            <h3 class="stat-blue"><%= String.format("%,.0f VND", request.getAttribute("totalIncome")) %></h3>
                            <p>Total Income</p>
                        </div>
                        <div class="stat-icon stat-blue"><i class="fas fa-coins"></i></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-content">
                        <div class="stat-info">
                            <h3 class="stat-green"><%= String.format("%,.0f VND", request.getAttribute("thisMonth")) %></h3>
                            <p>This Month</p>
                        </div>
                        <div class="stat-icon stat-green"><i class="fas fa-calendar-check"></i></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-content">
                        <div class="stat-info">
                            <% double rate = (double) request.getAttribute("growthRate"); %>
                            <h3 class="<%= rate >= 0 ? "stat-green" : "stat-purple" %>"><%= String.format("%.2f%% %s", Math.abs(rate), rate >= 0 ? "▲" : "▼") %></h3>
                            <p>Growth Rate</p>
                        </div>
                        <div class="stat-icon <%= rate >= 0 ? "stat-green" : "stat-purple" %>"><i class="fas fa-chart-line"></i></div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="hospital-table">
                        <div class="table-header"><h3>Monthly Income</h3></div>
                        <div class="p-4"><canvas id="monthlyIncomeChart" height="200"></canvas></div>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="hospital-table">
                        <div class="table-header"><h3>Top Doctor Revenue</h3></div>
                        <div class="p-4"><canvas id="doctorIncomeChart" height="200"></canvas></div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="hospital-table mb-4">
                        <div class="table-header bg-primary text-white"><h3>Top Doctors This Month</h3></div>
                        <ul class="list-group list-group-flush">
                            <% java.util.List<String> topDoctors = (java.util.List<String>) request.getAttribute("topDoctors");
                                for (String s : topDoctors) { %>
                            <li class="list-group-item py-3"><i class="fas fa-user-md text-primary mr-2"></i> <%= s %></li>
                            <% } %>
                        </ul>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="hospital-table mb-4">
                        <div class="table-header bg-success text-white"><h3>Popular Services Recently</h3></div>
                        <ul class="list-group list-group-flush">
                            <% java.util.List<String> popularServices = (java.util.List<String>) request.getAttribute("popularServices");
                                for (String s : popularServices) { %>
                            <li class="list-group-item py-3"><i class="fas fa-stethoscope text-success mr-2"></i> <%= s %></li>
                            <% } %>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const monthlyIncomeLabels = ${monthlyIncomeLabels};
    const monthlyIncomeData = ${monthlyIncomeData};
    const doctorNames = ${doctorNames};
    const doctorIncomeData = ${doctorIncomeData};

    new Chart(document.getElementById('monthlyIncomeChart'), {
        type: 'bar',
        data: {
            labels: monthlyIncomeLabels,
            datasets: [{
                label: 'Monthly Income (VND)',
                data: monthlyIncomeData,
                backgroundColor: '#0d6efd'
            }]
        }
    });

    new Chart(document.getElementById('doctorIncomeChart'), {
        type: 'bar',
        data: {
            labels: doctorNames,
            datasets: [{
                label: 'Doctor Income (VND)',
                data: doctorIncomeData,
                backgroundColor: '#198754'
            }]
        },
        options: {
            indexAxis: 'y'
        }
    });
</script>
</body>
</html>