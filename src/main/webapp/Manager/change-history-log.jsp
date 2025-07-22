<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change History Log - Hospital Admin</title>

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
                    <a href="${pageContext.request.contextPath}/change-history-log" class="nav-link active">
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
                        <h1><i class="fas fa-history mr-3"></i>Change History Log</h1>
                        <p class="page-subtitle">Track all system changes and user activities</p>
                    </div>
                    <div>
                        <button type="button" class="btn-hospital btn-secondary mr-2" onclick="exportHistory()">
                            <i class="fas fa-download mr-2"></i>Export History
                        </button>
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

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-card-content">
                        <div class="stat-info">
                            <h3 class="stat-blue">${totalChanges != null ? totalChanges : 0}</h3>
                            <p>Total Changes</p>
                        </div>
                        <div class="stat-icon stat-blue">
                            <i class="fas fa-edit"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-content">
                        <div class="stat-info">
                            <h3 class="stat-green">${todayChanges != null ? todayChanges : 0}</h3>
                            <p>Today's Changes</p>
                        </div>
                        <div class="stat-icon stat-green">
                            <i class="fas fa-calendar-day"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-content">
                        <div class="stat-info">
                            <h3 class="stat-orange">${activeManagers != null ? activeManagers : 0}</h3>
                            <p>Active Managers</p>
                        </div>
                        <div class="stat-icon stat-orange">
                            <i class="fas fa-user-tie"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-content">
                        <div class="stat-info">
                            <h3 class="stat-purple">${recentActions != null ? recentActions : 0}</h3>
                            <p>Recent Actions (24h)</p>
                        </div>
                        <div class="stat-icon stat-purple">
                            <i class="fas fa-clock"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Advanced Filter Section -->
            <form action="change-history-log" method="get" id="filterForm">
                <div class="filter-section">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Search Manager/User</label>
                                <div class="search-wrapper">
                                    <i class="fas fa-search"></i>
                                    <input type="text" class="form-control" name="keyword" id="keyword"
                                           value="${param.keyword}"
                                           placeholder="Search by name or ID">
                                </div>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group">
                                <label>Action Type</label>
                                <select class="form-control" name="action" id="action">
                                    <option value="">All Actions</option>
                                    <option value="create" ${param.action == 'create' ? 'selected' : ''}>Create</option>
                                    <option value="update" ${param.action == 'update' ? 'selected' : ''}>Update</option>
                                    <option value="delete" ${param.action == 'delete' ? 'selected' : ''}>Delete</option>
                                    <option value="other" ${param.action == 'other' ? 'selected' : ''}>Other</option>
                                </select>

                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group">
                                <label>Target Source</label>
                                <select class="form-control" name="source">
                                    <option value="">All Sources</option>
                                    <option value="Employee" ${param.source == 'Employee' ? 'selected' : ''}>Employee</option>
                                    <option value="Patient" ${param.source == 'Patient' ? 'selected' : ''}>Patient</option>
                                </select>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Date Range</label>
                                <div class="row">
                                    <div class="col-md-6">
                                        <input type="date" class="form-control" name="from" value="${param.from}">
                                    </div>
                                    <div class="col-md-6">
                                        <input type="date" class="form-control" name="to" value="${param.to}">
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
                    </div>
                </div>
            </form>

            <!-- Change History Table -->
            <div class="hospital-table">
                <div class="table-header">
                    <h3>
                        <i class="fas fa-list mr-2"></i>Change History Records
                        (<span id="historyCount">${fn:length(changeHistoryList)}</span>)
                    </h3>
                </div>

                <table class="table">
                    <thead>
                    <tr>
                        <th></th>
                        <th>Manager</th>
                        <th>Target User</th>
                        <th>Source</th>
                        <th>Action</th>
                        <th>Change Time</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="history" items="${changeHistoryList}">
                        <tr>
                            <td>
                                <input type="checkbox" class="record-checkbox" value="${history.changeId}">
                            </td>

                            <td>
                                <div class="user-info">
                                    <div class="user-avatar">
                                            ${fn:substring(history.managerName, 0, 1)}${fn:length(history.managerName) > 0 && fn:indexOf(history.managerName, ' ') > 0 ? fn:substring(history.managerName, fn:indexOf(history.managerName, ' ') + 1, fn:indexOf(history.managerName, ' ') + 2) : ''}
                                    </div>
                                    <div class="user-details">
                                        <h4>${history.managerName}</h4>
                                        <p>ID: ${history.managerId}</p>
                                    </div>
                                </div>
                            </td>

                            <td>
                                <div class="user-info">
                                    <div class="user-details">
                                        <h4>${history.targetUserName}</h4>
                                        <p>ID: ${history.targetUserId}</p>
                                    </div>
                                </div>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${fn:toLowerCase(history.targetSource) == 'employee'}">
                                        <span class="badge badge-published">
                                            <i class="fas fa-user-tie mr-1"></i>Employee
                                        </span>
                                    </c:when>
                                    <c:when test="${fn:toLowerCase(history.targetSource) == 'patient'}">
                                        <span class="badge badge-category">
                                            <i class="fas fa-user-injured mr-1"></i>Patient
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-category">
                                            <i class="fas fa-question mr-1"></i>${history.targetSource}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <div class="action-details">
                                    <c:choose>
                                        <c:when test="${fn:contains(fn:toLowerCase(history.action), 'create')}">
                                            <span class="role-badge role-doctor">
                                                <i class="fas fa-plus mr-1"></i>CREATE
                                            </span>
                                        </c:when>
                                        <c:when test="${fn:contains(fn:toLowerCase(history.action), 'update')}">
                                            <span class="role-badge role-assistant">
                                                <i class="fas fa-edit mr-1"></i>UPDATE
                                            </span>
                                        </c:when>
                                        <c:when test="${fn:contains(fn:toLowerCase(history.action), 'delete')}">
                                            <span class="role-badge role-manager">
                                                <i class="fas fa-trash mr-1"></i>DELETE
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="role-badge role-patient">
                                                <i class="fas fa-cog mr-1"></i>OTHER
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                    <br>
                                    <small class="text-muted">${history.action}</small>
                                </div>
                            </td>

                            <td>
                                <strong><fmt:formatDate value="${history.changeTime}" pattern="dd/MM/yyyy"/></strong>
                                <br>
                                <small class="text-muted">
                                    <fmt:formatDate value="${history.changeTime}" pattern="HH:mm:ss"/>
                                </small>
                                <br>
                                <small class="text-muted">
                                    <fmt:formatDate value="${history.changeTime}" pattern="EEEE"/>
                                </small>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <!-- Empty State -->
                <c:if test="${empty changeHistoryList}">
                    <div class="empty-state">
                        <i class="fas fa-history"></i>
                        <h3>No change history found</h3>
                        <p>No changes have been recorded yet or try adjusting your search criteria</p>
                    </div>
                </c:if>

                <!-- Bulk Actions -->
                <c:if test="${not empty changeHistoryList}">
                    <div class="tablenav">
                        <div class="actions">
                            <select id="bulkAction" class="form-control" style="width: auto; display: inline-block;">
                                <option value="">Bulk Actions</option>
                                <option value="export">Export Selected</option>
                                <c:if test="${sessionScope.userRole == 'ADMIN'}">
                                    <option value="delete">Delete Selected</option>
                                </c:if>
                            </select>
                            <button type="button" class="btn-hospital btn-sm" onclick="executeBulkAction()">Apply</button>
                        </div>
                    </div>
                </c:if>

                <!-- Pagination -->
                <!-- Update pagination links to match servlet param names -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination-container mt-4 text-center">
                        <nav aria-label="History pagination">
                            <ul class="pagination justify-content-center">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="change-history-log?page=${currentPage - 1}&keyword=${fn:escapeXml(param.keyword)}&action=${fn:escapeXml(param.action)}&source=${fn:escapeXml(param.source)}&from=${fn:escapeXml(param.from)}&to=${fn:escapeXml(param.to)}">«</a>
                                    </li>
                                </c:if>

                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link"
                                           href="change-history-log?page=${i}&keyword=${fn:escapeXml(param.keyword)}&action=${fn:escapeXml(param.action)}&source=${fn:escapeXml(param.source)}&from=${fn:escapeXml(param.from)}&to=${fn:escapeXml(param.to)}">${i}</a>
                                    </li>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="change-history-log?page=${currentPage + 1}&keyword=${fn:escapeXml(param.keyword)}&action=${fn:escapeXml(param.action)}&source=${fn:escapeXml(param.source)}&from=${fn:escapeXml(param.from)}&to=${fn:escapeXml(param.to)}">»</a>
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

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    // Select all functionality
    function toggleSelectAll() {
        const selectAll = document.getElementById('selectAll');
        const checkboxes = document.querySelectorAll('.record-checkbox');
        checkboxes.forEach(checkbox => {
            checkbox.checked = selectAll.checked;
        });
    }

    // Bulk actions
    function executeBulkAction() {
        const action = document.getElementById('bulkAction').value;
        const selectedIds = Array.from(document.querySelectorAll('.record-checkbox:checked')).map(cb => cb.value);

        if (!action) {
            alert('Please select an action');
            return;
        }

        if (selectedIds.length === 0) {
            alert('Please select at least one record');
            return;
        }

        switch(action) {
            case 'export':
                exportSelected(selectedIds);
                break;
            case 'delete':
                if (confirm(`Are you sure you want to delete ${selectedIds.length} selected records?`)) {
                    deleteSelected(selectedIds);
                }
                break;
        }
    }

    // Export functions
    function exportHistory() {
        const params = new URLSearchParams(window.location.search);
        params.set('action', 'export');
        window.location.href = 'change-history-log?' + params.toString();
    }

    function exportSelected(ids) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'change-history-log';

        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'exportSelected';
        form.appendChild(actionInput);

        ids.forEach(id => {
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'selectedIds';
            idInput.value = id;
            form.appendChild(idInput);
        });

        document.body.appendChild(form);
        form.submit();
        document.body.removeChild(form);
    }

    // Clear old history
    function clearOldHistory() {
        $('#clearHistoryModal').modal('show');
    }

    // Refresh data
    function refreshData() {
        window.location.reload();
    }

    // Auto-refresh every 30 seconds (optional)
    // setInterval(refreshData, 30000);

    // Initialize tooltips
    $(document).ready(function() {
        $('[data-toggle="tooltip"]').tooltip();
    });
</script>

</body>
</html>