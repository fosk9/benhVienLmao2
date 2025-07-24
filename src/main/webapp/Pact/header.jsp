<%--
  Created by IntelliJ IDEA.
  User: hung6
  Date: 24/05/2025
  Time: 7:03 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>Header</title>
  <meta name="description" content="">
  <meta name="viewport" content="width=device-width, initial-scale=1">

</head>

<body>
<header>
  <!-- Header Start -->
  <div class="header-area">
    <div class="main-header header-sticky">
      <div class="container-fluid">
        <div class="row align-items-center">
          <!-- Logo -->
          <div class="col-xl-2 col-lg-2 col-md-1">
            <div class="logo">
              <a href="<c:url value='/pactHome'/>"><img src="<c:url value='/assets/img/logo/logo.png'/>"
                                                        alt=""></a>
            </div>
          </div>
          <div class="col-xl-10 col-lg-10 col-md-10">
            <div class="menu-main d-flex align-items-center justify-content-end">
              <!-- Main-menu -->
              <div class="main-menu f-right d-none d-lg-block">
                <nav>
                  <ul id="navigation">
                    <c:forEach var="item" items="${systemItems}">
                      <c:choose>
                        <c:when test="${item.itemName == 'Account'}">
                          <li>
                            <a href="<c:url value='/${item.itemUrl}'/>">${item.itemName}</a>
                            <ul class="submenu">
                              <c:forEach var="subItem" items="${systemItems}">
                                <c:if test="${subItem.itemName == 'Logout' || subItem.itemName == 'My Profile' || subItem.itemName == 'Change Password'}">
                                  <li>
                                    <a href="<c:url value='/${subItem.itemUrl}'/>">${subItem.itemName}</a>
                                  </li>
                                </c:if>
                              </c:forEach>
                            </ul>
                          </li>
                        </c:when>
                        <c:when test="${item.itemName != 'Logout' && item.itemName != 'My Profile' && item.itemName != 'Change Password' && item.itemName != 'Book Appointment'}">
                          <li>
                            <a href="<c:url value='/${item.itemUrl}'/>">${item.itemName}</a>
                          </li>
                        </c:when>
                      </c:choose>
                    </c:forEach>
                  </ul>
                </nav>
              </div>
              <div class="header-right-btn f-right d-none d-lg-block ml-15">
                <c:forEach var="item" items="${systemItems}">
                  <c:if test="${item.itemName == 'Book Appointment'}">
                    <a href="<c:url value='/${item.itemUrl}'/>" class="btn header-btn">${item.itemName}</a>
                  </c:if>
                </c:forEach>
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
<script>
  document.addEventListener("DOMContentLoaded", function() {
    // Activate current menu item based on URL
    const currentUrl = window.location.pathname;
    const navLinks = document.querySelectorAll("#navigation li a");
    navLinks.forEach(link => {
      if(link.getAttribute("href") === currentUrl){
        link.classList.add("active");
      }
    });

    // Mobile menu toggle example (if you use Bootstrap or custom)
    const mobileMenu = document.querySelector(".mobile_menu");
    const nav = document.querySelector(".main-menu nav");
    if(mobileMenu && nav){
      mobileMenu.addEventListener("click", function(){
        nav.classList.toggle("open");
      });
    }

    // Example: Log clicked menu item for debug
    navLinks.forEach(link => {
      link.addEventListener("click", function(){
        console.log("Navigating to: " + this.getAttribute("href"));
      });
    });
  });

</script>
</body>
</html>