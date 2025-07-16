<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.DoctorShift" %>
<%
  DoctorShift shift = (DoctorShift) request.getAttribute("shift");
  boolean isEdit = (request.getAttribute("isEdit") != null && (Boolean) request.getAttribute("isEdit"));
%>

<!-- WARNING if doctor has appointments -->
<c:if test="${hasAppointment}">
  <div class="alert alert-warning">
    ⚠️ The doctor already has <strong>appointments</strong> in this shift. Please handle them before making changes.
  </div>
</c:if>

<form method="post" action="${pageContext.request.contextPath}/process-doctor-shift" class="needs-validation" novalidate>
  <input type="hidden" name="shiftId" value="<%= isEdit ? shift.getShiftId() : "" %>"/>
  <input type="hidden" name="doctorId" value="<%= shift.getDoctorId() %>"/>
  <input type="hidden" name="date" value="<%= shift.getShiftDate() %>"/>
  <input type="hidden" name="slot" value="<%= shift.getTimeSlot() %>"/>

  <div class="form-group">
    <label>Date:</label>
    <input type="text" class="form-control" value="<%= shift.getShiftDate() %>" readonly/>
  </div>

  <div class="form-group">
    <label>Time Slot:</label>
    <input type="text" class="form-control" value="<%= shift.getTimeSlot() %>" readonly/>
  </div>

  <div class="form-group">
    <label>Status:</label>
    <select name="status" class="form-control" required>
      <option value="">-- Select status --</option>
      <option value="Working" <%= "Working".equals(shift.getStatus()) ? "selected" : "" %>>Working</option>
      <option value="PendingLeave" <%= "PendingLeave".equals(shift.getStatus()) ? "selected" : "" %>>Pending Leave</option>
      <option value="Leave" <%= "Leave".equals(shift.getStatus()) ? "selected" : "" %>>Leave</option>
      <option value="Rejected" <%= "Rejected".equals(shift.getStatus()) ? "selected" : "" %>>Rejected</option>
    </select>
  </div>

  <div class="form-group d-flex justify-content-between">
    <c:if test="${isEdit}">
      <!-- Delete shift form -->
      <form method="post" action="${pageContext.request.contextPath}/delete-doctor-shift" onsubmit="return confirmDelete();">
        <input type="hidden" name="shiftId" value="<%= shift.getShiftId() %>"/>
      </form>
    </c:if>

    <button type="submit" class="btn btn-primary btn-sm ml-auto" <c:if test="${hasAppointment}">disabled</c:if>>
      <i class="fas fa-save"></i> <%= isEdit ? "Update" : "Add" %> Shift
    </button>
  </div>
</form>

<script>
  function confirmDelete() {
    return confirm("Are you sure you want to delete this shift?");
  }
</script>
