<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Thêm Blog Mới - Hospital Admin</title>

  <!-- Bootstrap 4 CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen-Sans, Ubuntu, Cantarell, "Helvetica Neue", sans-serif;
      background-color: #f8f9fa;
      margin: 0;
    }

    /* Main Layout */
    .hospital-admin {
      display: flex;
      min-height: 100vh;
    }

    /* Sidebar */
    .sidebar {
      width: 280px;
      background: #ffffff;
      border-right: 1px solid #e9ecef;
      position: fixed;
      top: 0;
      left: 0;
      bottom: 0;
      overflow-y: auto;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }

    /* Hospital Logo Header */
    .hospital-header {
      padding: 24px 20px;
      border-bottom: 1px solid #e9ecef;
      background: #ffffff;
    }

    .hospital-logo {
      display: flex;
      align-items: center;
      margin-bottom: 8px;
    }

    .hospital-icon {
      width: 48px;
      height: 48px;
      background: #4285f4;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 12px;
    }

    .hospital-icon i {
      color: white;
      font-size: 24px;
    }

    .hospital-title {
      font-size: 20px;
      font-weight: 600;
      color: #1f2937;
      margin: 0;
    }

    .hospital-subtitle {
      color: #6b7280;
      font-size: 14px;
      margin: 0;
      margin-top: 4px;
    }

    /* Navigation Menu */
    .nav-menu {
      padding: 16px 0;
    }

    .nav-menu ul {
      margin: 0;
      padding: 0;
      list-style: none;
    }

    .nav-menu li {
      margin: 0;
    }

    .nav-menu a {
      display: flex;
      align-items: center;
      padding: 12px 20px;
      color: #6b7280;
      text-decoration: none;
      font-size: 15px;
      font-weight: 500;
      transition: all 0.2s ease;
      border-left: 3px solid transparent;
    }

    .nav-menu a:hover {
      background-color: #f3f4f6;
      color: #374151;
      text-decoration: none;
    }

    .nav-menu a.active {
      background-color: #dbeafe;
      color: #1d4ed8;
      border-left-color: #1d4ed8;
    }

    .nav-menu i {
      width: 20px;
      margin-right: 12px;
      font-size: 18px;
      text-align: center;
    }

    /* Main Content */
    .main-content {
      margin-left: 280px;
      flex: 1;
      background: #f8f9fa;
      min-height: 100vh;
    }

    .content-header {
      background: #ffffff;
      padding: 20px 24px;
      border-bottom: 1px solid #e9ecef;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }

    .content-body {
      padding: 24px;
    }

    /* Page Header */
    .page-header h1 {
      font-size: 28px;
      font-weight: 600;
      color: #1f2937;
      margin: 0;
    }

    .page-subtitle {
      color: #6b7280;
      font-size: 16px;
      margin-top: 4px;
    }

    /* Form Container */
    .form-container {
      background: #ffffff;
      padding: 32px;
      border-radius: 12px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      border: 1px solid #e9ecef;
    }

    .form-group {
      margin-bottom: 24px;
    }

    .form-group label {
      display: block;
      margin-bottom: 8px;
      font-weight: 600;
      color: #374151;
      font-size: 14px;
    }

    .form-control {
      width: 100%;
      padding: 12px 16px;
      border: 1px solid #d1d5db;
      border-radius: 8px;
      height: auto;
      font-size: 14px;
      transition: all 0.2s ease;
      background: #ffffff;
    }

    .form-control:focus {
      outline: none;
      border-color: #4285f4;
      box-shadow: 0 0 0 3px rgba(66, 133, 244, 0.1);
    }

    .form-control:hover {
      border-color: #9ca3af;
    }

    /* Buttons */
    .btn-hospital {
      display: inline-flex;
      align-items: center;
      padding: 12px 24px;
      font-size: 14px;
      font-weight: 500;
      border-radius: 8px;
      border: 1px solid #d1d5db;
      background: #ffffff;
      color: #374151;
      text-decoration: none;
      cursor: pointer;
      transition: all 0.2s ease;
      margin-right: 12px;
    }

    .btn-hospital:hover {
      background: #f9fafb;
      border-color: #9ca3af;
      text-decoration: none;
      color: #374151;
    }

    .btn-primary {
      background: #4285f4;
      border-color: #4285f4;
      color: #ffffff;
    }

    .btn-primary:hover {
      background: #3367d6;
      border-color: #3367d6;
      color: #ffffff;
    }

    .btn-secondary {
      background: #6b7280;
      border-color: #6b7280;
      color: #ffffff;
    }

    .btn-secondary:hover {
      background: #4b5563;
      border-color: #4b5563;
      color: #ffffff;
    }

    /* Image Preview */
    .image-preview {
      max-width: 300px;
      max-height: 200px;
      margin-top: 12px;
      border-radius: 8px;
      display: none;
      object-fit: cover;
      border: 1px solid #e5e7eb;
    }

    /* Required Field */
    .required {
      color: #dc2626;
    }

    /* Alerts */
    .alert {
      padding: 16px;
      margin-bottom: 24px;
      border: 1px solid transparent;
      border-radius: 8px;
      font-size: 14px;
    }

    .alert-success {
      color: #065f46;
      background-color: #d1fae5;
      border-color: #a7f3d0;
    }

    .alert-danger {
      color: #991b1b;
      background-color: #fee2e2;
      border-color: #fecaca;
    }

    /* Form Layout */
    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 24px;
    }

    .form-group-full {
      grid-column: 1 / -1;
    }

    /* File Upload */
    .file-upload-wrapper {
      position: relative;
    }

    .file-upload-text {
      font-size: 12px;
      color: #6b7280;
      margin-top: 4px;
    }

    /* Responsive */
    @media screen and (max-width: 768px) {
      .sidebar {
        width: 60px;
      }

      .main-content {
        margin-left: 60px;
      }

      .hospital-header {
        padding: 16px 12px;
      }

      .hospital-title,
      .hospital-subtitle {
        display: none;
      }

      .nav-menu a {
        padding: 16px 12px;
        justify-content: center;
      }

      .nav-menu span {
        display: none;
      }

      .nav-menu i {
        margin-right: 0;
      }

      .form-row {
        grid-template-columns: 1fr;
      }

      .content-body {
        padding: 16px;
      }

      .form-container {
        padding: 24px 16px;
      }
    }
  </style>
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
            <p class="hospital-subtitle">Quản lý bệnh viện</p>
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
            <span>Trang chủ</span>
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
            <span>Cài đặt</span>
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
        <h1>Chỉnh sửa Blog</h1>
        <p class="page-subtitle">Chia sẻ kiến thức và kinh nghiệm y tế</p>
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
          <!-- Debug: Hiển thị giá trị blogId để kiểm tra -->
          <input type="hidden" name="blogId" id="blogId" value="${blog.blogId}" />
          <div class="form-group">
            <label for="blogName">Tiêu đề bài viết <span class="required">*</span></label>
            <input type="text" class="form-control" id="blogName" name="blogName" required maxlength="200" placeholder="Nhập tiêu đề bài viết..."
                   value="${blog.blogName}">
          </div>

          <div class="form-group">
            <label for="blogSubContent">Tóm tắt nội dung <span class="required">*</span></label>
            <textarea class="form-control" id="blogSubContent" name="blogSubContent" rows="3" required maxlength="500" placeholder="Nhập tóm tắt ngắn gọn về nội dung bài viết...">${blog.blogSubContent}</textarea>
          </div>

          <div class="form-group">
            <label for="content">Nội dung chi tiết <span class="required">*</span></label>
            <textarea class="form-control" id="content" name="content" rows="12" required placeholder="Nhập nội dung chi tiết của bài viết...">${blog.content}</textarea>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="categoryId">Danh mục <span class="required">*</span></label>
              <select class="form-control" id="categoryId" name="categoryId" required onchange="toggleNewCategoryInput()">
                <c:forEach var="category" items="${categories}">
                  <option value="${category.categoryId}" <c:if test="${category.categoryId == blog.categoryId}">selected</c:if>>${category.categoryName}</option>
                </c:forEach>
                <option value="other">Khác</option>
              </select>
              <input type="text" class="form-control mt-2" id="newCategoryName" name="newCategoryName" placeholder="Nhập tên danh mục mới..." style="display:none;">
            </div>

            <div class="form-group">
              <label for="author">Tác giả <span class="required">*</span></label>
              <input type="text" class="form-control" id="author" name="author" required maxlength="100" placeholder="Nhập tên tác giả..."
                     value="${blog.author}">
            </div>
          </div>

          <div class="form-group">
            <label for="blogImage">Hình ảnh đại diện</label>
            <div class="file-upload-wrapper">
              <input type="file" class="form-control" id="blogImage" name="blogImage" accept="image/*" onchange="previewImage(this)">
              <div class="file-upload-text">Chấp nhận JPG, PNG, GIF (tối đa 5MB)</div>
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
              <i class="fas fa-arrow-left mr-2"></i>Quay lại
            </button>
            <button type="submit" class="btn-hospital btn-primary">
              <i class="fas fa-save mr-2"></i>Lưu thay đổi
            </button>
          </div>
          <!-- Debug: Hiển thị dữ liệu form trước khi submit -->
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

    // Cấu hình font mặc định
    contentsCss: 'https://fonts.googleapis.com/css?family=Times+New+Roman',  // optional
    font_names: 'Times New Roman/Times New Roman, Times, serif;' + CKEDITOR.config.font_names,
    defaultFont: 'Times New Roman',

    // Đặt font mặc định khi mở editor
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
    // Lưu lại src ảnh cũ để có thể trả lại nếu không chọn file mới
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
      // Nếu không chọn file mới, trả lại ảnh cũ (nếu có)
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
      alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
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
  // Nếu cần, tự động hiển thị ô nhập danh mục mới nếu có dữ liệu cũ
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