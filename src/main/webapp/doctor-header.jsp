<%--
  Created by IntelliJ IDEA.
  User: hung6
  Date: 24/05/2025
  Time: 7:03 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>Header</title>
  <meta name="description" content="">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">

  <!-- CSS here -->
  <link rel="stylesheet" href="assets/css/bootstrap.min.css">
  <link rel="stylesheet" href="assets/css/owl.carousel.min.css">
  <link rel="stylesheet" href="assets/css/slicknav.css">
  <link rel="stylesheet" href="assets/css/animate.min.css">
  <link rel="stylesheet" href="assets/css/magnific-popup.css">
  <link rel="stylesheet" href="assets/css/fontawesome-all.min.css">
  <link rel="stylesheet" href="assets/css/themify-icons.css">
  <link rel="stylesheet" href="assets/css/slick.css">
  <link rel="stylesheet" href="assets/css/nice-select.css">
  <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
<header>
  <!--? Header Start -->
  <div class="header-area">
    <div class="main-header header-sticky">
      <div class="container-fluid">
        <div class="row align-items-center">
          <!-- Logo -->
          <div class="col-xl-2 col-lg-2 col-md-1">
            <div class="logo">
              <a href="${pageContext.request.contextPath}/doctor-home"><img src="assets/img/logo/logo.png" alt=""></a>
            </div>
          </div>
          <div class="col-xl-10 col-lg-10 col-md-10">
            <div class="menu-main d-flex align-items-center justify-content-end">
              <!-- Main-menu -->
              <div class="main-menu f-right d-none d-lg-block">
                <nav>
                  <ul id="navigation">
                    <li><a href="${pageContext.request.contextPath}/doctor-home">Appointment</a></li>
                    <li><a href="${pageContext.request.contextPath}/create-appointment">Create An Appointment</a></li>
                    <li><a href="services.html">Schedul</a></li>
                    <li><a href="blog.html">Information</a>
                      <ul class="submenu">
                        <li><a href="blog.html">Profile</a></li>
                        <li><a href="${pageContext.request.contextPath}/completed-history">History</a></li>
                        <li><a href="elements.html">Unknown</a></li>
                      </ul>
                    </li>
                    <li><a href="contact.html">Unknown</a></li>
                  </ul>
                </nav>
              </div>
              <div class="header-right-btn f-right d-none d-lg-block ml-15">
                <a href="#" class="btn header-btn">Unknown</a>
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

<!-- Nice-select, sticky -->
<script src="./assets/js/jquery.nice-select.min.js"></script>
<script src="./assets/js/jquery.sticky.js"></script>

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