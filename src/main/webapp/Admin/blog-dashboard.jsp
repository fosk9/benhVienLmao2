<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý Blog - Hospital Admin</title>

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

    /* Empty State */
    .empty-state {
      text-align: center;
      padding: 48px 24px;
      background-color: #f9fafb; /* Light background to distinguish the section */
      border-radius: 12px; /* Rounded corners */
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Soft shadow for depth */
      border: 1px solid #e5e7eb; /* Border color */
      max-width: none; /* Limit the width */
      margin: 0 auto; /* Center the element */
      transition: all 0.3s ease; /* Smooth transition for hover effect */
    }


    .empty-state i {
      font-size: 48px;
      color: #6b7280; /* Soft grey for the icon */
      margin-bottom: 16px;
      transition: color 0.3s ease; /* Transition effect for the icon */
    }

    .empty-state i:hover {
      color: #1d4ed8; /* Change icon color on hover */
    }

    .empty-state h3 {
      font-size: 24px;
      font-weight: 600;
      color: #374151; /* Dark grey for the heading */
      margin-bottom: 8px;
    }

    .empty-state p {
      color: #6b7280; /* Soft grey for the text */
      font-size: 14px;
      margin-top: 0;
    }

    .empty-state p a {
      color: #1d4ed8; /* Blue color for links */
      font-weight: 600;
      text-decoration: none; /* Remove underline */
    }

    .empty-state p a:hover {
      text-decoration: underline; /* Underline on hover */
    }

    /* Layout */
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

    /* Sidebar Header */
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
    }

    .nav-menu a.active {
      background-color: #dbeafe;
      color: #1d4ed8;
      border-left-color: #1d4ed8;
    }

    /* Main Content */
    .main-content {
      margin-left: 280px;
      flex: 1;
      background: #f8f9fa;
      min-height: 100vh;
    }

    /* Content Header */
    .content-header {
      background: #ffffff;
      padding: 20px 24px;
      border-bottom: 1px solid #e9ecef;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }

    /* Content Body */
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

    /* Stats Cards */
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 24px;
      margin-bottom: 32px;
    }

    .stat-card {
      background: #ffffff;
      padding: 24px;
      border-radius: 12px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      border: 1px solid #e9ecef;
    }

    .stat-card-content {
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .stat-info h3 {
      font-size: 32px;
      font-weight: 700;
      margin: 0;
      margin-bottom: 4px;
    }

    .stat-info p {
      font-size: 14px;
      font-weight: 500;
      color: #6b7280;
      margin: 0;
    }

    .stat-icon {
      width: 48px;
      height: 48px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .stat-icon i {
      font-size: 24px;
    }

    .stat-blue { color: #4285f4; background: #e3f2fd; }
    .stat-green { color: #10b981; background: #d1fae5; }
    .stat-yellow { color: #f59e0b; background: #fef3c7; }
    .stat-purple { color: #8b5cf6; background: #ede9fe; }

    /* Filter Section */
    .filter-section {
      background: #ffffff;
      padding: 24px;
      border-radius: 12px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      border: 1px solid #e9ecef;
      margin-bottom: 24px;
    }

    .filter-row {
      display: grid;
      grid-template-columns: 2fr 1fr 1fr;
      gap: 16px;
      align-items: end;
    }

    /* Blog Table */
    .blog-table-container {
      background: #ffffff;
      border-radius: 12px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      border: 1px solid #e9ecef;
      overflow: hidden;
    }

    .table-header {
      padding: 20px 24px;
      border-bottom: 1px solid #e9ecef;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .table-header h3 {
      font-size: 18px;
      font-weight: 600;
      color: #1f2937;
      margin: 0;
    }

    .blog-table {
      width: 100%;
      border-collapse: collapse;
    }

    .blog-table th {
      background: #f8f9fa;
      padding: 16px 20px;
      text-align: left;
      font-weight: 600;
      color: #374151;
      font-size: 14px;
      border-bottom: 1px solid #e9ecef;
    }

    .blog-table td {
      padding: 16px 20px;
      border-bottom: 1px solid #f3f4f6;
      vertical-align: middle;
    }

    .blog-table tr:hover {
      background: #f9fafb;
    }

    /* Blog Info */
    .blog-info {
      display: flex;
      align-items: center;
    }

    .blog-image {
      width: 64px;
      height: 48px;
      object-fit: cover;
      border-radius: 8px;
      margin-right: 16px;
    }

    .blog-details h4 {
      font-size: 14px;
      font-weight: 600;
      color: #1f2937;
      margin: 0 0 4px 0;
      line-height: 1.4;
    }

    .blog-details p {
      font-size: 12px;
      color: #6b7280;
      margin: 0;
      line-height: 1.4;
    }

    /* Badges */
    .badge {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 500;
    }

    .badge-published {
      background: #d1fae5;
      color: #065f46;
    }

    .badge-draft {
      background: #fef3c7;
      color: #92400e;
    }

    .badge-category {
      background: #f3f4f6;
      color: #374151;
      border: 1px solid #d1d5db;
    }

    /* Buttons */
    .btn-hospital {
      display: inline-flex;
      align-items: center;
      padding: 8px 16px;
      font-size: 14px;
      font-weight: 500;
      border-radius: 8px;
      border: 1px solid #d1d5db;
      background: #ffffff;
      color: #374151;
      text-decoration: none;
      cursor: pointer;
      transition: all 0.2s ease;
      margin-right: 8px;
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

    /* Form Controls */
    .form-control {
      width: 100%;
      height: auto;
      padding: 12px 16px;
      border: 1px solid #d1d5db;
      border-radius: 8px;
      font-size: 14px;
      transition: all 0.2s ease;
      background: #ffffff;
    }

    .form-control:focus {
      outline: none;
      border-color: #4285f4;
      box-shadow: 0 0 0 3px rgba(66, 133, 244, 0.1);
    }

    .form-group {
      margin-bottom: 16px;
    }

    .form-group label {
      display: block;
      margin-bottom: 6px;
      font-weight: 600;
      color: #374151;
      font-size: 14px;
    }

    /* Phần pagination */
    .pagination {
      display: flex;
      justify-content: center;
      align-items: center;
      margin-top: 30px;
      padding: 10px 0;
    }

    .pagination a {
      color: #000000;
      font-size: 16px;
      font-weight: 600;
      margin: 0 10px;
      padding: 8px 16px;
      text-decoration: none;
      border: 1px solid #ddd;
      border-radius: 8px;
      transition: background-color 0.3s ease, color 0.3s ease;
    }

    .pagination a:hover {
      background-color: #f1f1f1;
      color: #0056b3;
    }

    .pagination a.active {
      background-color: #007bff;
      color: white;
      border-color: #007bff;
    }

    .pagination a.disabled {
      color: #ccc;
      pointer-events: none;
      cursor: not-allowed;
    }

    .pagination a.disabled:hover {
      background-color: transparent;
      color: #ccc;
    }

    .pagination a:first-child, .pagination a:last-child {
      padding: 8px 20px; /* Cải thiện kích thước cho các nút "Previous" và "Next" */
    }

    .pagination .page-numbers {
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .pagination .page-numbers a {
      margin: 0 5px;
      padding: 8px 12px;
    }

    .pagination .page-numbers a:hover {
      background-color: #f1f1f1;
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

      .hospital-title, .hospital-subtitle {
        display: none;
      }

      .nav-menu a {
        padding: 16px 12px;
        justify-content: center;
      }

      .nav-menu span {
        display: none;
      }

      .stats-grid {
        grid-template-columns: 1fr;
      }

      .filter-row {
        grid-template-columns: 1fr;
      }

      .content-body {
        padding: 16px;
      }

      .blog-table-container {
        overflow-x: auto;
      }

      .blog-table {
        min-width: 800px;
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
          <a href="Admin/home-admin-dashboard.jsp" style="text-decoration: none;">
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
          <a href="${pageContext.request.contextPath}/blog-dashboard" class="nav-link active">
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
        <div style="display: flex; align-items: center; justify-content: space-between;">
          <div>
            <h1>Quản lý Blog</h1>
            <p class="page-subtitle">Quản lý và theo dõi các bài viết blog</p>
          </div>
          <a href="${pageContext.request.contextPath}/add-blog" class="btn-hospital btn-primary">
            <i class="fas fa-plus mr-2"></i>Thêm blog mới
          </a>
        </div>
      </div>
    </div>

    <!-- Content Body -->
    <div class="content-body">
      <!-- Stats Cards -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-blue">${totalBlogs}</h3>
              <p>Tổng số blog</p>
            </div>
            <div class="stat-icon stat-blue">
              <i class="fas fa-blog"></i>
            </div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-green"></h3>
              <p>Đã xuất bản</p>
            </div>
            <div class="stat-icon stat-green">
              <i class="fas fa-eye"></i>
            </div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-yellow"></h3>
              <p>Bản nháp</p>
            </div>
            <div class="stat-icon stat-yellow">
              <i class="fas fa-edit"></i>
            </div>
          </div>
        </div>

      </div>

      <!-- Filter Section -->
      <div class="filter-section">
        <form method="get" action="${pageContext.request.contextPath}/blog-dashboard">
          <div class="filter-row">
            <div class="form-group">
              <label>Tìm kiếm</label>
              <div class="search-wrapper">
                <i class="fas fa-search"></i>
                <input type="text" class="form-control" id="searchInput" name="keyword"
                       placeholder="Tìm kiếm theo tiêu đề hoặc tác giả..."
                       value="${keyword != null ? keyword : ''}">
              </div>
            </div>
            <div class="form-group">
              <label>Danh mục</label>
              <select class="form-control" id="categoryFilter" name="categoryId" onchange="this.form.submit()">
                <option value="">Tất cả danh mục</option>
                <c:forEach var="category" items="${categories}">
                  <option value="${category.categoryId}" <c:if test="${selectedCategoryId != null && category.categoryId == selectedCategoryId}">selected</c:if>>
                    ${category.categoryName}
                  </option>
                </c:forEach>
              </select>
            </div>
            <div class="form-group">
              <label>Trạng thái</label>
              <select class="form-control" id="statusFilter" disabled>
                <option value="">Tất cả trạng thái</option>
                <option value="published">Đã xuất bản</option>
                <option value="draft">Bản nháp</option>
              </select>
            </div>
          </div>
        </form>
        <c:if test="${not empty errorMessage}">
          <div class="alert alert-warning mt-3">${errorMessage}</div>
        </c:if>
      </div>

      <!-- Blog Table -->
      <div class="blog-table-container">
        <div class="table-header">
          <h3>Danh sách blog (<span id="blogCount"><c:out value="${fn:length(blogList)}"/></span>)</h3>
        </div>
        <table class="blog-table" id="blogTable">
          <thead>
          <tr>
            <th>Bài viết</th>
            <th>Tác giả</th>
            <th>Danh mục</th>
            <th>Ngày tạo</th>
            <th>Comments</th>
            <th>Thao tác</th>
          </tr>
          </thead>
          <tbody id="blogTableBody">
          <c:forEach var="blog" items="${blogList}">
            <tr data-category="${blog.categoryId}" data-title="${fn:toLowerCase(blog.blogName)}" data-author="${fn:toLowerCase(blog.author)}">
              <td>${blog.blogName}</td>
              <td>${blog.author}</td>
              <td><span class="badge badge-category">${blog.categoryName}</span></td>
              <td><fmt:formatDate value="${blog.date}" pattern="dd/MM/yyyy"/></td>
              <td>${blog.commentCount}</td>
              <td>
                <div class="btn-group" role="group">
                  <a href="${pageContext.request.contextPath}/blog-detail?id=${blog.blogId}" class="btn-hospital btn-primary btn-sm" title="Xem chi tiết">
                    <i class="fas fa-eye"></i>
                  </a>
                  <a href="${pageContext.request.contextPath}/blog-dashboard/edit?blogId=${blog.blogId}" class="btn-hospital btn-sm" title="Chỉnh sửa">
                    <i class="fas fa-edit"></i>
                  </a>
                  <a href="${pageContext.request.contextPath}/blog-dashboard/delete?blogId=${blog.blogId}" class="btn-hospital btn-sm text-danger" title="Xóa"
                     onclick="return confirm('Bạn có chắc chắn muốn xóa bài viết này?');">
                    <i class="fas fa-trash"></i>
                  </a>
                </div>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
        <div class="pagination">
          <c:if test="${currentPage > 1}">
            <a href="${pageContext.request.contextPath}/blog-dashboard?page=${currentPage - 1}" class="btn-hospital">
              &laquo; Trước
            </a>
          </c:if>

          <c:forEach var="i" begin="1" end="${totalPages}" varStatus="status">
            <a href="${pageContext.request.contextPath}/blog-dashboard?page=${i}"
               class="btn-hospital <c:if test="${i == currentPage}">btn-primary</c:if>">
                ${i}
            </a>
          </c:forEach>

          <c:if test="${currentPage < totalPages}">
            <a href="${pageContext.request.contextPath}/blog-dashboard?page=${currentPage + 1}" class="btn-hospital">
              Tiếp &raquo;
            </a>
          </c:if>
        </div>
        <div class="empty-state" id="emptyState" style="display: none;">
          <i class="fas fa-blog"></i>
          <h3>Không tìm thấy blog nào</h3>
          <p>Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm</p>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- jQuery and Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
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

  // Dropdown functionality
  function ftoggleDropdown(button) {
    // Close all other dropdowns
    $('.dropdown-menu').removeClass('show');

    // Toggle current dropdown
    const dropdown = $(button).siblings('.dropdown-menu');
    dropdown.toggleClass('show');

    // Close dropdown when clicking outside
    $(document).on('click', function(e) {
      if (!$(e.target).closest('.dropdown').length) {
        $('.dropdown-menu').removeClass('show');
      }
    });
  }

  // Delete blog function
  function deleteBlog(id) {
    if (confirm('Bạn có chắc chắn muốn xóa bài viết này?')) {
      // Remove the row
      $(`tr:has([onclick*="${id}"])`).fadeOut(300, function() {
        $(this).remove();
        updateBlogCount();
      });
    }
  }

  // Update blog count
  function updateBlogCount() {
    const count = $('#blogTableBody tr:visible').length;
    $('#blogCount').text(count);
  }

  // Bind filter events
  $('#searchInput, #categoryFilter, #statusFilter').on('input change', filterBlogs);

  // Initialize
  $(document).ready(function() {
    updateBlogCount();
  });
</script>

</body>
</html>