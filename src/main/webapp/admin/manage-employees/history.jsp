<%--
  Created by IntelliJ IDEA.
  User: Fosk Jesky
  Date: 7/3/2025
  Time: 1:35 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Role History - benhVienLmao</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<div class="container mt-5">
    <h2>User Role History</h2>
    <div class="mb-3">
        <strong>User:</strong> ${user.fullName} (${user.username})
    </div>
    <a href="${pageContext.request.contextPath}/admin/manageEmployees?action=list" class="btn btn-secondary mb-3">Back to List</a>
    <div class="card">
        <div class="card-body p-0">
            <table class="table table-bordered mb-0">
                <thead class="table-light">
                <tr>
                    <th>#</th>
                    <th>Role</th>
                    <th>Date</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="h" items="${history}" varStatus="loop">
                    <tr>
                        <td>${loop.index + 1}</td>
                        <td>
                            <c:forEach var="role" items="${roles}">
                                <c:if test="${role.roleId == h.roleId}">${role.roleName}</c:if>
                            </c:forEach>
                        </td>
                        <td>${h.date}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty history}">
                    <tr>
                        <td colspan="3" class="text-center">No history found.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
