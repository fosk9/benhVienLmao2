<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html class="no-js" lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Dental Care | Template</title>
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
    <!-- Enhanced CSS Files -->
    <link rel="stylesheet" href="assets/css/dental-specific.css">
    <link rel="stylesheet" href="assets/css/image-utilities.css">

    <style>
        /* CSS Variables */
        :root {
            --primary-color: #5AAC4E;
            --secondary-color: #234821;
            --accent-color: #6dc568;
            --text-dark: #0D210B;
            --text-light: #234821;
            --white: #ffffff;
            --light-bg: #f8fffe;
            --border-radius: 8px;
            --border-radius-large: 15px;
            --transition: all 0.3s ease;
            --shadow-light: 0 2px 10px rgba(0, 0, 0, 0.1);
            --shadow-medium: 0 4px 20px rgba(0, 0, 0, 0.15);
            --shadow-heavy: 0 8px 30px rgba(0, 0, 0, 0.2);
        }

        /* Fix slider background attachment issue */
        .slider-area {
            position: relative;
            background: linear-gradient(135deg, rgba(13, 33, 11, 0.8), rgba(90, 172, 78, 0.6)), url("assets/img/hero/h1_hero.png");
            background-size: cover;
            background-position: center;
            background-attachment: scroll; /* Changed from fixed to scroll */
            background-repeat: no-repeat;
            min-height: 100vh;
        }

        /* Enhanced section styling */
        .section-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: var(--text-dark);
        }

        .text-gradient {
            background: linear-gradient(135deg, #5aac4e 0%, #4a9142 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .section-subtitle {
            font-size: 1.1rem;
            color: #6c757d;
            max-width: 600px;
            margin: 0 auto;
        }

        /* Enhanced image utilities */
        .enhanced-image {
            position: relative;
            overflow: hidden;
            border-radius: var(--border-radius);
            transition: var(--transition);
        }

        .enhanced-image img {
            width: 100%;
            height: auto;
            transition: var(--transition);
        }

        .enhanced-image:hover img {
            transform: scale(1.05);
        }

        .image-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, rgba(90, 172, 78, 0.8), rgba(35, 72, 33, 0.8));
            opacity: 0;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
        }

        .enhanced-image:hover .image-overlay {
            opacity: 1;
        }

        .overlay-content h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            font-weight: 600;
        }

        .overlay-content p {
            font-size: 1rem;
            margin: 0;
        }

        /* Image optimization classes */
        .img-optimized {
            image-rendering: auto;
            -webkit-backface-visibility: hidden;
            backface-visibility: hidden;
            transform: translateZ(0);
        }

        .img-rounded-lg {
            border-radius: var(--border-radius-large);
        }

        .img-shadow {
            box-shadow: var(--shadow-medium);
        }

        .img-circle {
            border-radius: 50%;
        }

        .img-border {
            border: 3px solid var(--white);
        }

        /* Animation classes */
        .image-floating {
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px);
            }
            50% {
                transform: translateY(-10px);
            }
        }

        /* Feature item styling */
        .feature-item {
            padding: 8px 0;
            font-size: 0.9rem;
            color: #5a6c57;
            display: flex;
            align-items: center;
        }

        .feature-item::before {
            content: "✓";
            color: var(--primary-color);
            font-weight: bold;
            margin-right: 8px;
        }

        /* Responsive fixes */
        @media (max-width: 768px) {
            .slider-area {
                min-height: 70vh;
                background-attachment: scroll; /* Ensure scroll on mobile */
            }

            .section-title {
                font-size: 2rem;
            }

        }

        @media (max-width: 576px) {
            .slider-area {
                min-height: 60vh;
            }

            .section-title {
                font-size: 1.8rem;
            }

        }

        /* Fix for background section */
        .section-bg,
        .section-bg2,
        .section-bg3 {
            background-attachment: scroll !important; /* Override fixed attachment */
        }

        /* Performance optimizations */
        .slider-area,
        .enhanced-image,
        .image-overlay {
            will-change: transform;
            backface-visibility: hidden;
            -webkit-backface-visibility: hidden;
        }

        /* Accessibility improvements */
        .btn:focus,
        .accordion-button:focus {
            outline: 2px solid var(--primary-color);
            outline-offset: 2px;
        }

        /* Print styles */
        @media print {
            .slider-area {
                background: none !important;
                min-height: auto !important;
            }

            .image-overlay {
                display: none !important;
            }
        }

        /* Modern Video Section */
        .video-section-wrapper {
            padding: 80px 0;
            background: #f8f9fa;
        }

        .video-area-modern {
            position: relative;
            height: 400px;
            background-size: cover;
            background-position: center;
            border-radius: 20px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .video-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, rgba(90, 172, 78, 0.8), rgba(35, 72, 33, 0.8));
        }

        .video-content {
            position: relative;
            z-index: 2;
            text-align: center;
            color: white;
        }

        .video-text h3 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            font-weight: 700;
        }

        .video-text p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        .video-play-button .video-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 80px;
            height: 80px;
            background: rgba(255, 255, 255, 0.2);
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            color: white;
            font-size: 24px;
            text-decoration: none;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            position: relative;
        }

        .video-play-button .video-btn::before {
            content: '';
            position: absolute;
            top: -10px;
            left: -10px;
            right: -10px;
            bottom: -10px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            animation: pulse-ring 2s infinite;
        }

        .video-play-button .video-btn:hover {
            transform: scale(1.1);
            background: rgba(255, 255, 255, 0.3);
            border-color: rgba(255, 255, 255, 0.5);
        }

        @keyframes pulse-ring {
            0% {
                transform: scale(1);
                opacity: 1;
            }
            100% {
                transform: scale(1.3);
                opacity: 0;
            }
        }

        /* Modern Services Grid */
        .modern-services-section {
            padding: 100px 0;
            background: linear-gradient(135deg, #f8fffe 0%, #e8f5f3 100%);
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 30px;
            margin-bottom: 60px;
        }

        .service-card {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border: 1px solid rgba(90, 172, 78, 0.1);
            position: relative;
            overflow: hidden;
        }

        .service-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .service-card:hover::before {
            transform: scaleX(1);
        }

        .service-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
        }

        .service-card-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .service-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: white;
            font-size: 20px;
        }

        .service-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--text-dark);
            margin: 0;
        }

        .service-description {
            color: #666;
            line-height: 1.6;
            margin-bottom: 20px;
            font-size: 0.95rem;
        }

        .service-price {
            margin-bottom: 25px;
        }

        .price-label {
            display: block;
            font-size: 0.85rem;
            color: #999;
            margin-bottom: 5px;
        }

        .price-amount {
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--primary-color);
        }

        .service-btn {
            display: inline-flex;
            align-items: center;
            padding: 12px 24px;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .service-btn span {
            margin-right: 8px;
        }

        .service-btn i {
            transition: transform 0.3s ease;
        }

        .service-btn:hover {
            transform: translateX(4px);
            color: white;
            text-decoration: none;
        }

        .service-btn:hover i {
            transform: translateX(4px);
        }

        /* Popular Services Section */
        .popular-services-section {
            margin-top: 80px;
        }

        .popular-service-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            min-height: 280px;
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }

        .popular-service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.15);
        }

        .featured-left .popular-service-content {
            padding: 40px;
            flex: 1;
        }

        .featured-left .popular-service-image {
            flex: 1;
            height: 280px;
        }

        .featured-right {
            flex-direction: row-reverse;
        }

        .featured-right .popular-service-content {
            padding: 40px;
            flex: 1;
        }

        .featured-right .popular-service-image {
            flex: 1;
            height: 280px;
        }

        .popular-service-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .popular-badge {
            display: inline-block;
            padding: 6px 16px;
            background: linear-gradient(135deg, #ff6b6b, #ff8e8e);
            color: white;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .popular-badge.premium {
            background: linear-gradient(135deg, #ffd700, #ffed4e);
            color: #333;
        }

        .popular-service-card h3 {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 15px;
        }

        .popular-service-card p {
            color: #666;
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .popular-features {
            margin-bottom: 25px;
        }

        .feature-item {
            color: var(--primary-color);
            font-size: 0.9rem;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .popular-btn {
            display: inline-flex;
            align-items: center;
            padding: 15px 30px;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(90, 172, 78, 0.3);
        }

        .popular-btn.premium {
            background: linear-gradient(135deg, #ffd700, #ffed4e);
            color: #333;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.3);
        }

        .popular-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(90, 172, 78, 0.4);
            color: white;
            text-decoration: none;
        }

        .popular-btn.premium:hover {
            box-shadow: 0 8px 25px rgba(255, 215, 0, 0.4);
            color: #333;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .services-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .service-card {
                padding: 25px;
            }

            .popular-service-card {
                flex-direction: column !important;
                min-height: auto;
            }

            .featured-right {
                flex-direction: column !important;
            }

            .popular-service-content {
                padding: 30px !important;
            }

            .popular-service-image {
                height: 200px !important;
            }

            .video-area-modern {
                height: 300px;
            }

            .video-text h3 {
                font-size: 2rem;
            }

            .video-play-button .video-btn {
                width: 60px;
                height: 60px;
                font-size: 18px;
            }
        }

        @media (max-width: 576px) {
            .modern-services-section {
                padding: 60px 0;
            }

            .services-grid {
                margin: 0 15px;
            }

            .service-card {
                padding: 20px;
            }

            .popular-service-card h3 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
<!-- ? Preloader Start -->
<div id="preloader-active">
    <div class="preloader d-flex align-items-center justify-content-center">
        <div class="preloader-inner position-relative">
            <div class="preloader-circle"></div>
            <div class="preloader-img pere-text">
                <img src="assets/img/logo/loder.png" alt="" class="img-optimized">
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
                            <a href="index.jsp">
                                <img src="assets/img/logo/logo.png" alt="Dental Care Logo" class="img-fluid img-optimized">
                            </a>
                        </div>
                    </div>
                    <div class="col-xl-10 col-lg-10 col-md-10">
                        <div class="menu-main d-flex align-items-center justify-content-end">
                            <!-- Main-menu -->
                            <div class="main-menu f-right d-none d-lg-block">
                                <nav>
                                    <ul id="navigation">
                                        <li><a href="index.jsp">Home</a></li>
                                        <li><a href="about.html">About</a></li>
                                        <li><a href="services.html">Dental Services</a></li>
                                        <li><a href="blog.jsp">Blog</a>
                                            <ul class="submenu">
                                                <li><a href="blog.jsp">Blog</a></li>
                                                <li><a href="blog-detail.jsp">Blog Details</a></li>
                                                <li><a href="elements.html">Element</a></li>
                                            </ul>
                                        </li>
                                        <li><a href="contact.html">Contact</a></li>
                                    </ul>
                                </nav>
                            </div>
                            <div class="header-right-btn f-right d-none d-lg-block ml-15">
                                <div class="header-right-btn f-right d-none d-lg-block ml-15">
                                    <a href="login.jsp" class="btn header-btn">Login</a>
                                    <a href="register.jsp" class="btn header-btn">Register</a>
                                </div>
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
                        <div class="col-xl-7 col-lg-8 col-md-10 ">
                            <div class="hero-wrapper">
                                <!-- Video icon -->
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
                        <div class="col-xl-7 col-lg-8 col-md-10 ">
                            <div class="hero-wrapper">
                                <!-- Video icon -->
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
                                    <a href="#" class="btn" data-animation="fadeInLeft" data-delay=".3s">Book an
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
            <!-- Section Tittle -->
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
                                <img class="img-fluid img-optimized"
                                     src="${pageContext.request.contextPath}/${b.blogImg}"
                                     alt="${b.blogName}">
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
                    <!-- about-img -->
                    <div class="about-img enhanced-image">
                        <img src="assets/img/gallery/about.png"
                             alt="About Dental Care"
                             class="img-fluid img-rounded-lg img-shadow img-optimized">
                        <div class="image-overlay">
                            <div class="overlay-content">
                                <h3>Perfect Dental Care</h3>
                                <p>Professional & Caring</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-5 col-md-12">
                    <div class="about-caption">
                        <!-- Section Tittle -->
                        <div class="section-tittle mb-35">
                            <h2>Perfect Smile, Made Simple</h2>
                        </div>
                        <p class="pera-top mb-40">Experience top-notch dental care tailored to your needs</p>
                        <p class="pera-bottom mb-30">Our team of skilled dentists uses the latest technology to ensure
                            your dental health and comfort. From routine check-ups to advanced treatments, we've got you
                            covered.</p>
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
                <div class="col-lg-4 col-md-6 col-sm-6">
                    <div class="single-cat text-center mb-50">
                        <div class="cat-icon service-icon">
                            <img src="assets/img/icon/services1.svg" alt="Teeth Whitening" class="img-optimized">
                        </div>
                        <div class="cat-cap">
                            <h5><a href="book-appointment?appointmentTypeId=1">Teeth Whitening</a></h5>
                            <p>Achieve a brighter smile with our safe and effective whitening treatments.</p>
                            <a href="book-appointment?appointmentTypeId=1" class="plus-btn"><i class="ti-plus"></i></a>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 col-sm-6">
                    <div class="single-cat text-center mb-50">
                        <div class="cat-icon service-icon">
                            <img src="assets/img/icon/services2.svg" alt="Dental Checkup" class="img-optimized">
                        </div>
                        <div class="cat-cap">
                            <h5><a href="book-appointment?appointmentTypeId=1">Dental Checkup</a></h5>
                            <p>Restore your smile with durable and natural-looking dental implants.</p>
                            <a href="book-appointment?appointmentTypeId=1" class="plus-btn"><i class="ti-plus"></i></a>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 col-sm-6">
                    <div class="single-cat text-center mb-50">
                        <div class="cat-icon service-icon">
                            <img src="assets/img/icon/services3.svg" alt="Tooth Extraction" class="img-optimized">
                        </div>
                        <div class="cat-cap">
                            <h5><a href="book-appointment?appointmentTypeId=6">Tooth Extraction</a></h5>
                            <p>Straighten your teeth with our advanced braces and aligner solutions.</p>
                            <a href="book-appointment?appointmentTypeId=6" class="plus-btn"><i class="ti-plus"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Services Area End -->
    <!-- Modern Services Grid Area Start -->
    <section class="modern-services-section">
        <div class="container">
            <div class="row justify-content-center mb-5">
                <div class="col-lg-8 text-center">
                    <h2 class="section-title text-gradient">Our Dental Services</h2>
                    <p class="section-subtitle">Comprehensive dental care with modern technology and expert professionals</p>
                </div>
            </div>

            <!-- Services Grid -->
            <div class="services-grid">
                <c:forEach var="service" items="${services}" varStatus="loop">
                    <div class="service-card" data-aos="fade-up" data-aos-delay="${loop.index * 100}">
                        <div class="service-card-header">
                            <h4 class="service-title">${service.typeName}</h4>
                        </div>
                        <div class="service-card-body">
                            <p class="service-description">
                                    ${service.description != null ? service.description : 'Professional dental treatment with state-of-the-art equipment and experienced specialists.'}
                            </p>
                            <div class="service-price">
                                <span class="price-label">Starting from</span>
                                <span class="price-amount">
                                <fmt:formatNumber value="${service.price}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                            </span>
                            </div>
                        </div>
                        <div class="service-card-footer">
                            <a href="book-appointment?appointmentTypeId=${service.appointmentTypeId}" class="service-btn">
                                <span>Book Now</span>
                                <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
    <!-- Modern Services Grid Area End -->
    <!--? Testimonial Area Start -->
    <section class="testimonial-area testimonial-padding fix">
        <div class="container">
            <div class="row align-items-center justify-content-center">
                <div class=" col-lg-9">
                    <div class="about-caption">
                        <!-- Testimonial Start -->
                        <div class="h1-testimonial-active dot-style">
                            <!-- Single Testimonial -->
                            <div class="single-testimonial position-relative">
                                <div class="testimonial-caption">
                                    <img src="assets/img/icon/quotes-sign.png" alt="Quote" class="quotes-sign img-optimized">
                                    <p>"The dental care I received was exceptional. My smile has never looked better,
                                        and the process was so comfortable!"</p>
                                </div>
                                <!-- founder -->
                                <div class="testimonial-founder d-flex align-items-center">
                                    <div class="founder-img enhanced-image">
                                        <img src="assets/img/icon/testimonial.png"
                                             alt="Jane Smith"
                                             class="img-circle img-border img-shadow img-optimized">
                                    </div>
                                    <div class="founder-text">
                                        <span>Jane Smith</span>
                                        <p>Happy Patient</p>
                                    </div>
                                </div>
                            </div>
                            <!-- Single Testimonial -->
                            <div class="single-testimonial position-relative">
                                <div class="testimonial-caption">
                                    <img src="assets/img/icon/quotes-sign.png" alt="Quote" class="quotes-sign img-optimized">
                                    <p>"From consultation to treatment, the team was professional and caring. Highly
                                        recommend their services!"</p>
                                </div>
                                <!-- founder -->
                                <div class="testimonial-founder d-flex align-items-center">
                                    <div class="founder-img enhanced-image">
                                        <img src="assets/img/icon/testimonial.png"
                                             alt="John Doe"
                                             class="img-circle img-border img-shadow img-optimized">
                                    </div>
                                    <div class="founder-text">
                                        <span>John Doe</span>
                                        <p>Satisfied Client</p>
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
    <!--? Testimonial Area End -->
    <!--? video_start -->
    <div class="video-section-wrapper">
        <div class="container">
            <div class="video-area-modern" style="background-image: url('assets/img/gallery/video-bg.png');">
                <div class="video-overlay"></div>
                <div class="video-content">
                    <div class="video-text">
                        <h3>Watch Our Story</h3>
                        <p>Discover Our Dental Excellence</p>
                    </div>
                    <div class="video-play-button">
                        <a class="popup-video video-btn" href="https://www.youtube.com/watch?v=up68UAfH0d0" data-effect="mfp-zoom-in">
                            <i class="fas fa-play"></i>
                        </a>
                    </div>
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
                            <!-- Section Tittle -->
                            <div class="section-tittle mb-35">
                                <h2>100% Satisfaction Guaranteed</h2>
                            </div>
                            <p>Your perfect smile is our priority</p>
                            <a href="about.html" class="border-btn">Book a Dental Appointment</a>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-12">
                        <!-- about-img -->
                        <div class="about-img enhanced-image">
                            <div class="about-font-img">
                                <img src="assets/img/gallery/about2.png"
                                     alt="Dental Satisfaction"
                                     class="img-fluid img-rounded-lg img-shadow img-optimized image-floating">
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
                            <!-- logo -->
                            <div class="footer-logo mb-25">
                                <a href="index.jsp">
                                    <img src="assets/img/logo/logo2_footer.png"
                                         alt="Dental Care Footer Logo"
                                         class="img-fluid img-optimized">
                                </a>
                            </div>
                            <div class="header-area">
                                <div class="main-header main-header2">
                                    <div class="menu-main d-flex align-items-center justify-content-start">
                                        <!-- Main-menu -->
                                        <div class="main-menu main-menu2">
                                            <nav>
                                                <ul>
                                                    <li><a href="index.jsp">Home</a></li>
                                                    <li><a href="about.html">About</a></li>
                                                    <li><a href="services.html">Dental Services</a></li>
                                                    <li><a href="blog.jsp">Blog</a></li>
                                                    <li><a href="contact.html">Contact</a></li>
                                                </ul>
                                            </nav>
                                        </div>
                                    </div>
                                </div>
                            </div>
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
                                <h4>Subscribe to Our Newsletter</h4>
                            </div>
                            <!-- Form -->
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
        <!-- footer-bottom area -->
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
