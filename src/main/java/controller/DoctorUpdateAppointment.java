package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Appointment;
import model.AppointmentType;
import model.Employee;
import validation.DoctorValidator;
import view.AppointmentDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/update-appointment")
public class DoctorUpdateAppointment extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Employee doctor = (session != null) ? (Employee) session.getAttribute("account") : null;

        if (doctor == null || doctor.getRoleId() != 1) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String appointmentIdParam = request.getParameter("appointmentId") != null
                    ? request.getParameter("appointmentId")
                    : request.getParameter("id");
            int appointmentId = Integer.parseInt(appointmentIdParam);

            AppointmentDAO dao = new AppointmentDAO();
            Appointment appointment = dao.getAppointmentDetailById(appointmentId);
            List<AppointmentType> appointmentTypes = dao.getAllAppointmentTypes();

            if (appointment == null) {
                response.sendRedirect("error.jsp");
                return;
            }

            int selectedTypeId = appointment.getAppointmentType().getAppointmentTypeId();
            String typeDescription = "";
            for (AppointmentType type : appointmentTypes) {
                if (type.getAppointmentTypeId() == selectedTypeId) {
                    typeDescription = type.getDescription();
                    break;
                }
            }

            request.setAttribute("appointment", appointment);
            request.setAttribute("appointmentTypes", appointmentTypes);
            request.setAttribute("selectedTypeId", selectedTypeId);
            request.setAttribute("typeDescription", typeDescription);

            request.getRequestDispatcher("doctor-update-appointment.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Employee doctor = (session != null) ? (Employee) session.getAttribute("account") : null;

        if (doctor == null || doctor.getRoleId() != 1) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String fullName = DoctorValidator.cleanInput(request.getParameter("fullName"));
            String dob = request.getParameter("dob");
            String gender = request.getParameter("gender");
            String phone = DoctorValidator.cleanInput(request.getParameter("phone"));
            String address = DoctorValidator.cleanInput(request.getParameter("address"));
            String insuranceNumber = DoctorValidator.cleanInput(request.getParameter("insuranceNumber"));
            String emergencyContact = DoctorValidator.cleanInput(request.getParameter("emergencyContact"));
            String status = request.getParameter("status");
            String appointmentDate = request.getParameter("appointmentDate");
            int appointmentTypeId = Integer.parseInt(request.getParameter("appointmentTypeId"));

            AppointmentDAO dao = new AppointmentDAO();
            Appointment appointment = dao.getAppointmentDetailById(appointmentId);
            List<AppointmentType> appointmentTypes = dao.getAllAppointmentTypes();

            // Lấy đúng typeDescription từ appointmentTypes
            String typeDescription = "";
            for (AppointmentType type : appointmentTypes) {
                if (type.getAppointmentTypeId() == appointmentTypeId) {
                    typeDescription = type.getDescription();
                    break;
                }
            }

            String errorMessage = null;
            if (!DoctorValidator.isValidFullName(fullName)) {
                errorMessage = "Invalid full name!";
            } else if (!DoctorValidator.isValidPhoneNumber(phone)) {
                errorMessage = "Invalid phone number!";
            } else if (!DoctorValidator.isValidInsuranceNumber(insuranceNumber)) {
                errorMessage = "Invalid insurance number!";
            }

            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                request.setAttribute("appointment", appointment);
                request.setAttribute("appointmentTypes", appointmentTypes);
                request.setAttribute("selectedTypeId", appointmentTypeId);
                request.setAttribute("typeDescription", typeDescription);

                request.setAttribute("fullName", fullName);
                request.setAttribute("dob", dob);
                request.setAttribute("gender", gender);
                request.setAttribute("phone", phone);
                request.setAttribute("address", address);
                request.setAttribute("insuranceNumber", insuranceNumber);
                request.setAttribute("emergencyContact", emergencyContact);
                request.setAttribute("status", status);
                request.setAttribute("appointmentDate", appointmentDate);

                request.getRequestDispatcher("doctor-update-appointment.jsp").forward(request, response);
                return;
            }

            boolean updated = dao.updateAppointmentByDoctor(
                    appointmentId, fullName, dob, gender, phone, address,
                    insuranceNumber, emergencyContact, status, appointmentDate,
                    appointmentTypeId, typeDescription
            );

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/view-detail?id=" + appointmentId);
            } else {
                response.sendRedirect("error.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
