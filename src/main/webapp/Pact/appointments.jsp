<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>${sessionScope.username != null ? sessionScope.username : 'User'}'s Appointments</title>
    <meta name="description" content="View and manage your appointments with ease.">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/assets/css/fontawesome-all.min.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&display=swap" rel="stylesheet">
    <style>
        /* Existing styles remain unchanged */
        body {
            font-family: "Segoe UI", sans-serif;
            background: #f8f9fa;
            color: #333;
            margin: 0;
        }
        .container {
            max-width: 1000px;
            padding: 50px 20px;
        }
        h2 {
            font-size: 2rem;
            font-weight: 700;
            text-align: center;
            color: #28a745;
            margin: 50px 0;
            text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.1);
        }
        .btn-add-new {
            background: #28a745;
            border: none;
            padding: 15px 35px;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 12px;
            color: #fff;
            transition: transform 0.2s, box-shadow 0.3s;
            display: block;
            margin: 0 auto 40px;
            text-align: center;
        }
        .btn-add-new:hover {
            background: #218838;
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        /* Updated Search Form Styling - Horizontal Layout */
        .search-table {
            background: #fff;
            border: 3px solid #28a745;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            max-width: 900px;
            margin: 0 auto 50px;
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: center;
            gap: 15px; /* Space between items */
        }
        .search-table .form-group {
            flex: 1;
            min-width: 200px; /* Ensure minimum width for responsiveness */
            margin: 0;
        }
        .search-table label {
            color: #28a745;
            font-weight: 600;
            font-size: 1rem;
            display: block;
            margin-bottom: 5px;
        }
        .search-table .form-control, .search-table .form-select {
            border: 2px solid #28a745;
            font-size: 1rem;
            height: 50px;
            border-radius: 12px;
            transition: border-color 0.3s;
            width: 100%; /* Full width within flex item */
        }
        .search-table .form-control:focus, .search-table .form-select:focus {
            border-color: #218838;
            box-shadow: 0 0 8px rgba(40, 167, 69, 0.3);
        }
        .search-table .btn {
            padding: 12px 30px;
            font-size: 1rem;
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
        /* Remaining styles remain unchanged */
        .table-container {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            background: #fff;
        }
        .table thead th {
            background: #28a745;
            color: #fff;
            font-weight: 600;
            font-size: 1rem;
            padding: 10px;
            text-align: center;
        }
        .table tbody tr:hover {
            background-color: #f1f8f1;
        }
        .table td {
            vertical-align: middle;
            padding: 10px;
            text-align: center;
            font-size: 1rem;
        }
        .btn-action {
            padding: 5px 15px;
            font-size: 1rem;
            margin: 0 8px;
            border-radius: 10px;
            transition: transform 0.2s;
        }
        .btn-action:hover {
            transform: translateY(-3px);
        }
        .error-message {
            color: #dc3545;
            font-size: 1rem;
            font-weight: 500;
            text-align: center;
            margin-bottom: 40px;
            background: #fff;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        .pagination {
            margin-top: 40px;
            justify-content: center;
        }
        .page-link {
            font-size: 1rem;
            color: #28a745;
            border: 2px solid #28a745;
            padding: 12px 18px;
            border-radius: 10px;
            transition: background-color 0.3s, transform 0.2s;
        }
        .page-link:hover {
            background-color: #f1f8f1;
            color: #218838;
            transform: translateY(-3px);
        }
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .search-table {
                flex-direction: column;
                padding: 20px;
                max-width: 100%;
            }
            .search-table .form-group {
                min-width: 100%;
            }
            .search-table label {
                font-size: 1.4rem;
            }
            .search-table .form-control, .search-table .form-select {
                font-size: 1.2rem;
                height: 40px;
            }
            .search-table .btn {
                font-size: 1.2rem;
                padding: 10px 20px;
            }
        }
    </style>
</head>
<body>
<!-- Preloader Start -->
<div id="preloader-active">
    <div class="preloader d-flex align-items-center justify-content-center">
        <div class="preloader-inner position-relative">
            <div class="preloader-circle"></div>
            <div class="preloader-img pere-text">
                <img src="assets/img/logo/loder.png" alt="Preloader">
            </div>
        </div>
    </div>
</div>
<!-- Preloader End -->
<jsp:include page="/Pact/header.jsp"/>
<main>
    <div class="container">
        <h2>${sessionScope.username != null ? sessionScope.username : 'User'}'s Appointments</h2>
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        <a href="<c:url value='/book-appointment'/>" class="btn-add-new"><i class="fas fa-calendar-plus me-2"></i>Book Appointment</a>
        <!-- Updated Search Form - Horizontal Layout -->
        <form action="<c:url value='/appointments'/>" method="get" id="searchForm">
            <div class="search-table">
                <div class="form-group">
                    <label for="appointmentDate">Appointment Date</label>
                    <input type="date" id="appointmentDate" name="appointmentDate" class="form-control" value="${param.appointmentDate}">
                </div>
                <div class="form-group">
                    <label for="appointmentTypeId">Type</label>
                    <select id="appointmentTypeId" name="appointmentTypeId" class="form-select">
                        <option value="">All</option>
                        <c:forEach var="type" items="${appointmentTypes}">
                            <option value="${type.appointmentTypeId}"
                                    <c:if test="${param.appointmentTypeId == type.appointmentTypeId}">selected</c:if>>
                                    ${type.typeName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status" class="form-select">
                        <option value="">All</option>
                        <option value="Unpay" <c:if test="${param.status == 'Unpay'}">selected</c:if>>Unpaid</option>
                        <option value="Confirmed" <c:if test="${param.status == 'Confirmed'}">selected</c:if>>Confirmed</option>
                        <option value="Cancelled" <c:if test="${param.status == 'Cancelled'}">selected</c:if>>Cancelled</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="timeSlot">Time Slot</label>
                    <select id="timeSlot" name="timeSlot" class="form-select">
                        <option value="">All</option>
                        <option value="Morning" <c:if test="${param.timeSlot == 'Morning'}">selected</c:if>>Morning</option>
                        <option value="Afternoon" <c:if test="${param.timeSlot == 'Afternoon'}">selected</c:if>>Afternoon</option>
                        <option value="Evening" <c:if test="${param.timeSlot == 'Evening'}">selected</c:if>>Evening</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="requiresSpecialist">Request Specialist</label>
                    <select id="requiresSpecialist" name="requiresSpecialist" class="form-select">
                        <option value="">All</option>
                        <option value="Yes" <c:if test="${param.requiresSpecialist == 'Yes'}">selected</c:if>>Yes</option>
                        <option value="No" <c:if test="${param.requiresSpecialist == 'No'}">selected</c:if>>No</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="sortBy">Sort By</label>
                    <select id="sortBy" name="sortBy" class="form-select" onchange="updateSortDir()">
                        <option value="">Default (Newest)</option>
                        <option value="appointmentDate" <c:if test="${sortBy == 'appointmentDate' && sortDir == 'ASC'}">selected</c:if>>Date (Oldest to Newest)</option>
                        <option value="appointmentDate" <c:if test="${sortBy == 'appointmentDate' && sortDir == 'DESC'}">selected</c:if>>Date (Newest to Oldest)</option>
                        <option value="typeName" <c:if test="${sortBy == 'typeName' && sortDir == 'ASC'}">selected</c:if>>Type (A-Z)</option>
                        <option value="typeName" <c:if test="${sortBy == 'typeName' && sortDir == 'DESC'}">selected</c:if>>Type (Z-A)</option>
                    </select>
                    <input type="hidden" id="sortDir" name="sortDir" value="${sortDir}">
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-search me-2"></i>Search</button>
                    <button type="button" class="btn btn-secondary" onclick="resetForm()"><i class="fas fa-undo me-2"></i>Reset</button>
                </div>
            </div>
        </form>
        <!-- Display appointments in a table -->
        <div class="table-container">
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
                                    <span class="text-danger">Unknown Type</span>
                                    <script>
                                        console.warn("Appointment ID ${appointment.appointmentId} missing valid appointmentType: ", ${appointment.appointmentType});
                                    </script>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${appointment.requiresSpecialist}"><span class="badge bg-success">Yes</span></c:when>
                                <c:otherwise><span class="badge bg-secondary">No</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${appointment.status == 'Unpay'}"><span class="status-unpay">Unpaid</span></c:when>
                                <c:when test="${appointment.status == 'Confirmed'}"><span class="status-confirmed">Confirmed</span></c:when>
                                <c:when test="${appointment.status == 'Cancelled'}"><span class="status-cancelled">Cancelled</span></c:when>
                                <c:otherwise>${appointment.status}</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:set var="now" value="<%= new java.sql.Timestamp(System.currentTimeMillis()) %>"/>
                            <c:choose>
                                <c:when test="${appointment.appointmentDate.time > now.time}">
                                    <c:choose>
                                        <c:when test="${appointment.status == 'Unpay'}">
                                            <a href="<c:url value='/appointments/edit?id=${appointment.appointmentId}'/>"
                                               class="btn btn-primary btn-action"><i class="fas fa-edit me-2"></i>Edit</a>
                                            <a href="<c:url value='/appointments/delete?id=${appointment.appointmentId}'/>"
                                               class="btn btn-danger btn-action" onclick="return confirm('Are you sure?')"><i class="fas fa-trash me-2"></i>Delete</a>
                                            <a href="<c:url value='/payment?appointmentId=${appointment.appointmentId}'/>"
                                               class="btn btn-success btn-action"><i class="fas fa-credit-card me-2"></i>Pay</a>
                                        </c:when>
                                    </c:choose>
                                </c:when>
                            </c:choose>
                            <a href="<c:url value='/appointments/details?id=${appointment.appointmentId}'/>"
                               class="btn btn-info btn-action"><i class="fas fa-info-circle me-2"></i>Details</a>
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
                        </c:url>"><i class="fas fa-chevron-left"></i></a>
                    </li>
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
                        </c:url>"><i class="fas fa-chevron-right"></i></a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</main>
<footer>
    <div class="footer-wrappr">
        <div class="footer-area footer-padding">
            <div class="container">
                <div class="row justify-content-between">
                    <div class="col-xl-8 col-lg-8 col-md-6 col-sm-12">
                        <div class="single-footer-caption mb-50">
                            <div class="footer-logo mb-25">
                                <a href="<c:url value='/pactHome'/>"><img src="assets/img/logo/logo2_footer.png" alt="Footer Logo"></a>
                            </div>
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
                                <p>Copyright ©
                                    <script>document.write(new Date().getFullYear());</script>
                                    All rights reserved | Group 3 - SE1903 - SWP391 Summer2025
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</footer>
<div id="back-top">
    <a title="Go to Top" href="#"><i class="fas fa-level-up-alt"></i></a>
</div>
<script src="<c:url value='/assets/js/vendor/modernizr-3.5.0.min.js'/>"></script>
<script src="<c:url value='/assets/js/vendor/jquery-1.12.4.min.js'/>"></script>
<script src="<c:url value='/assets/js/bootstrap.min.js'/>"></script>
<script src="<c:url value='/assets/js/jquery.slicknav.min.js'/>"></script>
<script src="<c:url value='/assets/js/main.js'/>"></script>
<script>
    function updateSortDir() {
        const sortBySelect = document.getElementById('sortBy');
        const sortDirInput = document.getElementById('sortDir');
        const selectedOption = sortBySelect.selectedOptions[0].text;
        if (selectedOption.includes('(Z-A)') || selectedOption.includes('Newest')) {
            sortDirInput.value = 'DESC';
        } else {
            sortDirInput.value = 'ASC';
        }
        document.getElementById('searchForm').submit();
    }

    function resetForm() {
        const form = document.getElementById('searchForm');
        form.reset();
        document.getElementById('sortDir').value = 'DESC';
        form.submit();
    }
</script>
<script src="${pageContext.request.contextPath}/assets/js/header.js"></script>
</body>
</html>