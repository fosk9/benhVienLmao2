<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="view.BlogDAO" %>
<%@ page import="view.Blog" %>


<%
  String blogIdStr = request.getParameter("bid");
  Blog blog = null;
  Blog previousBlog = null;
  Blog nextBlog = null;

  int blogId = -1;
  BlogDAO dao = new BlogDAO();

  if (blogIdStr != null) {
    try {
      blogId = Integer.parseInt(blogIdStr);
      blog = dao.getBlogById(blogId);
      if (blog != null) {
        previousBlog = dao.getPreviousBlog(blog.getDate());
        nextBlog = dao.getNextBlog(blog.getDate());
      }
    } catch (NumberFormatException e) {
      out.println("<p style='color:red'>Lỗi: ID không hợp lệ.</p>");
    }
  } else {
    out.println("<p style='color:red'>Không có blog ID nào được truyền.</p>");
  }
%>
<!doctype html>
<html class="no-js" lang="zxx">
<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>Health | Template</title>
  <meta name="description" content="">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">

  <!-- CSS here -->
  <link rel="stylesheet" href="assets/css/bootstrap.min.css">
  <link rel="stylesheet" href="assets/css/owl.carousel.min.css">
  <link rel="stylesheet" href="assets/css/slicknav.css">
  <link rel="stylesheet" href="assets/css/animate.min.css">
  <link rel="stylesheet" href="assets/css/magnific-popup.css">
  <link rel="stylesheet" href="assets/css/fontawesome-all.min.css">
  <link rel="stylesheet" href="assets/css/themify-icons.css">
  <link rel="stylesheet" href="assets/css/slick.css">
  <link rel="stylesheet" href="assets/css/nice-select.css">
  <link rel="stylesheet" href="assets/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>
<!--? Preloader Start -->
<div id="preloader-active">
  <div class="preloader d-flex align-items-center justify-content-center">
    <div class="preloader-inner position-relative">
      <div class="preloader-circle"></div>
      <div class="preloader-img pere-text">
        <img src="assets/img/logo/loder.png" alt="">
      </div>
    </div>
  </div>
</div>
<!-- Preloader Start -->
<header>
  <!--? Header Start -->
  <div class="header-area">
    <div class="main-header header-sticky">
      <div class="container-fluid">
        <div class="row align-items-center">
          <!-- Logo -->
          <div class="col-xl-2 col-lg-2 col-md-1">
            <div class="logo">
              <a href="index.html"><img src="assets/img/logo/logo.png" alt=""></a>
            </div>
          </div>
          <div class="col-xl-10 col-lg-10 col-md-10">
            <div class="menu-main d-flex align-items-center justify-content-end">
              <!-- Main-menu -->
              <div class="main-menu f-right d-none d-lg-block">
                <nav>
                  <ul id="navigation">
                    <li><a href="index.html">Home</a></li>
                    <li><a href="about.html">About</a></li>
                    <li><a href="services.html">Services</a></li>
                    <li><a href="blog">Blog</a>
                      <ul class="submenu">
                        <li><a href="blog">Blog</a></li>
                        <li><a href="blog_details.jsp">Blog Details</a></li>
                        <li><a href="elements.html">Element</a></li>
                      </ul>
                    </li>
                    <li><a href="contact.html">Contact</a></li>
                  </ul>
                </nav>
              </div>
              <div class="header-right-btn f-right d-none d-lg-block ml-15">
                <a href="#" class="btn header-btn">Make an Appointment</a>
              </div>
            </div>
          </div>
          <!-- Mobile Menu -->
          <div class="col-12">
            <div class="mobile_menu d-block d-lg-none"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- Header End -->
