<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html class="no-js" lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>
        <c:choose>
            <c:when test="${not empty pageContents}">
                <c:set var="siteTitleFound" value="false"/>
                <c:forEach var="content" items="${pageContents}">
                    <c:if test="${content.contentKey == 'site_title' && content.active && content.contentValue != null}">
                        <c:set var="siteTitleFound" value="true"/>
                        ${content.contentValue}
                    </c:if>
                </c:forEach>
                <c:if test="${!siteTitleFound}">
                    Dental Care | benhVienLmao
                </c:if>
            </c:when>
            <c:otherwise>
                Dental Care | benhVienLmao
            </c:otherwise>
        </c:choose>
    </title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="manifest" href="${pageContext.request.contextPath}/site.webmanifest">
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/favicon.ico">
    <!-- CSS here -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/slicknav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/flaticon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/gijgo.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animate.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animated-headline.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/magnific-popup.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fontawesome-all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/themify-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/slick.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nice-select.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/chatbot.css"/>

</head>
<body>
<!-- ? Preloader Start -->
<div id="preloader-active">
    <div class="preloader d-flex align-items-center justify-content-center">
        <div class="preloader-inner position-relative">
            <div class="preloader-circle"></div>
            <div class="preloader-img pere-text">
                <c:choose>
                    <c:when test="${not empty pageContents}">
                        <c:set var="preloaderFound" value="false"/>
                        <c:forEach var="content" items="${pageContents}">
                            <c:if test="${content.contentKey == 'preloader_image' && content.active && content.imageUrl != null}">
                                <c:set var="preloaderFound" value="true"/>
                                <img src="${pageContext.request.contextPath}/${content.imageUrl}" alt="">
                            </c:if>
                        </c:forEach>
                        <c:if test="${!preloaderFound}">
                            <img src="${pageContext.request.contextPath}/assets/img/logo/loder.png" alt="">
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/assets/img/logo/loder.png" alt="">
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>
<!-- Preloader Start -->
<header>
    <!-- Header Start -->
    <div class="header-area">
        <div class="main-header header-sticky">
            <div class="container-fluid">
                <div class="row align-items-center">
                    <!-- Logo -->
                    <div class="col-xl-2 col-lg-2 col-md-1">
                        <div class="logo">
                            <a href="<c:url value='/index'/>">
                                <img src="<c:url value='/assets/img/logo/logo.png'/>" alt="">
                            </a>
                        </div>
                    </div>
                    <!-- Navigation -->
                    <div class="col-xl-10 col-lg-10 col-md-10">
                        <div class="menu-main d-flex align-items-center justify-content-end">
                            <!-- Main-menu -->
                            <div class="main-menu f-right d-none d-lg-block">
                                <nav>
                                    <ul id="navigation">
                                        <!-- Loop through navigation items -->
                                        <c:forEach var="item" items="${systemItems}">
                                            <li>
                                                <a href="<c:url value='/${item.itemUrl}'/>">${item.itemName}</a>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </nav>
                            </div>
                            <!-- Login/Register buttons -->
                            <div class="header-right-btn f-right d-none d-lg-block ml-15">
                                <a href="<c:url value='/login.jsp'/>" class="btn header-btn">Login</a>
                                <a href="<c:url value='/register.jsp'/>" class="btn header-btn">Register</a>
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
    <c:if test="${not empty error}">
        <div class="container mt-3">
            <div class="alert alert-danger">${error}</div>
        </div>
    </c:if>

    <!--? Slider Area Start-->
    <div class="slider-area">
        <div class="slider-active dot-style">
            <c:choose>
                <c:when test="${empty pageContents}">
                    <div class="single-slider d-flex align-items-center slider-height">
                        <div class="container">
                            <div class="row align-items-center">
                                <div class="col-xl-7 col-lg-8 col-md-10">
                                    <div class="hero-wrapper">
                                        <div class="video-icon">
                                            <a class="popup-video btn-icon"
                                               href="https://www.youtube.com/watch?v=up68UAfH0d0"
                                               data-animation="bounceIn" data-delay=".4s">
                                                <i class="fas fa-play"></i>
                                            </a>
                                        </div>
                                        <div class="hero__caption">
                                            <h1 data-animation="fadeInUp" data-delay=".3s">No Slider Content</h1>
                                            <p data-animation="fadeInUp" data-delay=".6s">Contact admin to add slider
                                                content.</p>
                                            <a href="${pageContext.request.contextPath}/book-appointment" class="btn"
                                               data-animation="fadeInLeft" data-delay=".3s">Book an Appointment</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:set var="hasSlider" value="false"/>
                    <c:forEach var="content" items="${pageContents}" varStatus="loop">
                        <c:catch var="exception">
                            <c:if test="${not empty content.pageName && content.pageName == 'index' && not empty content.contentKey && fn:startsWith(content.contentKey, 'slider') && content.active}">
                                <c:set var="hasSlider" value="true"/>
                                <div class="single-slider d-flex align-items-center slider-height"
                                        <c:if test="${content.imageUrl != null}">
                                            style="background-image: url('${pageContext.request.contextPath}/${content.imageUrl}'); background-size: cover;"
                                        </c:if>>
                                    <div class="container">
                                        <div class="row align-items-center">
                                            <div class="col-xl-7 col-lg-8 col-md-10">
                                                <div class="hero-wrapper">
                                                    <div class="video-icon">
                                                        <a class="popup-video btn-icon"
                                                           href="${content.videoUrl != null ? content.videoUrl : 'https://www.youtube.com/watch?v=up68UAfH0d0'}"
                                                           data-animation="bounceIn" data-delay=".4s">
                                                            <i class="fas fa-play"></i>
                                                        </a>
                                                    </div>
                                                    <div class="hero__caption">
                                                        <c:if test="${content.contentKey == 'slider1_caption' || content.contentKey == 'slider2_caption'}">
                                                            <h1 data-animation="fadeInUp"
                                                                data-delay=".3s">${content.contentValue != null ? content.contentValue : 'No Caption'}</h1>
                                                        </c:if>
                                                        <c:if test="${content.contentKey == 'slider1_subcaption' || content.contentKey == 'slider2_subcaption'}">
                                                            <p data-animation="fadeInUp"
                                                               data-delay=".6s">${content.contentValue != null ? content.contentValue : 'No Subcaption'}</p>
                                                        </c:if>
                                                        <c:if test="${content.buttonUrl != null && content.buttonText != null}">
                                                            <a href="${pageContext.request.contextPath}/${content.buttonUrl}"
                                                               class="btn" data-animation="fadeInLeft"
                                                               data-delay=".3s">${content.buttonText}</a>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:catch>
                        <c:if test="${not empty exception}">
                            <div class="alert alert-warning">Error processing content: ${exception.message}</div>
                        </c:if>
                    </c:forEach>
                    <c:if test="${!hasSlider}">
                        <div class="single-slider d-flex align-items-center slider-height">
                            <div class="container">
                                <div class="row align-items-center">
                                    <div class="col-xl-7 col-lg-8 col-md-10">
                                        <div class="hero-wrapper">
                                            <div class="video-icon">
                                                <a class="popup-video btn-icon"
                                                   href="https://www.youtube.com/watch?v=up68UAfH0d0"
                                                   data-animation="bounceIn" data-delay=".4s">
                                                    <i class="fas fa-play"></i>
                                                </a>
                                            </div>
                                            <div class="hero__caption">
                                                <h1 data-animation="fadeInUp" data-delay=".3s">No Slider Content</h1>
                                                <p data-animation="fadeInUp" data-delay=".6s">Contact admin to add
                                                    slider content.</p>
                                                <a href="${pageContext.request.contextPath}/book-appointment"
                                                   class="btn" data-animation="fadeInLeft" data-delay=".3s">Book an
                                                    Appointment</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <!-- Slider Area End -->

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
                                     src="${pageContext.request.contextPath}/${b.blogImg}"
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
    <!--? About-2 Area Start -->
    <div class="about-area2 section-padding40">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-7 col-md-12">
                    <div class="about-img">
                        <c:set var="aboutImageFound" value="false"/>
                        <c:forEach var="content" items="${pageContents}">
                            <c:if test="${content.contentKey == 'about_image' && content.active && content.imageUrl != null}">
                                <c:set var="aboutImageFound" value="true"/>
                                <img src="${pageContext.request.contextPath}/${content.imageUrl}" alt="">
                            </c:if>
                        </c:forEach>
                        <c:if test="${!aboutImageFound}">
                            <img src="${pageContext.request.contextPath}/assets/img/gallery/about.png" alt="">
                        </c:if>
                    </div>
                </div>
                <div class="col-lg-5 col-md-12">
                    <div class="about-caption">
                        <div class="section-tittle mb-35">
                            <c:set var="aboutTitleFound" value="false"/>
                            <c:forEach var="content" items="${pageContents}">
                                <c:if test="${content.contentKey == 'perfect_smile_title' && content.active && content.contentValue != null}">
                                    <c:set var="aboutTitleFound" value="true"/>
                                    <h2>${content.contentValue}</h2>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!aboutTitleFound}">
                                <h2>Perfect Smile, Made Simple</h2>
                            </c:if>
                        </div>
                        <c:set var="aboutSubtitleFound" value="false"/>
                        <c:set var="aboutDescFound" value="false"/>
                        <c:forEach var="content" items="${pageContents}">
                            <c:if test="${content.contentKey == 'perfect_smile_subtitle' && content.active && content.contentValue != null}">
                                <c:set var="aboutSubtitleFound" value="true"/>
                                <p class="pera-top mb-40">${content.contentValue}</p>
                            </c:if>
                            <c:if test="${content.contentKey == 'perfect_smile_description' && content.active && content.contentValue != null}">
                                <c:set var="aboutDescFound" value="true"/>
                                <p class="pera-bottom mb-30">${content.contentValue}</p>
                            </c:if>
                        </c:forEach>
                        <c:if test="${!aboutSubtitleFound}">
                            <p class="pera-top mb-40">Experience top-notch dental care tailored to your needs</p>
                        </c:if>
                        <c:if test="${!aboutDescFound}">
                            <p class="pera-bottom mb-30">Our team of skilled dentists uses the latest technology to
                                ensure your dental health and comfort. From routine check-ups to advanced treatments,
                                we’ve got you covered.</p>
                        </c:if>
                        <div class="icon-about">
                            <c:set var="aboutIcon1Found" value="false"/>
                            <c:set var="aboutIcon2Found" value="false"/>
                            <c:forEach var="content" items="${pageContents}">
                                <c:if test="${content.contentKey == 'about_icon1' && content.active && content.imageUrl != null}">
                                    <c:set var="aboutIcon1Found" value="true"/>
                                    <img src="${pageContext.request.contextPath}/${content.imageUrl}" alt=""
                                         class="mr-20">
                                </c:if>
                                <c:if test="${content.contentKey == 'about_icon2' && content.active && content.imageUrl != null}">
                                    <c:set var="aboutIcon2Found" value="true"/>
                                    <img src="${pageContext.request.contextPath}/${content.imageUrl}" alt="">
                                </c:if>
                            </c:forEach>
                            <c:if test="${!aboutIcon1Found}">
                                <img src="${pageContext.request.contextPath}/assets/img/icon/about1.svg" alt=""
                                     class="mr-20">
                            </c:if>
                            <c:if test="${!aboutIcon2Found}">
                                <img src="${pageContext.request.contextPath}/assets/img/icon/about2.svg" alt="">
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- About-2 Area End -->
    <section class="wantToWork-area section-bg3"
             data-background="${pageContext.request.contextPath}/assets/img/gallery/section_bg01.png">
        <div class="container">
            <div class="wants-wrapper w-padding2">
                <div class="row align-items-center justify-content-between">
                    <div class="col-xl-7 col-lg-9 col-md-8">
                        <div class="wantToWork-caption wantToWork-caption2">
                            <c:set var="wantToWorkTitleFound" value="false"/>
                            <c:set var="wantToWorkSubtitleFound" value="false"/>
                            <c:forEach var="content" items="${pageContents}">
                                <c:if test="${content.contentKey == 'want_to_work_title' && content.active && content.contentValue != null}">
                                    <c:set var="wantToWorkTitleFound" value="true"/>
                                    <h2>${content.contentValue}</h2>
                                </c:if>
                                <c:if test="${content.contentKey == 'want_to_work_subtitle' && content.active && content.contentValue != null}">
                                    <c:set var="wantToWorkSubtitleFound" value="true"/>
                                    <p>${content.contentValue}</p>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!wantToWorkTitleFound}">
                                <h2>Bright Smile Healthy Teeth</h2>
                            </c:if>
                            <c:if test="${!wantToWorkSubtitleFound}">
                                <p>Discover personalized dental care that makes you smile</p>
                            </c:if>
                        </div>
                    </div>
                    <div class="col-xl-2 col-lg-3 col-md-4">
                        <c:set var="wantToWorkButtonFound" value="false"/>
                        <c:forEach var="content" items="${pageContents}">
                            <c:if test="${content.contentKey == 'want_to_work_button' && content.active && content.buttonUrl != null && content.buttonText != null}">
                                <c:set var="wantToWorkButtonFound" value="true"/>
                                <a href="${pageContext.request.contextPath}/${content.buttonUrl}"
                                   class="btn f-right sm-left">${content.buttonText}</a>
                            </c:if>
                        </c:forEach>
                        <c:if test="${!wantToWorkButtonFound}">
                            <a href="${pageContext.request.contextPath}/appointment/list" class="btn f-right sm-left">Explore
                                Services</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </section>
