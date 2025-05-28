<%--
  Created by IntelliJ IDEA.
  User: Fosk Jesky
  Date: 5/27/2025
  Time: 1:08 AM
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
  <title>Book Appointment</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="<c:url value='/assets/css/bootstrap.min.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/select2.min.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
  <style>
    .big-form { max-width: 500px; margin: 0 auto; font-size: 1.3rem; }
    .big-form label, .big-form input, .big-form select, .big-form button { font-size: 1.2rem; }
    .big-form .form-control { height: 50px; font-size: 1.2rem; }
    .big-form .btn { padding: 15px 30px; font-size: 1.2rem; background-color: #28A745; border-color: #28A745; }
    .big-form .btn:hover { background-color: #218838; border-color: #218838; }
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
    <h2>Book Appointment</h2>
    <c:if test="${not empty errorMsg}">
      <div class="error-message" style="display: block;">${errorMsg}</div>
    </c:if>
    <form action="<c:url value='/book-appointment'/>" method="post" class="big-form" id="appointmentForm">
      <div class="form-group mb-4">
        <label for="appointmentTypeSelect">Appointment Type:</label>
        <select class="form-control" id="appointmentTypeSelect" name="appointmentTypeSelect" required onchange="toggleCustomType(this)">
          <option value="" <c:if test="${empty appointmentType}">selected</c:if>>-- Select Appointment Type --</option>
          <option value="General Checkup" <c:if test="${appointmentType == 'General Checkup'}">selected</c:if>>General Checkup</option>
          <option value="Cardiology Consultation" <c:if test="${appointmentType == 'Cardiology Consultation'}">selected</c:if>>Cardiology Consultation</option>
          <option value="Gastroenterology Consultation" <c:if test="${appointmentType == 'Gastroenterology Consultation'}">selected</c:if>>Gastroenterology Consultation</option>
          <option value="Orthopedic Consultation" <c:if test="${appointmentType == 'Orthopedic Consultation'}">selected</c:if>>Orthopedic Consultation</option>
          <option value="Neurology Consultation" <c:if test="${appointmentType == 'Neurology Consultation'}">selected</c:if>>Neurology Consultation</option>
          <option value="Mental Health Consultation" <c:if test="${appointmentType == 'Mental Health Consultation'}">selected</c:if>>Mental Health Consultation</option>
          <option value="Psychotherapy Session" <c:if test="${appointmentType == 'Psychotherapy Session'}">selected</c:if>>Psychotherapy Session</option>
          <option value="Psychiatric Evaluation" <c:if test="${appointmentType == 'Psychiatric Evaluation'}">selected</c:if>>Psychiatric Evaluation</option>
          <option value="Stress and Anxiety Management" <c:if test="${appointmentType == 'Stress and Anxiety Management'}">selected</c:if>>Stress and Anxiety Management</option>
          <option value="Depression Counseling" <c:if test="${appointmentType == 'Depression Counseling'}">selected</c:if>>Depression Counseling</option>
          <option value="Periodic Health Checkup" <c:if test="${appointmentType == 'Periodic Health Checkup'}">selected</c:if>>Periodic Health Checkup</option>
          <option value="Gynecology Consultation" <c:if test="${appointmentType == 'Gynecology Consultation'}">selected</c:if>>Gynecology Consultation</option>
          <option value="Pediatric Consultation" <c:if test="${appointmentType == 'Pediatric Consultation'}">selected</c:if>>Pediatric Consultation</option>
          <option value="Ophthalmology Consultation" <c:if test="${appointmentType == 'Ophthalmology Consultation'}">selected</c:if>>Ophthalmology Consultation</option>
          <option value="ENT Consultation" <c:if test="${appointmentType == 'ENT Consultation'}">selected</c:if>>ENT Consultation</option>
          <option value="On-Demand Consultation" <c:if test="${appointmentType == 'On-Demand Consultation'}">selected</c:if>>On-Demand Consultation</option>
          <option value="Emergency Consultation" <c:if test="${appointmentType == 'Emergency Consultation'}">selected</c:if>>Emergency Consultation</option>
          <option value="custom" <c:if test="${appointmentType == 'custom'}">selected</c:if>>Other...</option>
        </select>
        <input type="text" class="form-control mt-2" id="customAppointmentType" name="customAppointmentType" placeholder="Enter other appointment type" style="display:none;" value="${appointmentType != 'custom' ? '' : appointmentType}"/>
      </div>
      <div class="form-group mb-4">
        <label for="appointmentDateTime">Appointment Date & Time:</label>
        <input type="datetime-local" class="form-control" id="appointmentDateTime" name="appointmentDateTime" required>
        <div class="error-message" id="dateError">Invalid appointment time: Cannot book in the past.</div>
      </div>
      <c:if test="${not empty appointment}">
        <div class="form-group mb-4">
          <label>Selected Appointment Date & Time:</label>
          <p><fmt:formatDate value="${appointment.appointmentDate}" pattern="HH:mm dd/MM/yyyy"/></p>
        </div>
      </c:if>
      <button type="submit" class="btn btn-primary mt-3 w-100">Submit Appointment</button>
    </form>
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
