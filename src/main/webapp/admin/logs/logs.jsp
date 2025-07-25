
<%--
  Created by IntelliJ IDEA.
  User: Fosk Jesky
  Date: 7/23/2025
  Time: 12:57 AM
  Description: Admin log viewer page with a search form and log history table.
               Filters logs by username, date range, role, log level, and sort order.
               Excludes logLevel parameter when 'All Levels' is selected.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Logs - benhVienLmao</title>
    <!-- Bootstrap CSS for responsive and styled components -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <!-- Custom admin CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        /* Green theme inspired by Thu Cuc hospital */
        :root {
            --primary-color: #28a745; /* Green */
            --secondary-color: #4CAF50; /* Lighter green */
            --accent-color: #ffffff; /* White for contrast */
            --text-color: #333333; /* Dark text */
        }

        /* Enhanced container styling */
        .container {
            max-width: 1400px;
            padding: 30px;
        }

        /* Header styling */
        h2 {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 20px;
        }

        /* Search form container */
        .search-form-container {
            background-color: #f8f9fa;
            border: 2px solid var(--primary-color);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        /* Search form layout */
        .search-form .form-group {
            margin-bottom: 15px;
        }

        .search-form label {
            color: var(--primary-color);
            font-weight: 600;
            font-size: 1.1rem;
        }

        .search-form .form-control,
        .search-form .form-select {
            border: 1px solid var(--primary-color);
            border-radius: 8px;
            font-size: 1rem;
            height: 38px;
        }

        .search-form .form-control:focus,
        .search-form .form-select:focus {
            border-color: var(--secondary-color);
            box-shadow: 0 0 5px rgba(40, 167, 69, 0.3);
        }

        .search-form .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            padding: 8px 20px;
            border-radius: 8px;
        }

        .search-form .btn-primary:hover {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }

        .search-form .btn-secondary {
            border-radius: 8px;
            padding: 8px 20px;
        }

        /* Table styling */
        .table-container {
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .table thead th {
            background-color: var(--primary-color);
            color: var(--accent-color);
            font-weight: 600;
            padding: 12px;
            text-align: center;
        }

        .table tbody tr:hover {
            background-color: #f1f8f1;
        }

        .table td {
            vertical-align: middle;
            padding: 12px;
            text-align: center;
        }

        /* Real-time log section */
        .realtime-log-container {
            margin-top: 30px;
            border: 2px solid var(--primary-color);
            border-radius: 15px;
            padding: 20px;
            background-color: #f8f9fa;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .realtime-log-container textarea {
            width: 100%;
            border: 1px solid var(--primary-color);
            border-radius: 8px;
            font-size: 1rem;
            padding: 10px;
            min-height: 150px;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .search-form-container {
                padding: 15px;
            }
            .search-form label {
                font-size: 1rem;
            }
            .search-form .form-control,
            .search-form .form-select {
                font-size: 0.9rem;
                height: 35px;
            }
            .table td, .table th {
                font-size: 0.9rem;
                padding: 8px;
            }
            .realtime-log-container textarea {
                font-size: 0.8rem;
            }
        }
    </style>
</head>
<body>
<!-- Real-time Log Viewer -->
<div class="realtime-log-container">
    <h2>Real-time Log Viewer</h2>
    <jsp:include page="adminLog.jsp"/>
</div>

<div class="container">
    <!-- Page title -->
    <h2>Log System History</h2>

    <!-- Search Form -->
    <div class="search-form-container">
        <form method="get" action="${pageContext.request.contextPath}/admin/logs" id="logSearchForm" onsubmit="return validateForm()">
            <div class="row">
                <!-- Username Filter: Filters logs by user_name column -->
                <div class="col-md-6 col-lg-4 form-group">
                    <label for="username">Username</label>
                    <input type="text" class="form-control" id="username" name="username" value="${param.username}" placeholder="Enter username">
                </div>
                <!-- Date From Filter: Filters logs where created_at >= fromDate -->
                <div class="col-md-6 col-lg-4 form-group">
                    <label for="fromDate">Date From</label>
                    <input type="date" class="form-control" id="fromDate" name="fromDate" value="${param.fromDate}">
                </div>
                <!-- Date To Filter: Filters logs where created_at <= toDate -->
                <div class="col-md-6 col-lg-4 form-group">
                    <label for="toDate">Date To</label>
                    <input type="date" class="form-control" id="toDate" name="toDate" value="${param.toDate}">
                </div>
                <!-- Role Filter: Filters logs by role_name (Doctor, Receptionist, Admin, Manager, Patient, Guest) -->
                <div class="col-md-6 col-lg-4 form-group">
                    <label for="role">Role</label>
                    <select class="form-select" id="role" name="role">
                        <option value="" ${param.role == '' ? 'selected' : ''}>All Roles</option>
                        <option value="Doctor" ${param.role == 'Doctor' ? 'selected' : ''}>Doctor</option>
                        <option value="Receptionist" ${param.role == 'Receptionist' ? 'selected' : ''}>Receptionist</option>
                        <option value="Admin" ${param.role == 'Admin' ? 'selected' : ''}>Admin</option>
                        <option value="Manager" ${param.role == 'Manager' ? 'selected' : ''}>Manager</option>
                        <option value="Patient" ${param.role == 'Patient' ? 'selected' : ''}>Patient</option>
                        <option value="Guest" ${param.role == 'Guest' ? 'selected' : ''}>Guest</option>
                    </select>
                </div>
                <!-- Log Level Filter: Filters logs by log_level; excluded if 'All Levels' is selected -->
                <div class="col-md-6 col-lg-4 form-group">
                    <label for="logLevel">Log Level</label>
                    <select class="form-select" id="logLevel" name="logLevel" onchange="toggleLogLevel()">
                        <option value="" ${param.logLevel == '' ? 'selected' : ''}>All Levels</option>
                        <option value="INFO" ${param.logLevel == 'INFO' ? 'selected' : ''}>INFO</option>
                        <option value="WARN" ${param.logLevel == 'WARN' ? 'selected' : ''}>WARN</option>
                        <option value="ERROR" ${param.logLevel == 'ERROR' ? 'selected' : ''}>ERROR</option>
                        <option value="DEBUG" ${param.logLevel == 'DEBUG' ? 'selected' : ''}>DEBUG</option>
                    </select>
                </div>
                <!-- Sort Order Filter: Orders logs by created_at (Newest First or Oldest First) -->
                <div class="col-md-6 col-lg-4 form-group">
                    <label for="sortOrder">Sort Order</label>
                    <select class="form-select" id="sortOrder" name="sortOrder">
                        <option value="Newest First" ${param.sortOrder == 'Newest First' ? 'selected' : ''}>Newest First</option>
                        <option value="Oldest First" ${param.sortOrder == 'Oldest First' ? 'selected' : ''}>Oldest First</option>
                    </select>
                </div>
                <!-- Form Buttons -->
                <div class="col-12 text-center form-group">
                    <button type="submit" class="btn btn-primary me-2">
                        <i class="fas fa-search me-2"></i>Search
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="resetForm()">
                        <i class="fas fa-undo me-2"></i>Reset
                    </button>
                </div>
            </div>
        </form>
    </div>
    <!-- End Search Form -->

    <!-- Log History Table -->
    <div class="table-container">
        <table class="table table-bordered mb-0">
            <thead>
            <tr>
                <th>ID</th>
                <th>User</th>
                <th>Role</th>
                <th>Action</th>
                <th>Level</th>
                <th>Created At</th>
            </tr>
            </thead>
            <tbody id="logBody">
            <c:forEach var="l" items="${logs}">
                <tr>
                    <td>${l.logId}</td>
                    <td>${l.userName}</td>
                    <td>${l.roleName}</td>
                    <td>${l.action}</td>
                    <td>${l.logLevel}</td>
                    <td>${l.createdAt}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty logs}">
                <tr>
                    <td colspan="6" class="text-center">No logs found.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<!-- JavaScript for form validation and log level handling -->
<script>
    // Validate form before submission
    function validateForm() {
        const fromDate = document.getElementById('fromDate').value;
        const toDate = document.getElementById('toDate').value;

        if (fromDate && toDate && new Date(toDate) < new Date(fromDate)) {
            alert('Date To cannot be earlier than Date From.');
            return false;
        }
        return true;
    }

    // Conditionally disable logLevel parameter if 'All Levels' is selected
    function toggleLogLevel() {
        const logLevelSelect = document.getElementById('logLevel');
        if (logLevelSelect.value === '') {
            logLevelSelect.removeAttribute('name'); // Exclude from form submission
        } else {
            logLevelSelect.setAttribute('name', 'logLevel'); // Include in form submission
        }
    }

    // Reset form fields and submit to clear query parameters
    function resetForm() {
        const form = document.getElementById('logSearchForm');
        form.reset();
        document.getElementById('logLevel').setAttribute('name', 'logLevel'); // Restore name for reset
        form.submit();
    }

    // Initialize logLevel state on page load
    window.onload = function() {
        toggleLogLevel();
    };
</script>

</body>
</html>