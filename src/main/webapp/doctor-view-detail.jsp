<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
    boolean editMode = "true".equals(request.getParameter("edit"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Appointment Detail</title>
    <jsp:include page="doctor-common-css.jsp"/>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f3f3f3;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 600px;
            margin: 40px auto;
            padding: 25px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #1e1e1e;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px 12px;
            border: 1px solid #e0e0e0;
            vertical-align: middle;
        }

        th {
            background-color: #f8f8f8;
            width: 40%;
            text-align: left;
            font-weight: 600;
        }

        tr:nth-child(even) {
            background-color: #fafafa;
        }

        input[type="text"],
        input[type="date"],
        select {
            width: 100%;
            padding: 8px;
            border-radius: 4px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }

        .button-group {
            display: flex;
            justify-content: center;
            margin-top: 25px;
            gap: 15px;
        }

        .button-group a,
        .button-group button {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-back {
            background-color: #28a745;
            color: #fff;
        }

        .btn-edit {
            background-color: #007bff;
            color: #fff;
        }

        .btn-save {
            background-color: #17a2b8;
            color: #fff;
        }

        .btn-back:hover,
        .btn-edit:hover,
        .btn-save:hover {
            opacity: 0.9;
        }

        .error-message {
            color: red;
            font-weight: bold;
            text-align: center;
        }
    </style>
    <script>
        function updateDescription() {
            const select = document.getElementById('appointmentTypeSelect');
            const selectedOption = select.options[select.selectedIndex];
            const description = selectedOption.getAttribute('data-description');

            document.getElementById('descriptionField').value = description;
        }
    </script>

</head>
<body>
<jsp:include page="doctor-header.jsp"/>
<div class="container">
    <!-- Hiển thị thông báo lỗi nếu có -->
    <c:if test="${not empty errorMessage}">
        <div class="error-message">
                ${errorMessage}
        </div>
    </c:if>
    <h2>Appointment Detail</h2>
    <form method="post" action="${pageContext.request.contextPath}/update-appointment">
        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}"/>
        <table>
            <tr>
                <th>Patient Name</th>
                <td>
                    <c:choose>
                        <c:when test="<%= editMode %>">
                            <input type="text" name="fullName" value="${requestScope.fullName != null ? requestScope.fullName : appointment.patient.fullName}" required/>
                        </c:when>
                        <c:otherwise>${appointment.patient.fullName}</c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <th>Date of Birth</th>
                <td>
                    <c:choose>
                        <c:when test="<%= editMode %>">
                            <input type="date" name="dob"
                                   value="<fmt:formatDate value='${requestScope.dob != null ? requestScope.dob : appointment.patient.dob}' pattern='yyyy-MM-dd'/>"/>
                        </c:when>
                        <c:otherwise><fmt:formatDate value="${appointment.patient.dob}" pattern="dd/MM/yyyy"/></c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <th>Gender</th>
                <td>
                    <c:choose>
                        <c:when test="<%= editMode %>">
                            <select name="gender">
                                <option value="M" <c:if test="${requestScope.gender == 'M'}">selected</c:if>>Male</option>
                                <option value="F" <c:if test="${requestScope.gender == 'F'}">selected</c:if>>Female</option>
                            </select>
                        </c:when>
                        <c:otherwise>${appointment.patient.gender}</c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <th>Phone</th>
                <td>
                    <c:choose>
                        <c:when test="<%= editMode %>">
                            <input type="text" name="phone" value="${requestScope.phone != null ? requestScope.phone : appointment.patient.phone}"/>
                        </c:when>
                        <c:otherwise>${appointment.patient.phone}</c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <th>Address</th>
                <td>
                    <c:choose>
                        <c:when test="<%= editMode %>">
                            <input type="text" name="address" value="${requestScope.address != null ? requestScope.address : appointment.patient.address}"/>
                        </c:when>
                        <c:otherwise>${appointment.patient.address}</c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <th>Insurance Number</th>
                <td>
                    <c:choose>
                        <c:when test="<%= editMode %>">
                            <input type="text" name="insuranceNumber" value="${requestScope.insuranceNumber != null ? requestScope.insuranceNumber : appointment.patient.insuranceNumber}"/>
                        </c:when>
                        <c:otherwise>${appointment.patient.insuranceNumber}</c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <th>Emergency Contact</th>
                <td>
                    <c:choose>
                        <c:when test="<%= editMode %>">
                            <input type="text" name="emergencyContact" value="${requestScope.emergencyContact != null ? requestScope.emergencyContact : appointment.patient.emergencyContact}"/>
                        </c:when>
                        <c:otherwise>${appointment.patient.emergencyContact}</c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <th>Appointment Date</th>
                <td>
                    <c:choose>
                        <c:when test="<%= editMode %>">
                            <input type="date" name="appointmentDate"
                                   value="<fmt:formatDate value='${requestScope.appointmentDate != null ? requestScope.appointmentDate : appointment.appointmentDate}' pattern='yyyy-MM-dd'/>"/>
                        </c:when>
                        <c:otherwise><fmt:formatDate value="${appointment.appointmentDate}" pattern="dd/MM/yyyy"/></c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <th>Status</th>
                <td>
                    <c:choose>
                        <c:when test="<%= editMode %>">
                            <select name="status">
                                <option value="Pending" <c:if test="${appointment.status == 'Pending'}">selected</c:if>>Pending</option>
                                <option value="Confirmed" <c:if test="${appointment.status == 'Confirmed'}">selected</c:if>>Confirmed</option>
                                <option value="Completed" <c:if test="${appointment.status == 'Completed'}">selected</c:if>>Completed</option>
                                <option value="Cancelled" <c:if test="${appointment.status == 'Cancelled'}">selected</c:if>>Cancelled</option>
                            </select>
                        </c:when>
                        <c:otherwise>${appointment.status}</c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <th>Appointment Type</th>
                <td>
                    <c:choose>
                        <c:when test="<%= editMode %>">
                            <select name="appointmentTypeId" id="appointmentTypeSelect" onchange="updateDescription()">
                                <c:forEach var="type" items="${appointmentTypes}">
                                    <option value="${type.appointmentTypeId}"
                                            data-description="${type.description}"
                                            <c:if test="${type.appointmentTypeId == appointment.appointmentType.appointmentTypeId}">selected</c:if>>${type.typeName}</option>
                                </c:forEach>
                            </select>
                        </c:when>
                        <c:otherwise>${appointment.appointmentType.typeName}</c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <th>Description</th>
                <td>
                    <c:choose>
                        <c:when test="<%= editMode %>">
                            <input type="text" id="descriptionField" name="typeDescription" value="${appointment.appointmentType.description}" readonly/>
                        </c:when>
                        <c:otherwise>${appointment.appointmentType.description}</c:otherwise>
                    </c:choose>
                </td>
            </tr>

        </table>

        <div class="button-group">
            <a href="${pageContext.request.contextPath}/doctor-home" class="btn-back">Back to List</a>
            <c:choose>
                <c:when test="<%= !editMode %>">
                    <a href="${pageContext.request.contextPath}/view-detail?id=${appointment.appointmentId}&edit=true" class="btn-edit">Edit</a>
                </c:when>
                <c:otherwise>
                    <button type="submit" class="btn-save">Save</button>
                </c:otherwise>
            </c:choose>
        </div>
    </form>
</div>
<jsp:include page="doctor-footer.jsp"/>
<jsp:include page="doctor-common-scripts.jsp"/>
</body>
</html>
