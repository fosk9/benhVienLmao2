<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html class="no-js" lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>${sessionScope.username != null ? sessionScope.username : 'User'}'s Appointments</title>
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
        /* Consistent font with index.jsp, scaled up */
        body, .table th, .table td, .btn, .form-control, label {
            font-family: "Segoe UI", sans-serif;
            font-size: 1.8rem; /* Increased from 1.4rem */
        }

        /* Title styling */
        h2 {
            text-align: center;
            margin: 40px 0; /* Increased from 30px */
            font-size: 2.6rem; /* Increased from 2rem */
            color: #28a745;
        }

        /* Table styling */
        .card {
            border-radius: 15px; /* Increased from 12px */
            overflow: hidden;
            border: 2px solid #28a745; /* Increased from 1px */
            margin-top: 30px; /* Increased from 20px */
        }

        .table {
            border-radius: 15px; /* Increased from 12px */
            overflow: hidden;
        }

        .table thead th {
            background-color: #f1f8f1;
            color: #28a745;
            font-weight: bold;
            padding: 15px; /* Increased from 8px */
        }

        .table-bordered {
            border: 2px solid #28a745; /* Increased from 1px */
        }

        .table-bordered th, .table-bordered td {
            border: 2px solid #28a745; /* Increased from 1px */
            padding: 15px; /* Increased from 8px */
        }

        /* Button styling */
        .btn {
            font-size: 1.6rem; /* Increased from 1.2rem */
            padding: 16px 32px; /* Increased from 12px 24px */
            border-radius: 8px; /* Increased from 6px */
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

        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
            border-color: #c82333;
        }

        .btn-info {
            background-color: #17a2b8;
            border-color: #17a2b8;
        }

        .btn-info:hover {
            background-color: #138496;
            border-color: #138496;
        }

        .btn + .btn {
            margin-left: 15px; /* Increased from 10px */
        }

        /* Search form table styling */
        .search-table {
            width: 100%;
            max-width: 600px; /* Increased from 500px */
            margin: 30px auto; /* Increased from 20px */
            background-color: #f1f8f1;
            padding: 25px; /* Increased from 15px */
            border-radius: 25px; /* Increased from 20px */
            border: 2px solid #28a745; /* Increased from 1px */
        }

        .search-table td {
            padding: 12px; /* Increased from 8px */
            vertical-align: middle;
        }

        .search-table td:first-child {
            font-weight: bold;
            color: #28a745;
            font-size: 1.8rem; /* Increased from 1.2rem */
            width: 40%;
            text-align: right;
        }

        .search-table td:last-child {
            width: 60%;
        }

        .search-table .form-control {
            font-size: 1.6rem; /* Increased from 1.2rem */
            height: 50px; /* Increased for larger inputs */
            width: 100%;
        }

        .search-table .btn {
            font-size: 1.6rem; /* Increased from 1.2rem */
            padding: 14px 28px; /* Increased from 10px 20px */
            border-radius: 8px; /* Increased from 6px */
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

        /* Pagination styling */
        .pagination {
            justify-content: center;
            margin-top: 30px; /* Increased from 20px */
        }

        .page-link {
            font-size: 1.6rem; /* Increased from 1.2rem */
            color: #28a745;
            border-color: #28a745;
            padding: 12px 18px; /* Increased from default */
        }

        .page-link:hover {
            background-color: #f1f8f1;
            color: #218838;
        }

        .page-item.active .page-link {
            background-color: #28a745;
            border-color: #28a745;
            color: #fff;
        }

        .page-item.disabled .page-link {
            color: #6c757d;
        }

        /* Error message styling */
        .error-message {
            color: #dc3545;
            font-size: 1.6rem; /* Increased from 1.2rem */
            text-align: center;
            margin-bottom: 30px; /* Increased from 20px */
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .table th, .table td {
                font-size: 1.6rem; /* Increased from 1.2rem */
            }

            .btn {
                font-size: 1.4rem; /* Increased from 1rem */
                padding: 12px 24px; /* Increased from 8px 16px */
            }

            h2 {
                font-size: 2.2rem; /* Increased from 1.8rem */
            }

            .search-table {
                padding: 15px; /* Increased from 10px */
                max-width: 100%;
            }

            .search-table td:first-child, .search-table td:last-child {
                font-size: 1.6rem; /* Increased from 1.1rem */
                padding: 8px; /* Increased from 5px */
            }

            .search-table .form-control {
                font-size: 1.4rem; /* Increased from 1.1rem */
                height: 45px; /* Adjusted for mobile */
            }

            .search-table .btn {
                font-size: 1.4rem; /* Increased from 1.1rem */
                padding: 10px 20px; /* Increased from 8px 16px */
            }
        }

        /* Flexbox for appointment order (if needed) */
        #flex {
            display: flex;
            flex-direction: column;
        }

        #a { order: 1; }
        #b { order: 2; }
        #c { order: 3; }
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
        <!-- Display user's appointments title -->
        <h2>${sessionScope.username != null ? sessionScope.username : 'User'}'s Appointments</h2>
        <!-- Display error message if set -->
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        <!-- Search Form Start -->
        <table class="search-table">
            <form action="<c:url value='/appointments'/>" method="get" id="searchForm">
                <tr>
                    <td>Appointment Date</td>
                    <td><input type="date" id="appointmentDate" name="appointmentDate" class="form-control" value="${param.appointmentDate}"></td>
                </tr>
                <tr>
                    <td>Type</td>
                    <td>
                        <select id="appointmentTypeId" name="appointmentTypeId" class="form-control">
                            <option value="">All</option>
                            <c:forEach var="type" items="${appointmentTypes}">
                                <option value="${type.appointmentTypeId}"
                                        <c:if test="${param.appointmentTypeId == type.appointmentTypeId}">selected</c:if>>
                                        ${type.typeName}
                                </option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Status</td>
                    <td>
                        <select id="status" name="status" class="form-control">
                            <option value="">All</option>
                            <option value="Unpay" <c:if test="${param.status == 'Unpay'}">selected</c:if>>Unpaid</option>
                            <option value="Confirmed" <c:if test="${param.status == 'Confirmed'}">selected</c:if>>Confirmed</option>
                            <option value="Cancelled" <c:if test="${param.status == 'Cancelled'}">selected</c:if>>Cancelled</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Time Slot</td>
                    <td>
                        <select id="timeSlot" name="timeSlot" class="form-control">
                            <option value="">All</option>
                            <option value="Morning" <c:if test="${param.timeSlot == 'Morning'}">selected</c:if>>Morning</option>
                            <option value="Afternoon" <c:if test="${param.timeSlot == 'Afternoon'}">selected</c:if>>Afternoon</option>
                            <option value="Evening" <c:if test="${param.timeSlot == 'Evening'}">selected</c:if>>Evening</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Request Specialist</td>
                    <td>
                        <select id="requiresSpecialist" name="requiresSpecialist" class="form-control">
                            <option value="">All</option>
                            <option value="Yes" <c:if test="${param.requiresSpecialist == 'Yes'}">selected</c:if>>Yes</option>
                            <option value="No" <c:if test="${param.requiresSpecialist == 'No'}">selected</c:if>>No</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Sort By</td>
                    <td>
                        <select id="sortBy" name="sortBy" class="form-control" onchange="updateSortDir()">
                            <option value="">Default (Newest)</option>
                            <option value="appointmentDate" <c:if test="${sortBy == 'appointmentDate' && sortDir == 'ASC'}">selected</c:if>>Date (Oldest to Newest)</option>
                            <option value="appointmentDate" <c:if test="${sortBy == 'appointmentDate' && sortDir == 'DESC'}">selected</c:if>>Date (Newest to Oldest)</option>
                            <option value="typeName" <c:if test="${sortBy == 'typeName' && sortDir == 'ASC'}">selected</c:if>>Type (A-Z)</option>
                            <option value="typeName" <c:if test="${sortBy == 'typeName' && sortDir == 'DESC'}">selected</c:if>>Type (Z-A)</option>
                        </select>
                        <input type="hidden" id="sortDir" name="sortDir" value="${sortDir}">
                    </td>
                </tr>
                <tr>
                    <td><button type="submit" class="btn btn-primary">Search</button></td>
                    <td><button type="button" class="btn btn-secondary" onclick="resetForm()">Reset</button></td>
                </tr>
            </form>
        </table>
        <!-- Search Form End -->

        <!-- Display appointments in a table -->
        <div class="card">
            <div class="card-body">
                <table class="table table-bordered">
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
                            <td>${appointment.appointmentId}</td>
                            <td><fmt:formatDate value="${appointment.appointmentDate}" pattern="yyyy-MM-dd"/></td>
                            <td>${appointment.timeSlot}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty appointment.appointmentType and not empty appointment.appointmentType.typeName}">
                                        ${appointment.appointmentType.typeName}
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color:red;font-weight:bold;">Unknown Type</span>
                                        <script>
                                            console.warn("Appointment ID ${appointment.appointmentId} missing valid appointmentType: ", ${appointment.appointmentType});
                                        </script>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${appointment.requiresSpecialist}">Yes</c:when>
                                    <c:otherwise>No</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${appointment.status}</td>
                            <td>
                                <c:set var="now" value="<%= new java.sql.Timestamp(System.currentTimeMillis()) %>"/>
                                <c:choose>
                                    <c:when test="${appointment.appointmentDate.time > now.time}">
                                        <c:choose>
                                            <c:when test="${appointment.status == 'Unpay'}">
                                                <a href="<c:url value='/appointments/edit?id=${appointment.appointmentId}'/>"
                                                   class="btn btn-primary">Edit</a>
                                                <a href="<c:url value='/appointments/delete?id=${appointment.appointmentId}'/>"
                                                   class="btn btn-danger" onclick="return confirm('Are you sure?')">Delete</a>
                                            </c:when>
                                        </c:choose>
                                    </c:when>
                                </c:choose>
                                <a href="<c:url value='/appointments/details?id=${appointment.appointmentId}'/>"
                                   class="btn btn-info">Details</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty appointments}">
                        <tr>
                            <td colspan="7" class="text-center">No appointments found.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
                <!-- Pagination controls -->
                <nav>
                    <ul class="pagination">
                        <!-- Previous page link -->
                        <li class="page-item <c:if test='${currentPage == 1}'>disabled</c:if>">
                            <a class="page-link" href="<c:url value='/appointments'>
                                <c:param name='page' value='${currentPage - 1}'/>
                                <c:param name='appointmentDate' value='${param.appointmentDate}'/>
                                <c:param name='timeSlot' value='${param.timeSlot}'/>
                                <c:param name='appointmentTypeId' value='${param.appointmentTypeId}'/>
                                <c:param name='requiresSpecialist' value='${param.requiresSpecialist}'/>
                                <c:param name='status' value='${param.status}'/>
                                <c:param name='sortBy' value='${sortBy}'/>
                                <c:param name='sortDir' value='${sortDir}'/>
                            </c:url>">Previous</a>
                        </li>
                        <!-- Page numbers -->
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item <c:if test='${currentPage == i}'>active</c:if>">
                                <a class="page-link" href="<c:url value='/appointments'>
                                    <c:param name='page' value='${i}'/>
                                    <c:param name='appointmentDate' value='${param.appointmentDate}'/>
                                    <c:param name='timeSlot' value='${param.timeSlot}'/>
                                    <c:param name='appointmentTypeId' value='${param.appointmentTypeId}'/>
                                    <c:param name='requiresSpecialist' value='${param.requiresSpecialist}'/>
                                    <c:param name='status' value='${param.status}'/>
                                    <c:param name='sortBy' value='${sortBy}'/>
                                    <c:param name='sortDir' value='${sortDir}'/>
                                </c:url>">${i}</a>
                            </li>
                        </c:forEach>
                        <!-- Next page link -->
                        <li class="page-item <c:if test='${currentPage == totalPages}'>disabled</c:if>">
                            <a class="page-link" href="<c:url value='/appointments'>
                                <c:param name='page' value='${currentPage + 1}'/>
                                <c:param name='appointmentDate' value='${param.appointmentDate}'/>
                                <c:param name='timeSlot' value='${param.timeSlot}'/>
                                <c:param name='appointmentTypeId' value='${param.appointmentTypeId}'/>
                                <c:param name='requiresSpecialist' value='${param.requiresSpecialist}'/>
                                <c:param name='status' value='${param.status}'/>
                                <c:param name='sortBy' value='${sortBy}'/>
                                <c:param name='sortDir' value='${sortDir}'/>
                            </c:url>">Next</a>
                        </li>
                    </ul>
                </nav>
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
<script>
    // Update sort direction based on sortBy selection
    function updateSortDir() {
        const sortBySelect = document.getElementById('sortBy');
        const sortDirInput = document.getElementById('sortDir');
        const selectedOption = sortBySelect.selectedOptions[0].text;
        if (selectedOption.includes('(Z-A)') || selectedOption.includes('Newest') || selectedOption.includes('Latest')) {
            sortDirInput.value = 'DESC';
        } else {
            sortDirInput.value = 'ASC';
        }
        document.getElementById('searchForm').submit();
    }

    // Reset search form to default values
    function resetForm() {
        const form = document.getElementById('searchForm');
        form.reset();
        document.getElementById('sortDir').value = 'DESC';
        form.submit();
    }
</script>
</body>
</html>