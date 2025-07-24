<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.DoctorShift" %>

<%
    DoctorShift shift = (DoctorShift) request.getAttribute("shift");
%>

<!doctype html>
<html class="no-js" lang="en">
<head>
    <meta charset="utf-8">
    <title>Doctor Shift Detail</title>
    <jsp:include page="common-css.jsp"/>
</head>
<body>
<jsp:include page="doctor-header.jsp"/>

<!-- Main content -->
<main>
    <div class="container mt-100 mb-5">
        <a href="doctor-schedule" class="btn btn-primary mt-3">← Back to Schedule</a>
        <div class="section-top-border">
            <div class="row">
                <div class="col-md-12">
                    <c:if test="${param.msg != null}">
                        <div class="alert alert-success" role="alert">
                                ${param.msg}
                        </div>
                    </c:if>
                    <h3 class="mb-30">Doctor Shift Detail</h3>
                    <table class="table table-bordered">
                        <tr>
                            <th>Shift ID</th>
                            <td>${shift.shiftId}</td>
                        </tr>
                        <tr>
                            <th>Doctor ID</th>
                            <td>${shift.doctorId}</td>
                        </tr>
                        <tr>
                            <th>Shift Date</th>
                            <td><fmt:formatDate value="${shift.shiftDate}" pattern="dd/MM/yyyy"/></td>
                        </tr>
                        <tr>
                            <th>Time Slot</th>
                            <td>${shift.timeSlot}</td>
                        </tr>
                        <tr>
                            <th>Status</th>
                            <td>
                                <c:choose>
                                    <c:when test="${shift.status == 'Working'}">
                                        <span class="badge badge-success">Working</span>
                                    </c:when>
                                    <c:when test="${shift.status == 'PendingLeave'}">
                                        <span class="badge badge-warning">Pending Leave</span>
                                    </c:when>
                                    <c:when test="${shift.status == 'Leave'}">
                                        <span class="badge badge-secondary">Leave</span>
                                    </c:when>
                                    <c:when test="${shift.status == 'Rejected'}">
                                        <span class="badge badge-danger">Rejected</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-light">${shift.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th>Manager ID</th>
                            <td>
                                <c:if test="${shift.managerId != 0}">
                                    ${shift.managerId}
                                </c:if>
                                <c:if test="${shift.managerId == 0}">
                                    <span class="text-muted">N/A</span>
                                </c:if>
                            </td>
                        </tr>
                        <tr>
                            <th>Requested At</th>
                            <td>
                                <c:if test="${shift.requestedAt != null}">
                                    <fmt:formatDate value="${shift.requestedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </c:if>
                                <c:if test="${shift.requestedAt == null}">
                                    <span class="text-muted">N/A</span>
                                </c:if>
                            </td>
                        </tr>
                        <tr>
                            <th>Approved At</th>
                            <td>
                                <c:if test="${shift.approvedAt != null}">
                                    <fmt:formatDate value="${shift.approvedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </c:if>
                                <c:if test="${shift.approvedAt == null}">
                                    <span class="text-muted">N/A</span>
                                </c:if>
                            </td>
                        </tr>
                        <tr>
                            <th>Patients in this shift</th>
                            <td>
                                <c:choose>
                                    <c:when test="${empty patients}">
                                        <span class="text-muted">No appointments for this shift.</span>
                                    </c:when>
                                    <c:otherwise>
                                        <ul class="list-unstyled mb-0">
                                            <c:forEach var="p" items="${patients}">
                                                <li>
                                                    <a href="patient-details?id=${p.patientId}" class="text-primary">
                                                        <i class="fa fa-user"></i>${p.fullName}
                                                    </a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </table>
                    <c:if test="${shift.status != 'Leave' and shift.status != 'PendingLeave'}">
                        <form action="request-doctor-leave" method="post"
                              onsubmit="return confirm('Are you sure you want to request leave for this shift?');">
                            <input type="hidden" name="shiftId" value="${shift.shiftId}">
                            <input type="hidden" name="doctorId" value="${shift.doctorId}">
                            <button type="submit" class="btn btn-warning">Request Leave</button>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common-scripts.jsp"/>
</body>
</html>
