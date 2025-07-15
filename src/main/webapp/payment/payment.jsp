<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment</title>
    <link rel="stylesheet" href="<c:url value='/assets/css/bootstrap.min.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
    <style>
        .pay-card { max-width: 500px; margin: 40px auto; border-radius: 12px; border: 2px solid #28a745; }
        .pay-card .card-body { padding: 32px; }
        .pay-label { font-weight: bold; color: #28a745; }
        .pay-value { font-size: 1.2em; }
        #button-container button { width: 100%; background-color: #28a745; color: white; border: none; padding: 12px; font-size: 1.2em; border-radius: 6px; }
        #embeded-payment-container { height: 350px; margin-top: 20px; }
    </style>
</head>
<body>
<main>
    <div style="margin-top: 20px; text-align: center;">
        <a href="<c:url value='/appointments'/>" class="btn btn-secondary">Back</a>
    </div>
    <div class="container mt-5">
        <h2>Payment for Appointment</h2>
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        <div class="card pay-card">
            <div class="card-body">
                <div id="content-container">
                    <table class="table table-bordered">
                        <tr>
                            <th class="pay-label">Appointment ID</th>
                            <td class="pay-value">${appointment.appointmentId}</td>
                        </tr>
                        <tr>
                            <th class="pay-label">Patient Name</th>
                            <td class="pay-value">${appointment.patient.fullName}</td>
                        </tr>
                        <tr>
                            <th class="pay-label">Service</th>
                            <td class="pay-value">${appointment.appointmentType.typeName}</td>
                        </tr>
                        <tr>
                            <th class="pay-label">Specialist Required</th>
                            <td class="pay-value">
                                <c:choose>
                                    <c:when test="${appointment.requiresSpecialist}">Yes</c:when>
                                    <c:otherwise>No</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th class="pay-label">Amount</th>
                            <td class="pay-value"><fmt:formatNumber value="${appointment.appointmentType.price}" type="currency" currencySymbol="₫"/></td>
                        </tr>
                    </table>
                </div>
                <div id="button-container">
                    <form method="post" action="/benhVienLmao_war_exploded/payment">
                        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}" />
                        <button type="submit" id="create-payment-link-btn"
                            <c:if test="${appointment.status != 'Unpay'}">disabled</c:if>
                        >Comfirm pay</button>
                    </form>
                </div>
                <div id="embeded-payment-container"></div>
            </div>
        </div>
    </div>
</main>
<script>
    window.PAYMENT_APPOINTMENT_ID = "${appointment.appointmentId}";
</script>
<script src="https://cdn.payos.vn/payos-checkout/v1/stable/payos-initialize.js"></script>
</body>
</html>
