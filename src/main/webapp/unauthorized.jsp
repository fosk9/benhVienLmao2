<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Unauthorized Access</title>
  <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
<div class="container">
  <h1>Unauthorized Access</h1>
  <p>You do not have permission to access this page.</p>
  <a href="<%= request.getContextPath() %>/index">Return to Home</a> |
  <a href="<%= request.getContextPath() %>/logout">Logout</a>
</div>
</body>
</html>
