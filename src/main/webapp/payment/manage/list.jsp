<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> <%-- NEW: Thêm taglib cho định dạng ngày/giờ --%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Payment History - benhVienLmao</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css"> <%-- Đảm bảo đường dẫn CSS của bạn đúng --%>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  <style>
    /* Enhanced container styling */
    .container {
      max-width: 1400px;
      padding: 30px;
    }
    /* Header styling */
    h2 {
      color: #28a745;
      font-weight: 700;
      margin-bottom: 20px;
    }
    /* Search form styling */
    .search-table {
      background-color: #f8f9fa;
      border: 2px solid #28a745;
      border-radius: 15px;
      padding: 20px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }
    .search-table td {
      padding: 10px;
    }
    .search-table td:first-child {
      color: #28a745;
      font-weight: 600;
      font-size: 1.1rem;
      text-align: right;
      width: 30%;
    }
    .search-table td:last-child {
      width: 70%;
    }
    .search-table .form-control, .search-table .form-select {
      border: 1px solid #28a745;
      font-size: 1rem;
      height: 38px;
      border-radius: 8px;
    }
    .search-table .btn {
      padding: 8px 20px;
      font-size: 1rem;
      border-radius: 8px;
    }
    /* Table styling */
    .table-container {
      border-radius: 15px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }
    .table {
      margin-bottom: 0;
    }
    .table thead th {
      background-color: #28a745;
      color: white;
      font-weight: 600;
      padding: 12px;
      text-align: center;
    }
    .table tbody tr {
      transition: background-color 0.2s;
    }
    .table tbody tr:hover {
      background-color: #f1f8f1;
    }
    .table td {
      vertical-align: middle;
      padding: 12px;
      text-align: center;
    }
    .table .content-value { /* Re-purposed for pay content */
      max-width: 300px;
      white-space: pre-line;
      word-break: break-word;
      text-align: left;
    }
    /* Action buttons - simplified for view only */
    .btn-action {
      padding: 6px 12px;
      font-size: 0.9rem;
      margin: 0 5px;
      border-radius: 8px;
      transition: transform 0.2s;
    }
    .btn-action:hover {
      transform: translateY(-2px);
    }
    /* Pagination */
    .pagination {
      margin-top: 20px;
      justify-content: center;
    }
    /* Responsive adjustments */
    @media (max-width: 768px) {
      .search-table {
        padding: 15px;
      }
      .search-table td:first-child {
        font-size: 1rem;
        text-align: left;
      }
      .search-table .form-control, .search-table .form-select {
        font-size: 0.9rem;
        height: 35px;
      }
      .table td, .table th {
        font-size: 0.9rem;
        padding: 8px;
      }
      .btn-action {
        font-size: 0.8rem;
        padding: 5px 10px;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <h2>Payment History</h2>
  <%-- Nút "Add New Content" được loại bỏ vì thường không thêm lịch sử thanh toán trực tiếp --%>

  <form class="mb-4" method="get" action="${pageContext.request.contextPath}/admin/payments"> <%-- NEW: Điều chỉnh action URL --%>
    <input type="hidden" name="action" value="list">
    <table class="search-table">
      <tr>
        <td>Payment ID</td>
        <td><input type="text" class="form-control" name="searchPaymentId" value="${param.searchPaymentId}"></td>
      </tr>
      <tr>
        <td>Appointment ID</td>
        <td><input type="text" class="form-control" name="searchAppointmentId" value="${param.searchAppointmentId}"></td>
      </tr>
      <tr>
        <td>Method</td>
        <td><input type="text" class="form-control" name="searchMethod" value="${param.searchMethod}"></td>
      </tr>
      <tr>
        <td>Status</td>
        <td>
          <select class="form-select" name="searchStatus">
            <option value="">All</option>
            <option value="Paid" ${param.searchStatus == 'Paid' ? 'selected' : ''}>Paid</option>
            <option value="Pending" ${param.searchStatus == 'Pending' ? 'selected' : ''}>Pending</option>
            <option value="Cancelled" ${param.searchStatus == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
            <option value="Failed" ${param.searchStatus == 'Failed' ? 'selected' : ''}>Failed</option>
          </select>
        </td>
      </tr>
      <tr>
        <td>Created At (from)</td>
        <td><input type="date" class="form-control" name="searchCreatedAtFrom" value="${param.searchCreatedAtFrom}"></td>
      </tr>
      <tr>
        <td>Created At (to)</td>
        <td><input type="date" class="form-control" name="searchCreatedAtTo" value="${param.searchCreatedAtTo}"></td>
      </tr>
      <tr>
        <td colspan="2" class="text-center">
          <button type="submit" class="btn btn-primary me-2"><i class="fas fa-search me-2"></i>Search</button>
          <a href="${pageContext.request.contextPath}/admin/payments?action=list" class="btn btn-secondary"> <%-- NEW: Điều chỉnh reset URL --%>
            <i class="fas fa-undo me-2"></i>Reset
          </a>
        </td>
      </tr>
    </table>
  </form>
  <div class="table-container">
    <table class="table table-bordered mb-0">
      <thead>
      <tr>
        <th>ID</th>
        <th>Appointment ID</th>
        <th>Amount</th>
        <th>Method</th>
        <th>Status</th>
        <th>Pay Content</th>
        <th>Created At</th>
        <th>Paid At</th>
        <th>Actions</th> <%-- Giữ lại cột Actions cho mục đích xem chi tiết nếu cần --%>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="payment" items="${payments}"> <%-- NEW: Đổi var và items --%>
        <tr>
          <td>${payment.paymentId}</td>
          <td>${payment.appointmentId}</td>
          <td><fmt:formatNumber value="${payment.amount}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td> <%-- NEW: Định dạng tiền tệ --%>
          <td>${payment.method}</td>
          <td>
            <c:choose> <%-- NEW: Hiển thị badge theo trạng thái thanh toán --%>
              <c:when test="${payment.status == 'Paid'}"><span class="badge bg-success">Paid</span></c:when>
              <c:when test="${payment.status == 'Pending'}"><span class="badge bg-warning text-dark">Pending</span></c:when>
              <c:when test="${payment.status == 'Cancelled'}"><span class="badge bg-danger">Cancelled</span></c:when>
              <c:when test="${payment.status == 'Failed'}"><span class="badge bg-danger">Failed</span></c:when>
              <c:otherwise><span class="badge bg-info">Unknown</span></c:otherwise>
            </c:choose>
          </td>
          <td class="content-value">${payment.payContent}</td>
          <td><fmt:formatDate value="${payment.createdAt}" pattern="dd-MM-yyyy HH:mm:ss"/></td> <%-- NEW: Định dạng ngày/giờ --%>
          <td>
            <c:if test="${not empty payment.paidAt}">
              <fmt:formatDate value="${payment.paidAt}" pattern="dd-MM-yyyy HH:mm:ss"/>
            </c:if>
            <c:if test="${empty payment.paidAt}">
              N/A
            </c:if>
          </td>
          <td>
              <%-- NEW: Thêm nút xem chi tiết nếu cần. Các nút edit/delete thường không áp dụng cho lịch sử thanh toán --%>
            <a href="${pageContext.request.contextPath}/admin/payments?action=view&id=${payment.paymentId}"
               class="btn btn-info btn-action"><i class="fas fa-info-circle me-1"></i>View</a>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty payments}"> <%-- NEW: Đổi items --%>
        <tr>
          <td colspan="9" class="text-center">No payment history found.</td>
        </tr>
      </c:if>
      </tbody>
    </table>
  </div>

  <c:if test="${totalPages > 1}">
    <nav>
      <ul class="pagination">
        <li class="page-item <c:if test='${currentPage == 1}'>disabled</c:if>">
          <a class="page-link" href="?action=list&page=${currentPage - 1}"><i class="fas fa-chevron-left"></i></a>
        </li>
        <c:forEach begin="1" end="${totalPages}" var="i">
          <li class="page-item <c:if test='${currentPage == i}'>active</c:if>">
            <a class="page-link" href="?action=list&page=${i}">${i}</a>
          </li>
        </c:forEach>
        <li class="page-item <c:if test='${currentPage == totalPages}'>disabled</c:if>">
          <a class="page-link" href="?action=list&page=${currentPage + 1}"><i class="fas fa-chevron-right"></i></a>
        </li>
      </ul>
    </nav>
  </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>