<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
    .big-card { max-width: 600px; margin: 0 auto; font-size: 1.3rem; }
    .big-card .card-body p, .big-card .card-body strong { font-size: 1.2rem; }
    h2 { font-size: 2.2rem; text-align: center; margin-bottom: 30px; color: #28a745; }
    .btn { font-size: 1.2rem; padding: 15px 30px; background-color: #28a745; color: #fff; border-color: #28a745; }
    .btn:hover { background-color: #218838; border-color: #218838; }
    .total-price-section { margin-top: 20px; padding: 15px; background-color: #f1f8f1; border-radius: 8px; border: 1px solid #28a745; }
    .total-price-section .price-display { font-size: 1.3rem; color: #28a745; font-weight: bold; }
    .description-display { font-size: 1.1rem; color: #333; margin-top: 5px; }
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
    <h2>Appointment Details</h2>
    <div class="card big-card">
      <div class="card-body">
        <p><strong>ID:</strong> ${appointment.appointmentId}</p>
        <p><strong>Appointment Type:</strong>
          <c:choose>
            <c:when test="${not empty appointment.appointmentType and not empty appointment.appointmentType.typeName}">
              ${appointment.appointmentType.typeName}
            </c:when>
            <c:otherwise>Unknown Type</c:otherwise>
          </c:choose>
        </p>
        <p><strong>Description:</strong>
          <c:choose>
            <c:when test="${not empty appointment.appointmentType and not empty appointment.appointmentType.description}">
              ${appointment.appointmentType.description}
            </c:when>
            <c:otherwise>No description available</c:otherwise>
          </c:choose>
        </p>
        <p><strong>Date:</strong>
          <fmt:formatDate value="${appointment.appointmentDate}" pattern="dd/MM/yyyy"/>
        </p>
        <p><strong>Time Slot:</strong> ${not empty appointment.timeSlot ? appointment.timeSlot : 'Not specified'}</p>
        <p><strong>Requires Specialist:</strong>
          <c:choose>
            <c:when test="${appointment.requiresSpecialist}">Yes</c:when>
            <c:otherwise>No</c:otherwise>
          </c:choose>
        </p>
        <p><strong>Status:</strong> ${not empty appointment.status ? appointment.status : 'Not specified'}</p>
        <p><strong>Created At:</strong>
          <fmt:formatDate value="${appointment.createdAt}" pattern="HH:mm dd/MM/yyyy"/>
        </p>
        <p><strong>Updated At:</strong>
          <fmt:formatDate value="${appointment.updatedAt}" pattern="HH:mm dd/MM/yyyy"/>
        </p>
        <c:if test="${not empty doctor}">
          <p><strong>Doctor:</strong> ${doctor.fullName}
            <c:if test="${not empty doctor.email}">(${doctor.email})</c:if>
          </p>
        </c:if>
        <div class="total-price-section">
          <div class="price-display">Total Price:
            <span id="priceValue">
              <c:choose>
                <c:when test="${not empty appointment.appointmentType and not empty appointment.appointmentType.price}">
                  <c:set var="totalPrice" value="${appointment.appointmentType.price}"/>
                  <c:if test="${appointment.requiresSpecialist}">
                    <c:set var="totalPrice" value="${totalPrice * 1.5}"/>
                  </c:if>
                  <fmt:formatNumber value="${totalPrice}" type="number" groupingUsed="true"/> VND
                </c:when>
                <c:otherwise>0 VND</c:otherwise>
              </c:choose>
            </span>
          </div>
        </div>
        <a href="<c:url value='/appointments'/>" class="btn mt-3 w-100">Back to Appointments</a>
      </div>
    </div>
  </div>
</main>
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
<script src="<c:url value='/assets/js/main.js'/>"></script>
</body>
</html>