<%--    <!--? Services Area Start -->--%>
<%--    <div class="service-area">--%>
<%--        <div class="container">--%>
<%--            <div class="row">--%>
<%--                <c:forEach var="feature" items="${featureItems}" varStatus="loop">--%>
<%--                    <c:if test="${feature.active && feature.itemId != null}">--%>
<%--                        <div class="col-lg-4 col-md-6 col-sm-6">--%>
<%--                            <div class="single-cat text-center mb-50">--%>
<%--                                <div class="cat-icon">--%>
<%--                                    <c:choose>--%>
<%--                                        <c:when test="${feature.imageUrl != null}">--%>
<%--                                            <img src="${pageContext.request.contextPath}/${feature.imageUrl}"--%>
<%--                                                 alt="${feature.itemName}">--%>
<%--                                        </c:when>--%>
<%--                                        <c:otherwise>--%>
<%--                                            <img src="${pageContext.request.contextPath}/assets/img/icon/default_service.svg"--%>
<%--                                                 alt="${feature.itemName}">--%>
<%--                                        </c:otherwise>--%>
<%--                                    </c:choose>--%>
<%--                                </div>--%>
<%--                                <div class="cat-cap">--%>
<%--                                    <h5>--%>
<%--                                        <a href="${feature.itemUrl != null ? pageContext.request.contextPath + '/' + feature.itemUrl : '#'}">--%>
<%--                                                ${feature.itemName}--%>
<%--                                        </a>--%>
<%--                                    </h5>--%>
<%--                                    <c:set var="serviceDescFound" value="false"/>--%>
<%--                                    <c:forEach var="content" items="${pageContents}">--%>
<%--                                        <c:if test="${content.contentKey == 'service_description_' + feature.itemId.toString() && content.active && content.contentValue != null}">--%>
<%--                                            <c:set var="serviceDescFound" value="true"/>--%>
<%--                                            <p>${content.contentValue}</p>--%>
<%--                                        </c:if>--%>
<%--                                    </c:forEach>--%>
<%--                                    <c:if test="${!serviceDescFound}">--%>
<%--                                        <p>No description available for ${feature.itemName}.</p>--%>
<%--                                    </c:if>--%>
<%--                                    <a href="${feature.itemUrl != null ? pageContext.request.contextPath + '/' + feature.itemUrl : '#'}"--%>
<%--                                       class="plus-btn"><i class="ti-plus"></i></a>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </c:if>--%>
<%--                </c:forEach>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <!-- Services Area End -->--%>
    <!--? video_start -->
    <div class="container">
        <div class="video-area section-bg2 d-flex align-items-center"
             data-background="${pageContext.request.contextPath}/assets/img/gallery/video-bg.png">
            <div class="video-wrap position-relative">
                <div class="video-icon">
                    <c:set var="videoSectionFound" value="false"/>
                    <c:forEach var="content" items="${pageContents}">
                        <c:if test="${content.contentKey == 'video_section' && content.active && content.videoUrl != null}">
                            <c:set var="videoSectionFound" value="true"/>
                            <a class="popup-video btn-icon" href="${content.videoUrl}"><i class="fas fa-play"></i></a>
                        </c:if>
                    </c:forEach>
                    <c:if test="${!videoSectionFound}">
                        <a class="popup-video btn-icon" href="https://www.youtube.com/watch?v=up68UAfH0d0"><i
                                class="fas fa-play"></i></a>
                    </c:if>
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
                                <c:set var="aboutLawTitleFound" value="false"/>
                                <c:forEach var="content" items="${pageContents}">
                                    <c:if test="${content.contentKey == 'about_law_title' && content.active && content.contentValue != null}">
                                        <c:set var="aboutLawTitleFound" value="true"/>
                                        <h2>${content.contentValue}</h2>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${!aboutLawTitleFound}">
                                    <h2>100% Satisfaction Guaranteed</h2>
                                </c:if>
                            </div>
                            <c:set var="aboutLawSubtitleFound" value="false"/>
                            <c:forEach var="content" items="${pageContents}">
                                <c:if test="${content.contentKey == 'about_law_subtitle' && content.active && content.contentValue != null}">
                                    <c:set var="aboutLawSubtitleFound" value="true"/>
                                    <p>${content.contentValue}</p>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!aboutLawSubtitleFound}">
                                <p>Your perfect smile is our priority</p>
                            </c:if>
                            <c:set var="aboutLawButtonFound" value="false"/>
                            <c:forEach var="content" items="${pageContents}">
                                <c:if test="${content.contentKey == 'about_law_button' && content.active && content.buttonUrl != null && content.buttonText != null}">
                                    <c:set var="aboutLawButtonFound" value="true"/>
                                    <a href="${pageContext.request.contextPath}/${content.buttonUrl}"
                                       class="border-btn">${content.buttonText}</a>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!aboutLawButtonFound}">
                                <a href="${pageContext.request.contextPath}/book-appointment" class="border-btn">Book a
                                    Dental Appointment</a>
                            </c:if>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-12">
                        <div class="about-img">
                            <div class="about-font-img">
                                <c:set var="aboutLawImageFound" value="false"/>
                                <c:forEach var="content" items="${pageContents}">
                                    <c:if test="${content.contentKey == 'about_law_image' && content.active && content.imageUrl != null}">
                                        <c:set var="aboutLawImageFound" value="true"/>
                                        <img src="${pageContext.request.contextPath}/${content.imageUrl}" alt="">
                                    </c:if>
                                </c:forEach>
                                <c:if test="${!aboutLawImageFound}">
                                    <img src="${pageContext.request.contextPath}/assets/img/gallery/about2.png" alt="">
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- About Law End-->
</main>
<!-- Chat icon -->
<button id="chat-icon">💬</button>

