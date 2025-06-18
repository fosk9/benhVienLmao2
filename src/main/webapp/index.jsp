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
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/favicon.ico">
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <style>
        .editable:hover {
            background-color: #f0f0f0;
            cursor: pointer;
        }
        .edit-form {
            display: none;
            z-index: 1000;
            position: relative;
        }
    </style>
    <script>
        console.log('index.jsp: Starting head rendering at ' + new Date().toISOString());
    </script>
</head>
<body>
<script>
    console.log('index.jsp: Starting body rendering at ' + new Date().toISOString());
</script>

<!-- Debug Edit Mode -->
<c:out value="EditMode: ${editMode} Role: ${sessionScope.role}"/>

<div id="preloader-active">
    <div class="preloader d-flex align-items-center justify-content-center">
        <div class="preloader-inner position-relative">
            <div class="preloader-circle"></div>
            <div class="preloader-img pere-text">
                <img src="${pageContext.request.contextPath}/assets/img/logo/loder.png" alt="">
            </div>
        </div>
    </div>
</div>
<header>
    <div class="header-area">
        <div class="main-header header-sticky">
            <div class="container-fluid">
                <div class="row align-items-center">
                    <div class="col-xl-2 col-lg-2 col-md-1">
                        <div class="logo">
                            <a href="index.jsp"><img src="${pageContext.request.contextPath}/assets/img/logo/logo.png" alt=""></a>
                        </div>
                    </div>
                    <div class="col-xl-10 col-lg-10 col-md-10">
                        <div class="menu-main d-flex align-items-center justify-content-end">
                            <div class="main-menu f-right d-none d-lg-block">
                                <nav>
                                    <ul id="navigation">
                                        <c:forEach var="nav" items="${navItems}">
                                            <li>
                                                <c:choose>
                                                    <c:when test="${editMode}">
                                                        <span class="editable" onclick="toggleEdit('nav_${nav.itemId}')">${nav.itemName}</span>
                                                        <div id="edit_nav_${nav.itemId}" class="edit-form">
                                                            <form action="${pageContext.request.contextPath}/index" method="post" enctype="multipart/form-data">
                                                                <input type="hidden" name="action" value="save">
                                                                <input type="hidden" name="itemId" value="${nav.itemId}">
                                                                <input type="hidden" name="itemType" value="${nav.itemType}">
                                                                <input type="text" name="itemName_${nav.itemId}" value="${nav.itemName}" class="form-control mb-1">
                                                                <input type="text" name="itemUrl_${nav.itemId}" value="${nav.itemUrl}" class="form-control mb-1">
                                                                <select name="isActive_${nav.itemId}" class="form-select mb-1">
                                                                    <option value="true" ${nav.active ? 'selected' : ''}>Active</option>
                                                                    <option value="false" ${!nav.active ? 'selected' : ''}>Inactive</option>
                                                                </select>
                                                                <input type="number" name="displayOrder_${nav.itemId}" value="${nav.displayOrder}" class="form-control mb-1" placeholder="Display Order">
                                                                <select name="parentItemId_${nav.itemId}" class="form-select mb-1">
                                                                    <option value="">None</option>
                                                                    <c:forEach var="item" items="${navItems}">
                                                                        <option value="${item.itemId}" ${item.itemId == nav.parentItemId ? 'selected' : ''}>${item.itemName}</option>
                                                                    </c:forEach>
                                                                </select>
                                                                <button type="submit" class="btn btn-success btn-sm">Save</button>
                                                                <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit('nav_${nav.itemId}')">Cancel</button>
                                                            </form>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${nav.itemUrl}">${nav.itemName}</a>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:if test="${not empty nav.subItems}">
                                                    <ul class="submenu">
                                                        <c:forEach var="subNav" items="${nav.subItems}">
                                                            <li>
                                                                <c:choose>
                                                                    <c:when test="${editMode}">
                                                                        <span class="editable" onclick="toggleEdit('nav_${subNav.itemId}')">${subNav.itemName}</span>
                                                                        <div id="edit_nav_${subNav.itemId}" class="edit-form">
                                                                            <form action="${pageContext.request.contextPath}/index" method="post" enctype="multipart/form-data">
                                                                                <input type="hidden" name="action" value="save">
                                                                                <input type="hidden" name="itemId" value="${subNav.itemId}">
                                                                                <input type="hidden" name="itemType" value="${subNav.itemType}">
                                                                                <input type="text" name="itemName_${subNav.itemId}" value="${subNav.itemName}" class="form-control mb-1">
                                                                                <input type="text" name="itemUrl_${subNav.itemId}" value="${subNav.itemUrl}" class="form-control mb-1">
                                                                                <select name="isActive_${subNav.itemId}" class="form-select mb-1">
                                                                                    <option value="true" ${subNav.active ? 'selected' : ''}>Active</option>
                                                                                    <option value="false" ${!subNav.active ? 'selected' : ''}>Inactive</option>
                                                                                </select>
                                                                                <input type="number" name="displayOrder_${subNav.itemId}" value="${subNav.displayOrder}" class="form-control mb-1" placeholder="Display Order">
                                                                                <select name="parentItemId_${subNav.itemId}" class="form-select mb-1">
                                                                                    <option value="">None</option>
                                                                                    <c:forEach var="item" items="${navItems}">
                                                                                        <option value="${item.itemId}" ${item.itemId == subNav.parentItemId ? 'selected' : ''}>${item.itemName}</option>
                                                                                    </c:forEach>
                                                                                </select>
                                                                                <button type="submit" class="btn btn-success btn-sm">Save</button>
                                                                                <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit('nav_${subNav.itemId}')">Cancel</button>
                                                                            </form>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <a href="${subNav.itemUrl}">${subNav.itemName}</a>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </li>
                                                        </c:forEach>
                                                    </ul>
                                                </c:if>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </nav>
                            </div>
                            <div class="header-right-btn f-right d-none d-lg-block ml-15">
                                <c:if test="${sessionScope.role == 3 || sessionScope.role == 4}">
                                    <a href="${pageContext.request.contextPath}/admin/home" class="btn header-btn">Admin Dashboard</a>
                                    <c:choose>
                                        <c:when test="${editMode}">
                                            <a href="${pageContext.request.contextPath}/index" class="btn header-btn">Exit Edit Mode</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/index?action=edit" class="btn header-btn">Edit Page</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/login.jsp" class="btn header-btn">Login</a>
                                <a href="${pageContext.request.contextPath}/register.jsp" class="btn header-btn">Register</a>
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
    <div class="slider-area">
        <div class="slider-active dot-style">
            <c:forEach var="i" begin="1" end="2">
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
                                        <c:set var="captionKey" value="slider${i}_caption"/>
                                        <c:set var="subcaptionKey" value="slider${i}_subcaption"/>
                                        <c:forEach var="content" items="${pageContents}">
                                            <c:if test="${content.contentKey == captionKey}">
                                                <c:choose>
                                                    <c:when test="${editMode}">
                                                        <h1 data-animation="fadeInUp" data-delay=".3s" class="editable" onclick="toggleEdit('content_${content.contentId}')">${content.contentValue}</h1>
                                                        <div id="edit_content_${content.contentId}" class="edit-form">
                                                            <form action="${pageContext.request.contextPath}/index" method="post">
                                                                <input type="hidden" name="action" value="save">
                                                                <input type="hidden" name="contentId" value="${content.contentId}">
                                                                <input type="hidden" name="contentKey_${content.contentId}" value="${content.contentKey}">
                                                                <input type="text" name="contentValue_${content.contentId}" value="${content.contentValue}" class="form-control mb-1">
                                                                <button type="submit" class="btn btn-success btn-sm">Save</button>
                                                                <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit('content_${content.contentId}')">Cancel</button>
                                                            </form>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <h1 data-animation="fadeInUp" data-delay=".3s">${content.contentValue}</h1>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                            <c:if test="${content.contentKey == subcaptionKey}">
                                                <c:choose>
                                                    <c:when test="${editMode}">
                                                        <p data-animation="fadeInUp" data-delay=".6s" class="editable" onclick="toggleEdit('content_${content.contentId}')">${content.contentValue}</p>
                                                        <div id="edit_content_${content.contentId}" class="edit-form">
                                                            <form action="${pageContext.request.contextPath}/index" method="post">
                                                                <input type="hidden" name="action" value="save">
                                                                <input type="hidden" name="contentId" value="${content.contentId}">
                                                                <input type="hidden" name="contentKey_${content.contentId}" value="${content.contentKey}">
                                                                <input type="text" name="contentValue_${content.contentId}" value="${content.contentValue}" class="form-control mb-1">
                                                                <button type="submit" class="btn btn-success btn-sm">Save</button>
                                                                <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit('content_${content.contentId}')">Cancel</button>
                                                            </form>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p data-animation="fadeInUp" data-delay=".6s">${content.contentValue}</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                        </c:forEach>
                                        <a href="${pageContext.request.contextPath}/book-appointment" class="btn" data-animation="fadeInLeft" data-delay=".3s">Explore Dental Services</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
    <section class="latest-news-area section-padding30">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-7 col-md-9 col-sm-10">
                    <div class="section-tittle text-center mb-70">
                        <c:forEach var="content" items="${pageContents}">
                            <c:if test="${content.contentKey == 'daily_dental_updates_title'}">
                                <c:choose>
                                    <c:when test="${editMode}">
                                        <h2 class="editable" onclick="toggleEdit('content_${content.contentId}')">${content.contentValue}</h2>
                                        <div id="edit_content_${content.contentId}" class="edit-form">
                                            <form action="${pageContext.request.contextPath}/index" method="post">
                                                <input type="hidden" name="action" value="save">
                                                <input type="hidden" name="contentId" value="${content.contentId}">
                                                <input type="hidden" name="contentKey_${content.contentId}" value="${content.contentKey}">
                                                <input type="text" name="contentValue_${content.contentId}" value="${content.contentValue}" class="form-control mb-1">
                                                <button type="submit" class="btn btn-success btn-sm">Save</button>
                                                <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit('content_${content.contentId}')">Cancel</button>
                                            </form>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <h2>${content.contentValue}</h2>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <c:if test="${content.contentKey == 'daily_dental_updates_subtitle'}">
                                <c:choose>
                                    <c:when test="${editMode}">
                                        <p class="editable" onclick="toggleEdit('content_${content.contentId}')">${content.contentValue}</p>
                                        <div id="edit_content_${content.contentId}" class="edit-form">
                                            <form action="${pageContext.request.contextPath}/index" method="post">
                                                <input type="hidden" name="action" value="save">
                                                <input type="hidden" name="contentId" value="${content.contentId}">
                                                <input type="hidden" name="contentKey_${content.contentId}" value="${content.contentKey}">
                                                <input type="text" name="contentValue_${content.contentId}" value="${content.contentValue}" class="form-control mb-1">
                                                <button type="submit" class="btn btn-success btn-sm">Save</button>
                                                <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit('content_${content.contentId}')">Cancel</button>
                                            </form>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <p>${content.contentValue}</p>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <div class="row">
                <c:forEach var="b" items="${recentBlogs}" varStatus="loop">
                    <div class="col-lg-4 col-md-6 col-sm-12">
                        <article class="blog_item">
                            <div class="blog_item_img">
                                <img class="card-img rounded-0" src="${pageContext.request.contextPath}/assets/img/${b.blogImg}" alt="${b.blogName}">
                                <a href="#" class="blog_item_date">
                                    <h3><fmt:formatDate value="${b.date}" pattern="dd"/></h3>
                                    <p><fmt:formatDate value="${b.date}" pattern="MMM"/></p>
                                </a>
                            </div>
                            <div class="blog_details">
                                <a class="d-inline-block" href="${pageContext.request.contextPath}/blog-detail?id=${b.blogId}">
                                    <h2 class="blog-head" style="color: #2d2d2d;">${b.blogName}</h2>
                                </a>
                                <p>${b.blogSubContent}</p>
                                <ul class="blog-info-link">
                                    <li><a href="${pageContext.request.contextPath}/blog?categoryId=${b.categoryId}"><i class="fa fa-user"></i> ${b.categoryName}</a></li>
                                    <li><a href="#"><i class="fa fa-comments"></i> ${b.commentCount} Comments</a></li>
                                </ul>
                            </div>
                        </article>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
    <div class="about-area2 section-padding40">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-7 col-md-12">
                    <div class="about-img">
                        <img src="${pageContext.request.contextPath}/assets/img/gallery/about.png" alt="">
                    </div>
                </div>
                <div class="col-lg-5 col-md-12">
                    <div class="about-caption">
                        <div class="section-tittle mb-35">
                            <c:forEach var="content" items="${pageContents}">
                                <c:if test="${content.contentKey == 'perfect_smile_title'}">
                                    <c:choose>
                                        <c:when test="${editMode}">
                                            <h2 class="editable" onclick="toggleEdit('content_${content.contentId}')">${content.contentValue}</h2>
                                            <div id="edit_content_${content.contentId}" class="edit-form">
                                                <form action="${pageContext.request.contextPath}/index" method="post">
                                                    <input type="hidden" name="action" value="save">
                                                    <input type="hidden" name="contentId" value="${content.contentId}">
                                                    <input type="hidden" name="contentKey_${content.contentId}" value="${content.contentKey}">
                                                    <input type="text" name="contentValue_${content.contentId}" value="${content.contentValue}" class="form-control mb-1">
                                                    <button type="submit" class="btn btn-success btn-sm">Save</button>
                                                    <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit('content_${content.contentId}')">Cancel</button>
                                                </form>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <h2>${content.contentValue}</h2>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </c:forEach>
                        </div>
                        <c:forEach var="content" items="${pageContents}">
                            <c:if test="${content.contentKey == 'perfect_smile_subtitle'}">
                                <c:choose>
                                    <c:when test="${editMode}">
                                        <p class="pera-top mb-40 editable" onclick="toggleEdit('content_${content.contentId}')">${content.contentValue}</p>
                                        <div id="edit_content_${content.contentId}" class="edit-form">
                                            <form action="${pageContext.request.contextPath}/index" method="post">
                                                <input type="hidden" name="action" value="save">
                                                <input type="hidden" name="contentId" value="${content.contentId}">
                                                <input type="hidden" name="contentKey_${content.contentId}" value="${content.contentKey}">
                                                <input type="text" name="contentValue_${content.contentId}" value="${content.contentValue}" class="form-control mb-1">
                                                <button type="submit" class="btn btn-success btn-sm">Save</button>
                                                <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit('content_${content.contentId}')">Cancel</button>
                                            </form>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="pera-top mb-40">${content.contentValue}</p>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </c:forEach>
                        <p class="pera-bottom mb-30">Our team of skilled dentists uses the latest technology to ensure your dental health and comfort. From routine check-ups to advanced treatments, we’ve got you covered.</p>
                        <div class="icon-about">
                            <img src="${pageContext.request.contextPath}/assets/img/icon/about1.svg" alt="" class="mr-20">
                            <img src="${pageContext.request.contextPath}/assets/img/icon/about2.svg" alt="">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <section class="wantToWork-area section-bg3" data-background="${pageContext.request.contextPath}/assets/img/gallery/section_bg01.png">
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
                        <a href="${pageContext.request.contextPath}/book-appointment" class="btn f-right sm-left">Explore Services</a>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <div class="service-area">
        <div class="container">
            <div class="row">
                <c:forEach var="feature" items="${featureItems}" varStatus="loop">
                    <c:if test="${feature.active}">
                        <div class="col-lg-4 col-md-6 col-sm-6">
                            <div class="single-cat text-center mb-50">
                                <div class="cat-icon">
                                    <c:choose>
                                        <c:when test="${editMode}">
                                            <span class="editable" onclick="toggleEdit('feature_${feature.itemId}')">
                                                <img src="${pageContext.request.contextPath}/${feature.imageUrl}" alt="${feature.itemName}">
                                            </span>
                                            <div id="edit_feature_${feature.itemId}" class="edit-form">
                                                <form action="${pageContext.request.contextPath}/index" method="post" enctype="multipart/form-data">
                                                    <input type="hidden" name="action" value="save">
                                                    <input type="hidden" name="itemId" value="${feature.itemId}">
                                                    <input type="hidden" name="itemType" value="${feature.itemType}">
                                                    <input type="text" name="itemName_${feature.itemId}" value="${feature.itemName}" class="form-control mb-1">
                                                    <input type="text" name="itemUrl_${feature.itemId}" value="${feature.itemUrl}" class="form-control mb-1">
                                                    <input type="file" name="imageFile_${feature.itemId}" accept="image/*" class="form-control mb-1">
                                                    <input type="hidden" name="existingImageUrl_${feature.itemId}" value="${feature.imageUrl}">
                                                    <select name="isActive_${feature.itemId}" class="form-select mb-1">
                                                        <option value="true" ${feature.active ? 'selected' : ''}>Active</option>
                                                        <option value="false" ${!feature.active ? 'selected' : ''}>Inactive</option>
                                                    </select>
                                                    <input type="number" name="displayOrder_${feature.itemId}" value="${feature.displayOrder}" class="form-control mb-1" placeholder="Display Order">
                                                    <button type="submit" class="btn btn-success btn-sm">Save</button>
                                                    <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit('feature_${feature.itemId}')">Cancel</button>
                                                </form>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/${feature.imageUrl}" alt="${feature.itemName}">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="cat-cap">
                                    <c:choose>
                                        <c:when test="${editMode}">
                                            <h5 class="editable" onclick="toggleEdit('feature_${feature.itemId}')">${feature.itemName}</h5>
                                        </c:when>
                                        <c:otherwise>
                                            <h5><a href="${pageContext.request.contextPath}/${feature.itemUrl}">${feature.itemName}</a></h5>
                                        </c:otherwise>
                                    </c:choose>
                                    <p>Explore our ${feature.itemName} services for a healthier smile.</p>
                                    <a href="${pageContext.request.contextPath}/${feature.itemUrl}" class="plus-btn"><i class="ti-plus"></i></a>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </div>
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
                        <a href="${pageContext.request.contextPath}/book-appointment?appointmentTypeId=${service.appointmentTypeId}"
                           class="btn btn-sm btn-outline-success">
                            Book Now
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    <section class="testimonial-area testimonial-padding fix">
        <div class="container">
            <div class="row align-items-center justify-content-center">
                <div class="col-lg-9">
                    <div class="about-caption">
                        <div class="h1-testimonial-active dot-style">
                            <div class="single-testimonial position-relative">
                                <div class="testimonial-caption">
                                    <img src="${pageContext.request.contextPath}/assets/img/icon/quotes-sign.png" alt="" class="quotes-sign">
                                    <p>"The dental care I received was exceptional. My smile has never looked better,
                                        and the process was so comfortable!"</p>
                                </div>
                                <div class="testimonial-founder d-flex align-items-center">
                                    <div class="founder-img">
                                        <img src="${pageContext.request.contextPath}/assets/img/icon/testimonial.png" alt="">
                                    </div>
                                    <div class="founder-text">
                                        <span>Jane Smith</span>
                                        <p>Happy Patient</p>
                                    </div>
                                </div>
                            </div>
                            <div class="single-testimonial position-relative">
                                <div class="testimonial-caption">
                                    <img src="${pageContext.request.contextPath}/assets/img/icon/quotes-sign.png" alt="" class="quotes-sign">
                                    <p>"From consultation to treatment, the team was professional and caring. Highly
                                        recommend their services!"</p>
                                </div>
                                <div class="testimonial-founder d-flex align-items-center">
                                    <div class="founder-img">
                                        <img src="${pageContext.request.contextPath}/assets/img/icon/testimonial.png" alt="">
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
    <div class="container">
        <div class="video-area section-bg2 d-flex align-items-center" data-background="${pageContext.request.contextPath}/assets/img/gallery/video-bg.png">
            <div class="video-wrap position-relative">
                <div class="video-icon">
                    <a class="popup-video btn-icon" href="https://www.youtube.com/watch?v=up68UAfH0d0"><i
                            class="fas fa-play"></i></a>
                </div>
            </div>
        </div>
    </div>
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
                            <a href="${pageContext.request.contextPath}/book-appointment" class="border-btn">Book a Dental Appointment</a>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-12">
                        <div class="about-img">
                            <div class="about-font-img">
                                <img src="${pageContext.request.contextPath}/assets/img/gallery/about2.png" alt="">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>
