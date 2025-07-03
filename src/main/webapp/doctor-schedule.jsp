<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.sql.Date" %>
<%@ page import="model.DoctorShift" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor's Weekly Schedule</title>
    <!-- Bootstrap 4 -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 70px; /* để nội dung không bị header che mất */
        }

        @media (max-width: 576px) {
            .navbar span {
                font-size: 14px;
            }
        }

        body {
            padding-top: 70px;
        }

        .badge {
            font-size: 90%;
        }
    </style>
</head>
<body>
<!-- Minimal Header with Back Button -->
<nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top shadow-sm">
    <div class="container">
        <a href="${pageContext.request.contextPath}/doctor-home" class="btn btn-outline-primary">
            &larr; Back to Doctor Home
        </a>
        <span class="ml-auto font-weight-bold text-secondary">Doctor's Weekly Schedule</span>
    </div>
</nav>


<main class="container mt-4">
    <!-- Filter Form -->
    <form id="weekSelectorForm" method="get" action="doctor-schedule" class="form-inline mb-4 flex-wrap">
        <label for="yearSelect" class="mr-2">Year:</label>
        <select name="year" id="yearSelect" class="form-control mr-3 mb-2">
            <c:forEach var="y" items="${years}">
                <option value="${y}" <c:if test="${y == selectedYear}">selected</c:if>>${y}</option>
            </c:forEach>
        </select>

        <label for="weekSelect" class="mr-2">Week:</label>
        <select name="startDate" id="weekSelect" class="form-control mb-2">
            <c:forEach var="w" items="${weeks}">
                <c:set var="start" value="${w[0]}"/>
                <c:set var="end" value="${w[1]}"/>
                <option value="${start}" <c:if test="${start == selectedWeekStart}">selected</c:if>>
                    <fmt:formatDate value="${start}" pattern="dd/MM"/> - <fmt:formatDate value="${end}"
                                                                                         pattern="dd/MM"/>
                </option>
            </c:forEach>
        </select>
    </form>

    <!-- Navigation Buttons -->
    <div class="row mb-4">
        <div class="col-md-4 text-left">
            <a href="doctor-schedule?startDate=${selectedWeekStart}&year=${selectedYear}&weekOffset=-1"
               class="btn btn-outline-primary btn-sm">&laquo; Previous Week</a>
        </div>
        <div class="col-md-4 text-center">
            <h5>${weekRange}</h5>
        </div>
        <div class="col-md-4 text-right">
            <a href="doctor-schedule?startDate=${selectedWeekStart}&year=${selectedYear}&weekOffset=1"
               class="btn btn-outline-primary btn-sm">Next Week &raquo;</a>
        </div>
    </div>

    <!-- Schedule Table -->
    <div class="table-responsive">
        <table class="table table-bordered text-center">
            <thead class="thead-light">
            <tr>
                <th>Shift</th>
                <th>Monday</th>
                <th>Tuesday</th>
                <th>Wednesday</th>
                <th>Thursday</th>
                <th>Friday</th>
                <th>Saturday</th>
                <th>Sunday</th>
            </tr>
            <tr>
                <th></th>
                <%
                    java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("dd/MM");
                    Date monday = (Date) request.getAttribute("monday");
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    if (monday != null) {
                        cal.setTime(monday);
                        for (int i = 0; i < 7; i++) {
                %>
                <th><%= df.format(cal.getTime()) %>
                </th>
                <%
                        cal.add(java.util.Calendar.DAY_OF_MONTH, 1);
                    }
                } else {
                %>
                <td colspan="7" class="text-danger">[Error: 'monday' not set]</td>
                <%
                    }
                %>
            </tr>
            </thead>
            <tbody>
            <%
                String[] slots = {"Morning", "Afternoon", "Evening", "Night"};
                cal.setTime(monday);
                for (String slot : slots) {
                    cal.setTime(monday);
            %>
            <tr>
                <td><strong><%= slot %>
                </strong></td>
                <%
                    for (int i = 0; i < 7; i++) {
                        Date day = new Date(cal.getTimeInMillis());
                        Map<String, DoctorShift> dayShifts = ((Map<Date, Map<String, DoctorShift>>) request.getAttribute("shiftMap")).get(day);
                        DoctorShift shift = (dayShifts != null) ? dayShifts.get(slot) : null;
                %>
                <td>
                    <% if (shift != null) {
                        String badgeClass = "badge-secondary";
                        switch (shift.getStatus()) {
                            case "Working":
                                badgeClass = "badge-success";
                                break;
                            case "PendingLeave":
                                badgeClass = "badge-warning";
                                break;
                            case "Leave":
                                badgeClass = "badge-secondary";
                                break;
                            case "Rejected":
                                badgeClass = "badge-danger";
                                break;
                        }
                    %>
                    <a href="doctor-shift-detail?shiftId=<%= shift.getShiftId() %>" class="badge <%= badgeClass %>">
                        <%= shift.getStatus() %>
                    </a>
                    <% } else { %>
                    <span class="text-muted">-</span>
                    <% } %>
                </td>
                <%
                        cal.add(java.util.Calendar.DAY_OF_MONTH, 1);
                    }
                %>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</main>

<!-- Minimal JS just for form auto-submit -->
<script>
    document.getElementById("yearSelect").addEventListener("change", function () {
        // Reset weekSelect nhưng xóa name="startDate" để form không gửi param này lên
        const weekSelect = document.getElementById("weekSelect");

        // ✅ Bỏ name để không gửi startDate nữa
        weekSelect.removeAttribute("name");

        document.getElementById("weekSelectorForm").submit();
    });

    document.getElementById("weekSelect").addEventListener("change", function () {
        // Đặt lại name để gửi startDate khi chọn tuần
        document.getElementById("weekSelect").setAttribute("name", "startDate");
        document.getElementById("weekSelectorForm").submit();
    });
</script>

</body>
</html>
