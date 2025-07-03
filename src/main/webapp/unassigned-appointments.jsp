<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Appointment" %>
<%@ page import="java.util.List" %>
<jsp:include page="/common-css.jsp"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Unassigned Appointments</title>
</head>
<body>
<jsp:include page="header.jsp"/>

<main>

    <div class="whole-wrap">
        <div class="container box_1170 mt-5">
            <div class="section-top-border">
                <h3 class="mb-30">List of Unassigned Appointments</h3>

                <%
                    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                    if (appointments == null || appointments.isEmpty()) {
                %>
                <p>No unassigned appointments found.</p>
                <% } else { %>
                <div class="progress-table-wrap">
                    <div class="progress-table">
                        <div class="table-head">
                            <div class="serial">#</div>
                            <div class="visit">Patient ID</div>
                            <div class="visit">Appointment Date</div>
                            <div class="visit">Time Slot</div>
                            <div class="visit">Type</div>
                            <div class="visit">Status</div>
                            <div class="visit">Action</div>
                        </div>
                        <%
                            int index = 1;
                            for (Appointment a : appointments) {
                        %>
                        <div class="table-row">
                            <div class="serial"><%= index++ %>
                            </div>
                            <div class="visit"><%= a.getPatientId() %>
                            </div>
                            <div class="visit"><%= a.getAppointmentDate() %>
                            </div>
                            <div class="visit"><%= a.getTimeSlot() %>
                            </div>
                            <div class="visit"><%= a.getAppointmentTypeId() %>
                            </div>
                            <div class="visit"><%= a.getStatus() %>
                            </div>
                            <div class="visit">
                                <a href="<%= request.getContextPath() %>/assign-appointment?id=<%= a.getAppointmentId() %>"
                                   class="genric-btn primary small">Assign</a>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/common-scripts.jsp"/>
</body>
</html>
