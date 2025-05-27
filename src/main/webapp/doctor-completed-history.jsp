<%--
  Created by IntelliJ IDEA.
  User: ADMIN
  Date: 5/28/2025
  Time: 4:35 AM
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Completed Appointments History</title>
  <jsp:include page="common-css.jsp"/>
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
    .pagination {
      justify-content: center;
      margin-top: 15px;
    }
  </style>
</head>
<body>

<jsp:include page="header.jsp"/>

<!-- Phân trang tính toán -->
<c:set var="page" value="${param.page != null ? param.page : 1}" />
<c:set var="page" value="${page + 0}" />
<c:set var="pageSize" value="5" />
<c:set var="totalItems" value="${fn:length(completedAppointments)}" />
<c:set var="totalPages" value="${(totalItems + pageSize - 1) / pageSize}" />
<c:set var="start" value="${(page - 1) * pageSize}" />
<c:set var="end" value="${page * pageSize}" />

<div class="container mt-5">
  <section class="about-area2 section-padding40" id="completed-history-section">
    <div class="container">
      <div class="section-tittle mb-30 text-center">
        <h2>Completed Appointments History</h2>
      </div>
      <div class="row justify-content-center">
        <div class="col-lg-10">
          <table class="table table-hover table-bordered text-center">
            <thead class="thead-dark" style="font-weight: 600;">
            <tr>
              <th style="padding: 6px 10px;">Number</th>
              <th style="padding: 6px 10px;">Insurance Number</th>
              <th style="padding: 6px 10px;">Patient Name</th>
              <th style="padding: 6px 10px;">Appointment Type</th>
              <th style="padding: 6px 10px;">Appointment Date</th>
              <th style="padding: 6px 10px;">Status</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
              <c:when test="${empty completedAppointments}">
                <tr>
                  <td colspan="6" class="text-center">No completed appointments found.</td>
                </tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="a" items="${completedAppointments}" varStatus="loop">
                  <c:if test="${loop.index >= start && loop.index < end}">
                    <tr style="text-align: center;">
                      <td style="padding: 6px 10px;">${loop.index - start + 1}</td>
                      <td style="padding: 6px 10px;">${a.insuranceNumber}</td>
                      <td style="padding: 6px 10px;">${a.patientFullName}</td>
                      <td style="padding: 6px 10px;">${a.appointmentType}</td>
                      <td style="padding: 6px 10px;">
                        <c:choose>
                          <c:when test="${not empty a.appointmentDate}">
                            <fmt:formatDate value="${a.appointmentDate}" pattern="dd/MM/yyyy" />
                          </c:when>
                          <c:otherwise>
                            Not scheduled
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td style="padding: 6px 10px;">${a.status}</td>
                    </tr>
                  </c:if>
                </c:forEach>
              </c:otherwise>
            </c:choose>
            </tbody>
          </table>
          <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
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

<jsp:include page="footer.jsp"/>
<jsp:include page="common-scripts.jsp"/>

</body>
</html>
