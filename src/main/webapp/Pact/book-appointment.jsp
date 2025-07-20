<%--
  Created by IntelliJ IDEA.
  User: Fosk Jesky
  Date: 5/27/2025
  Time: 1:08 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>Book Appointment</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="<c:url value='/assets/css/bootstrap.min.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/select2.min.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
  <style>
    /* Giữ nguyên CSS cũ của bạn và thêm những cải thiện nhẹ nhàng này */

    /* ===== EXISTING STYLES (giữ nguyên) ===== */
    .big-form { max-width: 600px; margin: 0 auto; font-size: 1.3rem; }
    .big-form label, .big-form input, .big-form select, .big-form button { font-size: 1.2rem; }
    .big-form .form-control { height: 50px; font-size: 1.2rem; }
    .big-form .btn { padding: 15px 30px; font-size: 1.2rem; background-color: #28a745; color: #fff; border-color: #28a745; }
    .big-form .btn:hover { background-color: #218838; border-color: #218838; }
    h2 { font-size: 2.2rem; text-align: center; margin-bottom: 30px; color: #28a745; }
    .select2-container--default .select2-selection--single { height: 50px; font-size: 1.2rem; border-color: #28a745; }
    .select2-container--default .select2-selection--single .select2-selection__rendered { line-height: 50px; }
    .select2-container--default .select2-selection--single .select2-selection__arrow { height: 50px; }
    .error-message { color: #dc3545; font-size: 1rem; margin-top: 5px; display: none; }
    .price-display { font-size: 1.2rem; color: #28a745; margin-top: 10px; font-weight: bold; }
    .description-display { font-size: 1.1rem; color: #333; margin-top: 5px; }
    .total-price-section { margin-top: 20px; margin-bottom: 20px; padding: 15px; background-color: #f1f8f1; border-radius: 8px; border: 1px solid #28a745; }
    .total-price-section .price-display { font-size: 1.3rem; color: #28a745; }
    .price-warning { color: #dc3545; font-size: 1rem; margin-top: 5px; display: none; }

    /* ===== SUBTLE IMPROVEMENTS (chỉ thêm vào) ===== */
    body {
      background: linear-gradient(135deg, #f0f9f2 0%, #ffffff 50%, #f0f9f2 100%);
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      min-height: 100vh;
    }

    /* Header cải thiện nhẹ */
    .header-area {
      box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    }

    /* Form container đẹp hơn một chút */
    .big-form {
      background: white;
      padding: 40px;
      border-radius: 10px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.1);
      border: 1px solid #e9ecef;
    }

    /* Form controls cải thiện nhẹ */
    .big-form .form-control {
      border: 1px solid #ced4da;
      border-radius: 6px;
      transition: border-color 0.3s ease, box-shadow 0.3s ease;
    }

    .big-form .form-control:focus {
      border-color: #28a745;
      box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.15);
      outline: none;
    }

    /* Labels đẹp hơn */
    .big-form label {
      font-weight: 600;
      color: #495057;
      margin-bottom: 8px;
    }

    /* Button cải thiện nhẹ */
    .big-form .btn {
      border-radius: 6px;
      transition: all 0.3s ease;
      font-weight: 600;
    }

    .big-form .btn:hover {
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
    }

    /* Select2 cải thiện */
    .select2-container--default .select2-selection--single {
      border: 1px solid #ced4da;
      border-radius: 6px;
      transition: border-color 0.3s ease;
    }

    .select2-container--default.select2-container--focus .select2-selection--single {
      border-color: #28a745;
      box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.15);
    }

    /* Price section cải thiện nhẹ */
    .total-price-section {
      border-radius: 10px;
      box-shadow: 0 2px 8px rgba(40, 167, 69, 0.1);
    }

    /* Description display đẹp hơn */
    .description-display {
      background-color: #e8f5e8;
      border: 1px solid #c3e6cb;
      border-radius: 6px;
      padding: 12px;
      margin-top: 10px;
    }

    /* Error messages cải thiện */
    .error-message {
      background-color: #f8d7da;
      border: 1px solid #f5c6cb;
      border-radius: 6px;
      padding: 10px;
      margin-top: 8px;
    }

    .price-warning {
      background-color: #fff3cd;
      border: 1px solid #ffeaa7;
      border-radius: 6px;
      padding: 10px;
      margin-top: 8px;
    }

    /* Form groups spacing */
    .form-group {
      margin-bottom: 25px;
    }

    /* Title cải thiện nhẹ */
    h2 {
      font-weight: 700;
      text-shadow: 0 1px 3px rgba(40, 167, 69, 0.1);
    }

    /* Responsive cải thiện */
    @media (max-width: 768px) {
      .big-form {
        margin: 20px;
        padding: 30px 25px;
      }

      h2 {
        font-size: 2rem;
      }
    }

    @media (max-width: 576px) {
      .big-form {
        margin: 15px;
        padding: 25px 20px;
      }

      h2 {
        font-size: 1.8rem;
      }

      .big-form .form-control {
        height: 45px;
        font-size: 1.1rem;
      }

      .big-form .btn {
        padding: 12px 25px;
        font-size: 1.1rem;
      }
    }

    /* Smooth transitions cho tất cả */
    * {
      transition: all 0.3s ease;
    }

    /* Focus accessibility */
    .big-form .form-control:focus,
    .big-form .btn:focus {
      outline: none;
    }

    /* Loading state cho button */
    .big-form .btn:disabled {
      opacity: 0.6;
      cursor: not-allowed;
      transform: none;
    }

    .description-display {
      transition: all 0.3s ease;
      display: none; /* Ẩn mặc định */
    }

    .description-display:not(:empty) {
      display: block; /* Hiện khi có nội dung */
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
                    <c:if test="${sessionScope.patientId != null}">
                      <li><a href="<c:url value='/appointments'/>">My Appointments</a></li>
                      <li><a href="<c:url value='/logout'/>">Logout</a></li>
                    </c:if>
                    <c:if test="${sessionScope.patientId == null}">
                      <li><a href="<c:url value='/login'/>">Login</a></li>
                      <li><a href="<c:url value='/register'/>">Register</a></li>
                    </c:if>
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
    <h2>Book Appointment</h2>
    <c:if test="${not empty errorMsg}">
      <div class="error-message" style="display: block;">${errorMsg}</div>
    </c:if>
    <form action="<c:url value='/book-appointment'/>" method="post" class="big-form" id="appointmentForm">
      <c:if test="${sessionScope.patientId == null}">
        <div class="form-group mb-4">
          <label for="email">Email:</label>
          <input type="email" class="form-control" id="email" name="email" required value="${formData.email}">
          <div class="error-message" id="emailError">Invalid email format.</div>
        </div>
      </c:if>
      <div class="form-group mb-4">
        <label for="appointmentTypeSelect">Appointment Type:</label>
        <select class="form-control" id="appointmentTypeSelect" name="appointmentTypeId" required>
          <option value="">-- Select Appointment Type --</option>
          <c:forEach var="type" items="${appointmentTypes}">
            <option value="${type.appointmentTypeId}"
                    data-price="${type.price != null ? type.price : ''}"
                    data-description="${type.description != null ? type.description : ''}"
                    data-type-name="${type.typeName != null ? type.typeName : ''}"
                    <c:if test="${type.appointmentTypeId == formData.appointmentTypeId || type.appointmentTypeId == selectedTypeId}">selected</c:if>>
                ${type.typeName != null ? type.typeName : 'Unknown Type'}
            </option>
          </c:forEach>
        </select>
        <input type="hidden" id="typeName" name="typeName" value="${formData.typeName}">
        <div class="description-display" id="typeDescription">${formData.typeDescription}</div>
        <div class="price-warning" id="priceWarning" style="display:none;">
          <i class="fas fa-exclamation-triangle"></i>
          Invalid price for selected appointment type. Please select another type.
        </div>
      </div>
      <div class="form-group mb-4">
        <label for="appointmentDate">Appointment Date:</label>
        <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required value="${formData.appointmentDate != null ? formData.appointmentDate : param.appointmentDate}">
        <div class="error-message" id="dateError">Invalid appointment date: Cannot book in the past.</div>
      </div>
      <div class="form-group mb-4">
        <label for="timeSlot">Time Slot:</label>
        <select class="form-control" id="timeSlot" name="timeSlot" required>
          <option value="">-- Select Time Slot --</option>
          <option value="Morning" <c:if test="${formData.timeSlot == 'Morning' || param.timeSlot == 'Morning'}">selected</c:if>>Morning</option>
          <option value="Afternoon" <c:if test="${formData.timeSlot == 'Afternoon' || param.timeSlot == 'Afternoon'}">selected</c:if>>Afternoon</option>
          <option value="Evening" <c:if test="${formData.timeSlot == 'Evening' || param.timeSlot == 'Evening'}">selected</c:if>>Evening</option>
        </select>
      </div>
      <div class="form-group mb-4">
        <label>Requires Specialist:</label>
        <div class="form-check">
          <input type="checkbox" class="form-check-input" id="requiresSpecialist" name="requiresSpecialist" <c:if test="${formData.requiresSpecialist || requiresSpecialist}">checked</c:if>>
          <label class="form-check-label" for="requiresSpecialist">Yes (+50% price)</label>
        </div>
      </div>
      <div class="total-price-section">
        <div class="price-display" id="priceDisplay">Total Price: <span id="priceValue">${formData.finalPrice != null ? formData.finalPrice : '0'}</span> VND</div>
        <input type="hidden" id="finalPrice" name="finalPrice" value="${formData.finalPrice != null ? formData.finalPrice : '0'}">
      </div>
      <button type="submit" class="btn btn-primary mt-3 w-100">Submit Appointment</button>
    </form>
  </div>
</main>
<script>
  // Lưu trữ dữ liệu appointmentTypes từ server vào array JS
  const appointmentTypes = [
    <c:forEach var="type" items="${appointmentTypes}" varStatus="loop">
    {
      appointmentTypeId: ${type.appointmentTypeId},
      typeName: "${type.typeName}",
      price: ${type.price != null ? type.price : 0},
      description: "${type.description != null ? type.description : ''}"
    }<c:if test="${!loop.last}">,</c:if>
    </c:forEach>
  ];
  console.log("Loaded appointmentTypes:", appointmentTypes);

  function getTypeById(id) {
    return appointmentTypes.find(t => t.appointmentTypeId == id);
  }

  function updatePriceAndDescription() {
    const select = document.getElementById('appointmentTypeSelect');
    const selectedId = select.value;
    const specialist = document.getElementById('requiresSpecialist').checked;
    const priceDisplay = document.getElementById('priceValue');
    const typeDescription = document.getElementById('typeDescription');
    const typeNameInput = document.getElementById('typeName');
    const finalPriceInput = document.getElementById('finalPrice');
    const priceWarning = document.getElementById('priceWarning');

    priceWarning.style.display = 'none';

    let price = 0;
    let valid = true;
    let typeObj = null;

    if (selectedId) {
      typeObj = getTypeById(selectedId);
      console.log("Selected type object:", typeObj);
      if (typeObj && typeof typeObj.price === "number") {
        price = typeObj.price;
      } else {
        valid = false;
      }
    } else {
      valid = false;
    }

    if (specialist && valid) price = price * 1.5;

    priceDisplay.innerText = price.toLocaleString('vi-VN');
    finalPriceInput.value = price;

    // Hiển thị mô tả
    if (typeObj && typeObj.description && selectedId) {
      typeDescription.innerText = "Description: " + typeObj.description;
      typeDescription.style.display = 'block';
    } else {
      typeDescription.innerText = "";
      typeDescription.style.display = 'none';
    }
    // Gán typeName vào input ẩn
    typeNameInput.value = typeObj && typeObj.typeName ? typeObj.typeName : "";

    // Show/hide warning
    priceWarning.style.display = valid ? 'none' : '';
    // Log for debug
    console.log("updatePriceAndDescription: selectedId=", selectedId, "specialist=", specialist, "price=", price, "valid=", valid);
  }

  document.addEventListener('DOMContentLoaded', function() {
    const now = new Date();
    const pad = n => n < 10 ? '0' + n : n;
    const yyyy = now.getFullYear();
    const MM = pad(now.getMonth() + 1);
    const dd = pad(now.getDate());
    const minDate = `${yyyy}-${MM}-${dd}`;
    const dateInput = document.getElementById('appointmentDate');
    dateInput.setAttribute('min', minDate);

    // Wait for jQuery and Select2 to be loaded before initializing
    function initSelect2IfReady() {
      if (window.jQuery && typeof $.fn.select2 === 'function') {
        try {
          $('#appointmentTypeSelect').select2({
            placeholder: "-- Select Appointment Type --",
            allowClear: true,
            width: '100%'
          });
        } catch (e) {
          console.error('Failed to initialize Select2:', e);
          $('#appointmentTypeSelect').css('width', '100%');
        }
      } else {
        // fallback
        $('#appointmentTypeSelect').css('width', '100%');
        if (!window.jQuery) {
          console.warn('jQuery is not loaded. Falling back to default select.');
        } else {
          console.warn('Select2 is not loaded. Falling back to default select.');
        }
      }
    }
    initSelect2IfReady();

    // Bind events
    document.getElementById('appointmentTypeSelect').addEventListener('change', updatePriceAndDescription);
    document.getElementById('requiresSpecialist').addEventListener('change', updatePriceAndDescription);

    // Trigger initial update
    updatePriceAndDescription();

    // Client-side validation for past dates
    document.getElementById('appointmentForm').addEventListener('submit', function(event) {
      const selectedDate = new Date(dateInput.value);
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      if (selectedDate < today) {
        event.preventDefault();
        document.getElementById('dateError').style.display = 'block';
      } else {
        document.getElementById('dateError').style.display = 'none';
      }
    });
  });
</script>
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

<script src="<c:url value='/assets/js/vendor/jquery-1.12.4.min.js'/>"></script>
<script src="<c:url value='/assets/js/popper.min.js'/>"></script>
<script src="<c:url value='/assets/js/bootstrap.min.js'/>"></script>
<script src="<c:url value='/assets/js/select2.min.js'/>"></script>
<script src="<c:url value='/assets/js/main.js'/>"></script>
</body>
</html>