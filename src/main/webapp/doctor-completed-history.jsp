<%--
  Created by IntelliJ IDEA.
  User: ADMIN
  Date: 5/28/2025
  Time: 4:35 AM
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Completed Appointments History</title>
  <jsp:include page="doctor-common-css.jsp"/>
  <style>
    form {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 15px;
      margin: 0 auto;
      width: 100%; /* Form chiếm toàn bộ chiều rộng */
      flex-wrap: wrap;
      padding: 10px;
    }

    form input, form select {
      width: 30%; /* Đảm bảo các trường nhập liệu có chiều rộng bằng nhau */
      height: 40px; /* Chiều cao của các trường nhập liệu đồng đều */
    }

    form .btn {
      width: 30%; /* Chiều rộng của nút tìm kiếm lớn hơn các trường */
      height: 40px; /* Chiều cao của nút tìm kiếm */
      margin-top: 10px;
    }

    /* Cải thiện giao diện của bảng */
    .table {
      font-size: 0.9rem;
      width: 75%;
      margin: 30px auto;
      border-collapse: collapse;
    }

    .table th, .table td {
      padding: 6px 10px;
      text-align: center;
    }

    .table th:nth-child(1), table.table td:nth-child(1) {
      width: 3%;
    }

    .table th:nth-child(2), table.table td:nth-child(2) {
      width: 15%;
    }

    .table th:nth-child(3), table.table td:nth-child(3) {
      width: 22%;
    }

    .table th:nth-child(4), table.table td:nth-child(4) {
      width: 15%;
    }

    .table th:nth-child(5), table.table td:nth-child(5) {
      width: 15%;
    }

    .table th:nth-child(6), table.table td:nth-child(6) {
      width: 12%;
    }

    .table th:nth-child(7), table.table td:nth-child(7) {
      width: 18%;
    }

    .pagination {
      justify-content: center;
      display: flex;
      gap: 10px;
    }

    .pagination .page-item .page-link {
      color: #28a745;
    }
  </style>
  <script>
    function validateForm() {
      // Lấy giá trị từ form và loại bỏ khoảng trắng thừa
      var fullName = document.forms[0]["fullName"].value.trim();
      var insuranceNumber = document.forms[0]["insuranceNumber"].value.trim();
      var appointmentType = document.forms[0]["appointmentType"].value.trim();
      var customAppointmentType = document.forms[0]["customAppointmentType"] ? document.forms[0]["customAppointmentType"].value.trim() : '';

      fullName = fullName.replace(/\s+/g, ' ');  // Thay thế tất cả khoảng trắng thừa thành một khoảng trắng duy nhất
      insuranceNumber = insuranceNumber.replace(/\s+/g, ' ');  // Thay thế tất cả khoảng trắng thừa thành một khoảng trắng duy nhất
      // Kiểm tra nếu không có dữ liệu trong các trường tìm kiếm
      if (fullName === "" && insuranceNumber === "" && appointmentType === "" && customAppointmentType === "") {
        alert("Please enter at least one search criterion.");
        return false;
      }

      // Kiểm tra tên bệnh nhân không chứa ký tự lạ và khoảng trắng thừa
      if (fullName !== "" && !/^[a-zA-Z\s]+$/.test(fullName)) {
        alert("Please enter a valid patient's name (only letters and spaces).");
        return false;
      }

      // Kiểm tra mã bảo hiểm (INS + số)
      if (insuranceNumber !== "" && !/^\d+$/.test(insuranceNumber)) {
        alert("Please enter a valid insurance number (only digits after INS).");
        return false;
      }

      // Kiểm tra nếu chọn "Other..." nhưng không nhập loại cuộc hẹn
      if (appointmentType === "custom" && customAppointmentType === "") {
        alert("Please enter a custom appointment type.");
        return false;
      }

      return true; // Cho phép gửi form nếu tất cả các điều kiện đều hợp lệ
    }
  </script>
</head>
<body>

<jsp:include page="doctor-header.jsp"/>

<c:set var="page" value="${param.page != null ? param.page : 1}" />
<c:set var="page" value="${page + 0}" />
<c:set var="pageSize" value="5" />
<c:set var="totalItems" value="${fn:length(completedAppointments)}" />
<c:set var="totalPages" value="${(totalItems + pageSize - 1) / pageSize}" />
<c:set var="start" value="${(page - 1) * pageSize}" />
<c:set var="end" value="${page * pageSize}" />

