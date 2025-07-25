<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="common-css.jsp"/>
    <title>Consultation Detail</title>
</head>
<body>
<jsp:include page="header.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">Examination Detail</h2>

    <div class="card mb-4">
        <div class="card-header">Appointment Information</div>
        <div class="card-body">
            <p><strong>Patient:</strong> ${patient.fullName}</p>
            <p><strong>Date:</strong> <fmt:formatDate value="${appointment.appointmentDate}" pattern="dd/MM/yyyy"/></p>
            <p><strong>Time Slot:</strong> ${appointment.timeSlot}</p>
            <p><strong>Type:</strong> ${appointmentType.typeName} (${appointmentType.price}$)</p>
            <p><strong>Description:</strong> ${appointmentType.description}</p>
            <p><strong>Status:</strong> ${appointment.status}</p>
            <p><strong>Requires Specialist:</strong> ${appointment.requiresSpecialist ? 'Yes' : 'No'}</p>

            <hr>
            <p><strong>Diagnoses:</strong></p>
            <c:choose>
                <c:when test="${not empty diagnoses}">
                    <c:forEach var="d" items="${diagnoses}">
                        <p>- ${d.notes}</p>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="text-muted">No diagnoses recorded.</p>
                </c:otherwise>
            </c:choose>
            <hr>
            <p><strong>Prescriptions:</strong></p>
            <c:choose>
                <c:when test="${not empty prescriptions}">
                    <c:forEach var="p" items="${prescriptions}">
                        <p>- ${p.medicationDetails}</p>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="text-muted">No prescriptions provided.</p>
                </c:otherwise>
            </c:choose>
            <hr>
            <p><strong>Treatments:</strong></p>
            <c:choose>
                <c:when test="${not empty treatments}">
                    <c:forEach var="t" items="${treatments}">
                        <p>- <strong>${t.treatmentType}</strong>: ${t.treatmentNotes}</p>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="text-muted">No treatments assigned.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>


    <a href="examination-history" class="btn btn-secondary">Back to List</a>
</div>
<jsp:include page="footer.jsp"/>

<jsp:include page="common-scripts.jsp"/>
</body>
</html>
