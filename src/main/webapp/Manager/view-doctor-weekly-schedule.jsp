<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.sql.Date" %>
<%@ page import="model.DoctorShift" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Doctor's Weekly Schedule</title>
  <!-- Bootstrap 4 -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <style>
    body { padding-top: 70px; }
    .badge { font-size: 90%; }
    .action-buttons { margin-bottom: 20px; }
    .schedule-cell { position: relative; transition: background-color 0.2s; }
    .schedule-cell:hover { background-color: #f8f9fa; }
    .cell-actions { position: absolute; top: 2px; right: 2px; opacity: 0; transition: opacity 0.2s; }
    .schedule-cell:hover .cell-actions { opacity: 1; }
    .btn-mini { padding: 2px 6px; font-size: 10px; border-radius: 3px; margin-left: 2px; }
  </style>
</head>
<body>
<!-- Hiển thị cảnh báo lỗi nếu có -->
<c:if test="${not empty param.error}">
  <div class="alert alert-danger alert-dismissible fade show" role="alert">
    <i class="fas fa-exclamation-triangle"></i>
      ${param.error}
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
      <span aria-hidden="true">&times;</span>
    </button>
    <c:remove var="error" scope="session"/>
  </div>
</c:if>

<!-- Hiển thị thông báo thành công nếu có -->
<c:if test="${not empty param.success}">
  <div class="alert alert-success alert-dismissible fade show" role="alert">
    <i class="fas fa-check-circle"></i>
      ${param.success}
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
      <span aria-hidden="true">&times;</span>
    </button>
    <c:remove var="success" scope="session"/>
  </div>
</c:if>

<nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top shadow-sm">
  <div class="container">
    <a href="${pageContext.request.contextPath}/assign-doctor-schedule" class="btn btn-outline-primary">&larr; Back to Doctor Schedule</a>
    <span class="ml-auto font-weight-bold text-secondary">Doctor's Weekly Schedule</span>
  </div>
</nav>

<main class="container mt-4">
  <form id="weekSelectorForm" method="get" action="view-doctor-schedule" class="form-inline mb-4 flex-wrap">
    <input type="hidden" name="doctorId" value="${doctorId}" />
    <label for="yearSelect" class="mr-2">Year:</label>
    <select name="year" id="yearSelect" class="form-control mr-3 mb-2">
      <c:forEach var="y" items="${years}">
        <option value="${y}" <c:if test="${y == selectedYear}">selected</c:if>>${y}</option>
      </c:forEach>
    </select>
    <label for="weekSelect" class="mr-2">Week:</label>
    <select name="startDate" id="weekSelect" class="form-control mb-2">
      <c:forEach var="w" items="${weeks}">
        <c:set var="start" value="${w[0]}"/>
        <c:set var="end" value="${w[1]}"/>
        <option value="${start}" <c:if test="${start == selectedWeekStart}">selected</c:if>>
          <fmt:formatDate value="${start}" pattern="dd/MM"/> - <fmt:formatDate value="${end}" pattern="dd/MM"/>
        </option>
      </c:forEach>
    </select>
  </form>

  <div class="row mb-4">
    <div class="col-md-4 text-left">
      <a href="view-doctor-schedule?doctorId=${doctorId}&startDate=${selectedWeekStart}&year=${selectedYear}&weekOffset=-1" class="btn btn-outline-primary btn-sm">&laquo; Previous Week</a>
    </div>
    <div class="col-md-4 text-center">
      <h5>${weekRange}</h5>
    </div>
    <div class="col-md-4 text-right">
      <a href="view-doctor-schedule?doctorId=${doctorId}&startDate=${selectedWeekStart}&year=${selectedYear}&weekOffset=1" class="btn btn-outline-primary btn-sm">Next Week &raquo;</a>
    </div>
  </div>

  <div class="table-responsive">
    <table class="table table-bordered text-center">
      <thead class="thead-light">
      <tr>
        <th>Shift</th>
        <th>Monday</th><th>Tuesday</th><th>Wednesday</th><th>Thursday</th><th>Friday</th><th>Saturday</th><th>Sunday</th>
      </tr>
      <tr>
        <th></th>
        <% java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("dd/MM");
          Date monday = (Date) request.getAttribute("monday");
          java.util.Calendar cal = java.util.Calendar.getInstance();
          if (monday != null) {
            cal.setTime(monday);
            for (int i = 0; i < 7; i++) { %>
        <th><%= df.format(cal.getTime()) %></th>
        <% cal.add(java.util.Calendar.DAY_OF_MONTH, 1); } } else { %>
        <td colspan="7" class="text-danger">[Error: 'monday' not set]</td>
        <% } %>
      </tr>
      </thead>
      <tbody>
      <% String[] slots = {"Morning", "Afternoon", "Evening", "Night"};
        cal.setTime(monday);
        for (String slot : slots) {
          cal.setTime(monday); %>
      <tr><td><strong><%= slot %></strong></td>
        <% for (int i = 0; i < 7; i++) {
          Date day = new Date(cal.getTimeInMillis());
          Map<String, DoctorShift> dayShifts = ((Map<Date, Map<String, DoctorShift>>) request.getAttribute("shiftMap")).get(day);
          DoctorShift shift = (dayShifts != null) ? dayShifts.get(slot) : null; %>
        <td class="schedule-cell">
          <% if (shift != null) {
            String badgeClass = "badge-secondary";
            switch (shift.getStatus()) {
              case "Working": badgeClass = "badge-success"; break;
              case "PendingLeave": badgeClass = "badge-warning"; break;
              case "Leave": badgeClass = "badge-secondary"; break;
              case "Rejected": badgeClass = "badge-danger"; break;
            } %>
          <a href="#" class="badge <%= badgeClass %>" data-toggle="modal" data-target="#shiftModal" onclick="openDetailModal(<%= shift.getShiftId() %>)">
            <%= shift.getStatus() %>
          </a>
          <div class="cell-actions">
            <button type="button" class="btn btn-outline-primary btn-mini" onclick="editShift(<%= shift.getShiftId() %>)"><i class="fas fa-edit"></i></button>
            <button type="button" class="btn btn-outline-danger btn-mini" onclick="deleteShift(<%= shift.getShiftId() %>)"><i class="fas fa-trash"></i></button>
          </div>
          <% } else { %>
          <span class="text-muted">-</span>
          <div class="cell-actions">
            <button type="button" class="btn btn-outline-success btn-mini" onclick="addShiftToCell('<%= day %>', '<%= slot %>')"><i class="fas fa-plus"></i></button>
          </div>
          <% } %>
        </td>
        <% cal.add(java.util.Calendar.DAY_OF_MONTH, 1); } %>
      </tr>
      <% } %>
      </tbody>
    </table>
  </div>
</main>

<!-- MODAL for shift details -->
<div class="modal fade" id="shiftModal" tabindex="-1" role="dialog" aria-labelledby="shiftModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="shiftModalLabel">Shift Details</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" id="shiftModalBody">Loading...</div>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  document.getElementById("yearSelect").addEventListener("change", function () {
    const weekSelect = document.getElementById("weekSelect");
    weekSelect.removeAttribute("name");
    document.getElementById("weekSelectorForm").submit();
  });

  document.getElementById("weekSelect").addEventListener("change", function () {
    document.getElementById("weekSelect").setAttribute("name", "startDate");
    document.getElementById("weekSelectorForm").submit();
  });

  function addShiftToCell(date, slot) {
    const url = '${pageContext.request.contextPath}/add-doctor-shift-modal?doctorId=${doctorId}&date=' + date + '&slot=' + slot;
    openShiftModal(url, 'Add Shift');
  }

  function editShift(shiftId) {
    const url = '${pageContext.request.contextPath}/edit-doctor-shift-modal?shiftId=' + shiftId;
    openShiftModal(url, 'Edit Shift');
  }

  function openShiftModal(url, title) {
    $('#shiftModalLabel').text(title);
    $('#shiftModalBody').html('<div class="text-center p-3">Loading...</div>');

    fetch(url)
            .then(response => response.text())
            .then(html => {
              $('#shiftModalBody').html(html);
              $('#shiftModal').modal('show');
            })
            .catch(error => {
              $('#shiftModalBody').html('<div class="text-danger">Error loading form.</div>');
            });
  }

  function clearWeek() {
    if (confirm('Clear all shifts for this week?')) {
      window.location.href = '${pageContext.request.contextPath}/clear-week-schedule?doctorId=${doctorId}&weekStart=${selectedWeekStart}';
    }
  }

  function deleteShift(shiftId) {
    if (confirm('Delete this shift?')) {
      const form = document.createElement('form');
      form.method = 'post';
      form.action = '${pageContext.request.contextPath}/delete-doctor-shift';

      const input = document.createElement('input');
      input.type = 'hidden';
      input.name = 'shiftId';
      input.value = shiftId;

      form.appendChild(input);
      document.body.appendChild(form);
      form.submit(); // => gọi POST, Servlet nhận trong doPost()
    }
  }


  function openDetailModal(shiftId) {
    const url = '${pageContext.request.contextPath}/doctor-shift-detail?shiftId=' + shiftId;
    $('#shiftModalLabel').text('Shift Details');
    $('#shiftModalBody').html('Loading...');
    fetch(url)
            .then(response => response.text())
            .then(html => {
              $('#shiftModalBody').html(html);
              $('#shiftModal').modal('show');
            })
            .catch(error => {
              $('#shiftModalBody').html('<div class="text-danger">Failed to load details.</div>');
            });
  }
</script>

</body>
</html>