</header>
<main>
  <!--? Slider Area Start-->
  <div class="slider-area slider-area2">
    <div class="slider-active dot-style">
      <!-- Slider Single -->
      <div class="single-slider  d-flex align-items-center slider-height2">
        <div class="container">
          <div class="row align-items-center">
            <div class="col-xl-7 col-lg-8 col-md-10 ">
              <div class="hero-wrapper">
                <div class="hero__caption">
                  <h1 data-animation="fadeInUp" data-delay=".3s">Blog Details</h1>

                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- Slider Area End -->
  <!--? Blog Area Start -->
  <section class="blog_area single-post-area section-padding">
    <div class="container">
      <div class="row">
        <div class="col-lg-8 posts-list">
          <div class="single-post">
            <div class="feature-img">
              <img class="img-fluid" src="<%= blog.getImage() %>" alt="">
            </div>
          </div>
          <div class="blog_details">
            <h2 style="color: #2d2d2d;"><%= blog.getTitle() %></h2>
            <ul class="blog-info-link mt-3 mb-4">
              <li><i class="fa fa-user"></i> <%= blog.getAuthor() %></li>
              <li><i class="fa fa-calendar"></i> <%= blog.getDate() %></li>
            </ul>
            <p><%= blog.getContent() %></p>
          </div>
          <ul class="social-icons">
            <li><a href="https://www.facebook.com/sai4ull"><i class="fab fa-facebook-f"></i></a></li>
            <li><a href="#"><i class="fab fa-twitter"></i></a></li>
            <li><a href="#"><i class="fab fa-dribbble"></i></a></li>
            <li><a href="#"><i class="fab fa-behance"></i></a></li>
          </ul>
        </div>
        <div class="navigation-area">
          <div class="row">
            <!-- Previous Post -->
            <div class="col-lg-6 nav-left d-flex align-items-center">
              <% if (previousBlog != null) { %>
              <a href="blog_details.jsp?bid=<%= previousBlog.getBlogId() %>" class="d-flex align-items-center text-decoration-none">
                <i class="fas fa-arrow-left fa-2x text-dark mr-2"></i>
                <div>
                  <p class="mb-0">Prev Post</p>
                  <h5><%= previousBlog.getTitle() %></h5>
                </div>
              </a>
              <% } %>
            </div>

            <!-- Next Post -->
            <div class="col-lg-6 nav-right d-flex justify-content-end align-items-center text-right">
              <% if (nextBlog != null) { %>
              <a href="blog_details.jsp?bid=<%= nextBlog.getBlogId() %>" class="d-flex align-items-center text-decoration-none">
                <div>
                  <p class="mb-0">Next Post</p>
                  <h5><%= nextBlog.getTitle() %></h5>
                </div>
                <i class="fas fa-arrow-right fa-2x text-dark ml-2"></i>
              </a>
              <% } %>
            </div>
          </div>
        </div>
      </div>
      <div class="blog-author">
        <div class="media align-items-center">

          <div class="media-body">
            <a href="#">
              <h4></h4>
            </a>
            <p></p>
          </div>
        </div>
      </div>
      <div class="comments-area">
        <h4>05 Comments</h4>
        <div class="comment-list">
          <div class="single-comment justify-content-between d-flex">
            <div class="user justify-content-between d-flex">
              <div class="thumb">
                <img src="" alt="">
              </div>
              <div class="desc">
                <p class="comment">

                </p>
                <div class="d-flex justify-content-between">
                  <div class="d-flex align-items-center">
                    <h5>
                      <a href="#"></a>
                    </h5>
                    <p class="date"> </p>
                  </div>
                  <div class="reply-btn">
                    <a href="#" class="btn-reply text-uppercase">reply</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="comment-list">
          <div class="single-comment justify-content-between d-flex">
            <div class="user justify-content-between d-flex">
              <div class="thumb">
                <img src="" alt="">
              </div>
              <div class="desc">
                <p class="comment">

                </p>
                <div class="d-flex justify-content-between">
                  <div class="d-flex align-items-center">
                    <h5>
                      <a href="#"></a>
                    </h5>
                    <p class="date"> </p>
                  </div>
                  <div class="reply-btn">
                    <a href="#" class="btn-reply text-uppercase">reply</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="comment-list">
          <div class="single-comment justify-content-between d-flex">
            <div class="user justify-content-between d-flex">
              <div class="thumb">
                <img src="" alt="">
              </div>
              <div class="desc">
                <p class="comment">

                </p>
                <div class="d-flex justify-content-between">
                  <div class="d-flex align-items-center">
                    <h5>
                      <a href="#"></a>
                    </h5>
                    <p class="date"></p>
                  </div>
                  <div class="reply-btn">
                    <a href="#" class="btn-reply text-uppercase">reply</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="comment-form">
        <h4>Leave a Reply</h4>
        <form class="form-contact comment_form" action="#" id="commentForm">
          <div class="row">
            <div class="col-12">
              <div class="form-group">
     <textarea class="form-control w-100" name="comment" id="comment" cols="30" rows="9"
               placeholder="Write Comment"></textarea>
              </div>
            </div>
            <div class="col-sm-6">
              <div class="form-group">
                <input class="form-control" name="name" id="name" type="text" placeholder="Name">
              </div>
            </div>
            <div class="col-sm-6">
              <div class="form-group">
                <input class="form-control" name="email" id="email" type="email" placeholder="Email">
              </div>
            </div>
          </div>
      </div>
      <div class="form-group">
        <button type="submit" class="button button-contactForm btn_1 boxed-btn">Post Comment</button>
      </div>
      </form>
    </div>
    </div>
    <div class="col-lg-4">
      <div class="blog_right_sidebar">
        <aside class="single_sidebar_widget search_widget">
          <form action="#">
            <div class="form-group">
              <div class="input-group mb-3">
                <input type="text" class="form-control" placeholder='Search Keyword'
                       onfocus="this.placeholder = ''" onblur="this.placeholder = 'Search Keyword'">
                <div class="input-group-append">
                  <button class="btns" type="button"><i class="ti-search"></i></button>
                </div>
              </div>
            </div>
            <button class="button rounded-0 primary-bg text-white w-100 btn_1 boxed-btn"
                    type="submit">Search</button>
          </form>
        </aside>
        <aside class="single_sidebar_widget post_category_widget">
          <h4 class="widget_title" style="color: #2d2d2d;">Category</h4>
          <ul class="list cat-list">
            <li>
              <a href="#" class="d-flex">
                <p></p>
                <p></p>
              </a>
            </li>
            <li>
              <a href="#" class="d-flex">
                <p></p>
                <p></p>
              </a>
            </li>
            <li>
              <a href="#" class="d-flex">
                <p></p>
                <p></p>
              </a>
            </li>
            <li>
              <a href="#" class="d-flex">
                <p></p>
                <p></p>
              </a>
            </li>
            <li>
              <a href="#" class="d-flex">
                <p></p>
                <p></p>
              </a>
            </li>
            <li>
              <a href="#" class="d-flex">
                <p></p>
                <p></p>
              </a>
            </li>
          </ul>
        </aside>
        <aside class="single_sidebar_widget popular_post_widget">

      </div>
      </aside>

      <h4 class="widget_title" style="color: #2d2d2d;">Instagram Feeds</h4>
      <ul class="instagram_row flex-wrap">
        <li>
          <a href="#">
            <img class="img-fluid" src="" alt="">
          </a>
        </li>
        <li>
          <a href="#">
            <img class="img-fluid" src="" alt="">
          </a>
        </li>
        <li>
          <a href="#">
            <img class="img-fluid" src="" alt="">
          </a>
        </li>
        <li>
          <a href="#">
            <img class="img-fluid" src="" alt="">
          </a>
        </li>
        <li>
          <a href="#">
            <img class="img-fluid" src="" alt="">
          </a>
        </li>
        <li>
          <a href="#">
            <img class="img-fluid" src="" alt="">
          </a>
        </li>
      </ul>
      </aside>
      <aside class="single_sidebar_widget newsletter_widget">
        <h4 class="widget_title" style="color: #2d2d2d;">Newsletter</h4>
        <form action="#">
          <div class="form-group">
            <input type="email" class="form-control" onfocus="this.placeholder = ''"
                   onblur="this.placeholder = 'Enter email'" placeholder='Enter email' required>
          </div>
          <button class="button rounded-0 primary-bg text-white w-100 btn_1 boxed-btn"
                  type="submit">Subscribe</button>
        </form>
      </aside>
    </div>
    </div>
    </div>
    </div>
  </section>
  <!-- Blog Area End -->
  <!--? About Law Start-->
  <section class="about-low-area mt-60">
    <div class="container">
      <div class="about-cap-wrapper">
        <div class="row">
          <div class="col-xl-5  col-lg-6 col-md-10 offset-xl-1">
            <div class="about-caption mb-50">
              <!-- Section Tittle -->
              <div class="section-tittle mb-35">
                <h2>100% satisfaction guaranteed.</h2>
              </div>
              <p>Almost before we knew it, we had left the ground</p>
              <a href="about.html" class="border-btn">Make an Appointment</a>
            </div>
          </div>
          <div class="col-lg-6 col-md-12">
            <!-- about-img -->
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
  <!-- About Law End-->
