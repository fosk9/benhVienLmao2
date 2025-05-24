<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Patient List</title>
  <!-- Bootstrap + FontAwesome (assumed from elements.html) -->
  <link rel="stylesheet" href="css/bootstrap.min.css">
  <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- Header include -->
<jsp:include page="header.jsp"/>

<div class="container mt-5">
  <h2 class="mb-4">Danh sách bệnh nhân</h2>

  <!-- Filter/Search/Sort Form -->
  <form method="get" action="PatientList" class="row g-3 mb-4">
    <div class="col-md-3">
      <input type="text" name="search" class="form-control" placeholder="Tìm theo tên hoặc email...">
    </div>
    <div class="col-md-2">
      <select name="gender" class="form-select">
        <option value="">Lọc theo giới tính</option>
        <option value="M">Nam</option>
        <option value="F">Nữ</option>
      </select>
    </div>
    <div class="col-md-3">
      <select name="sortBy" class="form-select">
        <option value="">Sắp xếp theo</option>
        <option value="full_name">Họ tên</option>
        <option value="dob">Ngày sinh</option>
        <option value="email">Email</option>
      </select>
    </div>
    <div class="col-md-2">
      <select name="sortDir" class="form-select">
        <option value="asc">Tăng dần</option>
        <option value="desc">Giảm dần</option>
      </select>
    </div>
    <div class="col-md-2">
      <button type="submit" class="btn btn-primary w-100">Lọc</button>
    </div>
  </form>

  <!-- Patient Table -->
  <div class="table-responsive">
    <table class="table table-bordered table-hover align-middle text-center">
      <thead class="table-light">
      <tr>
        <th>ID</th>
        <th>Họ tên</th>
        <th>Ngày sinh</th>
        <th>Giới tính</th>
        <th>Email</th>
        <th>Điện thoại</th>
        <th>Chi tiết</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="p" items="${patients}">
        <tr>
          <td>${p.patientId}</td>
          <td>${p.fullName}</td>
          <td><fmt:formatDate value="${p.dob}" pattern="dd/MM/yyyy"/></td>
          <td>
            <c:choose>
              <c:when test="${p.gender == 'M'}">Nam</c:when>
              <c:when test="${p.gender == 'F'}">Nữ</c:when>
              <c:otherwise>Khác</c:otherwise>
            </c:choose>
          </td>
          <td>${p.email}</td>
          <td>${p.phone}</td>
          <td>
            <a href="PatientDetails?id=${p.patientId}" class="btn btn-sm btn-outline-info">Xem</a>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<!-- Footer include -->
<jsp:include page="footer.jsp"/>

<!-- Script dependencies -->
<script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>
