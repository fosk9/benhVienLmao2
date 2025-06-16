<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html class="no-js" lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Dental Care | benhVienLmao</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="manifest" href="site.webmanifest">
    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">
    <!-- CSS here -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
                            <a href="index.jsp"><img src="assets/img/logo/logo.png" alt=""></a>
                        </div>
                    </div>
                    <div class="col-xl-10 col-lg-10 col-md-10">
                        <div class="menu-main d-flex align-items-center justify-content-end">
                            <!-- Main-menu -->
                            <div class="main-menu f-right d-none d-lg-block">
                                <nav>
                                    <ul id="navigation">
                                        <c:forEach var="nav" items="${navItems}">
                                            <li>
                                                <a href="${nav.itemUrl}">${nav.itemName}</a>
                                                <c:if test="${not empty nav.subItems}">
                                                    <ul class="submenu">
                                                        <c:forEach var="subNav" items="${nav.subItems}">
                                                            <li><a href="${subNav.itemUrl}">${subNav.itemName}</a></li>
                                                        </c:forEach>
                                                    </ul>
                                                </c:if>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </nav>
                            </div>
                            <div class="header-right-btn f-right d-none d-lg-block ml-15">
                                <a href="login.jsp" class="btn header-btn">Login</a>
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
    <!--? Slider Area Start-->
    <div class="slider-area">
        <div class="slider-active dot-style">
            <!-- Slider Single -->
            <div class="single-slider d-flex align-items-center slider-height">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-xl-7 col-lg-8 col-md-10">
                            <div class="hero-wrapper">
                                <div class="video-icon">
                                    <a class="popup-video btn-icon" href="https://www.youtube.com/watch?v=up68UAfH0d0"
                                       data-animation="bounceIn" data-delay=".4s">
                                        <i class="fas fa-play"></i>
                                    </a>
                                </div>
                                <div class="hero__caption">
                                    <h1 data-animation="fadeInUp" data-delay=".3s">Smile with Confidence</h1>
                                    <p data-animation="fadeInUp" data-delay=".6s">Transform your smile with our expert
                                        dental care services</p>
                                    <a href="book-appointment" class="btn" data-animation="fadeInLeft" data-delay=".3s">Explore
                                        Dental Services</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Slider Single -->
            <div class="single-slider d-flex align-items-center slider-height">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-xl-7 col-lg-8 col-md-10">
                            <div class="hero-wrapper">
                                <div class="video-icon">
                                    <a class="popup-video btn-icon" href="https://www.youtube.com/watch?v=up68UAfH0d0"
                                       data-animation="bounceIn" data-delay=".4s">
                                        <i class="fas fa-play"></i>
                                    </a>
                                </div>
                                <div class="hero__caption">
                                    <h1 data-animation="fadeInUp" data-delay=".3s">Healthy Teeth, Happy Life</h1>
                                    <p data-animation="fadeInUp" data-delay=".6s">Comprehensive dental solutions for all
                                        ages</p>
                                    <a href="book-appointment" class="btn" data-animation="fadeInLeft" data-delay=".3s">Book an
                                        Appointment</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Slider Area End -->
    <!--? Latest News Area Start -->
    <section class="latest-news-area section-padding30">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-7 col-md-9 col-sm-10">
                    <div class="section-tittle text-center mb-70">
                        <h2>Daily Dental Updates</h2>
                        <p>Stay informed with the latest tips and news for a healthy smile</p>
                    </div>
                </div>
            </div>
            <div class="row">
                <c:forEach var="b" items="${recentBlogs}" varStatus="loop">
                    <div class="col-lg-4 col-md-6 col-sm-12">
                        <article class="blog_item">
                            <div class="blog_item_img">
                                <img class="card-img rounded-0" src="assets/img/${b.blogImg}" alt="${b.blogName}">
                                <a href="#" class="blog_item_date">
                                    <h3><fmt:formatDate value="${b.date}" pattern="dd"/></h3>
                                    <p><fmt:formatDate value="${b.date}" pattern="MMM"/></p>
                                </a>
                            </div>
                            <div class="blog_details">
                                <a class="d-inline-block" href="blog-detail?id=${b.blogId}">
                                    <h2 class="blog-head" style="color: #2d2d2d;">${b.blogName}</h2>
                                </a>
                                <p>${b.blogSubContent}</p>
                                <ul class="blog-info-link">
                                    <li><a href="blog?categoryId=${b.categoryId}"><i
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
    <!--? About-2 Area Start -->
    <div class="about-area2 section-padding40">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-7 col-md-12">
                    <div class="about-img">
                        <img src="assets/img/gallery/about.png" alt="">
                    </div>
                </div>
                <div class="col-lg-5 col-md-12">
                    <div class="about-caption">
                        <div class="section-tittle mb-35">
                            <h2>Perfect Smile, Made Simple</h2>
                        </div>
                        <p class="pera-top mb-40">Experience top-notch dental care tailored to your needs</p>
                        <p class="pera-bottom mb-30">Our team of skilled dentists uses the latest technology to ensure
                            your dental health and comfort. From routine check-ups to advanced treatments, we’ve got you
                            covered.</p>
                        <div class="icon-about">
                            <img src="assets/img/icon/about1.svg" alt="" class="mr-20">
                            <img src="assets/img/icon/about2.svg" alt="">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- About-2 Area End -->
    <section class="wantToWork-area section-bg3" data-background="assets/img/gallery/section_bg01.png">
        <div class="container">
            <div class="wants-wrapper w-padding2">
                <div class="row align-items-center justify-content-between">
                    <div class="col-xl-7 col-lg-9 col-md-8">
                        <div class="wantToWork-caption wantToWork-caption2">
                            <h2>Bright Smile <br>Healthy Teeth</h2>
                            <p>Discover personalized dental care that makes you smile</p>
                        </div>
                    </div>
                    <div class="col-xl-2 col-lg-3 col-md-4">
                        <a href="book-appointment" class="btn f-right sm-left">Explore Services</a>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!--? Services Area Start -->
    <div class="service-area">
        <div class="container">
            <div class="row">
                <c:forEach var="feature" items="${featureItems}" varStatus="loop">
                    <c:if test="${feature.isActive}">
                        <div class="col-lg-4 col-md-6 col-sm-6">
                            <div class="single-cat text-center mb-50">
                                <div class="cat-icon">
                                    <img src="${feature.imageUrl}" alt="${feature.itemName}">
                                </div>
                                <div class="cat-cap">
                                    <h5><a href="${feature.itemUrl}">${feature.itemName}</a></h5>
                                    <p>Explore our ${feature.itemName} services for a healthier smile.</p>
                                    <a href="${feature.itemUrl}" class="plus-btn"><i class="ti-plus"></i></a>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </div>
    <!-- Services Area End -->
    <!--? Services List Area Start -->
    <div class="accordion compact-accordion" id="servicesAccordion">
        <c:forEach var="service" items="${services}" varStatus="loop">
            <div class="accordion-item">
                <h2 class="accordion-header" id="heading-${service.appointmentTypeId}">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapse-${service.appointmentTypeId}" aria-expanded="false"
                            aria-controls="collapse-${service.appointmentTypeId}">
                            ${service.typeName}
                    </button>
                </h2>
                <div id="collapse-${service.appointmentTypeId}" class="accordion-collapse collapse"
                     aria-labelledby="heading-${service.appointmentTypeId}" data-bs-parent="#servicesAccordion">
                    <div class="accordion-body">
                        <p class="service-description">${service.description != null ? service.description : 'No description available.'}</p>
                        <p class="service-price">
                            <strong>Price:</strong>
                            <fmt:formatNumber value="${service.price}" type="currency" currencyCode="VND"
                                              maxFractionDigits="0"/>
                        </p>
                        <a href="book-appointment?appointmentTypeId=${service.appointmentTypeId}"
                           class="btn btn-sm btn-outline-success">
                            Book Now
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    <!-- Services List Area End -->
    <!--? Testimonial Area Start -->
    <section class="testimonial-area testimonial-padding fix">
        <div class="container">
            <div class="row align-items-center justify-content-center">
                <div class="col-lg-9">
                    <div class="about-caption">
                        <div class="h1-testimonial-active dot-style">
                            <div class="single-testimonial position-relative">
                                <div class="testimonial-caption">
                                    <img src="assets/img/icon/quotes-sign.png" alt="" class="quotes-sign">
                                    <p>"The dental care I received was exceptional. My smile has never looked better,
                                        and the process was so comfortable!"</p>
                                </div>
                                <div class="testimonial-founder d-flex align-items-center">
                                    <div class="founder-img">
                                        <img src="assets/img/icon/testimonial.png" alt="">
                                    </div>
                                    <div class="founder-text">
                                        <span>Jane Smith</span>
                                        <p>Happy Patient</p>
                                    </div>
                                </div>
                            </div>
                            <div class="single-testimonial position-relative">
                                <div class="testimonial-caption">
                                    <img src="assets/img/icon/quotes-sign.png" alt="" class="quotes-sign">
                                    <p>"From consultation to treatment, the team was professional and caring. Highly
                                        recommend their services!"</p>
                                </div>
                                <div class="testimonial-founder d-flex align-items-center">
                                    <div class="founder-img">
                                        <img src="assets/img/icon/testimonial.png" alt="">
                                    </div>
                                    <div class="founder-text">
                                        <span>John Doe</span>
                                        <p>Satisfied Client</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!--? Testimonial Area End -->
    <!--? video_start -->
    <div class="container">
        <div class="video-area section-bg2 d-flex align-items-center" data-background="assets/img/gallery/video-bg.png">
            <div class="video-wrap position-relative">
                <div class="video-icon">
                    <a class="popup-video btn-icon" href="https://www.youtube.com/watch?v=up68UAfH0d0"><i
                            class="fas fa-play"></i></a>
                </div>
            </div>
        </div>
    </div>
    <!-- video_end -->
    <!--? About Law Start-->
    <section class="about-low-area mt-30">
        <div class="container">
            <div class="about-cap-wrapper">
                <div class="row">
                    <div class="col-xl-5 col-lg-6 col-md-10 offset-xl-1">
                        <div class="about-caption mb-50">
                            <div class="section-tittle mb-35">
                                <h2>100% Satisfaction Guaranteed</h2>
                            </div>
                            <p>Your perfect smile is our priority</p>
                            <a href="book-appointment" class="border-btn">Book a Dental Appointment</a>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-12">
                        <div class="about-img">
                            <div class="about-font-img">
                                <img src="assets/img/gallery/about2.png" alt="">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- About Law End-->