<!-- Chat box -->
<div id="chatbox">
    <div id="chatbox-header">Chatbot</div>
    <div id="chat-messages"></div>
    <div id="chat-input-area">
        <input type="text" id="chat-input" placeholder="Type a message..."/>
        <button id="send-button">Send</button>
    </div>
</div>
<footer>
    <div class="footer-wrappr section-bg3"
         data-background="${pageContext.request.contextPath}/assets/img/gallery/footer-bg.png">
        <div class="footer-area footer-padding">
            <div class="container">
                <div class="row justify-content-between">
                    <div class="col-xl-8 col-lg-8 col-md-6 col-sm-12">
                        <div class="single-footer-caption mb-50">
                            <div class="footer-logo mb-25">
                                <c:set var="footerLogoFound" value="false"/>
                                <c:forEach var="content" items="${pageContents}">
                                    <c:if test="${content.contentKey == 'footer_logo' && content.active && content.imageUrl != null}">
                                        <c:set var="footerLogoFound" value="true"/>
                                        <a href="${pageContext.request.contextPath}/index"><img
                                                src="${pageContext.request.contextPath}/${content.imageUrl}" alt=""></a>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${!footerLogoFound}">
                                    <a href="${pageContext.request.contextPath}/index"><img
                                            src="${pageContext.request.contextPath}/assets/img/logo/logo2_footer.png"
                                            alt=""></a>
                                </c:if>
                            </div>

                            <div class="footer-social mt-50">
                                <c:set var="socialTwitterFound" value="false"/>
                                <c:set var="socialFacebookFound" value="false"/>
                                <c:set var="socialPinterestFound" value="false"/>
                                <c:forEach var="content" items="${pageContents}">
                                    <c:if test="${content.contentKey == 'footer_social_twitter' && content.active && content.buttonUrl != null}">
                                        <c:set var="socialTwitterFound" value="true"/>
                                        <a href="${content.buttonUrl}"><i class="fab fa-twitter"></i></a>
                                    </c:if>
                                    <c:if test="${content.contentKey == 'footer_social_facebook' && content.active && content.buttonUrl != null}">
                                        <c:set var="socialFacebookFound" value="true"/>
                                        <a href="${content.buttonUrl}"><i class="fab fa-facebook-f"></i></a>
                                    </c:if>
                                    <c:if test="${content.contentKey == 'footer_social_pinterest' && content.active && content.buttonUrl != null}">
                                        <c:set var="socialPinterestFound" value="true"/>
                                        <a href="${content.buttonUrl}"><i class="fab fa-pinterest-p"></i></a>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${!socialTwitterFound}">
                                    <a href="#"><i class="fab fa-twitter"></i></a>
                                </c:if>
                                <c:if test="${!socialFacebookFound}">
                                    <a href="https://bit.ly/sai4ull"><i class="fab fa-facebook-f"></i></a>
                                </c:if>
                                <c:if test="${!socialPinterestFound}">
                                    <a href="#"><i class="fab fa-pinterest-p"></i></a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-4 col-lg-4 col-md-6 col-sm-12">
                        <div class="single-footer-caption">
                            <div class="footer-tittle mb-50">
                                <c:set var="newsletterTitleFound" value="false"/>
                                <c:forEach var="content" items="${pageContents}">
                                    <c:if test="${content.contentKey == 'footer_newsletter_title' && content.active && content.contentValue != null}">
                                        <c:set var="newsletterTitleFound" value="true"/>
                                        <h4>${content.contentValue}</h4>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${!newsletterTitleFound}">
                                    <h4>Subscribe to Our Newsletter</h4>
                                </c:if>
                            </div>
                            <div class="footer-form">
                                <div id="mc_embed_signup">
                                    <c:set var="newsletterFormFound" value="false"/>
                                    <c:forEach var="content" items="${pageContents}">
                                        <c:if test="${content.contentKey == 'footer_newsletter_form' && content.active && content.buttonUrl != null}">
                                            <c:set var="newsletterFormFound" value="true"/>
                                            <form target="_blank" action="${content.buttonUrl}" method="get"
                                                  class="subscribe_form relative mail_part" novalidate="true">
                                                <input type="email" name="EMAIL" id="newsletter-form-email"
                                                       placeholder="${content.contentValue != null ? content.contentValue : 'Email Address'}"
                                                       class="placeholder hide-on-focus"
                                                       onfocus="this.placeholder = ''"
                                                       onblur="this.placeholder = '${content.contentValue != null ? content.contentValue : 'Email Address'}'">
                                                <div class="form-icon">
                                                    <button type="submit" name="submit" id="newsletter-submit"
                                                            class="email_icon newsletter-submit button-contactForm">
                                                        <c:set var="newsletterButtonFound" value="false"/>
                                                        <c:forEach var="subContent" items="${pageContents}">
                                                            <c:if test="${subContent.contentKey == 'footer_newsletter_button' && subContent.active && subContent.contentValue != null}">
                                                                <c:set var="newsletterButtonFound" value="true"/>
                                                                ${subContent.contentValue}
                                                            </c:if>
                                                        </c:forEach>
                                                        <c:if test="${!newsletterButtonFound}">
                                                            Subscribe
                                                        </c:if>
                                                    </button>
                                                </div>
                                                <div class="mt-10 info"></div>
                                            </form>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${!newsletterFormFound}">
                                        <form target="_blank"
                                              action="https://spondonit.us12.list-manage.com/subscribe/post?u=1462626880ade1ac87bd9c93a&id=92a4423d01"
                                              method="get" class="subscribe_form relative mail_part" novalidate="true">
                                            <input type="email" name="EMAIL" id="newsletter-form-email"
                                                   placeholder="Email Address" class="placeholder hide-on-focus"
                                                   onfocus="this.placeholder = ''"
                                                   onblur="this.placeholder = 'Email Address'">
                                            <div class="form-icon">
                                                <button type="submit" name="submit" id="newsletter-submit"
                                                        class="email_icon newsletter-submit button-contactForm">
                                                    Subscribe
                                                </button>
                                            </div>
                                            <div class="mt-10 info"></div>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                            <div class="footer-tittle">
                                <div class="footer-pera">
                                    <c:set var="newsletterSubtitleFound" value="false"/>
                                    <c:forEach var="content" items="${pageContents}">
                                        <c:if test="${content.contentKey == 'footer_newsletter_subtitle' && content.active && content.contentValue != null}">
                                            <c:set var="newsletterSubtitleFound" value="true"/>
                                            <p>${content.contentValue}</p>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${!newsletterSubtitleFound}">
                                        <p>Stay updated with the latest dental care tips and promotions.</p>
                                    </c:if>
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
                                <c:set var="copyrightFound" value="false"/>
                                <c:forEach var="content" items="${pageContents}">
                                    <c:if test="${content.contentKey == 'footer_copyright' && content.active && content.contentValue != null}">
                                        <c:set var="copyrightFound" value="true"/>
                                        <p>${content.contentValue}
                                            <script>document.write(new Date().getFullYear());</script>
                                        </p>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${!copyrightFound}">
                                    <p>Copyright ©
                                        <script>document.write(new Date().getFullYear());</script>
                                        All rights reserved | This template is made with <i class="fa fa-heart"
                                                                                            aria-hidden="true"></i> by
                                        <a href="https://colorlib.com" target="_blank">Colorlib</a></p>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</footer>
