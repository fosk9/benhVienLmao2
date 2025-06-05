package controller;

import view.AppointmentDAO;
import model.Appointment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.logging.Logger;

@WebServlet("/book-appointment")
public class BookAppointmentServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(BookAppointmentServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        if (type != null) {
            request.setAttribute("appointmentType", type);
        }
        request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("patientId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int patientId = (int) session.getAttribute("patientId");
        String appointmentTypeIdStr = request.getParameter("appointmentTypeSelect");
        String doctorIdStr = request.getParameter("doctorId");
        String appointmentDateStr = request.getParameter("appointmentDate");
        String timeSlot = request.getParameter("timeSlot");

        try {
            if (appointmentTypeIdStr == null || appointmentTypeIdStr.isEmpty()) {
                throw new IllegalArgumentException("Appointment type is required");
            }
            int appointmentTypeId = Integer.parseInt(appointmentTypeIdStr);

            if (doctorIdStr == null || doctorIdStr.isEmpty()) {
                throw new IllegalArgumentException("Doctor is required");
            }
            int doctorId = Integer.parseInt(doctorIdStr);

            if (appointmentDateStr == null || appointmentDateStr.isEmpty()) {
                throw new IllegalArgumentException("Appointment date is required");
            }
            LocalDate localDate;
            try {
                localDate = LocalDate.parse(appointmentDateStr);
            } catch (DateTimeParseException e) {
                throw new IllegalArgumentException("Invalid date format");
            }
            Date appointmentDate = Date.valueOf(localDate);

            if (timeSlot == null || timeSlot.isEmpty()) {
                throw new IllegalArgumentException("Time slot is required");
            }

            Timestamp now = new Timestamp(System.currentTimeMillis());

            Appointment appointment = Appointment.builder()
                    .patientId(patientId)
                    .doctorId(doctorId)
                    .appointmentTypeId(appointmentTypeId)
                    .appointmentDate(appointmentDate)
                    .timeSlot(timeSlot)
                    .status("Pending")
                    .createdAt(now)
                    .updatedAt(now)
                    .build();

            AppointmentDAO appointmentDAO = new AppointmentDAO();
            int result = appointmentDAO.insert(appointment);
            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/appointments");
            } else {
                throw new Exception("Failed to insert appointment");
            }
        } catch (IllegalArgumentException e) {
            LOGGER.warning("Invalid input: " + e.getMessage());
            request.setAttribute("errorMsg", e.getMessage());
            request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing appointment: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/error");
        }
    }
}
