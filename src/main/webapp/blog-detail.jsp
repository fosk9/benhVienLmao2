<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Chi tiết bài viết</title>
  <jsp:include page="common-css.jsp"/>
</head>
<style>
  .feature-img img {
    width: 100%; /* Chiếm toàn bộ chiều rộng */
    height: auto; /* Đảm bảo tỉ lệ ảnh không bị méo */
    object-fit: cover; /* Đảm bảo ảnh không bị méo và được cắt sao cho vừa */
  }

  .comment-user-img {
    width: 50px; /* Đặt kích thước ảnh đại diện */
    height: 50px;
    border-radius: 50%; /* Làm ảnh tròn */
    object-fit: cover; /* Đảm bảo ảnh không bị méo */
    margin-right: 15px; /* Khoảng cách giữa ảnh và tên người dùng */
  }

  .comment-user-img-default {
    width: 50px;
    height: 50px;
    background-color: #ccc; /* Màu nền nếu không có ảnh */
    border-radius: 50%; /* Làm ảnh tròn */
    display: inline-block; /* Đảm bảo ảnh và bình luận nằm trên cùng một dòng */
  }

  .single-comment {
    display: flex; /* Hiển thị các phần tử con theo chiều ngang */
    margin-bottom: 15px; /* Khoảng cách giữa các bình luận */
  }

  .user {
    display: flex; /* Đảm bảo ảnh và tên người dùng nằm cùng hàng */
    align-items: center; /* Căn chỉnh ảnh và tên người dùng thẳng hàng */
  }

  .desc {
    flex: 1; /* Cho phép nội dung bình luận chiếm phần còn lại */
  }

  .comment-user-img-wrapper {
    margin-right: 15px; /* Khoảng cách giữa ảnh và nội dung bình luận */
  }

  .comment-user-img {
    width: 50px;
    height: 50px;
    border-radius: 50%; /* Làm cho ảnh tròn */
    object-fit: cover;
  }

</style>

<body>
<jsp:include page="header.jsp"/>
<main>
  <!-- Slider Area -->
  <div class="slider-area slider-area2">
    <div class="slider-active dot-style">
      <div class="single-slider d-flex align-items-center slider-height2">
        <div class="container">
          <div class="row align-items-center">
            <div class="col-xl-12">
              <div class="hero-wrapper text-center">
                <div class="hero__caption">
                  <h1>${blog.blogName}</h1>
                  <p><fmt:formatDate value="${blog.date}" pattern="dd-MM-yyyy"/> - ${blog.author}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Blog Details -->
  <section class="blog_area single-post-area section-padding">
    <div class="container">
      <div class="row">
        <div class="col-lg-8 posts-list">
          <div class="single-post">
            <div class="feature-img">
              <img class="img-fluid" src="assets/img/${blog.blogImg}" alt="${blog.blogName}">
            </div>
            <div class="blog_details">
              <p class="excert">${blog.blogSubContent}</p>
              <div class="content">
                <p>${blog.content}</p>
              </div>
            </div>
          </div>

          <div class="comments-area">
            <h4>${fn:length(comments)} Comments</h4>
            <c:forEach var="c" items="${comments}">
              <div class="comment-list">
                <div class="single-comment justify-content-between d-flex">
                  <div class="user justify-content-between d-flex">
                    <!-- Ảnh người dùng -->
                    <div class="comment-user-img-wrapper">
                      <c:choose>
                        <c:when test="${empty c.patientImage}">
                          <img class="comment-user-img-default" alt="User Image">
                        </c:when>
                        <c:otherwise>
                          <img class="comment-user-img" src="assets/img/${c.patientImage}" alt="${c.patientName}">
                        </c:otherwise>
                      </c:choose>
                    </div>

                    <!-- Nội dung bình luận -->
                    <div class="desc">
                      <p class="comment">${c.content}</p>
                      <div class="d-flex justify-content-between">
                        <div class="d-flex align-items-center">
                          <h5>${c.patientName}</h5>
                          <p class="date"> <fmt:formatDate value="${c.date}" pattern="dd-MM-yyyy"/> </p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </c:forEach>

          </div>

          <!-- Comment Form -->
          <div class="comment-form">
            <h4>Write a Comment</h4>
            <c:if test="${not empty errorMessage}">
              <div style="color:red;">
                ${errorMessage}
                <c:if test="${not empty errorCode}">
                  <span style="font-size: 0.9em; color: #888;">(Mã lỗi: ${errorCode})</span>
                </c:if>
              </div>
            </c:if>
            <form action="blog-detail" method="POST">
              <input type="hidden" name="action" value="addComment">
              <input type="hidden" name="blogId" value="${blog.blogId}">

              <!-- Kiểm tra session, nếu có userName và userEmail trong session -->
              <c:choose>
                <c:when test="${not empty sessionScope.username}">
                  <input type="text" id="userName" name="userName" value="${sessionScope.username}" readonly>
                </c:when>
                <c:otherwise>
                  <!-- Các trường này sẽ hiển thị nếu chưa có session username và email -->
                  <div id="userEmailGroup" class="form-group">
                    <input class="form-control" id="userEmail" name="userEmail" type="email" placeholder="Your Email">
                  </div>
                </c:otherwise>
              </c:choose>

              <div class="row">
                <div class="col-12">
                  <div class="form-group">
                    <textarea class="form-control w-100" name="content"
                              cols="30" rows="9"
                              placeholder="Write your comment here..."
                              required></textarea>
                  </div>
                </div>
              </div>

              <div class="form-group">
                <button type="submit" class="button button-contactForm boxed-btn">
                  Post Comment
                </button>
              </div>
            </form>
          </div>
        </div>

        <script>
          window.onload = function() {
            // Lấy giá trị của userEmail từ các trường nhập liệu
            var userEmail = document.getElementById("userEmail").value;

            // Kiểm tra nếu cả userName và userEmail có dữ liệu
            if (userName.trim() !== "" && userEmail.trim() !== "") {
              // Nếu có dữ liệu, ẩn các trường nhập liệu
              document.getElementById("userEmailGroup").style.display = "none";
            } else {
              // Nếu không có dữ liệu, hiển thị các trường nhập liệu
              document.getElementById("userEmailGroup").style.display = "block";
            }
          }
        </script>

        <!-- Sidebar -->
        <div class="col-lg-4">
          <jsp:include page="blog-sidebar.jsp"/>
        </div>

        </div>
      </div>
    </div>
  </section>
</main>
<jsp:include page="footer.jsp"/>
<jsp:include page="common-scripts.jsp"/>
</body>
</html>