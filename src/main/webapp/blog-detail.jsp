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
              <img class="img-fluid" src="${blog.blogImg}" alt="${blog.blogName}">
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
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
          <jsp:include page="blog-sidebar.jsp"/>
        </div>
      </div>
    </div>
  </section>
</main>
<jsp:include page="footer.jsp"/>
<jsp:include page="common-scripts.jsp"/>
</body>
</html>
