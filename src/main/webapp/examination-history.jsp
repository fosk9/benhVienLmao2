<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Examination History</title>
    <jsp:include page="common-css.jsp"/>
</head>
<body>

<jsp:include page="header.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">Examination History</h2>

    <!-- Message Notification -->
    <c:if test="${not empty message}">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
                ${message}
        </div>
    </c:if>

    <!-- Table List -->
    <div class="table-responsive">
        <form method="get" class="form-inline mb-3">
            <!-- Search -->
            <input type="text" name="search" class="form-control mr-2" placeholder="Search by patient name"
                   value="${search != null ? search : ''}"/>

            <!-- Sort By -->
            <select name="sortBy" class="form-control mr-2">
                <option value="">Sort By</option>
                <option value="appointment_date" ${sortBy == 'appointment_date' ? 'selected' : ''}>Appointment Date
                </option>
                <option value="patient_name" ${sortBy == 'patient_name' ? 'selected' : ''}>Patient Name</option>
                <option value="appointment_type" ${sortBy == 'appointment_type' ? 'selected' : ''}>Appointment Type
                </option>
            </select>

            <!-- Sort Direction -->
            <select name="sortDir" class="form-control mr-2">
                <option value="asc" ${sortDir == 'asc' ? 'selected' : ''}>Ascending</option>
                <option value="desc" ${sortDir == 'desc' ? 'selected' : ''}>Descending</option>
            </select>

            <!-- Records per Page -->
            <label class="mr-1 ml-3">Records/Page:</label>
            <input type="number" name="recordsPerPage" class="form-control mr-2" min="1" value="${recordsPerPage}"/>

            <button type="submit" class="genric-btn success circle">Apply</button>
        </form>

        <table class="table table-bordered table-hover align-middle text-center">
            <thead class="table-light">
            <tr>
                <th>Appointment ID</th>
                <th>Date</th>
                <th>Time Slot</th>
                <th>Type</th>
                <th>Patient</th>
                <th>Status</th>
                <th>Details</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="c" items="${examinations}">
                <tr>
                    <td>${c.appointmentId}</td>
                    <td><fmt:formatDate value="${c.appointmentDate}" pattern="dd/MM/yyyy"/></td>
                    <td>${c.timeSlot}</td>
                    <td>${c.appointmentTypeName}</td>
                    <td>${c.patientName}</td>
                    <td>
                        <span class="badge bg-${c.status == 'Completed' ? 'success' : (c.status == 'Cancelled' ? 'danger' : 'secondary')}">
                                ${c.status}
                        </span>
                    </td>
                    <td>
                        <a href="examination-history-details?appointmentId=${c.appointmentId}"
                           class="genric-btn success circle">View</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <nav class="mt-4">
            <ul class="pagination justify-content-center">
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <c:url var="pageUrl" value="examination-history">
                            <c:param name="page" value="${i}"/>
                            <c:param name="recordsPerPage" value="${recordsPerPage}"/>
                            <c:param name="search" value="${param.search}"/>
                            <c:param name="sortBy" value="${param.sortBy}"/>
                            <c:param name="sortDir" value="${param.sortDir}"/>
                        </c:url>
                        <a class="page-link" href="${pageUrl}">${i}</a>
                    </li>
                </c:forEach>
            </ul>
        </nav>
    </c:if>

</div>

<jsp:include page="footer.jsp"/>
<jsp:include page="common-scripts.jsp"/>

</body>
</html>
