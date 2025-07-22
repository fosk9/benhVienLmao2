<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Appointment, model.Diagnosis, model.Prescription, model.Treatment" %>
<jsp:include page="common-css.jsp"/>

<%
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    Diagnosis diagnosis = (Diagnosis) request.getAttribute("diagnosis");
    Prescription prescription = (Prescription) request.getAttribute("prescription");
    Treatment treatment = (Treatment) request.getAttribute("treatment");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Examination Note</title>
</head>
<body>
<jsp:include page="header.jsp"/>

<div class="container mt-5">
    <div class="section-top-border">
        <%
            String message = (String) request.getAttribute("message");
            if (message != null && !message.trim().isEmpty()) {
        %>
        <div class="alert alert-success" role="alert">
            <%= message %>
        </div>
        <%
            }
        %>

        <h3 class="mb-30">Examination Note - Appointment #<%= appointment.getAppointmentId() %>
        </h3>
        <form action="update-examination-note" method="post">
            <input type="hidden" name="appointmentId" value="<%= appointment.getAppointmentId() %>"/>

            <div class="form-group">
                <label>Diagnosis Notes</label>
                <textarea name="diagnosis_notes" class="single-textarea" rows="4"
                          placeholder="Enter diagnosis..."><%= diagnosis != null ? diagnosis.getNotes() : "" %></textarea>
            </div>

            <div class="form-group mt-4">
                <label>Prescribed Medications</label>
                <textarea name="medication_details" class="single-textarea" rows="4"
                          placeholder="Enter medications..."><%= prescription != null ? prescription.getMedicationDetails() : "" %></textarea>
            </div>

            <div class="form-group mt-4">
                <label>Treatment Type</label>
                <input type="text" name="treatment_type" class="single-input"
                       value="<%= treatment != null ? treatment.getTreatmentType() : "" %>"
                       placeholder="Enter treatment type"/>
            </div>

            <div class="form-group mt-4">
                <label>Treatment Notes</label>
                <textarea name="treatment_notes" class="single-textarea" rows="4"
                          placeholder="Enter treatment notes..."><%= treatment != null ? treatment.getTreatmentNotes() : "" %></textarea>
            </div>

            <div class="form-group mt-4">
                <button type="submit" class="genric-btn primary">Update Examination Note</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="common-scripts.jsp"/>
</body>
</html>