</main>
<footer>
    <div class="footer-wrappr section-bg3" data-background="assets/img/gallery/footer-bg.png">
        <div class="footer-area footer-padding">
            <div class="container">
                <div class="row justify-content-between">
                    <div class="col-xl-8 col-lg-8 col-md-6 col-sm-12">
                        <div class="single-footer-caption mb-50">
                            <div class="footer-logo mb-25">
                                <a href="index.jsp"><img src="assets/img/logo/logo2_footer.png" alt=""></a>
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
                    <div class="col-xl-4 col-lg-4 col-md-6 col-sm-12">
                        <div class="single-footer-caption">
                            <div class="footer-tittle mb-50">
                                <h4>Subscribe to Our Newsletter</h4>
                            </div>
                            <div class="footer-form">
                                <div id="mc_embed_signup">
                                    <form target="_blank"
                                          action="https://spondonit.us12.list-manage.com/subscribe/post?u=1462626880ade1ac87bd9c93a&id=92a4423d01"
                                          method="get" class="subscribe_form relative mail_part" novalidate="true">
                                        <input type="email" name="EMAIL" id="newsletter-form-email"
                                               placeholder="Email Address" class="placeholder hide-on-focus"
                                               onfocus="this.placeholder = ''"
                                               onblur="this.placeholder = 'Enter your email'">
                                        <div class="form-icon">
                                            <button type="submit" name="submit" id="newsletter-submit"
                                                    class="email_icon newsletter-submit button-contactForm">
                                                Subscribe
                                            </button>
                                        </div>
                                        <div class="mt-10 info"></div>
                                    </form>
                                </div>
                            </div>
                            <div class="footer-tittle">
                                <div class="footer-pera">
                                    <p>Stay updated with the latest dental care tips and promotions.</p>
                                </div>
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
                                    All rights reserved | This template is made with <i class="fa fa-heart"
                                                                                        aria-hidden="true"></i> by <a
                                            href="https://colorlib.com" target="_blank">Colorlib</a></p>
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
<script src="./assets/js/vendor/modernizr-3.5.0.min.js"></script>
<script src="./assets/js/vendor/jquery-1.12.4.min.js"></script>
<script src="./assets/js/popper.min.js"></script>
<script src="./assets/js/bootstrap.min.js"></script>
<script src="./assets/js/jquery.slicknav.min.js"></script>
<script src="./assets/js/owl.carousel.min.js"></script>
<script src="./assets/js/slick.min.js"></script>
<script src="./assets/js/wow.min.js"></script>
<script src="./assets/js/animated.headline.js"></script>
<script src="./assets/js/jquery.magnific-popup.js"></script>
<script src="./assets/js/gijgo.min.js"></script>
<script src="./assets/js/jquery.nice-select.min.js"></script>
<script src="./assets/js/jquery.sticky.js"></script>
<script src="./assets/js/jquery.counterup.min.js"></script>
<script src="./assets/js/waypoints.min.js"></script>
<script src="./assets/js/jquery.countdown.min.js"></script>
<script src="./assets/js/hover-direction-snake.min.js"></script>
<script src="./assets/js/contact.js"></script>
<script src="./assets/js/jquery.form.js"></script>
<script src="./assets/js/jquery.validate.min.js"></script>
<script src="./assets/js/mail-script.js"></script>
<script src="./assets/js/jquery.ajaxchimp.min.js"></script>
<script src="./assets/js/plugins.js"></script>
<script src="./assets/js/main.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>