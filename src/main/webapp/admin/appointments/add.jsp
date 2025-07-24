<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Add Appointment Type - benhVienLmao</title>
  <!-- Bootstrap CSS for consistent styling -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Custom admin CSS for green theme inspired by Thu Cuc hospital -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<div class="container mt-5">
  <!-- Page title -->
  <h2 class="mb-4 text-success">Add New Appointment Type</h2>

  <!-- Display error message if present -->
  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger" role="alert">
        ${errorMessage}
    </div>
  </c:if>

  <!-- Form to add new appointment type -->
  <form action="${pageContext.request.contextPath}/admin/appointments" method="post" onsubmit="return validateForm()">
    <input type="hidden" name="action" value="add">

    <!-- Type Name field -->
    <div class="mb-3">
      <label for="typeName" class="form-label">Type Name <span class="text-danger">*</span></label>
      <input type="text" class="form-control" id="typeName" name="typeName" required>
      <div class="invalid-feedback">Type name is required.</div>
    </div>

    <!-- Description field -->
    <div class="mb-3">
      <label for="description" class="form-label">Description</label>
      <textarea class="form-control" id="description" name="description" rows="4"></textarea>
    </div>

    <!-- Price field -->
    <div class="mb-3">
      <label for="price" class="form-label">Price (VND) <span class="text-danger">*</span></label>
      <input type="number" class="form-control" id="price" name="price" step="0.01" required>
      <div class="invalid-feedback">Please enter a valid price.</div>
    </div>

    <!-- Form buttons -->
    <button type="submit" class="btn btn-success">Add Appointment Type</button>
    <a href="${pageContext.request.contextPath}/admin/appointments?action=list" class="btn btn-secondary">Cancel</a>
  </form>
</div>

<!-- Bootstrap JS for form validation -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Client-side form validation
  function validateForm() {
    const form = document.querySelector('form');
    const typeName = document.getElementById('typeName');
    const price = document.getElementById('price');

    form.classList.add('was-validated');

    if (!typeName.value.trim()) {
      typeName.classList.add('is-invalid');
      return false;
    } else {
      typeName.classList.remove('is-invalid');
    }

    if (!price.value || price.value <= 0) {
      price.classList.add('is-invalid');
      return false;
    } else {
      price.classList.remove('is-invalid');
    }

    return true;
  }
</script>
</body>
</html>