</main>
<footer>
  <div class="footer-wrappr section-bg3" data-background="assets/img/gallery/footer-bg.png">
    <div class="footer-area footer-padding ">
      <div class="container">
        <div class="row justify-content-between">
          <div class="col-xl-8 col-lg-8 col-md-6 col-sm-12">
            <div class="single-footer-caption mb-50">
              <!-- logo -->
              <div class="footer-logo mb-25">
                <a href="index.html"><img src="assets/img/logo/logo2_footer.png" alt=""></a>
              </div>
              <d iv class="header-area">
                <div class="main-header main-header2">
                  <div class="menu-main d-flex align-items-center justify-content-start">
                    <!-- Main-menu -->
                    <div class="main-menu main-menu2">
                      <nav>
                        <ul>
                          <li><a href="index.html">Home</a></li>
                          <li><a href="about.html">About</a></li>
                          <li><a href="services.html">Services</a></li>
                          <li><a href="blog">Blog</a></li>
                          <li><a href="contact.html">Contact</a></li>
                        </ul>
                      </nav>
                    </div>
                  </div>
                </div>
              </d>
              <!-- social -->
              <div class="footer-social mt-50">
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="https://bit.ly/sai4ull"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-pinterest-p"></i></a>
              </div>
            </div>
          </div>
          <div class="col-xl-4 col-lg-4 col-md-6 col-sm-12">
            <div class="single-footer-caption">
              <div class="footer-tittle mb-50">
                <h4>Subscribe newsletter</h4>
              </div>
              <!-- Form -->
              <div class="footer-form">
                <div id="mc_embed_signup">
                  <form target="_blank" action="https://spondonit.us12.list-manage.com/subscribe/post?u=1462626880ade1ac87bd9c93a&amp;id=92a4423d01" method="get" class="subscribe_form relative mail_part" novalidate="true">
                    <input type="email" name="EMAIL" id="newsletter-form-email" placeholder=" Email Address " class="placeholder hide-on-focus" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter your email'">
                    <div class="form-icon">
                      <button type="submit" name="submit" id="newsletter-submit" class="email_icon newsletter-submit button-contactForm">
                        Subscribe
                      </button>
                    </div>
                    <div class="mt-10 info"></div>
                  </form>
                </div>
              </div>
              <div class="footer-tittle">
                <div class="footer-pera">
                  <p>Praesent porttitor, nulla vitae posuere iaculis, arcu nisl dignissim dolor, a pretium misem ut ipsum.</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- footer-bottom area -->
    <div class="footer-bottom-area">
      <div class="container">
        <div class="footer-border">
          <div class="row">
            <div class="col-xl-10 ">
              <div class="footer-copy-right">
                <p>
                  Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="fa fa-heart" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</footer>
