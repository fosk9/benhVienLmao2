<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html class="no-js" lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>Appointment Types - benhVienLmao</title>
  <meta name="description" content="View all available appointment types and book a consultation.">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="manifest" href="site.webmanifest">
  <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">
  <!-- CSS here -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
    /* Consistent font with index.jsp */
    body, .accordion, .btn, .service-content {
      font-family: "Segoe UI", sans-serif;
    }
    /* Enhanced page heading */
    h1 {
      font-size: 3.8rem; /* Increased for prominence */
      font-weight: 700;
      text-align: center;
      margin-bottom: 20px;
      color: #28a745; /* Green theme */
    }
    /* Subheading for context */
    .section-subheading {
      font-size: 1.8rem; /* Increased size */
      text-align: center;
      margin-bottom: 40px;
      color: #333;
    }
    /* Search container */
    .search-container {
      max-width: 800px;
      margin: 0 auto 30px auto;
      display: flex;
      align-items: center;
    }
    .search-input {
      width: 100%;
      padding: 12px;
      font-size: 1.2rem; /* Increased size */
      border: 1px solid #28a745;
      border-radius: 5px;
    }
    /* Accordion styling matching index.jsp */
    .accordion.compact-accordion {
      max-width: 800px;
      margin: 0 auto;
      border-radius: 12px;
      overflow: hidden;
    }
    .accordion-item {
      border-bottom: 1px solid #28a745;
    }
    .accordion-item:last-child {
      border-bottom: none;
    }
    .accordion-button {
      font-size: 2rem; /* Increased for prominence */
      color: #28a745;
      background-color: #f1f8f1; /* Light green background */
      padding: 18px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .accordion-button:not(.collapsed) {
      color: #218838; /* Darker green when expanded */
      background-color: #ffffff;
    }
    .accordion-button:focus {
      box-shadow: none;
      border-color: #28a745;
    }
    .service-type-price {
      font-size: 2rem; /* Matches accordion-button size */
      color: #28a745;
    }
    .accordion-body {
      padding: 25px;
      background-color: #ffffff;
    }
    .service-description {
      font-size: 1.4rem; /* Increased size */
      color: #333;
      margin-bottom: 20px;
    }
    .btn-outline-success {
      font-size: 1.4rem; /* Increased size */
      padding: 12px 25px;
      border-color: #28a745;
      color: #28a745;
    }
    .btn-outline-success:hover {
      background-color: #28a745;
      color: #fff;
    }
    /* Error message styling */
    .error-message {
      color: #dc3545;
      font-size: 1.4rem; /* Increased size */
      text-align: center;
      margin-bottom: 20px;
    }
    /* Responsive adjustments */
    @media (max-width: 768px) {
      h1 {
        font-size: 3rem;
      }
      .section-subheading {
        font-size: 1.4rem;
      }
      .search-input {
        font-size: 1rem;
        padding: 10px;
      }
      .accordion-button, .service-type-price {
        font-size: 1.6rem; /* Slightly smaller on mobile */
        padding: 14px;
      }
      .service-description {
        font-size: 1.2rem;
      }
      .btn-outline-success {
        font-size: 1.2rem;
        padding: 10px 20px;
      }
      .error-message {
        font-size: 1.2rem;
      }
    }
  </style>
</head>
<body>
<!-- Preloader Start -->
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
<!-- Preloader End -->
<jsp:include page="header.jsp"/>
<%--<header>--%>
<%--  <!-- Header Start -->--%>
<%--  <div class="header-area">--%>
<%--    <div class="main-header header-sticky">--%>
<%--      <div class="container-fluid">--%>
<%--        <div class="row align-items-center">--%>
<%--          <div class="col-xl-2 col-lg-2 col-md-1">--%>
<%--            <div class="logo">--%>
<%--              <a href="<c:url value='/pactHome'/>"><img src="assets/img/logo/logo.png" alt=""></a>--%>
<%--            </div>--%>
<%--          </div>--%>
<%--          <div class="col-xl-10 col-lg-10 col-md-10">--%>
<%--            <div class="menu-main d-flex align-items-center justify-content-end">--%>
<%--              <div class="main-menu f-right d-none d-lg-block">--%>
<%--                <nav>--%>
<%--                  <ul id="navigation">--%>
<%--                    <c:forEach var="nav" items="${navItems}">--%>
<%--                      <li>--%>
<%--                        <a href="${nav.itemUrl}">${nav.itemName}</a>--%>
<%--                        <c:if test="${not empty nav.subItems}">--%>
<%--                          <ul class="submenu">--%>
<%--                            <c:forEach var="subNav" items="${nav.subItems}">--%>
<%--                              <li><a href="${subNav.itemUrl}">${subNav.itemName}</a></li>--%>
<%--                            </c:forEach>--%>
<%--                          </ul>--%>
<%--                        </c:if>--%>
<%--                      </li>--%>
<%--                    </c:forEach>--%>
<%--                    <c:if test="${sessionScope.patientId != null}">--%>
<%--                      <li><a href="<c:url value='/appointments'/>">My Appointments</a></li>--%>
<%--                      <li><a href="<c:url value='/logout'/>">Logout</a></li>--%>
<%--                    </c:if>--%>
<%--                    <c:if test="${sessionScope.patientId == null}">--%>
<%--                      <li><a href="<c:url value='/login'/>">Login</a></li>--%>
<%--                      <li><a href="<c:url value='/register'/>">Register</a></li>--%>
<%--                    </c:if>--%>
<%--                  </ul>--%>
<%--                </nav>--%>
<%--              </div>--%>
<%--              <div class="header-right-btn f-right d-none d-lg-block ml-15">--%>
<%--                <a href="<c:url value='/book-appointment'/>" class="btn header-btn">Book Appointment</a>--%>
<%--              </div>--%>
<%--            </div>--%>
<%--          </div>--%>
<%--          <div class="col-12">--%>
<%--            <div class="mobile_menu d-block d-lg-none"></div>--%>
<%--          </div>--%>
<%--        </div>--%>
<%--      </div>--%>
<%--    </div>--%>
<%--  </div>--%>
<%--  <!-- Header End -->--%>
<%--</header>--%>
<main>
  <!-- Page Content Start -->
  <section class="services-list-area section-padding">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-lg-7 col-md-9 col-sm-10">
          <div class="section-tittle text-center mb-30">
            <h1>Explore Our Appointment Types</h1>
            <p class="section-subheading">Find the perfect consultation or appointment service tailored to your needs</p>
          </div>
        </div>
      </div>
      <!-- Search Control -->
      <div class="search-container">
        <input type="text" id="searchInput" class="search-input" placeholder="Search by name...">
      </div>
      <!-- Display error message if no appointment types found -->
      <c:if test="${empty appointmentTypes}">
        <div class="error-message">No appointment types available at this time. Please check back later.</div>
      </c:if>
      <!-- Services List Area Start -->
      <div class="accordion compact-accordion" id="servicesAccordion">
        <c:forEach var="service" items="${appointmentTypes}" varStatus="loop">
          <div class="accordion-item" data-name="${service.typeName.toLowerCase()}">
            <h2 class="accordion-header" id="heading-${service.appointmentTypeId}">
              <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                      data-bs-target="#collapse-${service.appointmentTypeId}" aria-expanded="false"
                      aria-controls="collapse-${service.appointmentTypeId}">
                <span class="service-type-price">
                  ${service.typeName} - <fmt:formatNumber value="${service.price}" type="number" groupingUsed="true"/>đ
                </span>
              </button>
            </h2>
            <div id="collapse-${service.appointmentTypeId}" class="accordion-collapse collapse"
                 aria-labelledby="heading-${service.appointmentTypeId}" data-bs-parent="#servicesAccordion">
              <div class="accordion-body">
                <p class="service-description">${service.description != null ? service.description : 'No description available.'}</p>
                <a href="/benhVienLmao_war_exploded/book-appointment?appointmentTypeId=${service.appointmentTypeId}"
                   class="btn btn-sm btn-outline-success">
                  Book Now
                </a>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
      <!-- Services List Area End -->
    </div>
  </section>
  <!-- Page Content End -->
</main>
<!-- Footer Start -->
<footer>
  <div class="footer-wrappr section-bg3" data-background="assets/img/gallery/footer-bg.png">
    <div class="footer-area footer-padding">
      <div class="container">
        <div class="row justify-content-between">
          <div class="col-xl-8 col-lg-8 col-md-6 col-sm-12">
            <div class="single-footer-caption mb-50">
              <div class="footer-logo mb-25">
                <a href="<c:url value='/index'/>"><img src="assets/img/logo/logo2_footer.png" alt=""></a>
              </div>
              <div class="header-area">
                <div class="main-header main-header2">
                  <div class="menu-main d-flex align-items-center justify-content-start">
                    <div class="main-menu main-menu2">
                      <nav>
                        <ul>
                          <c:forEach var="nav" items="${navItems}">
                            <li><a href="${nav.itemUrl}">${nav.itemName}</a></li>
                          </c:forEach>
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
                <p>Copyright ©
                  <script>document.write(new Date().getFullYear());</script>
                  All rights reserved | Group 3 - SE1903 - SWP391 Summer2025
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</footer>
<!-- Footer End -->
<div id="back-top">
  <a title="Go to Top" href="#"> <i class="fas fa-level-up-alt"></i></a>
</div>
<!-- JS here -->
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Client-side search with whitespace normalization
  document.addEventListener('DOMContentLoaded', function () {
    const searchInput = document.getElementById('searchInput');
    const accordion = document.getElementById('servicesAccordion');
    const items = Array.from(accordion.getElementsByClassName('accordion-item'));

    // Search on input with whitespace normalization
    searchInput.addEventListener('input', function () {
      // Normalize whitespace: trim and replace multiple spaces with single space
      const query = searchInput.value.trim().replace(/\s+/g, ' ').toLowerCase();
      items.forEach(item => {
        const name = item.dataset.name;
        const matches = name.includes(query);
        item.style.display = matches ? '' : 'none';
      });
    });
  });
</script>
<script src="${pageContext.request.contextPath}/assets/js/header.js"></script>
</body>
</html>