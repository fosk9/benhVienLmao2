<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Blog Management - Hospital Admin</title>

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
          <a href="Admin/home-admin-dashboard.jsp" style="text-decoration: none;">
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
          <a href="${pageContext.request.contextPath}/update-user-role" class="nav-link">
            <i class="fas fa-users-cog"></i>
            <span>User Management</span>
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
        <div style="display: flex; align-items: center; justify-content: space-between;">
          <div>
            <h1>Blog Management</h1>
            <p class="page-subtitle">Manage and monitor blog posts</p>
          </div>
          <a href="${pageContext.request.contextPath}/add-blog" class="btn-hospital btn-primary">
            <i class="fas fa-plus mr-2"></i>Add New Blog
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
              <p>Total Blogs</p>
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
              <p>Published</p>
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
              <p>Draft</p>
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
              <label>Search</label>
              <div class="search-wrapper">
                <i class="fas fa-search"></i>
                <input type="text" class="form-control" id="searchInput" name="keyword"
                       placeholder="Search by title or author..."
                       value="${keyword != null ? keyword : ''}">
              </div>
            </div>
            <div class="form-group">
              <label>Category</label>
              <select class="form-control" id="categoryFilter" name="categoryId" onchange="this.form.submit()">
                <option value="">All Categories</option>
                <c:forEach var="category" items="${categories}">
                  <option value="${category.categoryId}" <c:if test="${selectedCategoryId != null && category.categoryId == selectedCategoryId}">selected</c:if>>
                      ${category.categoryName}
                  </option>
                </c:forEach>
              </select>
            </div>
            <div class="form-group">
              <label>Status</label>
              <select class="form-control" id="statusFilter" disabled>
                <option value="">All Status</option>
                <option value="published">Published</option>
                <option value="draft">Draft</option>
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
          <h3>Blog List (<span id="blogCount"><c:out value="${fn:length(blogList)}"/></span>)</h3>
        </div>
        <table class="blog-table" id="blogTable">
          <thead>
          <tr>
            <th>Article</th>
            <th>Author</th>
            <th>Category</th>
            <th>Created Date</th>
            <th>Comments</th>
            <th>Actions</th>
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
                  <a href="${pageContext.request.contextPath}/blog-detail?id=${blog.blogId}" class="btn-hospital btn-primary btn-sm" title="View Details">
                    <i class="fas fa-eye"></i>
                  </a>
                  <a href="${pageContext.request.contextPath}/blog-dashboard/edit?blogId=${blog.blogId}" class="btn-hospital btn-sm" title="Edit">
                    <i class="fas fa-edit"></i>
                  </a>
                  <a href="${pageContext.request.contextPath}/blog-dashboard/delete?blogId=${blog.blogId}" class="btn-hospital btn-sm text-danger" title="Delete"
                     onclick="return confirm('Are you sure you want to delete this article?');">
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
              &laquo; Previous
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
              Next &raquo;
            </a>
          </c:if>
        </div>
        <div class="empty-state" id="emptyState" style="display: none;">
          <i class="fas fa-blog"></i>
          <h3>No blogs found</h3>
          <p>Try changing the filter or search keywords</p>
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
    if (confirm('Are you sure you want to delete this article?')) {
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
