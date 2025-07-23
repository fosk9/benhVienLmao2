<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>Error</title>
  <link rel="stylesheet" href="css/bootstrap.min.css"/>
</head>
<body class="bg-light">
<div class="container text-center mt-5">
  <h1 class="text-danger">Error Occurred</h1>
  <p class="lead">
    <c:out value="${param.error}" default="An unexpected error has occurred."/>
  </p>
  <a href="javascript:history.back()" class="btn btn-secondary mt-3">Go Back</a>
</div>
</body>
</html>