<!-- Scroll Up -->
<div id="back-top" >
  <a title="Go to Top" href="#"> <i class="fas fa-level-up-alt"></i></a>
</div>

<!-- JS here -->

<script src="./assets/js/vendor/modernizr-3.5.0.min.js"></script>
<!-- Jquery, Popper, Bootstrap -->
<script src="./assets/js/vendor/jquery-1.12.4.min.js"></script>
<script src="./assets/js/popper.min.js"></script>
<script src="./assets/js/bootstrap.min.js"></script>
<!-- Jquery Mobile Menu -->
<script src="./assets/js/jquery.slicknav.min.js"></script>

<!-- Jquery Slick , Owl-Carousel Plugins -->
<script src="./assets/js/owl.carousel.min.js"></script>
<script src="./assets/js/slick.min.js"></script>

<!-- One Page, Animated-HeadLin -->
<script src="./assets/js/wow.min.js"></script>
<script src="./assets/js/animated.headline.js"></script>
<script src="./assets/js/jquery.magnific-popup.js"></script>

<!-- Nice-select, sticky -->
<script src="./assets/js/jquery.nice-select.min.js"></script>
<script src="./assets/js/jquery.sticky.js"></script>

<!-- contact js -->
<script src="./assets/js/contact.js"></script>
<script src="./assets/js/jquery.form.js"></script>
<script src="./assets/js/jquery.validate.min.js"></script>
<script src="./assets/js/mail-script.js"></script>
<script src="./assets/js/jquery.ajaxchimp.min.js"></script>

<!-- Jquery Plugins, main Jquery -->
<script src="./assets/js/plugins.js"></script>
<script src="./assets/js/main.js"></script>

</body>
</html>