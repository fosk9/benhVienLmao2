<%--
  Created by IntelliJ IDEA.
  User: Fosk Jesky
  Date: 5/26/2025
  Time: 4:12 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>My Appointments</title>
  <meta name="description" content="">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="<c:url value='/assets/css/bootstrap.min.css'/>">
</head>
<body>
<header>
  <div class="header-area">
    <div class="main-header header-sticky">
      <div class="container-fluid">
        <div class="row align-items-center">
          <div class="col-xl-2 col-lg-2 col-md-1">
            <div class="logo">
              <a href="<c:url value='/home'/>">HealthCare</a>
            </ google.comdiv>
          </div>
          <div class="col-xl-10 col-lg-10 col-md-10">
            <div class="menu-main d-flex align-items-center justify-content-end">
              <div class="main-menu f-right d-none d-lg-block">
                <nav>
                  <ul id="navigation">
                    <li><a href="<c:url value='/home'/>">Home</a></li>
                    <li><a href="<c:url value='/book-appointment'/>">Book Appointment</a></li>
                  </ul>
                </nav>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</header>
<main>
  <div class="container mt-5">
    <h2>My Appointments</h2>
    <table class="table table-bordered">
      <thead>
      <tr>
        <th>ID</th>
        <th>Appointment Date</th>
        <th>Type</th>
        <th>Status</th>
        <th>Actions</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="appointment" items="${appointments}">
        <tr>
          <td>${appointment.appointmentId}</td>
          <td>${appointment.appointmentDate}</td>
          <td>${appointment.appointmentType}</td>
          <td>${appointment.status}</td>
          <td>
            <a href="<c:url value='/appointments/edit?id=${appointment.appointmentId}'/>" class="btn btn-sm btn-primary">Edit</a>
            <a href="<c:url value='/appointments/delete?id=${appointment.appointmentId}'/>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">Delete</a>
            <a href="<c:url value='/appointments/details?id=${appointment.appointmentId}'/>" class="btn btn-sm btn-info">Details</a>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</main>
</body>
</html>