<!-- Scroll Up -->
<%--<div id="back-top">--%>
<%--    <c:set var="scrollUpFound" value="false"/>--%>
<%--    <c:forEach var="content" items="${pageContents}">--%>
<%--        <c:if test="${content.contentKey == 'scroll_up_button' && content.active && content.contentValue != null}">--%>
<%--            <c:set var="scrollUpFound" value="true"/>--%>
<%--            <a title="${content.contentValue}" href="#"><i class="fas fa-level-up-alt"></i></a>--%>
<%--        </c:if>--%>
<%--    </c:forEach>--%>
<%--    <c:if test="${!scrollUpFound}">--%>
<%--        <a title="Go to Top" href="#"><i class="fas fa-level-up-alt"></i></a>--%>
<%--    </c:if>--%>
<%--</div>--%>
<!-- JS here -->
<script src="${pageContext.request.contextPath}/assets/js/vendor/modernizr-3.5.0.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.slicknav.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/slick.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/animated.headline.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/gijgo.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.sticky.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.counterup.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/waypoints.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.countdown.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/hover-direction-snake.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/contact.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.form.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.validate.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/mail-script.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.ajaxchimp.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/plugins.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = "<%=request.getContextPath()%>";
</script>
<script src="${pageContext.request.contextPath}/assets/js/chatbot.js"></script>
</body>
</html>