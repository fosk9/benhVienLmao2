<%--
  Created by IntelliJ IDEA.
  User: Fosk Jesky
  Date: 7/23/2025
  Time: 12:57 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Admin Logs</title>
  <script>
    let socket = new WebSocket("ws://localhost:8080/benhVienLmao/logsystemsocket");

    socket.onmessage = function(event) {
      let tbody = document.getElementById("logBody");
      let row = document.createElement("tr");
      let cell = document.createElement("td");
      cell.colSpan = 7;
      cell.textContent = event.data;
      row.appendChild(cell);
      tbody.prepend(row);
    };
  </script>
</head>
<body>
<h2>Log System Viewer</h2>

<form method="get">
  Username: <input type="text" name="username" value="${param.username}"/>
  Date From: <input type="date" name="fromDate" value="${param.fromDate}"/>
  To: <input type="date" name="toDate" value="${param.toDate}"/>
  Role:
  <select name="role">
    <option>All Roles</option>
    <option>Patient</option>
    <option>Employee</option>
  </select>
  Log Level:
  <select name="logLevel">
    <option>All Levels</option>
    <option>INFO</option>
    <option>WARN</option>
    <option>ERROR</option>
    <option>DEBUG</option>
  </select>
  Sort Order:
  <select name="sortOrder">
    <option>Newest First</option>
    <option>Oldest First</option>
  </select>
  <button type="submit">Search</button>
  <button type="reset" onclick="window.location='logs'">Reset</button>
</form>

<table border="1">
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
  </tbody>
</table>

</body>
</html>