<footer>
    <div class="footer-wrappr section-bg3" data-background="${pageContext.request.contextPath}/assets/img/gallery/footer-bg.png">
        <div class="footer-area footer-padding">
            <div class="container">
                <div class="row justify-content-between">
                    <div class="col-xl-8 col-lg-8 col-md-6 col-sm-12">
                        <div class="single-footer-caption mb-50">
                            <div class="footer-logo mb-25">
                                <a href="index.jsp"><img src="${pageContext.request.contextPath}/assets/img/logo/logo2_footer.png" alt=""></a>
                            </div>
                            <div class="header-area">
                                <div class="main-header main-header2">
                                    <div class="menu-main d-flex align-items-center justify-content-start">
                                        <div class="main-menu main-menu2">
                                            <nav>
                                                <ul>
                                                    <c:forEach var="nav" items="${navItems}">
                                                        <li>
                                                            <c:choose>
                                                                <c:when test="${editMode}">
                                                                    <span class="editable" onclick="toggleEdit('footer_nav_${nav.itemId}')">${nav.itemName}</span>
                                                                    <div id="edit_footer_nav_${nav.itemId}" class="edit-form">
                                                                        <form action="${pageContext.request.contextPath}/index" method="post" enctype="multipart/form-data">
                                                                            <input type="hidden" name="action" value="save">
                                                                            <input type="hidden" name="itemId" value="${nav.itemId}">
                                                                            <input type="hidden" name="itemType" value="${nav.itemType}">
                                                                            <input type="text" name="itemName_${nav.itemId}" value="${nav.itemName}" class="form-control mb-1">
                                                                            <input type="text" name="itemUrl_${nav.itemId}" value="${nav.itemUrl}" class="form-control mb-1">
                                                                            <select name="isActive_${nav.itemId}" class="form-select mb-1">
                                                                                <option value="true" ${nav.active ? 'selected' : ''}>Active</option>
                                                                                <option value="false" ${!nav.active ? 'selected' : ''}>Inactive</option>
                                                                            </select>
                                                                            <input type="number" name="displayOrder_${nav.itemId}" value="${nav.displayOrder}" class="form-control mb-1" placeholder="Display Order">
                                                                            <select name="parentItemId_${nav.itemId}" class="form-select mb-1">
                                                                                <option value="">None</option>
                                                                                <c:forEach var="item" items="${navItems}">
                                                                                    <option value="${item.itemId}" ${item.itemId == nav.parentItemId ? 'selected' : ''}>${item.itemName}</option>
                                                                                </c:forEach>
                                                                            </select>
                                                                            <button type="submit" class="btn btn-success btn-sm">Save</button>
                                                                            <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit('footer_nav_${nav.itemId}')">Cancel</button>
                                                                        </form>
                                                                    </div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a href="${pageContext.request.contextPath}/${nav.itemUrl}">${nav.itemName}</a>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </li>
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
<div id="back-top">
    <a title="Go to Top" href="#"> <i class="fas fa-level-up-alt"></i></a>
