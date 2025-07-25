<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Blog - Hospital Admin</title>

  <!-- Bootstrap 4 CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <!-- Hospital Admin CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Manager/css/hospital-admin.css">

</head>
<body>
<div class="hospital-admin">
  <!-- Sidebar -->
  <div class="sidebar d-flex flex-column">
    <!-- Hospital Header -->
    <div class="hospital-header p-3">
      <div class="hospital-logo d-flex align-items-center">
        <div class="hospital-icon mr-2">
          <a href="${pageContext.request.contextPath}/manager-dashboard">
            <i class="fas fa-user-tie fa-2x"></i>
          </a>
        </div>
        <div>
          <a href="${pageContext.request.contextPath}/manager-dashboard" style="text-decoration: none;">
            <h4 class="hospital-title mb-0">Manager Portal</h4>
            <small class="hospital-subtitle text-muted">Hospital Management</small>
          </a>
        </div>
      </div>
    </div>

    <!-- Navigation Menu -->
    <nav class="nav-menu flex-grow-1">
      <ul class="nav flex-column px-3">
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/manager-dashboard" class="nav-link">
            <i class="fas fa-tachometer-alt"></i> <span>Dashboard</span>
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/update-user-role" class="nav-link">
            <i class="fas fa-users-cog"></i> <span>User Management</span>
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/hospital-statistics" class="nav-link">
            <i class="fas fa-chart-bar"></i> <span>Revenue Report</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/export-activity-report" class="nav-link">
            <i class="fas fa-file-invoice-dollar"></i> <span>Income Report</span>
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/add-doctor-form" class="nav-link">
            <i class="fas fa-user-plus"></i> <span>Add Staff</span>
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/assign-doctor-schedule" class="nav-link">
            <i class="fas fa-calendar-alt"></i> <span>Doctor Schedules</span>
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/unassigned-appointments" class="nav-link">
            <i class="fas fa-calendar-times"></i> <span>Unassigned Appointments</span>
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/request-leave-list" class="nav-link">
            <i class="fas fa-user-clock"></i> <span>Leave Requests</span>
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/blog-dashboard" class="nav-link active">
            <i class="fas fa-podcast"></i> <span>Blog Dashboard</span>
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/change-history-log" class="nav-link">
            <i class="fas fa-history"></i> <span>Change History</span>
          </a>
        </li>
      </ul>
    </nav>

    <!-- Logout at bottom -->
    <div class="logout-section mt-auto px-3 pb-3">
      <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger">
        <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
      </a>
    </div>
  </div>

  <!-- Main Content -->
  <div class="main-content">
    <!-- Content Header -->
    <div class="content-header">
      <div class="page-header">
        <h1>Edit Blog</h1>
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

        <form action="${pageContext.request.contextPath}/edit-blog" method="POST" enctype="multipart/form-data">
          <!-- Debug: Display blogId value for checking -->
          <input type="hidden" name="blogId" id="blogId" value="${blog.blogId}" />
          <div class="form-group">
            <label for="blogName">Article Title <span class="required">*</span></label>
            <input type="text" class="form-control" id="blogName" name="blogName" required maxlength="200" placeholder="Enter article title..."
                   value="${blog.blogName}">
          </div>

          <div class="form-group">
            <label for="blogSubContent">Content Summary <span class="required">*</span></label>
            <textarea class="form-control" id="blogSubContent" name="blogSubContent" rows="3" required maxlength="500" placeholder="Enter a brief summary of the article content...">${blog.blogSubContent}</textarea>
          </div>

          <div class="form-group">
            <label for="content">Detailed Content <span class="required">*</span></label>
            <textarea class="form-control" id="content" name="content" rows="12" required placeholder="Enter detailed article content...">${blog.content}</textarea>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="categoryId">Category <span class="required">*</span></label>
              <select class="form-control" id="categoryId" name="categoryId" required onchange="toggleNewCategoryInput()">
                <c:forEach var="category" items="${categories}">
                  <option value="${category.categoryId}" <c:if test="${category.categoryId == blog.categoryId}">selected</c:if>>${category.categoryName}</option>
                </c:forEach>
                <option value="other">Other</option>
              </select>
              <input type="text" class="form-control mt-2" id="newCategoryName" name="newCategoryName" placeholder="Enter new category name..." style="display:none;">
            </div>

            <div class="form-group">
              <label for="author">Author <span class="required">*</span></label>
              <input type="text" class="form-control" id="author" name="author" required maxlength="100" placeholder="Enter author name..."
                     value="${blog.author}">
            </div>
          </div>

          <div class="form-group">
            <label for="blogImage">Featured Image</label>
            <div class="file-upload-wrapper">
              <input type="file" class="form-control" id="blogImage" name="blogImage" accept="image/*" onchange="previewImage(this)">
              <div class="file-upload-text">Accept JPG, PNG, GIF (max 5MB)</div>
              <c:if test="${not empty blog.blogImg}">
                <img id="imagePreview" class="image-preview" alt="Preview" src="${pageContext.request.contextPath}/${blog.blogImg}" style="display:block;">
              </c:if>
              <c:if test="${empty blog.blogImg}">
                <img id="imagePreview" class="image-preview" alt="Preview" style="display:none;">
              </c:if>
            </div>
          </div>

          <div class="form-group text-center mt-4">
            <button type="button" class="btn-hospital btn-secondary" onclick="history.back()">
              <i class="fas fa-arrow-left mr-2"></i>Back
            </button>
            <button type="submit" class="btn-hospital btn-primary">
              <i class="fas fa-save mr-2"></i>Save Changes
            </button>
          </div>
          <!-- Debug: Display form data before submit -->
          <script>
            document.getElementById('editBlogForm').onsubmit = function(e) {
              const fd = new FormData(this);
              for (const [k, v] of fd.entries()) {
                console.log('[DEBUG][FORM]', k, v);
              }
              // e.preventDefault();
            };
          </script>
        </form>
      </div>
    </div>
  </div>
</div>

<!-- jQuery and Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<!-- CKEditor 4 -->
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
    // Save old image src to restore if no new file is selected
    const oldSrc = preview.getAttribute('data-old-src') || preview.src;
    if (!preview.getAttribute('data-old-src')) {
      preview.setAttribute('data-old-src', oldSrc);
    }
    if (file) {
      const reader = new FileReader();
      reader.onload = function (e) {
        preview.src = e.target.result;
        preview.style.display = 'block';
      };
      reader.readAsDataURL(file);
    } else {
      // If no new file is selected, restore old image (if any)
      preview.src = oldSrc;
      if (oldSrc && oldSrc !== '') {
        preview.style.display = 'block';
      } else {
        preview.style.display = 'none';
      }
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
  // If needed, automatically show new category input if there's old data
  window.onload = function() {
    toggleNewCategoryInput();
  };
</script>

<style>
  .form-control.is-invalid {
    border-color: #dc2626;
    box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
  }
</style>

</body>
</html>
