<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Blog List</title>
  <jsp:include page="common-css.jsp"/>
<%--  <link rel="stylesheet" href="assets/css/dental-specific.css">--%>
<%--  <link rel="stylesheet" href="assets/css/image-utilities.css">--%>

  <!-- CSS cho phân trang -->
  <style>
    /* Container cho phân trang */
    .pagination {
      display: flex;
      justify-content: center;
      align-items: center;
      margin-top: 30px;
    }

    /* Các liên kết trang */
    .pagination a {
      color: #333;
      font-size: 16px;
      font-weight: bold;
      margin: 0 10px;
      padding: 8px 15px;
      text-decoration: none;
      border: 1px solid #ddd;
      border-radius: 5px;
      transition: background-color 0.3s, color 0.3s;
    }

    /* Hiển thị hiệu ứng khi di chuột qua các liên kết */
    .pagination a:hover {
      background-color: #007bff;
      color: #fff;
      border-color: #007bff;
    }

    /* Các liên kết đang ở trạng thái bị vô hiệu hóa (khi không thể quay lại trang đầu hoặc trước) */
    .pagination a.disabled {
      color: #ddd;
      cursor: not-allowed;
    }

    /* Hiển thị liên kết trang hiện tại với nền khác biệt */
    .pagination a.active {
      background-color: #007bff;
      color: white;
      border-color: #007bff;
    }

    /* Thêm khoảng cách giữa các nút phân trang */
    .pagination a {
      margin: 0 5px;
    }

    /* Các liên kết "Previous" và "Next" */
    .pagination .prev, .pagination .next {
      font-size: 16px;
      font-weight: normal;
      text-transform: uppercase;
    }

    /* Liên kết đầu và cuối */
    .pagination .first, .pagination .last {
      font-weight: bold;
    }

    .blog_item_img img {
      width: 100%;              /* full chiều rộng container */
      height: 250px;            /* hoặc bạn có thể dùng 300px nếu muốn ảnh cao hơn */
      object-fit: cover;        /* cắt ảnh để fit khung mà không bị méo */
      border-radius: 5px;       /* bo góc nếu muốn */
      display: block;           /* tránh lỗi margin dưới ảnh */
    }

  </style>

