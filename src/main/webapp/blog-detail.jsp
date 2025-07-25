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
  <style>
    .feature-img img {
      width: 100%; /* Chiếm toàn bộ chiều rộng */
      height: auto; /* Đảm bảo tỉ lệ ảnh không bị méo */
      object-fit: cover; /* Đảm bảo ảnh không bị méo và được cắt sao cho vừa */
    }
     .blog_details p {
       display: block !important;
       overflow: visible !important;
       -webkit-line-clamp: unset !important;
       -webkit-box-orient: initial !important;
       white-space: normal !important;
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

    /* CSS cho phân trang */
    .pagination {
      display: flex;
      justify-content: flex-start;
      align-items: center;
      margin-top: -50px;
      margin-bottom: -25px;
    }

    .pagination a {
      padding: 5px 10px;
      margin: 0 5px;
      border-radius: 4px;
      background-color: #e0e0e0;
      color: #333;
      text-decoration: none;
      font-size: 10px;
      font-weight: 600;
      transition: all 0.3s ease;
      cursor: pointer;
    }

    .pagination a:hover {
      background-color: black;
      color: white;
      transform: scale(1.05);
    }

    .pagination a.active {
      background-color: white;
      color: black;
      border: 2px solid black;
    }

    .pagination a:disabled {
      background-color: #d1d1d1;
      color: #888;
      cursor: not-allowed;
    }

    .pagination a:focus {
      outline: none;
      box-shadow: 0 0 0 2px rgba(66, 133, 244, 0.4);
    }

    /* Nút "Trước" và "Tiếp" */
    .pagination .btn-hospital {
      display: inline-flex;
      align-items: center;
      padding: 5px 10px;
      border-radius: 5px;
      background-color: #f3f4f6;
      color: #374151;
      font-weight: 600;
      text-decoration: none;
      margin-top: 15px;
    }

    .pagination .btn-hospital:hover {
      background-color: #e2e8f0;
      color: black;
    }

    .pagination .btn-hospital:disabled {
      background-color: #d1d5db;
      color: #b1b5b7;
    }

    /* Giới hạn kích thước ảnh trong nội dung CKEditor/blog content */
    .blog_details .content img,
    .content img {
      max-width: 100%;
      height: auto;
      display: block;
      margin: 0 auto;
    }


    /* Modal styles */
    .modal-img-viewer {
      display: none;
      position: fixed;
      z-index: 9999;
      left: 0; top: 0; width: 100vw; height: 100vh;
      background: rgba(0,0,0,0.8);
      justify-content: center;
      align-items: center;
    }
    .modal-img-viewer.active {
      display: flex;
    }
    .modal-img-content {
      max-width: 98vw;
      max-height: 92vh;
      border-radius: 8px;
      box-shadow: 0 0 20px #000;
      background: #fff;
      padding: 10px 20px 20px 20px;
      position: relative;
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    .modal-img-content img {
      max-width: 95vw;
      max-height: 85vh;
      margin-bottom: 10px;
      border-radius: 6px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.15);
      transition: max-width 0.2s, max-height 0.2s;
    }
    .modal-img-caption {
      color: #333;
      font-size: 1.1rem;
      margin-top: 5px;
      text-align: center;
      min-height: 22px;
      max-width: 90vw;
      word-break: break-word;
    }
    .modal-img-close, .modal-img-prev, .modal-img-next {
      position: absolute;
      top: 10px;
      background: rgba(0,0,0,0.5);
      color: #fff;
      border: none;
      font-size: 2rem;
      cursor: pointer;
      border-radius: 50%;
      width: 40px; height: 40px;
      display: flex; align-items: center; justify-content: center;
      z-index: 2;
      transition: background 0.2s;
    }
    .modal-img-close:hover, .modal-img-prev:hover, .modal-img-next:hover {
      background: rgba(0,0,0,0.8);
    }
    .modal-img-close { right: 10px; }
    .modal-img-prev { left: 10px; top: 50%; transform: translateY(-50%); }
    .modal-img-next { right: 10px; top: 50%; transform: translateY(-50%); }
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
            <h2 class="font-weight-bold mb-3" style="font-family: 'Times New Roman', Times, serif;">${blog.blogName}</h2>
            <div class="blog_details">
              <p class="font-weight-bold text-muted mb-4" style="font-size: 1.1rem; font-family: 'Times New Roman', Times, serif;">${blog.blogSubContent}</p>
              <div class="content" style="font-size: 1rem; line-height: 1.8; text-align: justify;">
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

            <!-- Phân trang -->
            <div class="pagination">
              <c:if test="${currentPage > 1}">
                <a href="${pageContext.request.contextPath}/blog-detail?id=${blog.blogId}&page=${currentPage - 1}" class="btn-hospital">
                  &laquo; Trước
                </a>
              </c:if>

              <c:forEach var="i" begin="1" end="${totalPages}" varStatus="status">
                <a href="${pageContext.request.contextPath}/blog-detail?id=${blog.blogId}&page=${i}"
                   class="btn-hospital <c:if test="${i == currentPage}">active</c:if>">
                    ${i}
                </a>
              </c:forEach>

              <c:if test="${currentPage < totalPages}">
                <a href="${pageContext.request.contextPath}/blog-detail?id=${blog.blogId}&page=${currentPage + 1}" class="btn-hospital">
                  Tiếp &raquo;
                </a>
              </c:if>
            </div>

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

<!-- Modal Image Viewer -->
<div id="modalImgViewer" class="modal-img-viewer">
  <div class="modal-img-content">
    <button class="modal-img-close" id="modalImgClose" title="Đóng">&times;</button>
    <button class="modal-img-prev" id="modalImgPrev" title="Trước">&#8592;</button>
    <img id="modalImgMain" src="" alt="Ảnh blog" />
    <div class="modal-img-caption" id="modalImgCaption"></div>
    <button class="modal-img-next" id="modalImgNext" title="Tiếp">&#8594;</button>
  </div>
</div>

<script>
  // Lấy tất cả ảnh trong phần nội dung blog (CKEditor)
  document.addEventListener("DOMContentLoaded", function() {
    const contentDiv = document.querySelector('.blog_details .content');
    if (!contentDiv) return;

    const images = Array.from(contentDiv.querySelectorAll('img'));
    if (images.length === 0) return;

    // Modal elements
    const modal = document.getElementById('modalImgViewer');
    const modalImg = document.getElementById('modalImgMain');
    const modalCaption = document.getElementById('modalImgCaption');
    const btnClose = document.getElementById('modalImgClose');
    const btnPrev = document.getElementById('modalImgPrev');
    const btnNext = document.getElementById('modalImgNext');

    let currentIdx = 0;

    // Mở modal khi click vào ảnh
    images.forEach((img, idx) => {
      img.style.cursor = "pointer";
      img.addEventListener('click', function() {
        currentIdx = idx;
        showModalImg();
      });
    });

    function showModalImg() {
      const img = images[currentIdx];
      modalImg.src = img.src;
      // Lấy chú thích từ alt, nếu không có thì lấy title, nếu không có thì để rỗng
      modalCaption.textContent = img.getAttribute('alt') || img.getAttribute('title') || '';
      modal.classList.add('active');
      updateNavButtons();
    }

    function updateNavButtons() {
      btnPrev.style.display = currentIdx > 0 ? 'flex' : 'none';
      btnNext.style.display = currentIdx < images.length - 1 ? 'flex' : 'none';
    }

    btnClose.onclick = function() {
      modal.classList.remove('active');
      modalImg.src = "";
      modalCaption.textContent = "";
    };

    btnPrev.onclick = function(e) {
      e.stopPropagation();
      if (currentIdx > 0) {
        currentIdx--;
        showModalImg();
      }
    };

    btnNext.onclick = function(e) {
      e.stopPropagation();
      if (currentIdx < images.length - 1) {
        currentIdx++;
        showModalImg();
      }
    };

    // Đóng modal khi click ra ngoài ảnh
    modal.addEventListener('click', function(e) {
      if (e.target === modal) {
        modal.classList.remove('active');
        modalImg.src = "";
        modalCaption.textContent = "";
      }
    });

    // Đóng modal bằng phím ESC
    document.addEventListener('keydown', function(e) {
      if (modal.classList.contains('active')) {
        if (e.key === "Escape") {
          modal.classList.remove('active');
          modalImg.src = "";
          modalCaption.textContent = "";
        }
        if (e.key === "ArrowLeft" && currentIdx > 0) {
          currentIdx--;
          showModalImg();
        }
        if (e.key === "ArrowRight" && currentIdx < images.length - 1) {
          currentIdx++;
          showModalImg();
        }
      }
    });
  });
</script>
</body>
</html>