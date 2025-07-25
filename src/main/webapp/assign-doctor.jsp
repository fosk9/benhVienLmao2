<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Appointment, model.DoctorShift" %>
<%@ page import="java.util.List" %>

<%
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    List<DoctorShift> availableDoctors = (List<DoctorShift>) request.getAttribute("availableDoctors");
%>

<div class="modal-body">

    <div class="mb-4">
        <h6 class="text-dark">📋 Appointment Details</h6>
        <div class="row">
            <div class="col-md-6"><strong>ID:</strong> <%= appointment.getAppointmentId() %></div>
            <div class="col-md-6"><strong>Patient ID:</strong> <%= appointment.getPatientId() %></div>
            <div class="col-md-6"><strong>Date:</strong> <%= appointment.getAppointmentDate() %></div>
            <div class="col-md-6"><strong>Time Slot:</strong> <%= appointment.getTimeSlot() %></div>
            <div class="col-md-6"><strong>Type:</strong> <%= appointment.getAppointmentTypeId() %></div>
            <div class="col-md-6"><strong>Status:</strong> <%= appointment.getStatus() %></div>
        </div>
    </div>

    <h6 class="text-dark mb-2">👨‍⚕️ Available Doctors</h6>
    <%
        if (availableDoctors == null || availableDoctors.isEmpty()) {
    %>
    <div class="alert alert-warning">No doctors available for this time slot.</div>
    <%
    } else {
    %>
    <div class="table-responsive">
        <table class="table table-sm table-bordered table-hover">
            <thead class="thead-light">
            <tr class="text-center">
                <th>#</th>
                <th>Doctor ID</th>
                <th>Shift ID</th>
                <th>Time Slot</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <%
                int i = 1;
                for (DoctorShift ds : availableDoctors) {
            %>
            <tr class="text-center">
                <td><%= i++ %></td>
                <td><%= ds.getDoctorId() %></td>
                <td><%= ds.getShiftId() %></td>
                <td><%= ds.getTimeSlot() %></td>
                <td><%= ds.getStatus() %></td>
                <td>
                    <form method="post" action="<%= request.getContextPath() %>/assign-appointment" style="margin:0;">
                        <input type="hidden" name="appointmentId" value="<%= appointment.getAppointmentId() %>"/>
                        <input type="hidden" name="doctorId" value="<%= ds.getDoctorId() %>"/>
                        <button type="submit" class="btn btn-sm btn-success">
                            <i class="fas fa-check"></i> Assign
                        </button>
                    </form>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>

</div>
