<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Blog - Hospital Admin</title>

    <!-- Bootstrap 4 CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- Hospital Admin CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/hospital-admin.css">
</head>
<body>
<div class="hospital-admin">
    <!-- Sidebar -->
    <div class="sidebar">
        <!-- Hospital Header -->
        <div class="hospital-header">
            <div class="hospital-logo">
                <div class="hospital-icon">
                    <a href="Admin/home-admin-dashboard.jsp">
                        <i class="fas fa-stethoscope"></i>
                    </a>
                </div>
                <div>
                    <a href="Admin/home-admin-dashboard.jsp">
                        <h2 class="hospital-title">Hospital Admin</h2>
                        <p class="hospital-subtitle">Hospital Management</p>
                    </a>
                </div>
            </div>
        </div>

        <!-- Navigation Menu -->
        <nav class="nav-menu">
            <ul>
                <li>
                    <a href="Admin/home-admin-dashboard.jsp" class="nav-link">
                        <i class="fas fa-home"></i>
                        <span>Home</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/blog-dashboard" class="nav-link">
                        <i class="fas fa-blog"></i>
                        <span>Blog</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-podcast"></i>
                        <span>Post</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-cog"></i>
                        <span>Settings</span>
                    </a>
                </li>
            </ul>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Content Header -->
        <div class="content-header">
            <div class="page-header">
                <h1>Add New Blog</h1>
                <p class="page-subtitle">Share medical knowledge and experience</p>
            </div>
        </div>

        <!-- Content Body -->
        <div class="content-body">
            <div class="form-container">
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle mr-2"></i>${successMessage}
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle mr-2"></i>${errorMessage}
                    </div>
                </c:if>

                <form action="add-blog" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="blogName">Article Title <span class="required">*</span></label>
                        <input type="text" class="form-control" id="blogName" name="blogName" required maxlength="200" placeholder="Enter article title...">
                    </div>

                    <div class="form-group">
                        <label for="blogSubContent">Content Summary <span class="required">*</span></label>
                        <textarea class="form-control" id="blogSubContent" name="blogSubContent" rows="3" required maxlength="500" placeholder="Enter a brief summary of the article content..."></textarea>
                    </div>

                    <div class="form-group">
                        <label for="content">Detailed Content <span class="required">*</span></label>
                        <textarea id="content" name="content" rows="10" required></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="categoryId">Category <span class="required">*</span></label>
                            <select class="form-control" id="categoryId" name="categoryId" required onchange="toggleNewCategoryInput()">
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.categoryId}">${category.categoryName}</option>
                                </c:forEach>
                                <option value="other">Other</option>
                            </select>
                            <input type="text" class="form-control mt-2" id="newCategoryName" name="newCategoryName" placeholder="Enter new category name..." style="display:none;">
                        </div>

                        <div class="form-group">
                            <label for="author">Author <span class="required">*</span></label>
                            <input type="text" class="form-control" id="author" name="author" required maxlength="100" placeholder="Enter author name...">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="blogImage">Featured Image</label>
                        <div class="file-upload-wrapper">
                            <input type="file" class="form-control" id="blogImage" name="blogImage" accept="image/*" onchange="previewImage(this)">
                            <div class="file-upload-text">Accept JPG, PNG, GIF (max 5MB)</div>
                            <img id="imagePreview" class="image-preview" alt="Preview">
                        </div>
                    </div>

                    <div class="form-group text-center mt-4">
                        <button type="button" class="btn-hospital btn-secondary" onclick="history.back()">
                            <i class="fas fa-arrow-left mr-2"></i>Back
                        </button>
                        <button type="submit" class="btn-hospital btn-primary">
                            <i class="fas fa-save mr-2"></i>Submit Article
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- jQuery and Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script src="${pageContext.request.contextPath}/assets/ckeditor_4.20.2_full/ckeditor/ckeditor.js"></script>
<script>
    CKEDITOR.replace('content', {
        filebrowserUploadUrl: '${pageContext.request.contextPath}/upload-image-blog',
        filebrowserUploadMethod: 'form',

        // Default font configuration
        contentsCss: 'https://fonts.googleapis.com/css?family=Times+New+Roman',  // optional
        font_names: 'Times New Roman/Times New Roman, Times, serif;' + CKEDITOR.config.font_names,
        defaultFont: 'Times New Roman',

        // Set default font when opening editor
        on: {
            instanceReady: function(ev) {
                this.document.getBody().setStyle('font-family', 'Times New Roman, Times, serif');
            }
        }
    });
</script>

<script>
    function previewImage(input) {
        const file = input.files[0];
        const preview = document.getElementById('imagePreview');
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.src = e.target.result;
                preview.style.display = 'block';
            };
            reader.readAsDataURL(file);
        } else {
            preview.src = '';
            preview.style.display = 'none';
        }
    }

    // Navigation active state
    $('.nav-link').click(function(e) {
        if ($(this).attr('href') === '#') {
            e.preventDefault();
        }
        $('.nav-link').removeClass('active');
        $(this).addClass('active');
    });

    // Mobile responsive
    $(window).resize(function() {
        if ($(window).width() <= 768) {
            $('.sidebar').addClass('mobile');
        } else {
            $('.sidebar').removeClass('mobile');
        }
    }).trigger('resize');

    // Form validation
    $('form').on('submit', function(e) {
        let isValid = true;

        // Check required fields
        $(this).find('[required]').each(function() {
            if (!$(this).val().trim()) {
                isValid = false;
                $(this).addClass('is-invalid');
            } else {
                $(this).removeClass('is-invalid');
            }
        });

        if (!isValid) {
            e.preventDefault();
            alert('Please fill in all required information!');
        }
    });

    // Remove validation error on input
    $('.form-control').on('input change', function() {
        $(this).removeClass('is-invalid');
    });

    function toggleNewCategoryInput() {
        var select = document.getElementById('categoryId');
        var newCatInput = document.getElementById('newCategoryName');
        if (select.value === 'other') {
            newCatInput.style.display = 'block';
            newCatInput.required = true;
        } else {
            newCatInput.style.display = 'none';
            newCatInput.required = false;
            newCatInput.value = '';
        }
    }
</script>

<style>
    .form-control.is-invalid {
        border-color: #dc2626;
        box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
    }
</style>

</body>
</html>
