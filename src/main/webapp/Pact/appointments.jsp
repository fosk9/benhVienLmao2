<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html class="no-js" lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>My Appointments</title>
  <meta name="description" content="">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="<c:url value='/assets/css/bootstrap.min.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/owl.carousel.min.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/slicknav.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/flaticon.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/gijgo.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/animate.min.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/animated-headline.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/magnific-popup.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/fontawesome-all.min.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/themify-icons.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/slick.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/nice-select.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
  <style>
    /* ===== GLOBAL ENHANCEMENTS ===== */
    body {
      background: linear-gradient(135deg, #f0f9f2 0%, #ffffff 50%, #f0f9f2 100%);
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      min-height: 100vh;
    }

    /* ===== HEADER ENHANCEMENTS ===== */
    .header-area {
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(10px);
      box-shadow: 0 2px 20px rgba(40, 167, 69, 0.1);
      border-bottom: 1px solid rgba(40, 167, 69, 0.1);
    }

    .logo a {
      font-size: 1.8rem;
      font-weight: 700;
      color: #28a745 !important;
      text-decoration: none;
      display: flex;
      align-items: center;
    }

    .logo a:before {
      margin-right: 8px;
      font-size: 1.5rem;
    }

    #navigation li a {
      color: #6c757d;
      font-weight: 500;
      transition: all 0.3s ease;
      position: relative;
    }

    #navigation li a:hover {
      color: #28a745;
    }

    /* ===== MAIN CONTENT STYLING ===== */
    main {
      padding: 60px 0;
      min-height: calc(100vh - 200px);
    }

    .container {
      max-width: 1400px;
    }

    /* ===== TITLE STYLING ===== */
    h2 {
      font-size: 3rem;
      text-align: center;
      margin-bottom: 50px;
      color: #28a745;
      font-weight: 700;
      position: relative;
      text-shadow: 0 2px 4px rgba(40, 167, 69, 0.1);
    }

    h2:after {
      content: '';
      position: absolute;
      bottom: -15px;
      left: 50%;
      transform: translateX(-50%);
      width: 80px;
      height: 4px;
      background: linear-gradient(90deg, #28a745, #20c997);
      border-radius: 2px;
    }

    /* ===== CARD ENHANCEMENTS ===== */
    .card {
      border: none;
      border-radius: 20px;
      box-shadow: 0 20px 60px rgba(40, 167, 69, 0.15);
      background: white;
      overflow: hidden;
      position: relative;
    }

    .card:before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 5px;
      background: linear-gradient(90deg, #28a745, #20c997, #17a2b8);
    }

    .card-body {
      padding: 0;
    }

    /* ===== TABLE STYLING ===== */
    .table-container {
      overflow-x: auto;
      border-radius: 0 0 20px 20px;
    }

    .table {
      margin-bottom: 0;
      font-size: 1.1rem;
      border-collapse: separate;
      border-spacing: 0;
    }

    .table thead th {
      background: linear-gradient(135deg, #28a745, #20c997);
      color: white;
      font-weight: 600;
      font-size: 1.1rem;
      padding: 20px 15px;
      border: none;
      text-align: center;
      position: sticky;
      top: 0;
      z-index: 10;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .table thead th:first-child {
      border-radius: 0;
    }

    .table thead th:last-child {
      border-radius: 0;
    }

    .table tbody td {
      padding: 20px 15px;
      border: none;
      border-bottom: 1px solid #f1f3f4;
      vertical-align: middle;
      text-align: center;
      transition: all 0.3s ease;
    }

    .table tbody tr {
      transition: all 0.3s ease;
    }

    .table tbody tr:hover {
      background: linear-gradient(135deg, #f8f9fa, #e9ecef);
      transform: translateY(-2px);
      box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }

    .table tbody tr:last-child td {
      border-bottom: none;
    }

    /* ===== STATUS BADGES ===== */
    .status-badge {
      padding: 8px 16px;
      border-radius: 20px;
      font-weight: 600;
      font-size: 0.9rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }

    .status-confirmed {
      background: linear-gradient(135deg, #28a745, #20c997);
      color: white;
    }

    .status-confirmed:before {
      content: "✓";
    }

    .status-pending {
      background: linear-gradient(135deg, #ffc107, #ffb300);
      color: #856404;
    }

    .status-pending:before {
      content: "⏳";
    }

    .status-cancelled {
      background: linear-gradient(135deg, #dc3545, #c82333);
      color: white;
    }

    .status-cancelled:before {
      content: "✗";
    }

    .status-completed {
      background: linear-gradient(135deg, #17a2b8, #138496);
      color: white;
    }

    .status-completed:before {
      content: "✓";
    }

    /* ===== SPECIALIST BADGES ===== */
    .specialist-badge {
      padding: 6px 12px;
      border-radius: 15px;
      font-weight: 600;
      font-size: 0.85rem;
      display: inline-flex;
      align-items: center;
      gap: 4px;
    }

    .specialist-yes {
      background: linear-gradient(135deg, #e3f2fd, #bbdefb);
      color: #1976d2;
      border: 1px solid #2196f3;
    }

    .specialist-yes:before {
      content: "👨‍⚕️";
    }

    .specialist-no {
      background: linear-gradient(135deg, #f3e5f5, #e1bee7);
      color: #7b1fa2;
      border: 1px solid #9c27b0;
    }

    .specialist-no:before {
      content: "👩‍⚕️";
    }

    /* ===== BUTTON ENHANCEMENTS ===== */
    .btn {
      font-size: 0.9rem;
      font-weight: 600;
      padding: 8px 16px;
      border-radius: 8px;
      border: none;
      transition: all 0.3s ease;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      margin: 2px;
      position: relative;
      overflow: hidden;
    }

    .btn:before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
      transition: left 0.5s;
    }

    .btn:hover:before {
      left: 100%;
    }

    .btn-primary {
      background: linear-gradient(135deg, #007bff, #0056b3);
      color: white;
      box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
    }

    .btn-primary:hover {
      background: linear-gradient(135deg, #0056b3, #004085);
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(0, 123, 255, 0.4);
      color: white;
    }

    .btn-danger {
      background: linear-gradient(135deg, #dc3545, #c82333);
      color: white;
      box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
    }

    .btn-danger:hover {
      background: linear-gradient(135deg, #c82333, #a71e2a);
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(220, 53, 69, 0.4);
      color: white;
    }

    .btn-info {
      background: linear-gradient(135deg, #17a2b8, #138496);
      color: white;
      box-shadow: 0 4px 15px rgba(23, 162, 184, 0.3);
    }

    .btn-info:hover {
      background: linear-gradient(135deg, #138496, #0f6674);
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(23, 162, 184, 0.4);
      color: white;
    }

    /* ===== ACTION BUTTONS CONTAINER ===== */
    .action-buttons {
      display: flex;
      gap: 5px;
      justify-content: center;
      flex-wrap: wrap;
    }

    /* ===== DATE AND TIME STYLING ===== */
    .date-display {
      font-weight: 600;
      color: #28a745;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
    }

    .date-display:before {
      content: "📅";
    }

    .time-display {
      font-weight: 600;
      color: #17a2b8;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
    }

    .time-display:before {
      content: "🕐";
    }

    /* ===== TYPE DISPLAY ===== */
    .type-display {
      font-weight: 600;
      color: #6f42c1;
      background: linear-gradient(135deg, #f8f9fa, #e9ecef);
      padding: 8px 12px;
      border-radius: 10px;
      border: 1px solid #dee2e6;
    }

    .type-unknown {
      color: #dc3545;
      background: linear-gradient(135deg, #f8d7da, #f5c6cb);
      border: 1px solid #f5c6cb;
    }

    /* ===== ID STYLING ===== */
    .id-display {
      font-weight: 700;
      color: #495057;
      background: linear-gradient(135deg, #e9ecef, #dee2e6);
      padding: 6px 10px;
      border-radius: 8px;
      font-family: 'Courier New', monospace;
    }

    /* ===== EMPTY STATE ===== */
    .empty-state {
      text-align: center;
      padding: 60px 20px;
      color: #6c757d;
    }

    .empty-state h3 {
      color: #28a745;
      margin-bottom: 20px;
      font-size: 2rem;
    }

    .empty-state p {
      font-size: 1.2rem;
      margin-bottom: 30px;
    }

    .empty-state .btn {
      font-size: 1.1rem;
      padding: 12px 30px;
    }

    /* ===== RESPONSIVE DESIGN ===== */
    @media (max-width: 1200px) {
      .container {
        max-width: 100%;
        padding: 0 20px;
      }
    }

    @media (max-width: 768px) {
      h2 {
        font-size: 2.2rem;
        margin-bottom: 30px;
      }

      .table {
        font-size: 0.9rem;
      }

      .table thead th,
      .table tbody td {
        padding: 12px 8px;
      }

      .btn {
        font-size: 0.8rem;
        padding: 6px 12px;
      }

      .action-buttons {
        flex-direction: column;
        gap: 3px;
      }

      .status-badge,
      .specialist-badge {
        font-size: 0.8rem;
        padding: 6px 10px;
      }
    }

    @media (max-width: 576px) {
      main {
        padding: 30px 0;
      }

      h2 {
        font-size: 1.8rem;
      }

      .card {
        margin: 0 10px;
        border-radius: 15px;
      }

      .table {
        font-size: 0.8rem;
      }

      .table thead th,
      .table tbody td {
        padding: 10px 6px;
      }
    }

    /* ===== LOADING ANIMATION ===== */
    .table-loading {
      position: relative;
    }

    .table-loading:after {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(255, 255, 255, 0.8);
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 20px;
    }

    /* ===== SMOOTH TRANSITIONS ===== */
    * {
      transition: all 0.3s ease;
    }

    /* ===== ACCESSIBILITY IMPROVEMENTS ===== */
    @media (prefers-reduced-motion: reduce) {
      * {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
      }
    }
  </style>
</head>
<body>
<header>
  <div class="header-area">
    <div class="main-header header-sticky">
      <div class="container-fluid">
        <div class="row align-items-center">
          <div class="col-xl-2 col-lg-2 col-md-1">
            <div class="logo">
              <a href="<c:url value='/pactHome'/>">
                <img src="<c:url value='/assets/img/logo/logo.png'/>" alt="Dental Care Logo" class="img-fluid img-optimized">
              </a>
            </div>
          </div>
          <div class="col-xl-10 col-lg-10 col-md-10">
            <div class="menu-main d-flex align-items-center justify-content-end">
              <div class="main-menu f-right d-none d-lg-block">
                <nav>
                  <ul id="navigation">
                    <li><a href="<c:url value='/pactHome'/>">Home</a></li>
                    <li><a href="<c:url value='/book-appointment'/>">Book Appointment</a></li>
                    <li><a href="<c:url value='/logout'/>">Logout</a></li>
                  </ul>
                </nav>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="mobile_menu d-block d-lg-none"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</header>

<main>
  <div class="container mt-5">
    <h2>My Appointments</h2>

    <div class="card">
      <div class="card-body">
        <c:choose>
          <c:when test="${empty appointments}">
            <div class="empty-state">
              <h3>📅 No Appointments Found</h3>
              <p>You don't have any appointments scheduled yet.</p>
              <a href="<c:url value='/book-appointment'/>" class="btn btn-primary">
                Book Your First Appointment
              </a>
            </div>
          </c:when>
          <c:otherwise>
            <div class="table-container">
              <table class="table">
                <thead>
                <tr>
                  <th>ID</th>
                  <th>Appointment Date</th>
                  <th>Time Slot</th>
                  <th>Type</th>
                  <th>Requires Specialist</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="appointment" items="${appointments}">
                  <tr>
                    <td>
                      <span class="id-display">#${appointment.appointmentId}</span>
                    </td>
                    <td>
                      <span class="date-display">
                        <fmt:formatDate value="${appointment.appointmentDate}" pattern="yyyy-MM-dd"/>
                      </span>
                    </td>
                    <td>
                      <span class="time-display">${appointment.timeSlot}</span>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty appointment.appointmentType and not empty appointment.appointmentType.typeName}">
                          <span class="type-display">${appointment.appointmentType.typeName}</span>
                        </c:when>
                        <c:otherwise>
                          <span class="type-display type-unknown">Unknown Type</span>
                          <script>
                            console.warn("Appointment ID ${appointment.appointmentId} missing valid appointmentType: ", ${appointment.appointmentType});
                          </script>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${appointment.requiresSpecialist}">
                          <span class="specialist-badge specialist-yes">Yes</span>
                        </c:when>
                        <c:otherwise>
                          <span class="specialist-badge specialist-no">No</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${appointment.status == 'Confirmed'}">
                          <span class="status-badge status-confirmed">${appointment.status}</span>
                        </c:when>
                        <c:when test="${appointment.status == 'Pending'}">
                          <span class="status-badge status-pending">${appointment.status}</span>
                        </c:when>
                        <c:when test="${appointment.status == 'Cancelled'}">
                          <span class="status-badge status-cancelled">${appointment.status}</span>
                        </c:when>
                        <c:when test="${appointment.status == 'Completed'}">
                          <span class="status-badge status-completed">${appointment.status}</span>
                        </c:when>
                        <c:otherwise>
                          <span class="status-badge status-pending">${appointment.status}</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <div class="action-buttons">
                        <c:set var="now" value="<%= new java.sql.Timestamp(System.currentTimeMillis()) %>" />
                        <c:choose>
                          <c:when test="${appointment.appointmentDate.time > now.time}">
                            <a href="<c:url value='/appointments/edit?id=${appointment.appointmentId}'/>"
                               class="btn btn-sm btn-primary" title="Edit Appointment">Edit</a>
                            <a href="<c:url value='/appointments/delete?id=${appointment.appointmentId}'/>"
                               class="btn btn-sm btn-danger"
                               onclick="return confirm('Are you sure you want to delete this appointment?')"
                               title="Delete Appointment">Delete</a>
                          </c:when>
                        </c:choose>
                        <a href="<c:url value='/appointments/details?id=${appointment.appointmentId}'/>"
                           class="btn btn-sm btn-info" title="View Details">Details</a>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
                </tbody>
              </table>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</main>

<footer>
  <div class="footer-wrappr section-bg3">
    <div class="footer-area footer-padding">
      <div class="container">
        <div class="row justify-content-between">
          <div class="col-xl-8 col-lg-8 col-md-6 col-sm-12">
            <div class="single-footer-caption mb-50">
              <div class="footer-logo mb-25">
                <a href="<c:url value='/pactHome'/>">HealthCare</a>
              </div>
              <div class="header-area">
                <div class="main-header main-header2">
                  <div class="menu-main d-flex align-items-center justify-content-start">
                    <div class="main-menu main-menu2">
                      <nav>
                        <ul>
                          <li><a href="<c:url value='/pactHome'/>">Home</a></li>
                          <li><a href="<c:url value='/about'/>">About</a></li>
                          <li><a href="<c:url value='/services'/>">Services</a></li>
                          <li><a href="<c:url value='/blog'/>">Blog</a></li>
                          <li><a href="<c:url value='/contact'/>">Contact</a></li>
                        </ul>
                      </nav>
                    </div>
                  </div>
                </div>
              </div>
              <div class="footer-social mt-50">
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="https://bit.ly/sai4ull"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-pinterest-p"></i></a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="footer-bottom-area">
      <div class="container">
        <div class="footer-border">
          <div class="row">
            <div class="col-xl-10">
              <div class="footer-copy-right">
                <p>Group 3 - SE1903 - SWP391 Summer2025</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</footer>

<div id="back-top">
  <a title="Go to Top" href="#"> <i class="fas fa-level-up-alt"></i></a>
</div>

<script src="<c:url value='/assets/js/vendor/modernizr-3.5.0.min.js'/>"></script>
<script src="<c:url value='/assets/js/vendor/jquery-1.12.4.min.js'/>"></script>
<script src="<c:url value='/assets/js/popper.min.js'/>"></script>
<script src="<c:url value='/assets/js/bootstrap.min.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.slicknav.min.js'/>"></script>
<script src="<c:url value='/assets/js/owl.carousel.min.js'/>"></script>
<script src="<c:url value='/assets/js/slick.min.js'/>"></script>
<script src="<c:url value='/assets/js/wow.min.js'/>"></script>
<script src="<c:url value='/assets/js/animated.headline.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.magnific-popup.js'/>"></script>
<script src="<c:url value='/assets/js/gijgo.min.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.nice-select.min.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.sticky.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.counterup.min.js'/>"></script>
<script src="<c:url value='/assets/js/waypoints.min.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.countdown.min.js'/>"></script>
<script src="<c:url value='/assets/js/hover-direction-snake.min.js'/>"></script>
<script src="<c:url value='/assets/js/contact.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.form.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.validate.min.js'/>"></script>
<script src="<c:url value='/assets/js/mail-script.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.ajaxchimp.min.js'/>"></script>
<script src="<c:url value='/assets/js/plugins.js'/>"></script>
<script src="<c:url value='/assets/js/main.js'/>"></script>
</body>
</html>