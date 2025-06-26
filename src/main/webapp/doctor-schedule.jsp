<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.sql.Date" %>
<%@ page import="model.DoctorShift" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="common-css.jsp"/>
    <title>Doctor's Weekly Schedule</title>
</head>
<body>
<jsp:include page="header.jsp"/>

<main>

    <!-- Filter Form -->
    <div class="container mt-5">
        <form id="weekSelectorForm" method="get" action="doctor-schedule" class="form-inline mb-4">
        <label for="year" class="mr-2">Year:</label>
            <select name="year" id="yearSelect" class="form-control mr-3">
                <c:forEach var="y" items="${years}">
                    <option value="${y}" ${y == selectedYear ? "selected" : ""}>${y}</option>
                </c:forEach>
            </select>

            <label for="startDate" class="mr-2">Week:</label>
                <select name="startDate" id="weekSelect" class="form-control mr-3">
                    <c:forEach var="w" items="${weeks}">
                        <c:set var="start" value="${w[0]}"/>
                        <c:set var="end" value="${w[1]}"/>
                        <option value="${start}" ${start == selectedWeekStart ? "selected" : ""}>
                            <fmt:formatDate value="${start}" pattern="dd/MM"/> - <fmt:formatDate value="${end}" pattern="dd/MM"/>
                        </option>
                    </c:forEach>
                </select>
        </form>

        <!-- Week Navigation -->
        <div class="row mb-4">
            <div class="col-md-4 text-left">
                <a href="doctor-schedule?startDate=${selectedWeekStart}&year=${selectedYear}&weekOffset=-1"
                   class="genric-btn primary circle arrow"><< Previous Week</a>
            </div>
            <div class="col-md-4 text-center">
                <h5>${weekRange}</h5>
            </div>
            <div class="col-md-4 text-right">
                <a href="doctor-schedule?startDate=${selectedWeekStart}&year=${selectedYear}&weekOffset=1"
                   class="genric-btn primary circle arrow">Next Week >></a>
            </div>
        </div>
    </div>

    <!-- Schedule Table -->
    <div class="container mb-5">
        <div class="table-responsive">
            <table class="table table-bordered text-center">
                <thead class="thead-light">
                <tr>
                    <th>Day of Week</th>
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
                        java.util.Calendar calHeader = java.util.Calendar.getInstance();
                        if (monday != null) {
                            calHeader.setTime(monday);
                            for (int i = 0; i < 7; i++) {
                    %>
                    <th><%= df.format(calHeader.getTime()) %></th>
                    <%
                            calHeader.add(java.util.Calendar.DAY_OF_MONTH, 1);
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
                    java.util.Calendar cal = java.util.Calendar.getInstance();

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
                        <% if (shift != null) { %>
                        <%
                            String badgeClass = "badge-light";
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
                        <div class="badge <%= badgeClass %>">
                            <%= shift.getStatus() %>
                        </div>
                        <% } else { %>
                        <span class="text-muted">-</span>
                        <% } %>
                    </td>
                    <%
                            cal.add(java.util.Calendar.DAY_OF_MONTH, 1);
                        }
                    %>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

</main>

<jsp:include page="footer.jsp"/>
<jsp:include page="common-scripts.jsp"/>

<!-- JS: Auto-submit form when year/week changes -->
<script>
    window.addEventListener("DOMContentLoaded", function () {
        const form = document.getElementById("weekSelectorForm");
        const yearSelect = document.getElementById("yearSelect");
        const weekSelect = document.getElementById("weekSelect");

        if (yearSelect && weekSelect && form) {
            yearSelect.addEventListener("change", function () {
                form.submit(); // submit form khi thay đổi năm
            });

            weekSelect.addEventListener("change", function () {
                form.submit(); // submit form khi chọn tuần
            });
        }
    });
</script>


</body>
</html>
