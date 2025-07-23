<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="common-css.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Approve Doctor Leave</title>
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

<!-- Leave Approval Form -->
<section class="section-padding30">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="form-wrapper bg-light p-4 shadow">
                    <h3 class="mb-4">Shift Information</h3>
                    <ul class="unordered-list">
                        <li><strong>Doctor ID:</strong> ${shift.doctorId}</li>
                        <li><strong>Shift Date:</strong> ${shift.shiftDate}</li>
                        <li><strong>Time Slot:</strong> ${shift.timeSlot}</li>
                        <li><strong>Status:</strong> ${shift.status}</li>
                    </ul>

                    <hr>

                    <form action="approve-leave" method="post">
                        <input type="hidden" name="shiftId" value="${shift.shiftId}">
                        <input type="hidden" name="managerId" value="1"/> <%-- TODO: thay bằng session real id --%>

                        <div class="form-group">
                            <label for="replacementDoctorId"><strong>Choose Replacement Doctor</strong></label>
                            <select class="form-control nice-select" name="replacementDoctorId" required>
                                <c:forEach var="doctor" items="${availableDoctors}">
                                    <option value="${doctor.employeeId}">
                                            ${doctor.fullName} (ID: ${doctor.employeeId})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mt-4 d-flex justify-content-between">
                            <button type="submit" name="action" value="approve" class="genric-btn success medium">
                                Approve
                            </button>
                            <button type="submit" name="action" value="reject" class="genric-btn danger medium">Reject
                            </button>
                            <a href="request-leave-list" class="genric-btn link medium">Back</a>
                        </div>
                    </form>

                    <c:if test="${empty availableDoctors}">
                        <div class="alert alert-warning mt-4">
                            ⚠ No available doctors found for this shift. You may only reject this request.
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="footer.jsp" %>
<%@ include file="common-scripts.jsp" %>
</body>
</html>
