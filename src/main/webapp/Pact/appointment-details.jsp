<%--
  Created by IntelliJ IDEA.
  User: Fosk Jesky
  Date: 5/26/2025
  Time: 4:14 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>Appointment Details</title>
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
            </div>
          </div>
          <div class="col-xl-10 col-lg-10 col-md-10">
            <div class="menu-main d-flex align-items-center justify-content-end">
              <div class="main-menu f-right d-none d-lg-block">
                <nav>
                  <ul id="navigation">
                    <li><a href="<c:url value='/home'/>">Home</a></li>
                    <li><a href="<c:url value='/appointments'/>">My Appointments</a></li>
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
    <h2>Appointment Details</h2>
    <p><strong>ID:</strong> ${appointment.appointmentId}</p>
    <p><strong>Date:</strong> ${appointment.appointmentDate}</p>
    <p><strong>Type:</strong> ${appointment.appointmentType}</p>
    <p><strong>Status:</strong> ${appointment.status}</p>
    <c:if test="${not empty doctor}">
      <h3>Doctor Information</h3>
      <p><strong>Name:</strong> ${doctor.fullName}</p>
      <p><strong>Email:</strong> ${doctor.email}</p>
      <p><strong>Phone:</strong> ${doctor.phone}</p>
    </c:if>
    <a href="<c:url value='/appointments'/>" class="btn btn-primary">Back to Appointments</a>
  </div>
</main>
</body>
</html>
