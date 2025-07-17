<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Payment - benhVienLmao</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/assets/css/fontawesome-all.min.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&display=swap" rel="stylesheet">
    <style>
        /* Minimalist and bold styling */
        body {
            font-family: "Playfair Display", serif;
            background: #f8f9fa; /* Clean light background */
            color: #333;
            margin: 0;
        }
        /* Container styling */
        .container {
            max-width: 1000px; /* Larger container */
            padding: 50px 20px;
        }
        /* Video container styling */
        .video-container {
            max-width: 800px; /* Match payment card width */
            margin: 0 auto 40px;
            border-radius: 20px; /* Rounded corners */
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        .video-container iframe {
            width: 100%;
            height: 450px; /* Larger video height */
            border: none;
        }
        /* Header styling */
        h2 {
            font-size: 4rem; /* Larger title */
            font-weight: 700;
            text-align: center;
            color: #28a745;
            margin: 50px 0;
            text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.1);
        }
        /* Back button */
        .btn-back {
            background: #6c757d;
            border: none;
            padding: 12px 30px;
            font-size: 1.6rem; /* Larger button text */
            border-radius: 12px;
            color: #fff;
            transition: transform 0.2s, background 0.3s;
            display: inline-block;
            margin-bottom: 30px;
        }
        .btn-back:hover {
            background: #5a6268;
            transform: translateY(-3px);
        }
        /* Payment card styling */
        .pay-card {
            max-width: 800px; /* Larger card */
            margin: 0 auto;
            border-radius: 20px; /* Larger rounded corners */
            border: 3px solid #28a745; /* Thicker border */
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            background: #fff;
        }
        .pay-card .card-body {
            padding: 40px; /* Larger padding */
        }
        /* Table styling */
        .table {
            margin-bottom: 0;
            font-size: 1.6rem; /* Larger table text */
        }
        .table th, .table td {
            padding: 20px; /* Larger padding */
            vertical-align: middle;
            text-align: left;
            border: 2px solid #28a745; /* Thicker border */
        }
        .pay-label {
            font-weight: 600;
            color: #28a745;
            font-size: 1.8rem; /* Larger label text */
        }
        .pay-value {
            font-size: 1.6rem; /* Larger value text */
        }
        /* Confirm pay button */
        #button-container button {
            width: 100%;
            background: #28a745;
            border: none;
            padding: 15px;
            font-size: 1.8rem; /* Larger button text */
            border-radius: 12px;
            color: #fff;
            transition: transform 0.2s, background 0.3s;
        }
        #button-container button:hover {
            background: #218838;
            transform: translateY(-3px);
        }
        #button-container button:disabled {
            background: #6c757d;
            cursor: not-allowed;
        }
        /* Embedded payment container */
        #embeded-payment-container {
            height: 400px; /* Larger height */
            margin-top: 30px;
        }
        /* Error message styling */
        .error-message {
            color: #dc3545;
            font-size: 1.8rem; /* Larger text */
            font-weight: 500;
            text-align: center;
            margin: 40px 0;
            background: #fff;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        /* Responsive adjustments */
        @media (max-width: 768px) {
            h2 {
                font-size: 3rem;
            }
            .container {
                padding: 30px 15px;
            }
            .video-container {
                max-width: 100%;
            }
            .video-container iframe {
                height: 300px; /* Adjusted for mobile */
            }
            .pay-card {
                max-width: 100%;
            }
            .pay-card .card-body {
                padding: 20px;
            }
            .table th, .table td {
                font-size: 1.2rem;
                padding: 12px;
            }
            .pay-label {
                font-size: 1.4rem;
            }
            .pay-value {
                font-size: 1.2rem;
            }
            .btn-back, #button-container button {
                font-size: 1.4rem;
                padding: 10px 20px;
            }
            #embeded-payment-container {
                height: 300px;
            }
            .error-message {
                font-size: 1.4rem;
                padding: 15px;
            }
        }
    </style>
</head>
<body>
<main>
    <div class="container">
        <!-- YouTube Video -->
        <div class="video-container">
            <iframe src="https://www.youtube.com/embed/Q-DYUEwwkTA" title="Payment Guide Video" allowfullscreen></iframe>
        </div>
        <!-- Back button -->
        <a href="<c:url value='/appointments'/>" class="btn-back"><i class="fas fa-arrow-left me-2"></i>Back</a>
        <!-- Page title -->
        <h2>Payment for Appointment</h2>
        <!-- Error message -->
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        <!-- Payment card -->
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
                                    <c:when test="${appointment.requiresSpecialist}"><span class="badge bg-success">Yes</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary">No</span></c:otherwise>
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
                        ><i class="fas fa-credit-card me-2"></i>Confirm Payment</button>
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