<%--
  Created by IntelliJ IDEA.
  User: Fosk Jesky
  Date: 5/27/2025
  Time: 1:08 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>Book Appointment</title>
  <meta name="description" content="">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="<c:url value='/assets/css/bootstrap.min.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/owl.carousel.min.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/slicknav.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/flaticon.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/gijgo.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/animate.min.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/animated-headline.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/magnific-popup.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/fontawesome-all.min.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/themify-icons.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/slick.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/nice-select.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
  <style>
    .big-form { max-width: 500px; margin: 0 auto; font-size: 1.3rem; }
    .big-form label, .big-form input, .big-form select, .big-form button { font-size: 1.2rem; }
    .big-form .form-control { height: 50px; font-size: 1.2rem; }
    .big-form .btn { padding: 15px 30px; font-size: 1.2rem; }
    h2 { font-size: 2.2rem; text-align: center; margin-bottom: 30px; }
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
    <form action="<c:url value='/book-appointment'/>" method="post" class="big-form">
      <div class="form-group mb-4">
        <label for="appointmentType">Appointment Type:</label>
        <input type="text" class="form-control" id="appointmentType" name="appointmentType" value="${appointmentType}" required>
      </div>
      <div class="form-group mb-4">
        <label for="appointmentDateTime">Appointment Date & Time:</label>
        <input type="datetime-local" class="form-control" id="appointmentDateTime" name="appointmentDateTime" required>
      </div>
      <button type="submit" class="btn btn-primary mt-3 w-100">Submit Appointment</button>
    </form>
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

<script src="<c:url value='/assets/js/vendor/modernizr-3.5.0.min.js'/>"></script>
<script src="<c:url value='/assets/js/vendor/jquery-1.12.4.min.js'/>"></script>
<script src="<c:url value='/assets/js/popper.min.js'/>"></script>
<script src="<c:url value='/assets/js/bootstrap.min.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.slicknav.min.js'/>"></script>
<script src="<c:url value='/assets/js/owl.carousel.min.js'/>"></script>
<script src="<c:url value='/assets/js/slick.min.js'/>"></script>
<script src="<c:url value='/assets/js/wow.min.js'/>"></script>
<script src="<c:url value='/assets/js/animated.headline.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.magnific-popup.js'/>"></script>
<script src="<c:url value='/assets/js/gijgo.min.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.nice-select.min.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.sticky.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.counterup.min.js'/>"></script>
<script src="<c:url value='/assets/js/waypoints.min.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.countdown.min.js'/>"></script>
<script src="<c:url value='/assets/js/hover-direction-snake.min.js'/>"></script>
<script src="<c:url value='/assets/js/contact.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.form.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.validate.min.js'/>"></script>
<script src="<c:url value='/assets/js/mail-script.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.ajaxchimp.min.js'/>"></script>
<script src="<c:url value='/assets/js/plugins.js'/>"></script>
<script src="<c:url value='/assets/js/main.js'/>"></script>
</body>
</html>
