<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Add Patient - benhVienLmao</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<div class="container mt-5">
  <h2>Add New Patient</h2>
  <form action="${pageContext.request.contextPath}/admin/managePatients" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="add">
    <div class="mb-3">
      <label for="fullName" class="form-label">Full Name</label>
      <input type="text" class="form-control" id="fullName" name="fullName" required>
    </div>
    <div class="mb-3">
      <label for="username" class="form-label">Username</label>
      <input type="text" class="form-control" id="username" name="username" required>
    </div>
    <div class="mb-3">
      <label for="password" class="form-label">Password</label>
      <input type="password" class="form-control" id="password" name="password" required>
    </div>
    <div class="mb-3">
      <label for="email" class="form-label">Email</label>
      <input type="email" class="form-control" id="email" name="email">
    </div>
    <div class="mb-3">
      <label for="phone" class="form-label">Phone</label>
      <input type="text" class="form-control" id="phone" name="phone">
    </div>
    <div class="mb-3">
      <label for="gender" class="form-label">Gender</label>
      <select class="form-select" id="gender" name="gender">
        <option value="">Select</option>
        <option value="M">Male</option>
        <option value="F">Female</option>
      </select>
    </div>
    <div class="mb-3">
      <label for="address" class="form-label">Address</label>
      <input type="text" class="form-control" id="address" name="address">
    </div>
    <div class="mb-3">
      <label for="insuranceNumber" class="form-label">Insurance Number</label>
      <input type="text" class="form-control" id="insuranceNumber" name="insuranceNumber">
    </div>
    <div class="mb-3">
      <label for="emergencyContact" class="form-label">Emergency Contact</label>
      <input type="text" class="form-control" id="emergencyContact" name="emergencyContact">
    </div>
    <div class="mb-3">
      <label for="patientAvaUrl" class="form-label">Avatar</label>
      <input type="file" class="form-control" id="patientAvaUrl" name="patientAvaUrl" accept=".jpg,.jpeg,.png">
    </div>
    <button type="submit" class="btn btn-success">Add Patient</button>
    <a href="${pageContext.request.contextPath}/admin/managePatients?action=list" class="btn btn-secondary">Cancel</a>
  </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>