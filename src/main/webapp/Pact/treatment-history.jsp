<%--
  Created by IntelliJ IDEA.
  User: Fosk Jesky
  Date: 7/3/2025
  Time: 2:22 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Treatment History</title>
    <link rel="stylesheet" href="<c:url value='/assets/css/bootstrap.min.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
    <style>
        body, .table th, .table td, .btn, .form-control, label {
            font-family: "Segoe UI", sans-serif;
            font-size: 1.8rem;
        }

        h2 {
            text-align: center;
            margin: 40px 0;
            font-size: 2.6rem;
            color: #28a745;
        }

        .card {
            border-radius: 15px;
            overflow: hidden;
            border: 2px solid #28a745;
            margin-top: 30px;
        }

        .table {
            border-radius: 15px;
            overflow: hidden;
        }

        .table thead th {
            background-color: #f1f8f1;
            color: #28a745;
            font-weight: bold;
            padding: 15px;
        }

        .table-bordered {
            border: 2px solid #28a745;
        }

        .table-bordered th, .table-bordered td {
            border: 2px solid #28a745;
            padding: 15px;
        }

        .btn {
            font-size: 1.6rem;
            padding: 16px 32px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background-color: #28a745;
            border-color: #28a745;
        }

        .btn-primary:hover {
            background-color: #218838;
            border-color: #218838;
        }

        .error-message {
            color: #dc3545;
            font-size: 1.6rem;
            text-align: center;
            margin-bottom: 30px;
        }

        .search-table {
            width: 100%;
            max-width: 600px;
            margin: 30px auto;
            background-color: #f1f8f1;
            padding: 25px;
            border-radius: 25px;
            border: 2px solid #28a745;
        }

        .search-table td {
            padding: 12px;
            vertical-align: middle;
        }

        .search-table td:first-child {
            font-weight: bold;
            color: #28a745;
            font-size: 1.8rem;
            width: 40%;
            text-align: right;
        }

        .search-table td:last-child {
            width: 60%;
        }

        .search-table .form-control {
            font-size: 1.6rem;
            height: 50px;
            width: 100%;
        }

        .search-table .btn {
            font-size: 1.6rem;
            padding: 14px 28px;
            border-radius: 8px;
        }

        .search-table .btn-primary {
            background-color: #28a745;
            border-color: #28a745;
        }

        .search-table .btn-primary:hover {
            background-color: #218838;
            border-color: #218838;
        }

        .search-table .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }

        .search-table .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #5a6268;
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
                            <a href="<c:url value='/pactHome'/>">HealthCare</a>
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
        <h2>Treatment History</h2>
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        <!-- Search Table Start -->
        <table class="search-table">
            <form action="<c:url value='/treatment/history'/>" method="get" id="searchForm">
                <tr>
                    <td>Treatment Date</td>
                    <td>
                        <input type="date" name="treatmentDate" class="form-control" value="${param.treatmentDate}">
                    </td>
                </tr>
                <tr>
                    <td>Treatment Type</td>
                    <td>
                        <input type="text" name="treatmentType" class="form-control" value="${param.treatmentType}" placeholder="Type name">
                    </td>
                </tr>
                <tr>
                    <td>Appointment ID</td>
                    <td>
                        <input type="text" name="appointmentId" class="form-control" value="${param.appointmentId}" placeholder="Appointment ID">
                    </td>
                </tr>
                <tr>
                    <td style="text-align:center;"><button type="submit" class="btn btn-primary">Search</button></td>
                    <td style="text-align:center;"><button type="button" class="btn btn-secondary" onclick="resetForm()">Reset</button></td>
                </tr>
            </form>
        </table>
        <!-- Search Table End -->
        <div class="card">
            <div class="card-body">
                <table class="table table-bordered">
                    <thead>
                    <tr>
                        <th>Treatment ID</th>
                        <th>Appointment ID</th>
                        <th>Treatment Type</th>
                        <th>Notes</th>
                        <th>Created At</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="treatment" items="${empty treatments ? [] : treatments}">
                        <tr>
                            <td>${treatment.treatmentId}</td>
                            <td>${treatment.appointmentId}</td>
                            <td>${treatment.treatmentType}</td>
                            <td>${treatment.treatmentNotes}</td>
                            <td>
                                <fmt:formatDate value="${treatment.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty treatments}">
                        <tr>
                            <td colspan="5" class="text-center">No treatment history found.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
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
<script src="<c:url value='/assets/js/vendor/modernizr-3.5.0.min.js'/>" ></script>
<script src="<c:url value='/assets/js/vendor/jquery-1.12.4.min.js'/>" ></script>
<script src="<c:url value='/assets/js/popper.min.js'/>" ></script>
<script src="<c:url value='/assets/js/bootstrap.min.js'/>" ></script>
<script src="<c:url value='/assets/js/jquery.slicknav.min.js'/>" ></script>
<script src="<c:url value='/assets/js/owl.carousel.min.js'/>" ></script>
<script src="<c:url value='/assets/js/slick.min.js'/>" ></script>
<script src="<c:url value='/assets/js/wow.min.js'/>" ></script>
<script src="<c:url value='/assets/js/animated.headline.js'/>" ></script>
<script src="<c:url value='/assets/js/jquery.magnific-popup.js'/>" ></script>
<script src="<c:url value='/assets/js/gijgo.min.js'/>" ></script>
<script src="<c:url value='/assets/js/jquery.nice-select.min.js'/>" ></script>
<script src="<c:url value='/assets/js/jquery.sticky.js'/>" ></script>
<script src="<c:url value='/assets/js/jquery.counterup.min.js'/>" ></script>
<script src="<c:url value='/assets/js/waypoints.min.js'/>" ></script>
<script src="<c:url value='/assets/js/jquery.countdown.min.js'/>" ></script>
<script src="<c:url value='/assets/js/hover-direction-snake.min.js'/>" ></script>
<script src="<c:url value='/assets/js/contact.js'/>" ></script>
<script src="<c:url value='/assets/js/jquery.form.js'/>" ></script>
<script src="<c:url value='/assets/js/jquery.validate.min.js'/>" ></script>
<script src="<c:url value='/assets/js/mail-script.js'/>" ></script>
<script src="<c:url value='/assets/js/jquery.ajaxchimp.min.js'/>" ></script>
<script src="<c:url value='/assets/js/plugins.js'/>" ></script>
<script src="<c:url value='/assets/js/main.js'/>" ></script>
<script>
    function resetForm() {
        document.getElementById('searchForm').reset();
        document.getElementById('searchForm').submit();
    }
</script>
</body>
</html>
