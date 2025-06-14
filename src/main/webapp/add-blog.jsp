<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Thêm Blog Mới</title>
  <jsp:include page="common-css.jsp"/>

  <style>
    .form-container {
      background: #fff;
      padding: 40px;
      border-radius: 10px;
      box-shadow: 0 0 20px rgba(0,0,0,0.1);
      margin: 40px 0;
    }

    .form-group {
      margin-bottom: 20px;
    }

    .form-group label {
      display: inline-block;
      margin-bottom: 8px;
      font-weight: 600;
      color: #333;
      font-size: 14px;
    }

    .form-control {
      width: 100%;
      padding: 12px 15px;
      border: 2px solid #e1e1e1;
      border-radius: 5px;
      font-size: 14px;
      transition: border-color 0.3s ease;
    }

    .form-control:focus {
      outline: none;
      border-color: #007bff;
      box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
    }

    .btn-primary {
      background-color: #007bff;
      border-color: #007bff;
      padding: 12px 30px;
      font-size: 16px;
      font-weight: 600;
      border-radius: 5px;
      transition: all 0.3s ease;
    }

    .btn-primary:hover {
      background-color: #0056b3;
      border-color: #0056b3;
      transform: translateY(-2px);
    }

    .btn-secondary {
      background-color: #6c757d;
      border-color: #6c757d;
      padding: 12px 30px;
      font-size: 16px;
      font-weight: 600;
      border-radius: 5px;
      margin-right: 10px;
    }

    .image-preview {
      max-width: 300px;
      max-height: 200px;
      margin-top: 10px;
      border-radius: 5px;
      display: none;
      object-fit: cover;
      border: 1px solid #e1e1e1;
    }

    .required {
      color: #dc3545;
    }

    .alert {
      padding: 15px;
      margin-bottom: 20px;
      border: 1px solid transparent;
      border-radius: 4px;
    }

    .alert-success {
      color: #155724;
      background-color: #d4edda;
      border-color: #c3e6cb;
    }

    .alert-danger {
      color: #721c24;
      background-color: #f8d7da;
      border-color: #f5c6cb;
    }

    .page-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 60px 0;
      margin-bottom: 0;
    }

    .page-header h1 {
      font-size: 2.5rem;
      font-weight: 700;
      margin-bottom: 10px;
    }

    .page-header p {
      font-size: 1.1rem;
      opacity: 0.9;
    }

    /* CSS Grid */
    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
    }

    /* Tạo các cột cho mỗi form-group */
    .form-group {
      margin-bottom: 20px;
    }

    /* Đảm bảo các trường input chiếm toàn bộ chiều rộng */
    .form-control {
      width: 100%;
    }

    /* Khi màn hình nhỏ, các cột sẽ chồng lên nhau */
    @media (max-width: 768px) {
      .form-row {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body>
<jsp:include page="header.jsp"/>

<main>
  <div class="page-header">
    <div class="container">
      <div class="row">
        <div class="col-12 text-center">
          <h1>Thêm Blog Mới</h1>
          <p>Chia sẻ kiến thức và kinh nghiệm của bạn</p>
        </div>
      </div>
    </div>
  </div>

  <section class="section-padding">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-lg-10">
          <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
          </c:if>
          <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
          </c:if>

          <form action="add-blog" method="post" enctype="multipart/form-data">
            <div class="form-group">
              <label for="blogName">Tiêu đề bài viết <span class="required">*</span></label>
              <input type="text" class="form-control" id="blogName" name="blogName" required maxlength="200">
            </div>

            <div class="form-group">
              <label for="blogSubContent">Tóm tắt nội dung <span class="required">*</span></label>
              <textarea class="form-control" id="blogSubContent" name="blogSubContent" rows="3" required maxlength="500"></textarea>
            </div>

            <div class="form-group">
              <label for="content">Nội dung chi tiết <span class="required">*</span></label>
              <textarea class="form-control" id="content" name="content" rows="15" required></textarea>
            </div>

            <div class="form-group">
              <label for="categoryId">Danh mục <span class="required">*</span></label>
              <select class="form-control" id="categoryId" name="categoryId">
                <option value="">-- Chọn danh mục --</option>
                <c:forEach var="category" items="${categories}">
                  <option value="${category.categoryId}">${category.categoryName}</option>
                </c:forEach>
              </select>
            </div>

            <div class="form-group">
              <label for="author">Tác giả <span class="required">*</span></label>
              <input type="text" class="form-control" id="author" name="author" required maxlength="100">
            </div>

            <div class="form-group">
              <label for="blogImage">Hình ảnh đại diện</label>
              <input type="file" class="form-control" id="blogImage" name="blogImage" accept="image/*" onchange="previewImage(this)">
              <small class="text-muted">Chấp nhận JPG, PNG, GIF (tối đa 5MB)</small>
              <img id="imagePreview" class="image-preview" alt="Preview">
            </div>

            <div class="form-group text-center mt-4">
              <button type="button" class="btn btn-secondary" onclick="history.back()">
                <i class="fa fa-arrow-left"></i> Quay lại
              </button>
              <button type="submit" class="btn btn-primary">
                <i class="fa fa-save"></i> Gửi bài viết
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </section>
</main>

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
</script>

<jsp:include page="footer.jsp"/>
<jsp:include page="common-scripts.jsp"/>

</body>
</html>
