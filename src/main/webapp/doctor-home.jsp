<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dto.AppointmentDTO, model.DoctorDetail, model.DoctorShift, java.util.List" %>
<%@ page import="model.Employee" %>

<%
    DoctorDetail doctorDetails = (DoctorDetail) request.getAttribute("doctorDetails");
    DoctorShift shiftToday = (DoctorShift) request.getAttribute("shiftToday");
    Employee doctor = (Employee) session.getAttribute("account");
    List<AppointmentDTO> todayAppointments = (List<AppointmentDTO>) request.getAttribute("todayAppointments");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Doctor Home</title>
    <jsp:include page="common-css.jsp"/>
</head>
<body>
<jsp:include page="doctor-header.jsp"/>

<!-- Hero Section -->
<div class="slider-area slider-area2 mb-5">
    <div class="slider-active dot-style">
        <div class="single-slider d-flex align-items-center slider-height2">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-xl-7 col-lg-8 col-md-10">
                        <div class="hero-wrapper">
                            <div class="hero__caption">
                                <h1>Welcome, Doctor</h1>
                                <h1><%= doctor.getFullName() %>
                                </h1>
                                <p>Here's your schedule and appointments today.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Main Content -->
<div class="container section-padding">

    <!-- Doctor Details Box -->
    <div class="card p-4 mb-4 shadow">
        <div class="section-tittle mb-3">
            <h2>Doctor Details</h2>
        </div>
        <% if (doctorDetails != null) { %>
        <ul class="unordered-list">
            <li><b>License Number:</b> <%= doctorDetails.getLicenseNumber() %>
            </li>
            <li><b>Specialist:</b> <%= doctorDetails.isSpecialist() ? "Yes" : "No" %>
            </li>
            <li><b>Rating:</b> <%= doctorDetails.getRating() != null ? doctorDetails.getRating() : "N/A" %>
            </li>
        </ul>
        <% } else { %>
        <p>No doctor information available.</p>
        <% } %>
    </div>

    <!-- Today's Shift Box -->
    <div class="card p-4 mb-4 shadow">
        <div class="section-tittle mb-3">
            <h2>Today's Shift</h2>
        </div>
        <% if (shiftToday != null) { %>
        <ul class="unordered-list">
            <li><b>Date:</b> <%= shiftToday.getShiftDate() %>
            </li>
            <li><b>Time Slot:</b> <%= shiftToday.getTimeSlot() %>
            </li>
            <li><b>Status:</b> <%= shiftToday.getStatus() %>
            </li>
        </ul>
        <% } else { %>
        <p>No shift assigned today.</p>
        <% } %>
    </div>

    <!-- Today's Appointments Box -->
    <div class="card p-4 mb-4 shadow">
        <div class="section-tittle mb-3">
            <h2>Today's Appointments</h2>
        </div>
        <% if (todayAppointments != null && !todayAppointments.isEmpty()) { %>
        <div class="progress-table-wrap">
            <div class="progress-table">
                <div class="table-head">
                    <div class="serial">#</div>
                    <div class="country">Patient</div>
                    <div class="visit">Type</div>
                    <div class="visit">Time Slot</div>
                    <div class="visit">Status</div>
                    <div class="visit">Action</div>
                </div>
                <% for (int i = 0; i < todayAppointments.size(); i++) {
                    AppointmentDTO ap = todayAppointments.get(i);
                %>
                <div class="table-row d-flex align-items-center">
                    <div class="serial"><%= i + 1 %>
                    </div>
                    <div class="country"><%= ap.getPatientName() %>
                    </div>
                    <div class="visit"><%= ap.getAppointmentType() %>
                    </div>
                    <div class="visit"><%= ap.getTimeSlot() %>
                    </div>
                    <div class="visit"><%= ap.getStatus() %>
                    </div>
                    <div class="visit">
                        <a href="examination-note?appointmentId=<%= ap.getAppointmentId() %>"
                           class="genric-btn primary small">Examine</a>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
        <% } else { %>
        <p>No appointments scheduled for today.</p>
        <% } %>
    </div>
</div>

<jsp:include page="common-scripts.jsp"/>
</body>
</html>
