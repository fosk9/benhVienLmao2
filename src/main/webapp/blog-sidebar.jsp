<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
  .post_item {
    display: flex;
    align-items: center;
    margin-bottom: 15px;
  }

  .post_item img {
    width: 80px;
    height: 80px;
    object-fit: cover;
    border-radius: 5px;
    margin-right: 15px;
  }

  .post_item .media-body h3 {
    font-size: 15px;
    font-weight: 600;
    margin-bottom: 5px;
  }

  .post_item .media-body p {
    font-size: 13px;
    color: #888;
  }
</style>
<!-- Sidebar Content -->
<div class="blog_right_sidebar">

  <!-- Form tìm kiếm -->
  <aside class="single_sidebar_widget search_widget">
    <form action="blog" method="get"> <!-- Chỉnh sửa action cho đúng servlet -->
      <div class="form-group">
        <div class="input-group mb-3">
          <input type="text" name="search" class="form-control" placeholder="Tìm kiếm bài viết..."
                 value="${searchKeyword != null ? searchKeyword : ''}" onfocus="this.placeholder = ''"
                 onblur="this.placeholder = 'Tìm kiếm bài viết'">
          <div class="input-group-append">
            <button class="btns" type="submit"><i class="ti-search"></i></button>
          </div>
        </div>
      </div>
      <button class="button rounded-0 primary-bg text-white w-100 btn_1 boxed-btn" type="submit">
        Tìm kiếm
      </button>
    </form>
  </aside>

  <!-- Categories Widget -->
  <aside class="single_sidebar_widget post_category_widget">
    <h4 class="widget_title" style="color: #2d2d2d;">Danh Mục</h4>
    <ul class="list cat-list">
      <c:forEach var="category" items="${categories}">
        <li><a href="blog?categoryId=${category.categoryId}" class="d-flex"><p>${category.categoryName}</p><p>(${category.blogCount})</p></a></li>
      </c:forEach>
    </ul>
  </aside>

  <!-- Recent Post Widget -->
  <aside class="single_sidebar_widget popular_post_widget">
    <h3 class="widget_title" style="color: #2d2d2d;">Bài Viết Gần Nhất</h3>
    <c:forEach var="blog" items="${recentBlogs}">
      <div class="media post_item">
        <img src="${pageContext.request.contextPath}/${blog.blogImg}" alt="${blog.blogName}">
        <div class="media-body">
          <a href="blog-detail?id=${blog.blogId}">
            <h3>${blog.blogName}</h3>
          </a>
          <p><fmt:formatDate value="${blog.date}" pattern="yyyy-MM-dd" /></p>
        </div>
      </div>
    </c:forEach>
  </aside>

</div>
</div>
