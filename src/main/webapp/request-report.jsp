<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="common-css.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Activity Report</title>
    <%@ include file="common-css.jsp" %>

</head>
<body>
<%@ include file="header.jsp" %>

<section class="section-margin--small">
    <div class="container">
        <div class="section-intro text-center pb-5">
            <h2 class="section-intro__title">Activity Report</h2>
            <p>Filter and view hospital activities before exporting to Excel</p>
        </div>

        <!-- Filter Form (GET) -->
        <form action="export-activity-report" method="get" class="row g-3 mb-4">
            <div class="col-md-3">
                <label>From Date</label>
                <input type="date" name="from_date" value="${from_date}" class="form-control"/>
            </div>
            <div class="col-md-3">
                <label>To Date</label>
                <input type="date" name="to_date" value="${to_date}" class="form-control"/>
            </div>
            <div class="col-md-3">
                <label>Filter by Month</label>
                <input type="month" name="month" value="${month}" class="form-control"/>
            </div>
            <div class="col-md-3">
                <label>Search</label>
                <input type="text" name="search" value="${search}" placeholder="Service / Doctor / Patient"
                       class="form-control"/>
            </div>
            <div class="col-12 text-end mt-3">
                <button type="submit" class="genric-btn primary circle">Filter</button>
            </div>
        </form>

        <!-- Export Form -->
        <form action="export-activity-report" method="post">
            <input type="hidden" name="from_date" value="${from_date}"/>
            <input type="hidden" name="to_date" value="${to_date}"/>
            <input type="hidden" name="month" value="${month}"/>
            <input type="hidden" name="search" value="${search}"/>
            <div class="text-end mt-3">
                <button type="submit" class="genric-btn primary circle">Export to Excel</button>
            </div>
        </form>

        <!-- Table -->
        <c:if test="${not empty reportList}">
            <div class="table-responsive mt-4">
                <table class="table table-bordered">
                    <thead class="thead-dark">
                    <tr>
                        <th>#</th>
                        <th>From Date</th>
                        <th>To Date</th>
                        <th>Service</th>
                        <th>Doctor</th>
                        <th>Patient</th>
                        <th>Total Amount</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:set var="total" value="0" scope="page"/>
                    <c:forEach var="r" items="${reportList}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td><fmt:formatDate value="${r.createdAt}" pattern="yyyy-MM-dd"/></td>
                            <td><fmt:formatDate value="${r.updatedAt}" pattern="yyyy-MM-dd"/></td>
                            <td>${r.serviceName}</td>
                            <td><a href="doctor-details?id=${r.doctorId}" class="text-dark">${r.doctorName}</a></td>
                            <td><a href="patient-details?id=${r.patientId}" class="text-dark">${r.patientName}</a></td>
                            <td>
                                <fmt:formatNumber value="${r.totalAmount}" type="number" groupingUsed="true"/>
                                <c:set var="total" value="${total + r.totalAmount}"/>
                            </td>
                        </tr>
                    </c:forEach>
                    <tr class="fw-bold">
                        <td colspan="6" class="text-end">Total:</td>
                        <td><fmt:formatNumber value="${total}" type="number" groupingUsed="true"/></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </c:if>

        <c:if test="${reportList != null and empty reportList}">
            <div class="alert alert-warning mt-4">No data matched your filter.</div>
        </c:if>
    </div>
</section>
<%@ include file="footer.jsp" %>
<%@ include file="common-scripts.jsp" %>
</body>
</html>
