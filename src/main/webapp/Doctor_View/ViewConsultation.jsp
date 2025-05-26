<%--
  Created by IntelliJ IDEA.
  User: ADMIN
  Date: 5/26/2025
  Time: 11:33 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>Health | Template</title>
  <meta name="description" content="">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="manifest" href="site.webmanifest">
  <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">

  <!-- CSS here -->
  <link rel="stylesheet" href="assets/css/bootstrap.min.css">
  <link rel="stylesheet" href="assets/css/owl.carousel.min.css">
  <link rel="stylesheet" href="assets/css/slicknav.css">
  <link rel="stylesheet" href="assets/css/flaticon.css">
  <link rel="stylesheet" href="assets/css/gijgo.css">
  <link rel="stylesheet" href="assets/css/animate.min.css">
  <link rel="stylesheet" href="assets/css/animated-headline.css">
  <link rel="stylesheet" href="assets/css/magnific-popup.css">
  <link rel="stylesheet" href="assets/css/fontawesome-all.min.css">
  <link rel="stylesheet" href="assets/css/themify-icons.css">
  <link rel="stylesheet" href="assets/css/slick.css">
  <link rel="stylesheet" href="assets/css/nice-select.css">
  <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
<!-- ? Preloader Start -->
<div id="preloader-active">
  <div class="preloader d-flex align-items-center justify-content-center">
    <div class="preloader-inner position-relative">
      <div class="preloader-circle"></div>
      <div class="preloader-img pere-text">
        <img src="assets/img/logo/loder.png" alt="">
      </div>
    </div>
  </div>
</div>
<!-- Preloader Start -->
<header>
  <!--? Header Start -->
  <div class="header-area">
    <div class="main-header header-sticky">
      <div class="container-fluid">
        <div class="row align-items-center">
          <!-- Logo -->
          <div class="col-xl-2 col-lg-2 col-md-1">
            <div class="logo">
              <a href="index.html"><img src="assets/img/logo/logo.png" alt=""></a>
            </div>
          </div>
          <div class="col-xl-10 col-lg-10 col-md-10">
            <div class="menu-main d-flex align-items-center justify-content-end">
              <!-- Main-menu -->
              <div class="main-menu f-right d-none d-lg-block">
                <nav>
                  <ul id="navigation">
                    <li><a href="index.html">Home</a></li>
                    <li><a href="about.html">About</a></li>
                    <li><a href="services.html">Services</a></li>
                    <li><a href="blog.html">Blog</a>
                      <ul class="submenu">
                        <li><a href="blog.html">Blog</a></li>
                        <li><a href="blog_details.html">Blog Details</a></li>
                        <li><a href="elements.html">Element</a></li>
                      </ul>
                    </li>
                    <li><a href="contact.html">Contact</a></li>
                  </ul>
                </nav>
              </div>
              <div class="header-right-btn f-right d-none d-lg-block ml-15">
                <a href="Login.jsp" class="btn header-btn">Login</a>
                <a href="register.jsp" class="btn header-btn">Register</a>
              </div>
            </div>
          </div>
          <!-- Mobile Menu -->
          <div class="col-12">
            <div class="mobile_menu d-block d-lg-none"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- Header End -->
