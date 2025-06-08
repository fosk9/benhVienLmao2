<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Blog Search</title>
  <jsp:include page="common-css.jsp"/>
  <style>
    .pagination {
      display: flex;
      justify-content: center;
      align-items: center;
      margin-top: 30px;
    }
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
    .pagination a:hover {
      background-color: #007bff;
      color: #fff;
      border-color: #007bff;
    }
    .pagination a.active {
      background-color: #007bff;
      color: white;
      border-color: #007bff;
    }
  </style>
</head>
<body>
<jsp:include page="header.jsp"/>

<main>
  <div class="container">
    <div class="row">
      <div class="col-lg-8 mb-5 mb-lg-0">
        <div class="blog_left_sidebar">

          <!-- Hiển thị kết quả tìm kiếm -->
          <c:if test="${not empty searchResults}">
            <c:forEach var="b" items="${searchResults}">
              <article class="blog_item">
                <div class="blog_item_img">
                  <img class="card-img rounded-0" src="${b.blogImg}" alt="${b.blogName}">
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
                    <li><a href="#"><i class="fa fa-user"></i> ${b.categoryName}</a></li>
                    <li><a href="#"><i class="fa fa-comments"></i> ${b.commentCount} Comments</a></li>
                  </ul>
                </div>
              </article>
            </c:forEach>
          </c:if>

          <!-- Nếu không có kết quả tìm kiếm -->
          <c:if test="${empty searchResults}">
            <p>Không có kết quả tìm kiếm nào. Hãy thử lại với từ khóa khác.</p>
          </c:if>

          <!-- Pagination -->
          <div class="pagination">
            <!-- First Page -->
            <c:if test="${currentPage > 1}">
              <a href="blog-search?search=${searchKeyword}&page=1">Đầu</a>
            </c:if>

            <!-- Previous Page -->
            <c:if test="${currentPage > 1}">
              <a href="blog-search?search=${searchKeyword}&page=${currentPage - 1}">Previous</a>
            </c:if>

            <!-- Pages -->
            <c:forEach var="i" begin="1" end="${totalPages}">
              <a href="blog-search?search=${searchKeyword}&page=${i}" class="<c:if test='${i == currentPage}'>active</c:if>">${i}</a>
            </c:forEach>

            <!-- Next Page -->
            <c:if test="${currentPage < totalPages}">
              <a href="blog-search?search=${searchKeyword}&page=${currentPage + 1}">Next</a>
            </c:if>

            <!-- Last Page -->
            <c:if test="${currentPage < totalPages}">
              <a href="blog-search?search=${searchKeyword}&page=${totalPages}">Cuối</a>
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
</main>

<jsp:include page="footer.jsp"/>
<jsp:include page="common-scripts.jsp"/>
</body>
</html>
