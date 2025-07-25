<%--
  Created by IntelliJ IDEA.
  User: hung6
  Date: 24/05/2025
  Time: 7:03 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Header Start -->
<div class="header-area">
  <div class="main-header header-sticky">
    <div class="container-fluid">
      <div class="row align-items-center">
        <!-- Logo -->
        <div class="col-xl-2 col-lg-2 col-md-1">
          <div class="logo">
            <a href="#"><img src="${pageContext.request.contextPath}/assets/img/logo/logo.png" alt="Logo"></a>
          </div>
        </div>
        <div class="col-xl-10 col-lg-10 col-md-10">
          <div class="menu-main d-flex align-items-center justify-content-end">
            <!-- Main-menu -->
            <div class="main-menu f-right d-none d-lg-block">
              <nav>
                <ul id="navigation"></ul>
              </nav>
            </div>
            <!-- Header Buttons -->
            <div class="header-right-btn f-right d-none d-lg-block ml-15"></div>
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

<!-- Define contextPath for header.js (move scripts to main pages if needed) -->
<script>
  const contextPath = "${pageContext.request.contextPath}";
</script>