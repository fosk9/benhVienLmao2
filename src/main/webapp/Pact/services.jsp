<%--
  Created by IntelliJ IDEA.
  User: Fosk Jesky
  Date: 5/26/2025
  Time: 2:56 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html class="no-js" lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Health | Template</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="manifest" href="<c:url value='/site.webmanifest'/>">
    <link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.ico'/>">

    <!-- CSS here -->
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
</head>
<body>
<!-- Preloader Start -->
<div id="preloader-active">
    <div class="preloader d-flex align-items-center justify-content-center">
        <div class="preloader-inner position-relative">
            <div class="preloader-circle"></div>
            <div class="preloader-img pere-text">
                <img src="<c:url value='/assets/img/logo/loder.png'/>" alt="">
            </div>
        </div>
    </div>
</div>
<!-- Preloader End -->
<header>
    <!-- Header Start -->
    <div class="header-area">
        <div class="main-header header-sticky">
            <div class="container-fluid">
                <div class="row align-items-center">
                    <!-- Logo -->
                    <div class="col-xl-2 col-lg-2 col-md-1">
                        <div class="logo">
                            <a href="<c:url value='/pactHome'/>"><img src="<c:url value='/assets/img/logo/logo.png'/>" alt=""></a>
                        </div>
                    </div>
                    <div class="col-xl-10 col-lg-10 col-md-10">
                        <div class="menu-main d-flex align-items-center justify-content-end">
                            <!-- Main-menu -->
                            <div class="main-menu f-right d-none d-lg-block">
                                <nav>
                                    <ul id="navigation">
                                        <c:forEach var="item" items="${systemItems}">
                                            <c:choose>
                                                <c:when test="${item.itemName == 'Account'}">
                                                    <li>
                                                        <!-- Use an <a> tag without href to match other menu items -->
                                                        <a class="menu-item">${item.itemName}</a>
                                                        <ul class="submenu">
                                                            <!-- Filter submenu items -->
                                                            <c:forEach var="subItem" items="${systemItems}">
                                                                <c:if test="${subItem.itemName == 'My Profile' || subItem.itemName == 'Change Password' || subItem.itemName == 'Logout'}">
                                                                    <li>
                                                                        <a href="<c:url value='/${subItem.itemUrl}'/>">${subItem.itemName}</a>
                                                                    </li>
                                                                </c:if>
                                                            </c:forEach>
                                                        </ul>
                                                    </li>
                                                </c:when>
                                                <c:when test="${item.itemName != 'Logout' && item.itemName != 'My Profile' && item.itemName != 'Change Password' && item.itemName != 'Book Appointment'}">
                                                    <li>
                                                        <a href="<c:url value='/${item.itemUrl}'/>">${item.itemName}</a>
                                                    </li>
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>
                                    </ul>
                                </nav>
                            </div>
                            <div class="header-right-btn f-right d-none d-lg-block ml-15">
                                <c:forEach var="item" items="${systemItems}">
                                    <c:if test="${item.itemName == 'Book Appointment'}">
                                        <a href="<c:url value='/${item.itemUrl}'/>" class="btn header-btn">${item.itemName}</a>
                                    </c:if>
                                </c:forEach>
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
    <!-- Slider Area Start -->
    <div class="slider-area slider-area2">
        <div class="slider-active dot-style">
            <!-- Slider Single -->
            <div class="single-slider d-flex align-items-center slider-height2">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-xl-7 col-lg-8 col-md-10">
                            <div class="hero-wrapper">
                                <div class="hero__caption">
                                    <h1 data-animation="fadeInUp" data-delay=".3s">Hello ${patient.firstName}</h1>
                                    <p data-animation="fadeInUp" data-delay=".6s">Register for a health check-up to
                                        receive exclusive offers</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Slider Area End -->
    <section class="wantToWork-area">
        <div class="container">
            <div class="wants-wrapper w-padding2">
                <div class="row align-items-center justify-content-between">
                    <div class="col-xl-7 col-lg-9 col-md-8">
                        <div class="wantToWork-caption wantToWork-caption2">
                            <h2>Happy mind <br>Healthy life</h2>
                            <p>Are you experiencing any of the following issues?<br> Register early to receive offers
                            </p>
                        </div>
                    </div>
                    <div class="col-xl-2 col-lg-3 col-md-4">
                        <a href="<c:url value='appointment/list'/>" class="btn f-right sm-left">Use Services</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Services Area Start -->
    <div class="service-area">
        <div class="container">
            <div class="row">
                <div class="col-lg-4 col-md-6 col-sm-6">
                    <div class="single-cat text-center mb-50">
                        <div class="cat-icon">
                            <img src="<c:url value='/assets/img/icon/services1.svg'/>" alt="General Checkup Icon">
                        </div>
                        <div class="cat-cap">
                            <h5><a href="<c:url value='/book-appointment?type=General Checkup'/>">Comprehensive General
                                Checkup</a></h5>
                            <p>Feeling off or overdue for a health screening? Our thorough checkup assesses your overall
                                wellness to catch issues early.</p>
                            <a href="<c:url value='/book-appointment?type=General Checkup'/>" class="plus-btn"><i
                                    class="ti-plus"></i></a>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 col-sm-6">
                    <div class="single-cat text-center mb-50">
                        <div class="cat-icon">
                            <img src="<c:url value='/assets/img/icon/services2.svg'/>" alt="Mental Health Icon">
                        </div>
                        <div class="cat-cap">
                            <h5><a href="<c:url value='/book-appointment?type=Mental Health Consultation'/>">Mental
                                Health Support</a></h5>
                            <p>Struggling with stress, anxiety, or low mood? Book a consultation with our compassionate
                                mental health specialists.</p>
                            <a href="<c:url value='/book-appointment?type=Mental Health Consultation'/>"
                               class="plus-btn"><i class="ti-plus"></i></a>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 col-sm-6">
                    <div class="single-cat text-center mb-50">
                        <div class="cat-icon">
                            <img src="<c:url value='/assets/img/icon/services3.svg'/>" alt="Periodic Checkup Icon">
                        </div>
                        <div class="cat-cap">
                            <h5><a href="<c:url value='/book-appointment?type=Periodic Health Checkup'/>">Routine Health
                                Monitoring</a></h5>
                            <p>Stay proactive about your health. Schedule a periodic checkup to monitor your well-being
                                and secure peace of mind.</p>
                            <a href="<c:url value='/book-appointment?type=Periodic Health Checkup'/>"
                               class="plus-btn"><i class="ti-plus"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Services Area End -->
    <!--? Latest News Area Start -->
    <section class="latest-news-area section-padding30">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-7 col-md-9 col-sm-10">
                    <div class="section-tittle text-center mb-70">
                        <c:set var="newsTitleFound" value="false"/>
                        <c:set var="newsSubtitleFound" value="false"/>
                        <c:forEach var="content" items="${pageContents}">
                            <c:if test="${content.contentKey == 'daily_dental_updates_title' && content.active && content.contentValue != null}">
                                <c:set var="newsTitleFound" value="true"/>
                                <h2>${content.contentValue}</h2>
                            </c:if>
                            <c:if test="${content.contentKey == 'daily_dental_updates_subtitle' && content.active && content.contentValue != null}">
                                <c:set var="newsSubtitleFound" value="true"/>
                                <p>${content.contentValue}</p>
                            </c:if>
                        </c:forEach>
                        <c:if test="${!newsTitleFound}">
                            <h2>Daily Dental Updates</h2>
                        </c:if>
                        <c:if test="${!newsSubtitleFound}">
                            <p>Stay informed with the latest tips and news for a healthy smile</p>
                        </c:if>
                    </div>
                </div>
            </div>
            <div class="row">
                <c:forEach var="b" items="${recentBlogs}" varStatus="loop">
                    <div class="col-lg-4 col-md-6 col-sm-12">
                        <article class="blog_item">
                            <div class="blog_item_img">
                                <img class="card-img rounded-0"
                                     src="${pageContext.request.contextPath}/assets/img/${b.blogImg}"
                                     alt="${b.blogName}">
                                <a href="#" class="blog_item_date">
                                    <h3><fmt:formatDate value="${b.date}" pattern="dd"/></h3>
                                    <p><fmt:formatDate value="${b.date}" pattern="MMM"/></p>
                                </a>
                            </div>
                            <div class="blog_details">
                                <a class="d-inline-block"
                                   href="${pageContext.request.contextPath}/blog-detail?id=${b.blogId}">
                                    <h2 class="blog-head" style="color: #2d2d2d;">${b.blogName}</h2>
                                </a>
                                <p>${b.blogSubContent}</p>
                                <ul class="blog-info-link">
                                    <li><a href="${pageContext.request.contextPath}/blog?categoryId=${b.categoryId}"><i
                                            class="fa fa-user"></i> ${b.categoryName}</a></li>
                                    <li><a href="#"><i class="fa fa-comments"></i> ${b.commentCount} Comments</a></li>
                                </ul>
                            </div>
                        </article>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
    <!-- Latest News Area End -->
    <!-- Video Start -->
    <div class="container pt-40">
        <div class="video-area section-bg2 d-flex align-items-center"
             data-background="<c:url value='/assets/img/gallery/video-bg.png'/>">
            <div class="video-wrap position-relative">
                <div class="video-icon">
                    <a class="popup-video btn-icon" href="https://www.youtube.com/watch?v=up68UAfH0d0"><i
                            class="fas fa-play"></i></a>
                </div>
            </div>
        </div>
    </div>
    <!-- Video End -->
    <!-- Testimonial Area Start -->
    <section class="testimonial-area testimonial-padding fix pb-bottom">
        <div class="container">
            <div class="row align-items-center justify-content-center">
                <div class="col-lg-9">
                    <div class="about-caption">
                        <!-- Testimonial Start -->
                        <div class="h1-testimonial-active dot-style">
                            <!-- Single Testimonial -->
                            <div class="single-testimonial position-relative">
                                <div class="testimonial-caption">
                                    <img src="<c:url value='/assets/img/icon/quotes-sign.png'/>" alt=""
                                         class="quotes-sign">
                                    <p>"I am very satisfied with the hospital's entire process, thorough and
                                        professional."</p>
                                </div>
                                <!-- Founder -->
                                <div class="testimonial-founder d-flex align-items-center">
                                    <div class="founder-img">
                                        <img src="<c:url value='/assets/img/icon/testimonial.png'/>" alt="">
                                    </div>
                                    <div class="founder-text">
                                        <span>Nguyen Thi Mai</span>
                                        <p>Homemaker</p>
                                    </div>
                                </div>
                            </div>
                            <!-- Single Testimonial -->
                            <div class="single-testimonial position-relative">
                                <div class="testimonial-caption">
                                    <img src="<c:url value='/assets/img/icon/quotes-sign.png'/>" alt=""
                                         class="quotes-sign">
                                    <p>"I detected my illness early and received timely treatment, thanks to the team of
                                        expert doctors."</p>
                                </div>
                                <!-- Founder -->
                                <div class="testimonial-founder d-flex align-items-center">
                                    <div class="founder-img">
                                        <img src="<c:url value='/assets/img/icon/testimonial.png'/>" alt="">
                                    </div>
                                    <div class="founder-text">
                                        <span>Le Minh Quan</span>
                                        <p>IT Professional</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Testimonial End -->
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Testimonial Area End -->
    <!-- About Law Start -->
    <section class="about-low-area mt-80">
        <div class="container">
            <div class="about-cap-wrapper">
                <div class="row">
                    <div class="col-xl-5 col-lg-6 col-md-10 offset-xl-1">
                        <div class="about-caption mb-50">
                            <!-- Section Title -->
                            <div class="section-tittle mb-35">
                                <h2>100% Satisfaction Guaranteed.</h2>
                            </div>
                            <p>Over 1,000 customers visit daily and are seen immediately because they booked early</p>
                            <a href="<c:url value='/book-appointment'/>" class="border-btn">Book Appointment</a>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-12">
                        <!-- About Image -->
                        <div class="about-img">
                            <div class="about-font-img">
                                <img src="<c:url value='/assets/img/gallery/about2.png'/>" alt="">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- About Law End -->
