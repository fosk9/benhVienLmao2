<%--
  Created by IntelliJ IDEA.
  User: ADMIN
  Date: 5/28/2025
  Time: 2:27 AM
  To change this template use File | Settings | File Templates.
--%>
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
      <div class="section-tittle text-center mb-30">
        <h2>Appointment Details</h2>
      </div>
      <div class="row justify-content-center">
        <div class="col-lg-8">
          <table class="table table-bordered" style="width: 90%; font-size: 1.5rem; margin: 0 auto;">
            <tr>
              <th style="padding: 20px 25px;">Patient Name</th>
              <td style="padding: 20px 25px;">${appointment.patient.fullName}</td>
            </tr>
            <tr>
              <th style="padding: 20px 25px;">Username</th>
              <td style="padding: 20px 25px;">${appointment.patient.username}</td>
            </tr>
            <tr>
              <th style="padding: 20px 25px;">Date of Birth</th>
              <td style="padding: 20px 25px;">
                <fmt:formatDate value="${appointment.patient.dob}" pattern="dd/MM/yyyy" />
              </td>
            </tr>
            <tr>
              <th style="padding: 20px 25px;">Gender</th>
              <td style="padding: 20px 25px;">${appointment.patient.gender}</td>
            </tr>
            <tr>
              <th style="padding: 20px 25px;">Email</th>
              <td style="padding: 20px 25px;">${appointment.patient.email}</td>
            </tr>
            <tr>
              <th style="padding: 20px 25px;">Phone</th>
              <td style="padding: 20px 25px;">${appointment.patient.phone}</td>
            </tr>
            <tr>
              <th style="padding: 20px 25px;">Address</th>
              <td style="padding: 20px 25px;">${appointment.patient.address}</td>
            </tr>
            <tr>
              <th style="padding: 20px 25px;">Insurance Number</th>
              <td style="padding: 20px 25px;">${appointment.patient.insuranceNumber}</td>
            </tr>
            <tr>
              <th style="padding: 20px 25px;">Emergency Contact</th>
              <td style="padding: 20px 25px;">${appointment.patient.emergencyContact}</td>
            </tr>
            <tr>
              <th style="padding: 20px 25px;">Appointment Time</th>
              <td style="padding: 20px 25px;">
                <c:choose>
                  <c:when test="${not empty appointment.appointmentDate}">
                    <fmt:formatDate value="${appointment.appointmentDate}" pattern="dd/MM/yyyy HH:mm" />
                  </c:when>
                  <c:otherwise>
                    Not scheduled
                  </c:otherwise>
                </c:choose>
              </td>
            </tr>
            <tr>
              <th style="padding: 20px 25px;">Status</th>
              <td style="padding: 20px 25px;">
                <form action="${pageContext.request.contextPath}/change-status" method="post" style="margin:0;">
                  <input type="hidden" name="appointmentId" value="${appointment.appointmentId}" />
                  <select name="status" onchange="this.form.submit()" style="font-size:1.5rem; padding:6px;">
                    <option value="Pending" ${appointment.status == 'Pending' ? 'selected' : ''}>Pending</option>
                    <option value="Confirmed" ${appointment.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                    <option value="Completed" ${appointment.status == 'Completed' ? 'selected' : ''}>Completed</option>
                    <option value="Cancelled" ${appointment.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                  </select>
                </form>
              </td>
            </tr>
          </table>
          <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/doctor-home" class="btn btn-outline-primary">← Back to Dashboard</a>
          </div>
        </div>
      </div>
    </div>
  </section>

</div>

<jsp:include page="doctor-footer.jsp"/>
<jsp:include page="doctor-common-scripts.jsp"/>

</body>
</html>
