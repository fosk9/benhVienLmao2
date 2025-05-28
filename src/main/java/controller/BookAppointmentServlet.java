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
import java.sql.Timestamp;
import java.util.logging.Logger;

@WebServlet("/book-appointment")
public class BookAppointmentServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(BookAppointmentServlet.class.getName());
    private static final int MAX_TYPE_LENGTH = 100; // Maximum length for custom appointment type

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
        // Prioritize custom input if provided
        String appointmentType = request.getParameter("customAppointmentType");
        if (appointmentType == null || appointmentType.trim().isEmpty()) {
            appointmentType = request.getParameter("appointmentTypeSelect");
        }

        String appointmentDateTimeStr = request.getParameter("appointmentDateTime");

        try {
            // Validate inputs
            if (appointmentType == null || appointmentType.trim().isEmpty()) {
                throw new IllegalArgumentException("Appointment type is required");
            }
            if (appointmentType.length() > MAX_TYPE_LENGTH) {
                throw new IllegalArgumentException("Appointment type is too long");
            }
            if (appointmentDateTimeStr == null || appointmentDateTimeStr.isEmpty()) {
                throw new IllegalArgumentException("Date and time are required");
            }

            // Format timestamp
            String tsStr = appointmentDateTimeStr.contains("T") ? appointmentDateTimeStr.replace("T", " ") + ":00" : appointmentDateTimeStr;
            Timestamp appointmentDateTime = Timestamp.valueOf(tsStr);
            Timestamp now = new Timestamp(System.currentTimeMillis());

            // Prevent past bookings
            if (appointmentDateTime.before(now)) {
                request.setAttribute("errorMsg", "Invalid appointment time: Cannot book in the past.");
                request.setAttribute("appointmentType", appointmentType);
                request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
                return;
            }

            Appointment appointment = Appointment.builder()
                    .patientId(patientId)
                    .appointmentType(appointmentType.trim())
                    .appointmentDate(appointmentDateTime)
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
            request.setAttribute("appointmentType", appointmentType);
            request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing appointment: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/error");
        }
    }
}