</main>
<footer>
    <div class="footer-wrappr section-bg3" data-background="<c:url value='/assets/img/gallery/footer-bg.png'/>">
        <div class="footer-area footer-padding">
            <div class="container">
                <div class="row justify-content-between">
                    <div class="col-xl-8 col-lg-8 col-md-6 col-sm-12">
                        <div class="single-footer-caption mb-50">
                            <!-- Logo -->
                            <div class="footer-logo mb-25">
                                <a href="<c:url value='/pactHome'/>"><img
                                        src="<c:url value='/assets/img/logo/logo2_footer.png'/>" alt=""></a>
                            </div>
                            <div class="header-area">
                                <div class="main-header main-header2">
                                    <div class="menu-main d-flex align-items-center justify-content-start">
                                        <!-- Main-menu -->
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
                            <!-- Social -->
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
        <!-- Footer Bottom Area -->
        <div class="footer-bottom-area">
            <div class="container">
                <div class="footer-border">
                    <div class="row">
                        <div class="col-xl-10">
                            <div class="footer-copy-right">
                                <p>
                                    Group 3 - SE1903 - SWP391 Summer2025
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</footer>
<!-- Scroll Up -->
<div id="back-top">
    <a title="Go to Top" href="#"> <i class="fas fa-level-up-alt"></i></a>
