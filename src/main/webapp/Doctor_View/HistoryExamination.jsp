<%--
  Created by IntelliJ IDEA.
  User: ADMIN
  Date: 5/27/2025
  Time: 11:55 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
  <title>Lịch sử khám đã hoàn thành</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 30px;
      background-color: #f9f9f9;
    }
    h2 {
      text-align: center;
      color: #333;
    }
    table {
      border-collapse: collapse;
      width: 90%;
      margin: 20px auto;
      background-color: #fff;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }
    th, td {
      border: 1px solid #ddd;
      padding: 12px 15px;
      text-align: left;
    }
    th {
      background-color: #4CAF50;
      color: white;
      font-weight: bold;
    }
    tr:nth-child(even) {
      background-color: #f2f2f2;
    }
    .no-data {
      text-align: center;
      padding: 20px;
      color: #666;
    }
  </style>
</head>
<body>

<h2>Lịch sử khám đã hoàn thành</h2>

<table>
  <thead>
  <tr>
    <th>Mã lịch hẹn</th>
    <th>Tên bệnh nhân</th>
    <th>Email</th>
    <th>Số điện thoại</th>
    <th>Ngày khám</th>
    <th>Trạng thái</th>
  </tr>
  </thead>
  <tbody>
  <c:choose>
    <c:when test="${not empty historyList}">
      <c:forEach var="appt" items="${historyList}">
        <tr>
          <td>${appt.appointmentId}</td>
          <td>${appt.patientName}</td>
          <td>${appt.patientEmail}</td>
          <td>${appt.patientPhone}</td>
          <td>
            <c:if test="${not empty appt.appointmentDate}">
              <fmt:formatDate value="${appt.appointmentDate}" pattern="dd-MM-yyyy HH:mm"/>
            </c:if>
          </td>
          <td>${appt.status}</td>
        </tr>
      </c:forEach>
    </c:when>
    <c:otherwise>
      <tr>
        <td colspan="6" class="no-data">Không có lịch sử khám nào.</td>
      </tr>
    </c:otherwise>
  </c:choose>
  </tbody>
</table>

</body>
</html>

