<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Examination Detail</title>
    <jsp:include page="common-css.jsp"/>
</head>
<body>

<jsp:include page="header.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">Examination Details</h2>

    <!-- Appointment Info -->
    <div class="card mb-4">
        <div class="card-header"><strong>Appointment Information</strong></div>
        <div class="card-body">
            <p><strong>Appointment ID:</strong> ${appointment.appointmentId}</p>
            <p><strong>Date:</strong> <fmt:formatDate value="${appointment.appointmentDate}" pattern="dd/MM/yyyy"/></p>
            <p><strong>Time Slot:</strong> ${appointment.timeSlot}</p>
            <p><strong>Type:</strong> ${appointmentType.typeName}</p>
            <p><strong>Status:</strong> ${appointment.status}</p>
            <c:if test="${not empty doctor}">
                <p><strong>Doctor:</strong> ${doctor.fullName}</p>
            </c:if>
        </div>
    </div>

    <!-- Diagnoses -->
    <div class="card mb-4">
        <div class="card-header"><strong>Diagnoses</strong></div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty diagnoses}">
                    <ul class="list-group list-group-flush">
                        <c:forEach var="d" items="${diagnoses}">
                            <li class="list-group-item">${d.notes}</li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <p>No diagnoses available.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Prescriptions -->
    <div class="card mb-4">
        <div class="card-header"><strong>Prescriptions</strong></div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty prescriptions}">
                    <ul class="list-group list-group-flush">
                        <c:forEach var="p" items="${prescriptions}">
                            <li class="list-group-item">${p.medicationDetails}</li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <p>No prescriptions available.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Treatments -->
    <div class="card mb-4">
        <div class="card-header"><strong>Treatments</strong></div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty treatments}">
                    <ul class="list-group list-group-flush">
                        <c:forEach var="t" items="${treatments}">
                            <li class="list-group-item">
                                <strong>${t.treatmentType}:</strong> ${t.treatmentNotes}
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <p>No treatments recorded.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Back button -->
    <a href="patient-examination-history" class="btn btn-secondary">Back to History</a>
</div>

<jsp:include page="footer.jsp"/>
<jsp:include page="common-scripts.jsp"/>

</body>
</html>
