<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Edit Patient - benhVienLmao</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<div class="container mt-5">
  <h2>Edit Patient</h2>
  <form action="${pageContext.request.contextPath}/admin/managePatients" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="edit">
    <input type="hidden" name="id" value="${user.patientId}">
    <div class="mb-3">
      <label for="fullName" class="form-label">Full Name</label>
      <input type="text" class="form-control" id="fullName" name="fullName" value="${user.fullName}" required>
    </div>
    <div class="mb-3">
      <label for="username" class="form-label">Username</label>
      <input type="text" class="form-control" id="username" name="username" value="${user.username}" required>
    </div>
    <div class="mb-3">
      <label for="password" class="form-label">Password (leave blank to keep current)</label>
      <input type="password" class="form-control" id="password" name="password">
    </div>
    <div class="mb-3">
      <label for="email" class="form-label">Email</label>
      <input type="email" class="form-control" id="email" name="email" value="${user.email}">
    </div>
    <div class="mb-3">
      <label for="phone" class="form-label">Phone</label>
      <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}">
    </div>
    <div class="mb-3">
      <label for="gender" class="form-label">Gender</label>
      <select class="form-select" id="gender" name="gender">
        <option value="">Select</option>
        <option value="M" ${user.gender == 'M' ? 'selected' : ''}>Male</option>
        <option value="F" ${user.gender == 'F' ? 'selected' : ''}>Female</option>
      </select>
    </div>
    <div class="mb-3">
      <label for="address" class="form-label">Address</label>
      <input type="text" class="form-control" id="address" name="address" value="${user.address}">
    </div>
    <div class="mb-3">
      <label for="insuranceNumber" class="form-label">Insurance Number</label>
      <input type="text" class="form-control" id="insuranceNumber" name="insuranceNumber" value="${user.insuranceNumber}">
    </div>
    <div class="mb-3">
      <label for="emergencyContact" class="form-label">Emergency Contact</label>
      <input type="text" class="form-control" id="emergencyContact" name="emergencyContact" value="${user.emergencyContact}">
    </div>
    <div class="mb-3">
      <label for="patientAvaUrl" class="form-label">Avatar</label>
      <input type="file" class="form-control" id="patientAvaUrl" name="patientAvaUrl" accept=".jpg,.jpeg,.png">
      <c:if test="${not empty user.patientAvaUrl}">
        <img src="${pageContext.request.contextPath}/${user.patientAvaUrl}" style="max-width:50px;"/>
        <input type="hidden" name="existingAvaUrl" value="${user.patientAvaUrl}">
      </c:if>
    </div>
    <button type="submit" class="btn btn-success">Save Changes</button>
    <a href="${pageContext.request.contextPath}/admin/managePatients?action=list" class="btn btn-secondary">Cancel</a>
  </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>