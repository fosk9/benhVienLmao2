<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>Appointment Details</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="<c:url value='/assets/css/bootstrap.min.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
  <style>
    .details-container { max-width: 600px; margin: 50px auto; padding: 20px; background-color: #f1f8f1; border-radius: 8px; border: 1px solid #28a745; }
    h2 { font-size: 2.2rem; text-align: center; margin-bottom: 30px; color: #28a745; }
    .detail-item { margin-bottom: 15px; font-size: 1.2rem; }
    .detail-item label { font-weight: bold; color: #333; }
    .btn-back { background-color: #28a745; color: #fff; padding: 10px 20px; border-radius: 5px; text-decoration: none; }
    .btn-back:hover { background-color: #218838; }
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
                    <c:if test="${sessionScope.patientId != null}">
                      <li><a href="<c:url value='/appointments'/>">My Appointments</a></li>
                      <li><a href="<c:url value='/logout'/>">Logout</a></li>
                    </c:if>
                    <c:if test="${sessionScope.patientId == null}">
                      <li><a href="<c:url value='/login'/>">Login</a></li>
                      <li><a href="<c:url value='/register'/>">Register</a></li>
                    </c:if>
                  </ul>
                </nav>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</header>
<main>
  <div class="container">
    <div class="details-container">
      <h2>Appointment Details</h2>
      <div class="detail-item">
        <label>Appointment Type:</label>
        <span>${appointment.appointmentType.typeName}</span>
      </div>
      <div class="detail-item">
        <label>Date:</label>
        <span>${appointment.appointmentDate}</span>
      </div>
      <div class="detail-item">
        <label>Time Slot:</label>
        <span>${appointment.timeSlot}</span>
      </div>
      <div class="detail-item">
        <label>Requires Specialist:</label>
        <span>${appointment.requiresSpecialist ? 'Yes' : 'No'}</span>
      </div>
      <div class="detail-item">
        <label>Status:</label>
        <span>${appointment.status}</span>
      </div>
      <c:if test="${doctor != null}">
        <div class="detail-item">
          <label>Doctor:</label>
          <span>${doctor.fullName}</span>
        </div>
      </c:if>
      <div class="text-center">
        <a href="<c:url value='/pactHome'/>" class="btn-back">Back to Home</a>
      </div>
    </div>
  </div>
</main>
<footer>
  <div class="footer-wrappr section-bg3">
    <div class="container">
      <div class="footer-copy-right">
        <p>Group 3 - SE1903 - SWP391 Summer2025</p>
      </div>
    </div>
  </div>
</footer>
<script src="<c:url value='/assets/js/vendor/jquery-1.12.4.min.js'/>"></script>
<script src="<c:url value='/assets/js/popper.min.js'/>"></script>
<script src="<c:url value='/assets/js/bootstrap.min.js'/>"></script>
</body>
</html>