</header>
<main>
  <section class="about-area2 section-padding40">
    <div class="container">
      <div class="section-tittle text-center mb-30">
        <h2>Appointment Details</h2>
      </div>
      <div class="row justify-content-center">
        <div class="col-lg-8">
          <table class="table table-bordered" style="width: 90%; font-size: 1.5rem; margin: 0 auto;">
            <tr>
              <th style="padding: 20px 25px;">Patient Name</th>
              <td style="padding: 20px 25px;">${appointment.patientName}</td>
            </tr>
            <tr>
              <th style="padding: 20px 25px;">Email</th>
              <td style="padding: 20px 25px;">${appointment.patientEmail}</td>
            </tr>
            <tr>
              <th style="padding: 20px 25px;">Phone</th>
              <td style="padding: 20px 25px;">${appointment.patientPhone}</td>
            </tr>
            <tr>
              <th style="padding: 20px 25px;">Appointment Time</th>
              <td style="padding: 20px 25px;">
                <c:choose>
                  <c:when test="${not empty appointment.appointmentDate}">
                    ${appointment.appointmentDate}
                  </c:when>
                  <c:otherwise>
                    Not scheduled
                  </c:otherwise>
                </c:choose>
              </td>
            </tr>
            <tr>
              <th style="padding: 20px 25px;">Status</th>
              <td style="padding: 20px 25px;">
                <form action="${pageContext.request.contextPath}/change-status" method="post" style="margin:0;">
                  <input type="hidden" name="appointmentId" value="${appointment.appointmentId}" />
                  <select name="status" onchange="this.form.submit()" style="font-size:1.5rem; padding:6px;">
                    <option value="Pending" ${appointment.status == 'Pending' ? 'selected' : ''}>Pending</option>
                    <option value="Confirmed" ${appointment.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                    <option value="Completed" ${appointment.status == 'Completed' ? 'selected' : ''}>Completed</option>
                    <option value="Cancelled" ${appointment.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                  </select>
                </form>
              </td>
            </tr>

          </table>
          <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/doctor-home" class="btn btn-outline-primary">← Back to Dashboard</a>
          </div>
        </div>
      </div>
    </div>
  </section>
</main>
<footer>
  <div class="footer-wrappr section-bg3" data-background="assets/img/gallery/footer-bg.png">
    <div class="footer-area footer-padding ">
      <div class="container">
        <div class="row justify-content-between">
          <div class="col-xl-8 col-lg-8 col-md-6 col-sm-12">
            <div class="single-footer-caption mb-50">
              <!-- logo -->
              <div class="footer-logo mb-25">
                <a href="index.html"><img src="assets/img/logo/logo2_footer.png" alt=""></a>
              </div>
              <d iv class="header-area">
                <div class="main-header main-header2">
                  <div class="menu-main d-flex align-items-center justify-content-start">
                    <!-- Main-menu -->
                    <div class="main-menu main-menu2">
                      <nav>
                        <ul>
                          <li><a href="index.html">Home</a></li>
                          <li><a href="about.html">About</a></li>
                          <li><a href="services.html">Services</a></li>
                          <li><a href="blog.html">Blog</a></li>
                          <li><a href="contact.html">Contact</a></li>
                        </ul>
                      </nav>
                    </div>
                  </div>
                </div>
              </d>
              <!-- social -->
              <div class="footer-social mt-50">
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="https://bit.ly/sai4ull"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-pinterest-p"></i></a>
              </div>
            </div>
          </div>
          <div class="col-xl-4 col-lg-4 col-md-6 col-sm-12">
            <div class="single-footer-caption">
              <div class="footer-tittle mb-50">
                <h4>Subscribe newsletter</h4>
              </div>
              <!-- Form -->
              <div class="footer-form">
                <div id="mc_embed_signup">
                  <form target="_blank" action="https://spondonit.us12.list-manage.com/subscribe/post?u=1462626880ade1ac87bd9c93a&amp;id=92a4423d01" method="get" class="subscribe_form relative mail_part" novalidate="true">
                    <input type="email" name="EMAIL" id="newsletter-form-email" placeholder=" Email Address " class="placeholder hide-on-focus" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter your email'">
                    <div class="form-icon">
                      <button type="submit" name="submit" id="newsletter-submit" class="email_icon newsletter-submit button-contactForm">
                        Subscribe
                      </button>
                    </div>
                    <div class="mt-10 info"></div>
                  </form>
                </div>
              </div>
              <div class="footer-tittle">
                <div class="footer-pera">
                  <p>Praesent porttitor, nulla vitae posuere iaculis, arcu nisl dignissim dolor, a pretium misem ut ipsum.</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- footer-bottom area -->
    <div class="footer-bottom-area">
      <div class="container">
        <div class="footer-border">
          <div class="row">
            <div class="col-xl-10 ">
              <div class="footer-copy-right">
                <p><!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
                  Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="fa fa-heart" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>
                  <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. --></p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</footer>
<!-- Scroll Up -->
<div id="back-top" >
  <a title="Go to Top" href="#"> <i class="fas fa-level-up-alt"></i></a>
</div>

<!-- JS here -->

<script src="./assets/js/vendor/modernizr-3.5.0.min.js"></script>
<!-- Jquery, Popper, Bootstrap -->
<script src="./assets/js/vendor/jquery-1.12.4.min.js"></script>
<script src="./assets/js/popper.min.js"></script>
<script src="./assets/js/bootstrap.min.js"></script>
<!-- Jquery Mobile Menu -->
<script src="./assets/js/jquery.slicknav.min.js"></script>

<!-- Jquery Slick , Owl-Carousel Plugins -->
<script src="./assets/js/owl.carousel.min.js"></script>
<script src="./assets/js/slick.min.js"></script>
<!-- One Page, Animated-HeadLin -->
<script src="./assets/js/wow.min.js"></script>
<script src="./assets/js/animated.headline.js"></script>
<script src="./assets/js/jquery.magnific-popup.js"></script>

<!-- Date Picker -->
<script src="./assets/js/gijgo.min.js"></script>
<!-- Nice-select, sticky -->
<script src="./assets/js/jquery.nice-select.min.js"></script>
<script src="./assets/js/jquery.sticky.js"></script>

<!-- counter , waypoint,Hover Direction -->
<script src="./assets/js/jquery.counterup.min.js"></script>
<script src="./assets/js/waypoints.min.js"></script>
<script src="./assets/js/jquery.countdown.min.js"></script>
<script src="./assets/js/hover-direction-snake.min.js"></script>

<!-- contact js -->
<script src="./assets/js/contact.js"></script>
<script src="./assets/js/jquery.form.js"></script>
<script src="./assets/js/jquery.validate.min.js"></script>
<script src="./assets/js/mail-script.js"></script>
<script src="./assets/js/jquery.ajaxchimp.min.js"></script>

<!-- Jquery Plugins, main Jquery -->
<script src="./assets/js/plugins.js"></script>
<script src="./assets/js/main.js"></script>

</body>
</html>