<%--
  Created by IntelliJ IDEA.
  User: Fosk Jesky
  Date: 7/3/2025
  Time: 2:22 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment History</title>
    <link rel="stylesheet" href="<c:url value='/assets/css/bootstrap.min.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
    <style>
        body, .table th, .table td, .btn, .form-control, label {
            font-family: "Segoe UI", sans-serif;
            font-size: 1.8rem;
        }

        h2 {
            text-align: center;
            margin: 40px 0;
            font-size: 2.6rem;
            color: #28a745;
        }

        .card {
            border-radius: 15px;
            overflow: hidden;
            border: 2px solid #28a745;
            margin-top: 30px;
        }

        .table {
            border-radius: 15px;
            overflow: hidden;
        }

        .table thead th {
            background-color: #f1f8f1;
            color: #28a745;
            font-weight: bold;
            padding: 15px;
        }

        .table-bordered {
            border: 2px solid #28a745;
        }

        .table-bordered th, .table-bordered td {
            border: 2px solid #28a745;
            padding: 15px;
        }

        .btn {
            font-size: 1.6rem;
            padding: 16px 32px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background-color: #28a745;
            border-color: #28a745;
        }

        .btn-primary:hover {
            background-color: #218838;
            border-color: #218838;
        }

        .search-table {
            width: 100%;
            max-width: 600px;
            margin: 30px auto;
            background-color: #f1f8f1;
            padding: 25px;
            border-radius: 25px;
            border: 2px solid #28a745;
        }

        .search-table td {
            padding: 12px;
            vertical-align: middle;
        }

        .search-table td:first-child {
            font-weight: bold;
            color: #28a745;
            font-size: 1.8rem;
            width: 40%;
            text-align: right;
        }

        .search-table td:last-child {
            width: 60%;
        }

        .search-table .form-control {
            font-size: 1.6rem;
            height: 50px;
            width: 100%;
        }

        .search-table .btn {
            font-size: 1.6rem;
            padding: 14px 28px;
            border-radius: 8px;
        }

        .search-table .btn-primary {
            background-color: #28a745;
            border-color: #28a745;
        }

        .search-table .btn-primary:hover {
            background-color: #218838;
            border-color: #218838;
        }

        .search-table .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }

        .search-table .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #5a6268;
        }

        .pagination {
            justify-content: center;
            margin-top: 30px;
        }

        .page-link {
            font-size: 1.6rem;
            color: #28a745;
            border-color: #28a745;
            padding: 12px 18px;
        }

        .page-link:hover {
            background-color: #f1f8f1;
            color: #218838;
        }

        .page-item.active .page-link {
            background-color: #28a745;
            border-color: #28a745;
            color: #fff;
        }

        .page-item.disabled .page-link {
            color: #6c757d;
        }

        .error-message {
            color: #dc3545;
            font-size: 1.6rem;
            text-align: center;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
<main>
    <div class="container mt-5">
        <h2>Payment History</h2>
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        <!-- Search Form Start -->
        <table class="search-table">
            <form action="<c:url value='/payment/history'/>" method="get" id="searchForm">
                <tr>
                    <td style="text-align:left; width:50%;">From Date</td>
                    <td style="width:50%;"><input type="date" id="fromDate" name="fromDate" class="form-control"
                                                  value="${param.fromDate}"></td>
                </tr>
                <tr>
                    <td style="text-align:left; width:50%;">To Date</td>
                    <td style="width:50%;"><input type="date" id="toDate" name="toDate" class="form-control"
                                                  value="${param.toDate}"></td>
                </tr>
                <tr>
                    <td style="text-align:left; width:50%;">Status</td>
                    <td style="width:50%;">
                        <select id="status" name="status" class="form-control">
                            <option value="">All</option>
                            <option value="PENDING" <c:if test="${param.status == 'PENDING'}">selected</c:if>>Pending
                            </option>
                            <option value="PAID" <c:if test="${param.status == 'PAID'}">selected</c:if>>Paid</option>
                            <option value="CANCEL" <c:if test="${param.status == 'CANCEL'}">selected</c:if>>Cancel
                            </option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:center; width:50%;">
                        <button type="submit" class="btn btn-primary">Search</button>
                    </td>
                    <td style="text-align:center; width:50%;">
                        <button type="button" class="btn btn-secondary" onclick="resetForm()">Reset</button>
                    </td>
                </tr>
            </form>
        </table>
        <!-- Search Form End -->
        <div class="card">
            <div class="card-body">
                <table class="table table-bordered">
                    <thead>
                    <tr>
                        <th>Payment ID</th>
                        <th>Appointment ID</th>
                        <th>Amount</th>
                        <th>Method</th>
                        <th>Status</th>
                        <th>Pay Content</th>
                        <th>Created At</th>
                        <th>Paid At</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="payment" items="${payments}">
                        <tr>
                            <td>${payment.paymentId}</td>
                            <td>${payment.appointmentId}</td>
                            <td><fmt:formatNumber value="${payment.amount}" type="currency" currencySymbol="₫"/></td>
                            <td>${payment.method}</td>
                            <td>${payment.status}</td>
                            <td>${payment.payContent}</td>
                            <td><fmt:formatDate value="${payment.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                            <td><fmt:formatDate value="${payment.paidAt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty payments}">
                        <tr>
                            <td colspan="8" class="text-center">No payment history found.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<script>
    function resetForm() {
        const form = document.getElementById('searchForm');
        form.reset();
        form.submit();
    }
</script>
</body>
</html>
