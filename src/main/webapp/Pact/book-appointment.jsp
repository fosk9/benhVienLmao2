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
    .big-form { max-width: 600px; margin: 0 auto; font-size: 1.3rem; }
    .big-form label, .big-form input, .big-form select, .big-form button { font-size: 1.2rem; }
    .big-form .form-control { height: 50px; font-size: 1.2rem; }
    .big-form .btn { padding: 15px 30px; font-size: 1.2rem; background-color: #28A745; border-color: #28A745; }
    .big-form .btn:hover { background-color: #218838; border-color: #218838; }
    h2 { font-size: 2.2rem; text-align: center; margin-bottom: 30px; color: #28A745; }
    .select2-container--default .select2-selection--single { height: 50px; font-size: 1.2rem; border-color: #28A745; }
    .select2-container--default .select2-selection--single .select2-selection__rendered { line-height: 50px; }
    .select2-container--default .select2-selection--single .select2-selection__arrow { height: 50px; }
    .error-message { color: #dc3545; font-size: 1rem; margin-top: 5px; display: none; }
    .price-display { font-size: 1.2rem; color: #28A745; margin-top: 10px; font-weight: bold; }
    .description-display { font-size: 1.1rem; color: #333; margin-top: 5px; }
    .total-price-section { margin-top: 20px; margin-bottom: 20px; padding: 15px; background-color: #f1f8f1; border-radius: 8px; border: 1px solid #28A745; }
    .total-price-section .price-display { font-size: 1.3rem; color: #28A745; }
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
                    <li><a href="<c:url value='/appointments'/>">My Appointments</a></li>
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
    <h2>Book Appointment</h2>
    <c:if test="${not empty errorMsg}">
      <div class="error-message" style="display: block;">${errorMsg}</div>
    </c:if>
    <form action="<c:url value='/book-appointment'/>" method="post" class="big-form" id="appointmentForm">
      <div class="form-group mb-4">
        <label for="appointmentTypeSelect">Appointment Type:</label>
        <select class="form-control" id="appointmentTypeSelect" name="appointmentTypeId" onChange="selectBoxDebug(this);" required>
          <option value="">-- Select Appointment Type --</option>
          <c:forEach var="type" items="${appointmentTypes}">
            <option value="${type.appointmentTypeId}"
                    data-price="${type.price}"
                    data-description="${type.description}"
                    data-type-name="${type.typeName}">
                ${type.typeName}
            </option>
          </c:forEach>
        </select>
        <input type="hidden" id="typeName" name="typeName" value="">
        <div class="description-display" id="typeDescription"></div>
      </div>
      <div class="form-group mb-4">
        <label for="appointmentDate">Appointment Date:</label>
        <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required>
        <div class="error-message" id="dateError">Invalid appointment date: Cannot book in the past.</div>
      </div>
      <div class="form-group mb-4">
        <label for="timeSlot">Time Slot:</label>
        <select class="form-control" id="timeSlot" name="timeSlot" required>
          <option value="">-- Select Time Slot --</option>
          <option value="Morning">Morning</option>
          <option value="Afternoon">Afternoon</option>
          <option value="Evening">Evening</option>
        </select>
      </div>
      <div class="form-group mb-4">
        <label>Requires Specialist:</label>
        <div class="form-check">
          <input type="checkbox" class="form-check-input" id="requiresSpecialist" name="requiresSpecialist">
          <label class="form-check-label" for="requiresSpecialist">Yes (+50% price)</label>
        </div>
      </div>
      <div class="total-price-section">
        <div class="price-display" id="priceDisplay">Total Price: <span id="priceValue">0</span> VND</div>
        <input type="hidden" id="finalPrice" name="finalPrice" value="0">
      </div>
      <button type="submit" class="btn btn-primary mt-3 w-100">Submit Appointment</button>
    </form>
  </div>
</main>
<script>
  window.onload = function() {
    const now = new Date();
    const pad = n => n < 10 ? '0' + n : n;
    const yyyy = now.getFullYear();
    const MM = pad(now.getMonth() + 1);
    const dd = pad(now.getDate());
    const minDate = `${yyyy}-${MM}-${dd}`;
    const dateInput = document.getElementById('appointmentDate');
    dateInput.setAttribute('min', minDate);

    // Initialize Select2 for searchable dropdown
    $('#appointmentTypeSelect').select2({
      placeholder: "-- Select Appointment Type --",
      allowClear: true,
      width: '100%'
    });

    // Update price and description when appointment type or specialist is changed
    function updatePriceAndDescription(event) {
      const $select = $('#appointmentTypeSelect');
      const selectedValue = $select.val();
      const $selectedOption = $select.find(`option[value="${selectedValue}"]`);
      const requiresSpecialist = $('#requiresSpecialist').is(':checked');
      const priceDisplay = $('#priceValue');
      const typeDescription = $('#typeDescription');
      const typeNameInput = $('#typeName');
      const finalPriceInput = $('#finalPrice');

      if (selectedValue && $selectedOption.length) {
        const basePrice = parseFloat($selectedOption.data('price'));
        const description = $selectedOption.data('description');
        const typeName = $selectedOption.data('type-name');

        // Tính giá cuối cùng: nếu chọn chuyên gia thì cộng 50%
        const multiplier = requiresSpecialist ? 1.5 : 1;
        const finalPrice = !isNaN(basePrice) ? basePrice * multiplier : 0;

        priceDisplay.text(finalPrice);
        finalPriceInput.val(finalPrice);
        typeDescription.text(description ? `Description: ${description}` : '');
        typeNameInput.val(typeName || '');
      } else {
        priceDisplay.text('0');
        finalPriceInput.val(0);
        typeDescription.text('');
        typeNameInput.val('');
      }
    }

    // Bind Select2 select event to update price immediately
    $('#appointmentTypeSelect').on('select2:select', updatePriceAndDescription);

    // Bind Select2 clear event to reset price
    $('#appointmentTypeSelect').on('select2:clear', updatePriceAndDescription);

    // Bind checkbox change event for specialist
    $('#requiresSpecialist').on('change', updatePriceAndDescription);

    // Trigger initial update in case of pre-selected values or error reload
    updatePriceAndDescription();

    // Client-side validation for past dates
    $('#appointmentForm').on('submit', function(event) {
      const selectedDate = new Date(dateInput.value);
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      if (selectedDate < today) {
        event.preventDefault();
        $('#dateError').show();
      } else {
        $('#dateError').hide();
      }
    });

    // Restore form state if error occurred
    <c:if test="${not empty finalPrice}">
    $('#finalPrice').val('${finalPrice}');
    $('#priceValue').text(parseFloat('${finalPrice}'));
    </c:if>
  };

  function selectBoxDebug(sel) {
    console.log(sel.options[sel.selectedIndex].text);
  }
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
