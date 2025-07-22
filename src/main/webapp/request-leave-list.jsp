<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="common-css.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Pending Leave Requests</title>
</head>
<body>

<!-- Preloader Start -->
<div id="preloader-active">
    <div class="preloader d-flex align-items-center justify-content-center">
        <div class="preloader-inner position-relative">
            <div class="preloader-circle"></div>
            <div class="preloader-img pere-text">
                <img src="assets/img/logo/loder.png" alt="">
            </div>
        </div>
    </div>
</div>

<%@ include file="header.jsp" %>

<!-- Table Section -->
<section class="section-padding30">
    <div class="container">
        <div class="row">
            <div class="col-12">
                <div class="section-tittle mb-40">
                    <h2>Leave Requests Waiting for Approval</h2>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover table-borderless">
                        <thead class="thead-light">
                        <tr>
                            <th scope="col">Doctor Name</th>
                            <th scope="col">Shift Date</th>
                            <th scope="col">Time Slot</th>
                            <th scope="col">Requested At</th>
                            <th scope="col">Status</th>
                            <th scope="col">Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="dto" items="${pendingLeaveList}">
                            <tr>
                                <td>${dto.doctorName}</td>
                                <td>${dto.shiftDate}</td>
                                <td>${dto.timeSlot}</td>
                                <td>${dto.requestedAt}</td>
                                <td><span class="badge badge-warning">${dto.status}</span></td>
                                <td>
                                    <a href="approve-leave?shiftId=${dto.shiftId}" class="genric-btn primary small">
                                        Review
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty pendingLeaveList}">
                            <tr>
                                <td colspan="6" class="text-center text-muted">No pending leave requests found.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="footer.jsp" %>
<%@ include file="common-scripts.jsp" %>
</body>
</html>