</div>

<!-- JS here -->
<script src="<c:url value='/assets/js/vendor/modernizr-3.5.0.min.js'/>"></script>
<!-- Jquery, Popper, Bootstrap -->
<script src="<c:url value='/assets/js/vendor/jquery-1.12.4.min.js'/>"></script>
<script src="<c:url value='/assets/js/popper.min.js'/>"></script>
<script src="<c:url value='/assets/js/bootstrap.min.js'/>"></script>
<!-- Jquery Mobile Menu -->
<script src="<c:url value='/assets/js/jquery.slicknav.min.js'/>"></script>
<!-- Jquery Slick, Owl-Carousel Plugins -->
<script src="<c:url value='/assets/js/owl.carousel.min.js'/>"></script>
<script src="<c:url value='/assets/js/slick.min.js'/>"></script>
<!-- One Page, Animated-HeadLin -->
<script src="<c:url value='/assets/js/wow.min.js'/>"></script>
<script src="<c:url value='/assets/js/animated.headline.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.magnific-popup.js'/>"></script>
<!-- Date Picker -->
<script src="<c:url value='/assets/js/gijgo.min.js'/>"></script>
<!-- Nice-select, sticky -->
<script src="<c:url value='/assets/js/jquery.nice-select.min.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.sticky.js'/>"></script>
<!-- Counter, Waypoint, Hover Direction -->
<script src="<c:url value='/assets/js/jquery.counterup.min.js'/>"></script>
<script src="<c:url value='/assets/js/waypoints.min.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.countdown.min.js'/>"></script>
<script src="<c:url value='/assets/js/hover-direction-snake.min.js'/>"></script>
<!-- Contact JS -->
<script src="<c:url value='/assets/js/contact.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.form.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.validate.min.js'/>"></script>
<script src="<c:url value='/assets/js/mail-script.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.ajaxchimp.min.js'/>"></script>
<!-- Jquery Plugins, Main Jquery -->
<script src="<c:url value='/assets/js/plugins.js'/>"></script>
<script src="<c:url value='/assets/js/main.js'/>"></script>
</body>
</html>