</div>
<script src="${pageContext.request.contextPath}/assets/js/vendor/modernizr-3.5.0.min.js"></script>
<script>
    console.log('index.jsp: Loaded modernizr at ' + new Date().toISOString());
</script>
<script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
<script>
    console.log('index.jsp: Loaded jQuery at ' + new Date().toISOString());
</script>
<script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
<script>
    console.log('index.jsp: Loaded Bootstrap at ' + new Date().toISOString());
</script>
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
<script src="${pageContext.request.contextPath}/assets/js/main.js" defer></script>
<script>
    console.log('index.jsp: Loaded main.js at ' + new Date().toISOString());
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    console.log('index.jsp: Loaded Bootstrap bundle at ' + new Date().toISOString());

    function toggleEdit(id) {
        console.log('index.jsp: toggleEdit called for ID: ' + id + ' at ' + new Date().toISOString());
        try {
            const element = document.getElementById(id);
            if (element) {
                const display = element.style.display;
                element.style.display = display === 'block' ? 'none' : 'block';
                console.log('index.jsp: Toggled display for ' + id + ' to ' + element.style.display);
            } else {
                console.error('index.jsp: Element not found for ID: ' + id);
            }
        } catch (error) {
            console.error('index.jsp: Error in toggleEdit for ID: ' + id + ': ' + error.message);
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        console.log('index.jsp: DOM fully loaded at ' + new Date().toISOString());
        try {
            // Initialize plugins safely
            if (typeof jQuery !== 'undefined') {
                console.log('index.jsp: jQuery version: ' + jQuery.fn.jquery);
                // Initialize Owl Carousel
                if (jQuery('.slider-active').owlCarousel) {
                    jQuery('.slider-active').owlCarousel({
                        loop: true,
                        nav: true,
                        dots: true,
                        responsive: {
                            0: { items: 1 },
                            600: { items: 1 },
                            1000: { items: 1 }
                        }
                    });
                    console.log('index.jsp: Initialized Owl Carousel');
                }
                // Initialize other plugins (e.g., Magnific Popup, Slick)
                if (jQuery.magnificPopup) {
                    jQuery('.popup-video').magnificPopup({ type: 'iframe' });
                    console.log('index.jsp: Initialized Magnific Popup');
                }
            } else {
                console.error('index.jsp: jQuery not loaded');
            }
        } catch (error) {
            console.error('index.jsp: Error initializing plugins: ' + error.message);
        }
    });

    window.addEventListener('load', function() {
        console.log('index.jsp: Window fully loaded at ' + new Date().toISOString());
    });

    // Log resource errors
    window.addEventListener('error', function(event) {
        console.error('index.jsp: Resource error: ' + event.message + ' at ' + event.filename + ':' + event.lineno);
    });
</script>
</body>
</html>