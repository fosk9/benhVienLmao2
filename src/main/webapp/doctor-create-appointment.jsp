<%--
  Created by IntelliJ IDEA.
  User: ADMIN
  Date: 5/28/2025
  Time: 3:11 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Patient List</title>
    <jsp:include page="doctor-common-css.jsp"/>
    <style>
        table.table {
            font-size: 0.9rem !important;
            width: 75% !important;
            margin: 0 auto !important;
        }

        table.table th, table.table td {
            padding: 6px 10px !important;
            white-space: nowrap;
        }

        table.table th:nth-child(1), table.table td:nth-child(1) {
            width: 15%;
        }

        table.table th:nth-child(2), table.table td:nth-child(2) {
            width: 22%;
        }

        table.table th:nth-child(3), table.table td:nth-child(3) {
            width: 12%;
        }

        table.table th:nth-child(4), table.table td:nth-child(4) {
            width: 12%;
        }

        table.table th:nth-child(5), table.table td:nth-child(5) {
            width: 12%;
        }

        table.table th:nth-child(6), table.table td:nth-child(6) {
            width: 15%;
        }

        table.table th:nth-child(7), table.table td:nth-child(7) {
            width: 12%;
        }
    </style>
</head>
<body>
<jsp:include page="doctor-header.jsp"/>

<section class="about-area2 section-padding40" id="patient-section" style="color: black;">
    <div class="container">
        <div class="section-tittle mb-30 text-center" style="color: black;">
            <h2 style="color: black;">Create an Appointment</h2>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-10">

                <table class="table table-hover table-bordered text-center" style="color: black;">
                    <thead>
                    <tr>
                        <th style="color: black;">Insurance Number</th>
                        <th style="color: black;">Full Name</th>
                        <th style="color: black;">DOB</th>
                        <th style="color: black;">Gender</th>
                        <th style="color: black;">Phone</th>
                        <th style="color: black;">Emergency Contact</th>
                        <th style="color: black;">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:if test="${empty patients}">
                        <tr>
                            <td colspan="7" class="text-center" style="color: black;">No patients found.</td>
                        </tr>
                    </c:if>

                    <c:forEach var="p" items="${patients}" varStatus="loop">
                        <tr>
                            <td style="color: black;">${p.insuranceNumber}</td>
                            <td style="color: black;">${p.fullName}</td>
                            <td style="color: black;"><fmt:formatDate value="${p.dob}" pattern="dd-MM-yyyy"/></td>
                            <td style="color: black;">${p.gender}</td>
                            <td style="color: black;">${p.phone}</td>
                            <td style="color: black;">${p.emergencyContact}</td>
                            <td>
                                <button type="button" onclick="showCreateForm(${p.patientId}, this)"
                                        style="font-size: 1rem; padding: 4px 12px; cursor: pointer; color: black; background-color: #f0f0f0; border: 1px solid #ccc; border-radius: 8px;">
                                    Create
                                </button>
                            </td>
                        </tr>
                        <tr class="create-form-row" style="display:none;">
                            <td colspan="7" style="color: black;">
                                <form action="${pageContext.request.contextPath}/create-appointment" method="post" style="font-size: 1rem; display: flex; align-items: center; gap: 8px; flex-wrap: nowrap; color: black;">
                                    <input type="hidden" name="patientId" value="${p.patientId}" />

                                    <label for="appointmentType-${p.patientId}" style="min-width: 110px; color: black; margin-right: 4px;">Type:</label>
                                    <select id="appointmentType-${p.patientId}" name="appointmentType" required style="font-size: 1rem; padding: 4px; min-width: 140px; color: black;">
                                        <option value="" disabled selected>Select Treatment</option>
                                        <option value="General Checkup">General Checkup</option>
                                        <option value="Dental">Dental</option>
                                        <option value="Eye Exam">Eye Exam</option>
                                        <option value="Surgery Consult">Surgery Consult</option>
                                        <option value="Follow-up">Follow-up</option>
                                    </select>

                                    <label for="appointmentDate-${p.patientId}" style="min-width: 60px; color: black; margin-left: 16px; margin-right: 4px;">Date:</label>
                                    <input id="appointmentDate-${p.patientId}" type="datetime-local" name="appointmentDate" required style="font-size: 1rem; padding: 4px; min-width: 170px; color: black;" />

                                    <label for="status-${p.patientId}" style="min-width: 60px; color: black; margin-left: 16px; margin-right: 4px;">Status:</label>
                                    <select id="status-${p.patientId}" name="status" style="font-size: 1rem; padding: 4px; min-width: 110px; color: black;">
                                        <option value="Pending">Pending</option>
                                        <option value="Confirmed">Confirmed</option>
                                    </select>

                                    <button type="submit" style="font-size: 1rem; padding: 6px 14px; cursor: pointer; color: white; background-color: #007bff; border: 1px solid #007bff; border-radius: 8px;">
                                        Save
                                    </button>
                                    <button type="button" onclick="hideCreateForm(this)" style="font-size: 1rem; padding: 6px 14px; margin-left: 6px; cursor: pointer; color: white; background-color: #dc3545; border: 1px solid #dc3545; border-radius: 8px;">
                                        Cancel
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

            </div>
        </div>
    </div>
</section>

<script>
    function showCreateForm(patientId, btn) {
        document.querySelectorAll('.create-form-row').forEach(row => row.style.display = 'none');
        const tr = btn.closest('tr');
        const formRow = tr.nextElementSibling;
        if (formRow && formRow.classList.contains('create-form-row')) {
            formRow.style.display = 'table-row';
        }
    }

    function hideCreateForm(btn) {
        const tr = btn.closest('tr');
        if (tr && tr.classList.contains('create-form-row')) {
            tr.style.display = 'none';
        }
    }
</script>


<jsp:include page="doctor-footer.jsp"/>
<jsp:include page="doctor-common-scripts.jsp"/>

</body>
</html>

