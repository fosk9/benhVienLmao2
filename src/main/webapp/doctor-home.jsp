<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient List</title>
    <jsp:include page="doctor-common-css.jsp"/>
    <style>
        table.table {
            font-size: 0.9rem !important;
            width: 75% !important;
            margin: 0 auto !important;
        }
        table.table th, table.table td {
            padding: 6px 10px !important;
            white-space: nowrap;
        }
        table.table th:nth-child(1), table.table td:nth-child(1) {
            width: 3%;
        }
        table.table th:nth-child(2), table.table td:nth-child(2) {
            width: 15%;
        }
        table.table th:nth-child(3), table.table td:nth-child(3) {
            width: 22%;
        }
        table.table th:nth-child(4), table.table td:nth-child(4) {
            width: 15%;
        }
        table.table th:nth-child(5), table.table td:nth-child(5) {
            width: 15%;
        }
        table.table th:nth-child(6), table.table td:nth-child(6) {
            width: 12%;
        }
        table.table th:nth-child(7), table.table td:nth-child(7) {
            width: 18%;
        }
        .pagination {
            justify-content: center;
            margin-top: 15px;
        }
    </style>
</head>
<body>
<jsp:include page="doctor-header.jsp"/>

<c:set var="page" value="${param.page != null ? param.page : 1}" />
<c:set var="pageSize" value="5" />
<c:set var="start" value="${(page - 1) * pageSize}" />
<c:set var="end" value="${page * pageSize}" />
<c:set var="totalItems" value="${fn:length(appointments)}" />
<c:set var="totalPages" value="${(totalItems + pageSize - 1) / pageSize}" />

<div class="container mt-5">
    <section class="about-area2 section-padding40" id="appointment-section">
        <div class="container">
            <div class="section-tittle mb-30 text-center">
                <h2>Closest Appointments</h2>
                <p>Hello, ${doctor.fullName} </p>
            </div>
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <table class="table table-hover table-bordered text-center">
                        <thead class="thead-dark" style="font-weight: 600;">
                        <tr>
                            <th style="padding: 6px 10px;">Number</th>
                            <th style="padding: 6px 10px;">Appointment Type</th>
                            <th style="padding: 6px 10px;">Appointment Date</th>
                            <th style="padding: 6px 10px;">Status</th>
                            <th style="padding: 6px 10px;">Details</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty appointments}">
                                <tr>
                                    <td colspan="7" class="text-center">No appointments scheduled today.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="a" items="${appointments}" varStatus="loop">
                                    <c:if test="${loop.index >= start && loop.index < end}">
                                        <tr style="text-align: center;">
                                            <td style="padding: 6px 10px;">${loop.index - start + 1}</td>
                                            <td style="padding: 6px 10px;">${a.appointmentType}</td>
                                            <td style="padding: 6px 10px;">
                                                <c:choose>
                                                    <c:when test="${not empty a.appointmentDate}">
                                                        <fmt:formatDate value="${a.appointmentDate}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        Not scheduled
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 6px 10px;">
                                                <form action="${pageContext.request.contextPath}/change-status" method="post" style="display:inline;">
                                                    <input type="hidden" name="appointmentId" value="${a.appointmentId}" />
                                                    <select name="status" onchange="this.form.submit()" style="font-size:1rem; padding:4px;">
                                                        <option value="Pending" ${a.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                                        <option value="Confirmed" ${a.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                                        <option value="Completed" ${a.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                                        <option value="Cancelled" ${a.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                                    </select>
                                                </form>
                                            </td>
                                            <td style="padding: 6px 10px;">
                                                <a href="${pageContext.request.contextPath}/view-detail?id=${a.appointmentId}"
                                                   class="btn btn-primary"
                                                   style="font-size: 1rem; padding: 10px 20px;">View</a>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == page ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </section>
</div>

<jsp:include page="doctor-footer.jsp"/>
<jsp:include page="doctor-common-scripts.jsp"/>

</body>
</html>
