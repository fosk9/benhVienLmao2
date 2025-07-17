<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Treatment History - benhVienLmao</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/assets/css/fontawesome-all.min.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&display=swap" rel="stylesheet">
    <style>
        /* Minimalist and bold styling */
        body {
            font-family: "Playfair Display", serif;
            background: #f8f9fa; /* Clean light background */
            color: #333;
            margin: 0;
        }
        /* Container styling */
        .container {
            max-width: 1400px; /* Larger container */
            padding: 50px 20px;
        }
        /* Header styling */
        h2 {
            font-size: 4.5rem; /* Larger title */
            font-weight: 700;
            text-align: center;
            color: #28a745;
            margin: 50px 0;
            text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.1);
        }
        /* Search form styling */
        .search-table {
            background: #fff;
            border: 3px solid #28a745; /* Thicker border */
            border-radius: 25px; /* Larger rounded corners */
            padding: 30px; /* Larger padding */
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            max-width: 900px; /* Larger form */
            margin: 0 auto 50px;
        }
        .search-table td {
            padding: 15px; /* Larger padding */
        }
        .search-table td:first-child {
            color: #28a745;
            font-weight: 600;
            font-size: 1.8rem; /* Larger label text */
            text-align: right;
            width: 35%;
        }
        .search-table td:last-child {
            width: 65%;
        }
        .search-table .form-control, .search-table .form-select {
            border: 2px solid #28a745; /* Thicker border */
            font-size: 1.6rem; /* Larger input text */
            height: 50px;
            border-radius: 12px;
            transition: border-color 0.3s;
        }
        .search-table .form-control:focus, .search-table .form-select:focus {
            border-color: #218838;
            box-shadow: 0 0 8px rgba(40, 167, 69, 0.3);
        }
        .search-table .btn {
            padding: 12px 30px;
            font-size: 1.6rem; /* Larger button text */
            border-radius: 12px;
            transition: transform 0.2s;
        }
        .search-table .btn:hover {
            transform: translateY(-3px);
        }
        .btn-primary {
            background: #28a745;
            border: none;
        }
        .btn-primary:hover {
            background: #218838;
        }
        .btn-secondary {
            background: #6c757d;
            border: none;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }
        /* Table styling */
        .table-container {
            border-radius: 20px; /* Larger rounded corners */
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            background: #fff;
        }
        .table {
            margin-bottom: 0;
        }
        .table thead th {
            background: #28a745;
            color: #fff;
            font-weight: 600;
            font-size: 1.8rem; /* Larger header text */
            padding: 20px; /* Larger padding */
            text-align: center;
        }
        .table tbody tr {
            transition: background-color 0.2s;
        }
        .table tbody tr:hover {
            background-color: #f1f8f1;
        }
        .table td {
            vertical-align: middle;
            padding: 20px; /* Larger padding */
            text-align: center;
            font-size: 1.6rem; /* Larger cell text */
        }
        /* Error message styling */
        .error-message {
            color: #dc3545;
            font-size: 1.8rem; /* Larger text */
            font-weight: 500;
            text-align: center;
            margin: 40px 0;
            background: #fff;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        /* Header and footer enhancements */
        .header-area {
            background: #fff;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        .footer-wrappr {
            background: #28a745;
            color: #fff;
            padding: 40px 0;
        }
        .footer-social a {
            color: #fff;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            padding: 12px;
            margin-right: 12px;
            font-size: 1.6rem; /* Larger icons */
            transition: background 0.3s;
        }
        .footer-social a:hover {
            background: rgba(255, 255, 255, 0.4);
        }
        .footer-copy-right p {
            font-size: 1.6rem; /* Larger footer text */
        }
        /* Responsive adjustments */
        @media (max-width: 768px) {
            h2 {
                font-size: 3rem;
            }
            .search-table {
                padding: 20px;
                max-width: 100%;
            }
            .search-table td:first-child {
                font-size: 1.4rem;
                text-align: left;
            }
            .search-table .form-control, .search-table .form-select {
                font-size: 1.2rem;
                height: 40px;
            }
            .search-table .btn {
                font-size: 1.2rem;
                padding: 10px 20px;
            }
            .table td, .table th {
                font-size: 1.2rem;
                padding: 12px;
            }
            .error-message {
                font-size: 1.4rem;
                padding: 15px;
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
                                <img src="<c:url value='/assets/img/logo/logo.png'/>" alt="Logo">
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
                            <div class="header-right-btn f-right d-none d-lg-block ml-15">
                                <a href="<c:url value='/book-appointment'/>" class="btn header-btn">Book Appointment</a>
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
    <div class="container">
        <!-- Page title -->
        <h2>Treatment History</h2>
        <!-- Error message -->
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        <!-- Search Table Start -->
        <form action="<c:url value='/treatment/history'/>" method="get" id="searchForm">
            <table class="search-table">
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
                    <td colspan="2" class="text-center">
                        <button type="submit" class="btn btn-primary"><i class="fas fa-search me-2"></i>Search</button>
                        <button type="button" class="btn btn-secondary" onclick="resetForm()"><i class="fas fa-undo me-2"></i>Reset</button>
                    </td>
                </tr>
            </table>
        </form>
        <!-- Search Table End -->
        <!-- Treatment History Table -->
        <div class="table-container">
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
</main>
<footer class="footer-wrappr">
    <div class="container">
        <div class="footer-social text-center">
            <a href="https://www.facebook.com/benhvienlmao" target="_blank"><i class="fab fa-facebook-f"></i></a>
            <a href="https://www.twitter.com/benhvienlmao" target="_blank"><i class="fab fa-twitter"></i></a>
            <a href="https://www.instagram.com/benhvienlmao" target="_blank"><i class="fab fa-instagram"></i></a>
        </div>
        <div class="footer-copy-right text-center">
            <p>&copy; 2023 benhVienLmao. All rights reserved.</p>
        </div>
    </div>
<div id="back-top">
    <a title="Go to Top" href="#"><i class="fas fa-level-up-alt"></i></a>
</div>
<script src="<c:url value='/assets/js/vendor/modernizr-3.5.0.min.js'/>"></script>
<script src="<c:url value='/assets/js/vendor/jquery-1.12.4.min.js'/>"></script>
<script src="<c:url value='/assets/js/bootstrap.min.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.slicknav.min.js'/>"></script>
<script src="<c:url value='/assets/js/main.js'/>"></script>
<script>
    function resetForm() {
        document.getElementById('searchForm').reset();
        document.getElementById('searchForm').submit();
    }
</script>
</body>
</html>