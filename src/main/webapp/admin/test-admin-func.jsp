<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html class="no-js" lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Test Admin Functions - benhVienLmao</title>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <style>
        .admin-header {
            background-color: #28a745;
            color: white;
        }
        .test-section {
            margin-top: 2rem;
        }
        .edit-form {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <!-- Header -->
    <header class="admin-header py-3 mb-4">
        <div class="container d-flex justify-content-between align-items-center">
            <h1 class="h3 mb-0">Test Admin Functions</h1>
            <div>
                <span class="me-3">Welcome, ${fullName}</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-light btn-sm">Logout</a>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="container">
        <h2 class="mb-4">Admin Testing Dashboard</h2>

        <!-- Quick Links -->
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/admin/system-items" class="btn btn-success me-2">Manage System Items</a>
            <a href="${pageContext.request.contextPath}/admin/test-admin-func?edit=true" class="btn btn-success me-2">Edit This Page</a>
            <a href="${pageContext.request.contextPath}/admin/home" class="btn btn-secondary">Back to Admin Home</a>
        </div>

        <!-- Display Error if Present -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <!-- Debugging Information -->
        <c:forEach var="content" items="${contents}">
            <p>Debug: Content ID=${content.contentId}, Active=${content.active}</p>
        </c:forEach>

        <!-- Content Area -->
        <div class="test-section">
            <c:choose>
                <c:when test="${editMode}">
                    <!-- Edit Mode -->
                    <h3>Edit Slider Content</h3>
                    <form action="${pageContext.request.contextPath}/admin/test-admin-func" method="post" enctype="multipart/form-data" class="edit-form">
                        <input type="hidden" name="action" value="save">
                        <c:choose>
                            <c:when test="${empty contents}">
                                <div class="alert alert-warning">No content available to edit. Add content via Manage Page Content.</div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="content" items="${contents}">
                                    <div class="mb-4 border p-3 rounded">
                                        <h5>Content ID: ${content.contentId}</h5>
                                        <input type="hidden" name="contentId" value="${content.contentId}">
                                        <div class="mb-3">
                                            <label for="contentKey_${content.contentId}" class="form-label">Content Key</label>
                                            <input type="text" class="form-control" id="contentKey_${content.contentId}" name="contentKey_${content.contentId}" value="${content.contentKey}" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="contentValue_${content.contentId}" class="form-label">Content Value</label>
                                            <textarea class="form-control" id="contentValue_${content.contentId}" name="contentValue_${content.contentId}" rows="3" required>${content.contentValue}</textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label for="imageFile_${content.contentId}" class="form-label">Background Image</label>
                                            <input type="file" class="form-control" id="imageFile_${content.contentId}" name="imageFile_${content.contentId}" accept="image/*">
                                            <c:if test="${not empty content.imageUrl}">
                                                <img src="${pageContext.request.contextPath}/${content.imageUrl}" alt="Current Image" width="100" class="mt-2">
                                                <input type="hidden" name="existingImageUrl_${content.contentId}" value="${content.imageUrl}">
                                            </c:if>
                                        </div>
                                        <div class="mb-3">
                                            <label for="videoUrl_${content.contentId}" class="form-label">Video URL</label>
                                            <input type="text" class="form-control" id="videoUrl_${content.contentId}" name="videoUrl_${content.contentId}" value="${content.videoUrl}" placeholder="e.g., https://www.youtube.com/watch?v=...">
                                        </div>
                                        <div class="mb-3">
                                            <label for="buttonUrl_${content.contentId}" class="form-label">Button URL</label>
                                            <input type="text" class="form-control" id="buttonUrl_${content.contentId}" name="buttonUrl_${content.contentId}" value="${content.buttonUrl}" placeholder="e.g., book-appointment">
                                        </div>
                                        <div class="mb-3">
                                            <label for="buttonText_${content.contentId}" class="form-label">Button Text</label>
                                            <input type="text" class="form-control" id="buttonText_${content.contentId}" name="buttonText_${content.contentId}" value="${content.buttonText}" placeholder="e.g., Explore Dental Services">
                                        </div>
                                        <div class="mb-3">
                                            <label for="isActive_${content.contentId}" class="form-label">Active</label>
                                            <select class="form-select" id="isActive_${content.contentId}" name="isActive_${content.contentId}">
                                                <option value="true" ${content.active ? 'selected' : ''}>Yes</option>
                                                <option value="false" ${!content.active ? 'selected' : ''}>No</option>
                                            </select>
                                        </div>
                                    </div>
                                </c:forEach>
                                <button type="submit" class="btn btn-success">Save Changes</button>
                                <a href="${pageContext.request.contextPath}/admin/test-admin-func" class="btn btn-secondary">Cancel</a>
                            </c:otherwise>
                        </c:choose>
                    </form>
                </c:when>
                <c:otherwise>
                    <!-- View Mode -->
                    <!--? Slider Area Start-->
                    <div class="slider-area">
                        <div class="slider-active dot-style">
                            <c:choose>
                                <c:when test="${empty contents}">
                                    <div class="alert alert-warning">No slider content available. Add content via Edit This Page.</div>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="hasSlider" value="false" />
                                    <c:forEach var="content" items="${contents}" varStatus="loop">
                                        <c:catch var="exception">
                                            <c:if test="${not empty content.pageName && content.pageName == 'index' && not empty content.contentKey && fn:startsWith(content.contentKey, 'slider') && content.active}">
                                                <c:set var="hasSlider" value="true" />
                                                <div class="single-slider d-flex align-items-center slider-height" style="background-image: url('${pageContext.request.contextPath}/${content.imageUrl}'); background-size: cover;">
                                                    <div class="container">
                                                        <div class="row align-items-center">
                                                            <div class="col-xl-7 col-lg-8 col-md-10">
                                                                <div class="hero-wrapper">
                                                                    <div class="video-icon">
                                                                        <a class="popup-video btn-icon" href="${content.videoUrl}"
                                                                           data-animation="bounceIn" data-delay=".4s">
                                                                            <i class="fas fa-play"></i>
                                                                        </a>
                                                                    </div>
                                                                    <div class="hero__caption">
                                                                        <h1 data-animation="fadeInUp" data-delay=".3s">${content.contentKey == 'slider1_caption' || content.contentKey == 'slider2_caption' ? content.contentValue : ''}</h1>
                                                                        <p data-animation="fadeInUp" data-delay=".6s">${content.contentKey == 'slider1_subcaption' || content.contentKey == 'slider2_subcaption' ? content.contentValue : ''}</p>
                                                                        <a href="${content.buttonUrl}" class="btn" data-animation="fadeInLeft" data-delay=".3s">${content.buttonText}</a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:catch>
                                        <c:if test="${not empty exception}">
                                            <c:set var="hasError" value="true" />
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${!hasSlider}">
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
                                                                <h1 data-animation="fadeInUp" data-delay=".3s">No Slider Content</h1>
                                                                <p data-animation="fadeInUp" data-delay=".6s">Add slider content in the Edit This Page section.</p>
                                                                <a href="${pageContext.request.contextPath}/admin/test-admin-func?edit=true" class="btn" data-animation="fadeInLeft" data-delay=".3s">Edit Content</a>
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
                    <c:if test="${hasError}">
                        <div class="alert alert-warning">Some content entries could not be processed. Check the data in Edit This Page.</div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

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
</body>
</html>