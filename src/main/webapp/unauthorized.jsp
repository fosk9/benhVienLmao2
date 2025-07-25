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
    <form action="<%= request.getContextPath() %>/index" method="get" style="display: inline;">
        <button type="submit" class="btn btn-primary">Return to Home</button>
    </form>

    <form action="<%= request.getContextPath() %>/logout" method="get" style="display: inline;">
        <button type="submit" class="btn btn-danger">Logout</button>
    </form>

</div>
</body>
</html>
