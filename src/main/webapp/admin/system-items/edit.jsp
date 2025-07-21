<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Edit System Item - benhVienLmao</title>
  <!-- Bootstrap CSS for consistent styling -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Custom admin CSS for green theme inspired by Thu Cuc hospital -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<div class="container mt-5">
  <!-- Page title -->
  <h2 class="mb-4 text-success">Edit System Item</h2>

  <!-- Display error message if present -->
  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger" role="alert">
        ${errorMessage}
    </div>
  </c:if>

  <!-- Form to edit system item -->
  <form id="editForm" action="${pageContext.request.contextPath}/admin/system-items" method="post" onsubmit="return validateForm()">
    <!-- Hidden fields for action and item ID -->
    <input type="hidden" name="action" value="edit">
    <input type="hidden" name="id" value="${item.itemId}">

    <!-- Item Name field -->
    <div class="mb-3">
      <label for="itemName" class="form-label">Name <span class="text-danger">*</span></label>
      <input type="text" class="form-control" id="itemName" name="itemName" value="${item.itemName}" required>
      <div class="invalid-feedback">Item name is required.</div>
    </div>

    <!-- Item URL field -->
    <div class="mb-3">
      <label for="itemUrl" class="form-label">URL</label>
      <input type="text" class="form-control" id="itemUrl" name="itemUrl" value="${item.itemUrl}">
    </div>

    <!-- Display Order field -->
    <div class="mb-3">
      <label for="displayOrder" class="form-label">Display Order</label>
      <input type="number" class="form-control" id="displayOrder" name="displayOrder" value="${item.displayOrder}">
    </div>

    <!-- Item Type field -->
    <div class="mb-3">
      <label for="itemType" class="form-label">Type <span class="text-danger">*</span></label>
      <select class="form-select" id="itemType" name="itemType" required>
        <option value="Feature" ${item.itemType == 'Feature' ? 'selected' : ''}>Feature</option>
        <option value="Navigation" ${item.itemType == 'Navigation' ? 'selected' : ''}>Navigation</option>
      </select>
      <div class="invalid-feedback">Please select an item type.</div>
    </div>

    <!-- Role Assignment field -->
    <div class="mb-3">
      <label class="form-label">Assign Roles</label>
      <div>
        <!-- Iterate over all roles to display checkboxes -->
        <c:forEach var="role" items="${allRoles}">
          <div class="form-check form-check-inline">
            <input class="form-check-input" type="checkbox" name="roleIds" id="role${role.roleId}" value="${role.roleId}"
                   <c:if test="${assignedRoleIds.contains(role.roleId)}">checked</c:if>>
            <label class="form-check-label" for="role${role.roleId}">${role.roleName}</label>
          </div>
        </c:forEach>
        <!-- Display message if no roles are available -->
        <c:if test="${empty allRoles}">
          <p class="text-muted">No roles available.</p>
        </c:if>
      </div>
    </div>

    <!-- Form buttons -->
    <button type="submit" class="btn btn-success">Save Changes</button>
    <a href="${pageContext.request.contextPath}/admin/system-items?action=list" class="btn btn-secondary">Cancel</a>
  </form>
</div>

<!-- Bootstrap JS for form validation -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Client-side form validation
  function validateForm() {
    const form = document.getElementById('editForm');
    const itemName = document.getElementById('itemName');
    const itemType = document.getElementById('itemType');

    // Reset validation feedback
    form.classList.add('was-validated');

    // Check if required fields are filled
    if (!itemName.value.trim()) {
      itemName.classList.add('is-invalid');
      return false;
    } else {
      itemName.classList.remove('is-invalid');
    }

    if (!itemType.value) {
      itemType.classList.add('is-invalid');
      return false;
    } else {
      itemType.classList.remove('is-invalid');
    }

    return true;
  }
</script>
</body>
</html>