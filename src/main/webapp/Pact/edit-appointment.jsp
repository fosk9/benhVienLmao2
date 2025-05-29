<%--
  Created by IntelliJ IDEA.
  User: Fosk Jesky
  Date: 5/26/2025
  Time: 4:12 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>Edit Appointment</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="<c:url value='/assets/css/bootstrap.min.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/select2.min.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
  <style>
    .big-form { max-width: 500px; margin: 0 auto; font-size: 1.3rem; }
    .big-form label, .big-form input, .big-form select, .big-form button { font-size: 1.2rem; }
    .big-form .form-control { height: 50px; font-size: 1.2rem; }
    .big-form .btn-primary { padding: 15px 30px; font-size: 1.2rem; background-color: #28A745; border-color: #28A745; }
    .big-form .btn-primary:hover { background-color: #218838; border-color: #218838; }
    .big-form .btn-secondary { padding: 15px 30px; font-size: 1.2rem; }
    h2 { font-size: 2.2rem; text-align: center; margin-bottom: 30px; color: #28A745; }
    .select2-container--default .select2-selection--single { height: 50px; font-size: 1.2rem; border-color: #28A745; }
    .select2-container--default .select2-selection--single .select2-selection__rendered { line-height: 50px; }
    .select2-container--default .select2-selection--single .select2-selection__arrow { height: 50px; }
    .error-message { color: #dc3545; font-size: 1rem; margin-top: 5px; display: none; }
  </style>
</head>
<body>
<header>
  <div class="header-area">
    <div class="main-header header-sticky">
      <div class="container-fluid">
        <div class="row align-items-center">
          <div class="col-xl-2 col-lg-2 col-md-1">
            <div class="logo">
              <a href="<c:url value='/pactHome'/>">HealthCare</a>
            </div>
          </div>
          <div class="col-xl-10 col-lg-10 col-md-10">
            <div class="menu-main d-flex align-items-center justify-content-end">
              <div class="main-menu f-right d-none d-lg-block">
                <nav>
                  <ul id="navigation">
                    <li><a href="<c:url value='/pactHome'/>">Home</a></li>
                    <li><a href="<c:url value='/services'/>">Services</a></li>
                    <li><a href="<c:url value='/book-appointment'/>">Book Appointment</a></li>
                    <li><a href="<c:url value='/appointments'/>">My Appointments</a></li>
                    <li><a href="<c:url value='/logout'/>">Logout</a></li>
                  </ul>
                </nav>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="mobile_menu d-block d-lg-none"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</header>
<main>
  <div class="container mt-5">
    <h2>Edit Appointment</h2>
    <c:if test="${not empty errorMsg}">
      <div class="error-message" style="display: block;">${errorMsg}</div>
    </c:if>
    <div class="card">
      <div class="card-body">
        <form action="<c:url value='/appointments/edit'/>" method="post" class="big-form" id="appointmentForm">
          <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
          <div class="form-group mb-4">
            <label for="appointmentTypeSelect">Appointment Type:</label>
            <select class="form-control" id="appointmentTypeSelect" name="appointmentTypeSelect" required onchange="toggleCustomType(this)">
              <option value="" <c:if test="${empty appointment.appointmentType}">selected</c:if>>-- Select Appointment Type --</option>
              <option value="General Checkup" <c:if test="${appointment.appointmentType == 'General Checkup'}">selected</c:if>>General Checkup</option>
              <option value="Cardiology Consultation" <c:if test="${appointment.appointmentType == 'Cardiology Consultation'}">selected</c:if>>Cardiology Consultation</option>
              <option value="Gastroenterology Consultation" <c:if test="${appointment.appointmentType == 'Gastroenterology Consultation'}">selected</c:if>>Gastroenterology Consultation</option>
              <option value="Orthopedic Consultation" <c:if test="${appointment.appointmentType == 'Orthopedic Consultation'}">selected</c:if>>Orthopedic Consultation</option>
              <option value="Neurology Consultation" <c:if test="${appointment.appointmentType == 'Neurology Consultation'}">selected</c:if>>Neurology Consultation</option>
              <option value="Mental Health Consultation" <c:if test="${appointment.appointmentType == 'Mental Health Consultation'}">selected</c:if>>Mental Health Consultation</option>
              <option value="Psychotherapy Session" <c:if test="${appointment.appointmentType == 'Psychotherapy Session'}">selected</c:if>>Psychotherapy Session</option>
              <option value="Psychiatric Evaluation" <c:if test="${appointment.appointmentType == 'Psychiatric Evaluation'}">selected</c:if>>Psychiatric Evaluation</option>
              <option value="Stress and Anxiety Management" <c:if test="${appointment.appointmentType == 'Stress and Anxiety Management'}">selected</c:if>>Stress and Anxiety Management</option>
              <option value="Depression Counseling" <c:if test="${appointment.appointmentType == 'Depression Counseling'}">selected</c:if>>Depression Counseling</option>
              <option value="Periodic Health Checkup" <c:if test="${appointment.appointmentType == 'Periodic Health Checkup'}">selected</c:if>>Periodic Health Checkup</option>
              <option value="Gynecology Consultation" <c:if test="${appointment.appointmentType == 'Gynecology Consultation'}">selected</c:if>>Gynecology Consultation</option>
              <option value="Pediatric Consultation" <c:if test="${appointment.appointmentType == 'Pediatric Consultation'}">selected</c:if>>Pediatric Consultation</option>
              <option value="Ophthalmology Consultation" <c:if test="${appointment.appointmentType == 'Ophthalmology Consultation'}">selected</c:if>>Ophthalmology Consultation</option>
              <option value="ENT Consultation" <c:if test="${appointment.appointmentType == 'ENT Consultation'}">selected</c:if>>ENT Consultation</option>
              <option value="On-Demand Consultation" <c:if test="${appointment.appointmentType == 'On-Demand Consultation'}">selected</c:if>>On-Demand Consultation</option>
              <option value="Emergency Consultation" <c:if test="${appointment.appointmentType == 'Emergency Consultation'}">selected</c:if>>Emergency Consultation</option>
              <option value="custom" <c:if test="${not empty appointment.appointmentType && appointment.appointmentType != 'General Checkup' && appointment.appointmentType != 'Cardiology Consultation' && appointment.appointmentType != 'Gastroenterology Consultation' && appointment.appointmentType != 'Orthopedic Consultation' && appointment.appointmentType != 'Neurology Consultation' && appointment.appointmentType != 'Mental Health Consultation' && appointment.appointmentType != 'Psychotherapy Session' && appointment.appointmentType != 'Psychiatric Evaluation' && appointment.appointmentType != 'Stress and Anxiety Management' && appointment.appointmentType != 'Depression Counseling' && appointment.appointmentType != 'Periodic Health Checkup' && appointment.appointmentType != 'Gynecology Consultation' && appointment.appointmentType != 'Pediatric Consultation' && appointment.appointmentType != 'Ophthalmology Consultation' && appointment.appointmentType != 'ENT Consultation' && appointment.appointmentType != 'On-Demand Consultation' && appointment.appointmentType != 'Emergency Consultation'}">selected</c:if>>Other...</option>
            </select>
            <input type="text" class="form-control mt-2" id="customAppointmentType" name="customAppointmentType" placeholder="Enter other appointment type" style="display:none;" value="${not empty appointment.appointmentType && appointment.appointmentType != 'General Checkup' && appointment.appointmentType != 'Cardiology Consultation' && appointment.appointmentType != 'Gastroenterology Consultation' && appointment.appointmentType != 'Orthopedic Consultation' && appointment.appointmentType != 'Neurology Consultation' && appointment.appointmentType != 'Mental Health Consultation' && appointment.appointmentType != 'Psychotherapy Session' && appointment.appointmentType != 'Psychiatric Evaluation' && appointment.appointmentType != 'Stress and Anxiety Management' && appointment.appointmentType != 'Depression Counseling' && appointment.appointmentType != 'Periodic Health Checkup' && appointment.appointmentType != 'Gynecology Consultation' && appointment.appointmentType != 'Pediatric Consultation' && appointment.appointmentType != 'Ophthalmology Consultation' && appointment.appointmentType != 'ENT Consultation' && appointment.appointmentType != 'On-Demand Consultation' && appointment.appointmentType != 'Emergency Consultation' ? appointment.appointmentType : ''}"/>
          </div>
          <div class="form-group mb-4">
            <label for="appointmentDateTime">Appointment Date & Time:</label>
            <input type="datetime-local" class="form-control" id="appointmentDateTime" name="appointmentDateTime" required
                   value="${appointment.appointmentDate != null ? appointment.appointmentDate.toString().replace(' ', 'T').substring(0,16) : ''}">
            <div class="mt-2">
              <fmt:formatDate value="${appointment.appointmentDate}" pattern="HH:mm dd/MM/yyyy"/>
            </div>
            <div class="error-message" id="dateError">Invalid appointment time: Cannot update to a past date.</div>
          </div>
          <button type="submit" class="btn btn-primary mt-3 w-100">Update Appointment</button>
          <a href="<c:url value='/appointments'/>" class="btn btn-secondary mt-3 w-100">Cancel</a>
        </form>
      </div>
    </div>
  </div>
</main>
<script>
  // Initialize form elements and validation
  window.onload = function() {
    const now = new Date();
    const pad = n => n < 10 ? '0' + n : n;
    const yyyy = now.getFullYear();
    const MM = pad(now.getMonth() + 1);
    const dd = pad(now.getDate());
    const hh = pad(now.getHours());
    const mm = pad(now.getMinutes());
    const minValue = `${yyyy}-${MM}-${dd}T${hh}:${mm}`;
    const dateInput = document.getElementById('appointmentDateTime');
    dateInput.setAttribute('min', minValue);

    // Initialize Select2 for searchable dropdown
    $('#appointmentTypeSelect').select2({
      placeholder: "-- Select Appointment Type --",
      allowClear: true,
      width: '100%'
    });

    // Ensure custom input is hidden or shown based on selection
    toggleCustomType(document.getElementById('appointmentTypeSelect'));

    // Client-side validation for past dates
    document.getElementById('appointmentForm').addEventListener('submit', function(event) {
      const selectedDate = new Date(dateInput.value);
      if (selectedDate < now) {
        event.preventDefault();
        document.getElementById('dateError').style.display = 'block';
      } else {
        document.getElementById('dateError').style.display = 'none';
      }
    });
  };

  // Toggle custom appointment type input
  function toggleCustomType(select) {
    const customInput = document.getElementById('customAppointmentType');
    if (select.value === 'custom') {
      customInput.style.display = 'block';
      customInput.setAttribute('required', 'required');
    } else {
      customInput.style.display = 'none';
      customInput.removeAttribute('required');
    }
  }
</script>
<footer>
  <div class="footer-wrappr section-bg3">
    <div class="footer-area footer-padding">
      <div class="container">
        <div class="row justify-content-between">
          <div class="col-xl-8 col-lg-8 col-md-6 col-sm-12">
            <div class="single-footer-caption mb-50">
              <div class="footer-logo mb-25">
                <a href="<c:url value='/pactHome'/>">HealthCare</a>
              </div>
              <div class="header-area">
                <div class="main-header main-header2">
                  <div class="menu-main d-flex align-items-center justify-content-start">
                    <div class="main-menu main-menu2">
                      <nav>
                        <ul>
                          <li><a href="<c:url value='/pactHome'/>">Home</a></li>
                          <li><a href="<c:url value='/about'/>">About</a></li>
                          <li><a href="<c:url value='/services'/>">Services</a></li>
                          <li><a href="<c:url value='/blog'/>">Blog</a></li>
                          <li><a href="<c:url value='/contact'/>">Contact</a></li>
                        </ul>
                      </nav>
                    </div>
                  </div>
                </div>
              </div>
              <div class="footer-social mt-50">
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="https://bit.ly/sai4ull"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-pinterest-p"></i></a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="footer-bottom-area">
      <div class="container">
        <div class="footer-border">
          <div class="row">
            <div class="col-xl-10">
              <div class="footer-copy-right">
                <p>Group 3 - SE1903 - SWP391 Summer2025</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</footer>
<div id="back-top">
  <a title="Go to Top" href="#"> <i class="fas fa-level-up-alt"></i></a>
</div>

<script src="<c:url value='/assets/js/vendor/jquery-1.12.4.min.js'/>"></script>
<script src="<c:url value='/assets/js/popper.min.js'/>"></script>
<script src="<c:url value='/assets/js/bootstrap.min.js'/>"></script>
<script src="<c:url value='/assets/js/select2.min.js'/>"></script>
<script src="<c:url value='/assets/js/main.js'/>"></script>
</body>
</html>