<div class="container mt-5">
  <section class="about-area2 section-padding40" id="completed-history-section">
    <div class="container">
      <div class="section-tittle mb-30 text-center">
        <h2>Completed Appointments History</h2>
      </div>
      <form action="completed-history" method="get" class="mb-4" style="display: flex; justify-content: center; align-items: center; gap: 15px; margin: 0 auto; width: 80%; flex-wrap: wrap;">
        <!-- Tìm kiếm theo tên bệnh nhân -->
        <input type="text" name="fullName" value="${param.fullName}" placeholder="Patient's Name..." class="form-control" style="width: 280px; height: 40px;" />

        <!-- Tìm kiếm theo mã bảo hiểm -->
        <input type="text" name="insuranceNumber" value="${param.insuranceNumber}" placeholder="Insurance Number..." class="form-control" style="width: 280px; height: 40px;" />

        <!-- Tìm kiếm theo loại cuộc hẹn -->
        <select name="appointmentType" class="form-control" style="width: 280px; height: 40px;">
          <option value="" disabled selected>Select Treatment</option>
          <option value="General Checkup">General Checkup</option>
          <option value="Cardiology Consultation">Cardiology Consultation</option>
          <option value="Gastroenterology Consultation">Gastroenterology Consultation</option>
          <option value="Orthopedic Consultation">Orthopedic Consultation</option>
          <option value="Neurology Consultation">Neurology Consultation</option>
          <option value="Mental Health Consultation">Mental Health Consultation</option>
          <option value="Psychotherapy Session">Psychotherapy Session</option>
          <option value="Psychiatric Evaluation">Psychiatric Evaluation</option>
          <option value="Stress and Anxiety Management">Stress and Anxiety Management</option>
          <option value="Depression Counseling">Depression Counseling</option>
          <option value="Periodic Health Checkup">Periodic Health Checkup</option>
          <option value="Gynecology Consultation">Gynecology Consultation</option>
          <option value="Pediatric Consultation">Pediatric Consultation</option>
          <option value="Ophthalmology Consultation">Ophthalmology Consultation</option>
          <option value="ENT Consultation">ENT Consultation</option>
          <option value="On-Demand Consultation">On-Demand Consultation</option>
          <option value="Emergency Consultation">Emergency Consultation</option>
          <option value="custom">Other...</option>
        </select>

        <button type="submit" class="btn btn-primary" style="width: 300px; height: 40px; margin-top: 10px;">Search</button>
      </form>
      <div class="row justify-content-center">
        <div class="col-lg-10">
          <table class="table table-hover table-bordered text-center">
            <thead class="thead-dark" style="font-weight: 600;">
            <tr>
              <th style="padding: 6px 10px;">Number</th>
              <th style="padding: 6px 10px;">Insurance Number</th>
              <th style="padding: 6px 10px;">Patient Name</th>
              <th style="padding: 6px 10px;">Appointment Type</th>
              <th style="padding: 6px 10px;">Appointment Date</th>
              <th style="padding: 6px 10px;">Status</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
              <c:when test="${empty completedAppointments}">
                <tr>
                  <td colspan="6" class="text-center">No completed appointments found.</td>
                </tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="a" items="${completedAppointments}" varStatus="loop">
                  <c:if test="${loop.index >= start && loop.index < end}">
                    <tr style="text-align: center;">
                      <td style="padding: 6px 10px;">${loop.index - start + 1}</td>
                      <td style="padding: 6px 10px;">${a.insuranceNumber}</td>
                      <td style="padding: 6px 10px;">${a.patientFullName}</td>
                      <td style="padding: 6px 10px;">${a.appointmentType}</td>
                      <td style="padding: 6px 10px;">
                        <c:choose>
                          <c:when test="${not empty a.appointmentDate}">
                            <fmt:formatDate value="${a.appointmentDate}" pattern="dd/MM/yyyy" />
                          </c:when>
                          <c:otherwise>
                            Not scheduled
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td style="padding: 6px 10px;">${a.status}</td>
                    </tr>
                  </c:if>
                </c:forEach>
              </c:otherwise>
            </c:choose>
            </tbody>
          </table>
          <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
              <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${i == page ? 'active' : ''}">
                  <a class="page-link" href="?page=${i}">${i}</a>
                </li>
              </c:forEach>
            </ul>
          </nav>
        </div>
      </div>
    </div>
  </section>
</div>

<jsp:include page="doctor-footer.jsp"/>
<jsp:include page="doctor-common-scripts.jsp"/>

</body>
</html>