</head>
<body>
<jsp:include page="header.jsp"/>
<main>
  <!-- Slider Area -->
  <div class="slider-area slider-area2">
    <div class="slider-active dot-style">
      <div class="single-slider d-flex align-items-center slider-height2">
        <div class="container">
          <div class="row align-items-center">
            <div class="col-xl-7 col-lg-8 col-md-10">
              <div class="hero-wrapper">
                <div class="hero__caption">
                  <h1>Blog</h1>
                  <p>Almost before we knew it,<br>we had left the ground</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- Blog Area Start -->
  <section class="blog_area section-padding">
    <div class="container">
      <div class="row">
        <!-- Blog List Left -->
        <div class="col-lg-8 mb-5 mb-lg-0">
          <div class="blog_left_sidebar">
            <!-- Kiểm tra nếu có kết quả tìm kiếm -->
            <c:if test="${not empty searchResults}">
              <c:forEach var="b" items="${searchResults}">
                <article class="blog_item">
                  <div class="blog_item_img">
                    <img class="card-img rounded-0" style="height: auto;" src="${pageContext.request.contextPath}/${b.blogImg}" alt="${b.blogName}">
                    <a href="#" class="blog_item_date">
                      <h3><fmt:formatDate value="${b.date}" pattern="dd"/></h3>
                      <p><fmt:formatDate value="${b.date}" pattern="MMM"/></p>
                    </a>
                  </div>
                  <div class="blog_details">
                    <a class="d-inline-block" href="blog-detail?id=${b.blogId}">
                      <h2 class="font-weight-bold mb-2 blog-head" style="color: #2d2d2d;">${b.blogName}</h2>
                    </a>
                    <p class="font-weight-normal text-muted">${b.blogSubContent}</p>
                    <ul class="blog-info-link">
                      <li><a href="blog?categoryId=${b.categoryId}"><i class="fa fa-user"></i> ${b.categoryName}</a></li>
                      <li><i class="fa fa-comments"></i> ${b.commentCount} Comments</li>
                    </ul>
                  </div>
                </article>
              </c:forEach>
            </c:if>

            <!-- Kiểm tra nếu có bài viết theo danh mục -->
            <c:if test="${not empty blogListByCategory}">
              <c:forEach var="b" items="${blogListByCategory}">
                <article class="blog_item">
                  <div class="blog_item_img">
                    <img class="card-img rounded-0" src="${pageContext.request.contextPath}/${b.blogImg}" alt="${b.blogName}">
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
                      <li><a href="blog?categoryId=${b.categoryId}"><i class="fa fa-user"></i> ${b.categoryName}</a></li>
                      <li><a href="#"><i class="fa fa-comments"></i> ${b.commentCount} Comments</a></li>
                    </ul>
                  </div>
                </article>
              </c:forEach>
            </c:if>

            <!-- Nếu không có kết quả tìm kiếm hoặc danh mục, hiển thị tất cả các bài viết -->
            <c:if test="${empty searchResults and empty blogListByCategory}">
              <c:forEach var="b" items="${searchResults}">
                <article class="blog_item">
                  <div class="blog_item_img">
                    <img class="card-img rounded-0" src="${pageContext.request.contextPath}/${b.blogImg}" alt="${b.blogName}">
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
                      <li><a href="blog?categoryId=${b.categoryId}"><i class="fa fa-user"></i> ${b.categoryName}</a></li>
                      <li><a href="#"><i class="fa fa-comments"></i> ${b.commentCount} Comments</a></li>
                    </ul>
                  </div>
                </article>
              </c:forEach>
            </c:if>

            <!-- Nếu không có kết quả tìm kiếm, danh mục hoặc bài viết, hiển thị thông báo -->
            <c:if test="${empty searchResults and empty blogListByCategory}">
              <p>Không tìm thấy bài viết nào.</p>
            </c:if>

            <!-- TODO: Pagination dynamic rendering here if needed -->
            <!-- Pagination -->
            <div class="pagination">
              <!-- First Page -->
              <c:if test="${currentPage > 1}">
                <a href="blog?page=1">Đầu</a>
              </c:if>

              <!-- Previous Page -->
              <c:if test="${currentPage > 1}">
                <a href="blog?page=${currentPage - 1}">Previous</a>
              </c:if>

              <!-- Pages -->
              <c:forEach var="i" begin="1" end="${totalPages}">
                <a href="blog?page=${i}" class="<c:if test='${i == currentPage}'>active</c:if>">${i}</a>
              </c:forEach>

              <!-- Next Page -->
              <c:if test="${currentPage < totalPages}">
                <a href="blog?page=${currentPage + 1}">Next</a>
              </c:if>

              <!-- Last Page -->
              <c:if test="${currentPage < totalPages}">
                <a href="blog?page=${totalPages}">Cuối</a>
              </c:if>
            </div>


          </div>
        </div>

        <!-- Blog Sidebar Right -->
        <div class="col-lg-4">
          <jsp:include page="blog-sidebar.jsp"/>
        </div>
      </div>
    </div>
  </section>
  <!-- About Section  -->
  <section class="about-low-area mt-60">
    <div class="container">
      <div class="about-cap-wrapper">
        <div class="row">
          <div class="col-xl-5 col-lg-6 col-md-10 offset-xl-1">
            <div class="about-caption mb-50">
              <div class="section-tittle mb-35">
                <h2>100% satisfaction guaranteed.</h2>
              </div>
              <p>Almost before we knew it, we had left the ground</p>
              <a href="about.html" class="border-btn">Make an Appointment</a>
            </div>
          </div>
          <div class="col-lg-6 col-md-12">
            <div class="about-img">
              <div class="about-font-img">
                <img src="assets/img/gallery/about2.png" alt="">
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</main>
<!-- Footer -->
<jsp:include page="footer.jsp"/>
<jsp:include page="common-scripts.jsp"/>
</body>
</html>