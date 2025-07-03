<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Appointment, model.DoctorShift" %>
<%@ page import="java.util.List" %>
<jsp:include page="/common-css.jsp"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Assign Doctor</title>
</head>
<body>
<jsp:include page="header.jsp"/>

<main>

    <div class="whole-wrap">
        <div class="container box_1170 mt-5">
            <div class="section-top-border">
                <h3 class="mb-30">Appointment Details</h3>
                <%
                    Appointment appointment = (Appointment) request.getAttribute("appointment");
                    List<DoctorShift> availableDoctors = (List<DoctorShift>) request.getAttribute("availableDoctors");
                %>
                <ul class="unordered-list">
                    <li><strong>Appointment ID:</strong> <%= appointment.getAppointmentId() %>
                    </li>
                    <li><strong>Patient ID:</strong> <%= appointment.getPatientId() %>
                    </li>
                    <li><strong>Date:</strong> <%= appointment.getAppointmentDate() %>
                    </li>
                    <li><strong>Time Slot:</strong> <%= appointment.getTimeSlot() %>
                    </li>
                    <li><strong>Appointment Type ID:</strong> <%= appointment.getAppointmentTypeId() %>
                    </li>
                    <li><strong>Status:</strong> <%= appointment.getStatus() %>
                    </li>
                </ul>
            </div>

            <div class="section-top-border">
                <h3 class="mb-30">Available Doctors</h3>
                <%
                    if (availableDoctors == null || availableDoctors.isEmpty()) {
                %>
                <p>No doctors available for this slot.</p>
                <%
                } else {
                %>
                <div class="progress-table-wrap">
                    <div class="progress-table">
                        <div class="table-head">
                            <div class="serial">#</div>
                            <div class="visit">Doctor ID</div>
                            <div class="visit">Shift ID</div>
                            <div class="visit">Time Slot</div>
                            <div class="visit">Status</div>
                            <div class="visit">Action</div>
                        </div>
                        <%
                            int i = 1;
                            for (DoctorShift ds : availableDoctors) {
                        %>
                        <div class="table-row">
                            <div class="serial"><%= i++ %>
                            </div>
                            <div class="visit"><%= ds.getDoctorId() %>
                            </div>
                            <div class="visit"><%= ds.getShiftId() %>
                            </div>
                            <div class="visit"><%= ds.getTimeSlot() %>
                            </div>
                            <div class="visit"><%= ds.getStatus() %>
                            </div>
                            <div class="visit">
                                <form method="post" action="<%= request.getContextPath() %>/assign-appointment">
                                    <input type="hidden" name="appointmentId"
                                           value="<%= appointment.getAppointmentId() %>"/>
                                    <input type="hidden" name="doctorId" value="<%= ds.getDoctorId() %>"/>
                                    <button type="submit" class="genric-btn primary small">Assign this Doctor</button>
                                </form>
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
