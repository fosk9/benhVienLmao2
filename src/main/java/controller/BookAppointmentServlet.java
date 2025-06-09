package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Appointment;
import model.Patient;
import view.AppointmentDAO;
import view.AppointmentTypeDAO;
import view.PatientDAO;
import model.AppointmentType;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet("/book-appointment")
public class BookAppointmentServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(BookAppointmentServlet.class.getName());

    // Lookup method to find price by appointmentTypeId
    private BigDecimal getPriceByTypeId(List<AppointmentType> types, int appointmentTypeId) {
        if (types == null || types.isEmpty()) {
            LOGGER.warning("Appointment types list is null or empty");
            return null;
        }
        for (AppointmentType type : types) {
            if (type.getAppointmentTypeId() == appointmentTypeId) {
                BigDecimal price = type.getPrice();
                if (price == null) {
                    LOGGER.warning("Null price for appointmentTypeId=" + appointmentTypeId);
                } else {
                    LOGGER.info("Found price=" + price + " for appointmentTypeId=" + appointmentTypeId);
                }
                return price;
            }
        }
        LOGGER.warning("No price found for appointmentTypeId=" + appointmentTypeId);
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Load all appointment types

        AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();
        List<AppointmentType> appointmentTypes = appointmentTypeDAO.select();
        if (appointmentTypes.isEmpty()) {
            LOGGER.severe("No appointment types available");
            request.setAttribute("errorMsg", "No appointment types available. Please contact support.");
            request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
            return;
        }
        request.setAttribute("appointmentTypes", appointmentTypes);

        // Restore form data if available
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("appointmentFormData") != null) {
            request.setAttribute("formData", session.getAttribute("appointmentFormData"));
        }

        // Forward to JSP
        request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();
        List<AppointmentType> appointmentTypes = appointmentTypeDAO.select();
        if (appointmentTypes.isEmpty()) {
            LOGGER.severe("No appointment types available");
            request.setAttribute("errorMsg", "No appointment types available. Please contact support.");
            request.setAttribute("appointmentTypes", appointmentTypes);
            request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
            return;
        }

        try {
            // Retrieve form parameters
            String email = request.getParameter("email");
            int appointmentTypeId = Integer.parseInt(request.getParameter("appointmentTypeId"));
            String typeName = request.getParameter("typeName");
            String appointmentDateStr = request.getParameter("appointmentDate");
            String timeSlot = request.getParameter("timeSlot");
            boolean requiresSpecialist = "on".equals(request.getParameter("requiresSpecialist"));
            String finalPriceStr = request.getParameter("finalPrice");

            // Retrieve client-side final price
            BigDecimal clientFinalPrice = null;
            if (finalPriceStr != null && !finalPriceStr.isEmpty()) {
                try {
                    clientFinalPrice = new BigDecimal(finalPriceStr);
                } catch (NumberFormatException ex) {
                    LOGGER.warning("Invalid client final price: " + finalPriceStr);
                    clientFinalPrice = null;
                }
            }

            LOGGER.info("Received form data: email=" + email + ", appointmentTypeId=" + appointmentTypeId + ", typeName=" + typeName +
                    ", appointmentDate=" + appointmentDateStr + ", timeSlot=" + timeSlot +
                    ", requiresSpecialist=" + requiresSpecialist + ", clientFinalPrice=" + clientFinalPrice);

            // Validate inputs
            if (appointmentDateStr == null || appointmentDateStr.isEmpty()) {
                throw new IllegalArgumentException("Appointment date is required");
            }
            Date appointmentDate = Date.valueOf(appointmentDateStr);

            if (timeSlot == null || timeSlot.isEmpty()) {
                throw new IllegalArgumentException("Time slot is required");
            }

            if (!List.of("Morning", "Afternoon", "Evening").contains(timeSlot)) {
                throw new IllegalArgumentException("Invalid time slot");
            }

            // Get price using lookup method
            BigDecimal price = getPriceByTypeId(appointmentTypes, appointmentTypeId);
            if (price == null) {
                throw new IllegalArgumentException("Invalid appointment type or price not found");
            }

            // Calculate final price with specialist multiplier
            BigDecimal serverPrice = price;
            if (requiresSpecialist) {
                serverPrice = price.multiply(new BigDecimal("1.5"));
            }

            // Validate client-side price against server-side calculation
            if (clientFinalPrice != null && serverPrice.compareTo(clientFinalPrice) != 0) {
                LOGGER.warning("Client price mismatch: client=" + clientFinalPrice + ", server=" + serverPrice);
                clientFinalPrice = serverPrice; // Use server-calculated price
            }

            // Check if user is logged in
            Integer patientId = (Integer) session.getAttribute("patientId");
            PatientDAO patientDAO = new PatientDAO();

            if (patientId == null) {
                // Non-logged-in user: validate email
                if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
                    throw new IllegalArgumentException("Invalid email format");
                }


                // Check if email exists
                Patient patient = patientDAO.getPatientByEmail(email);
                if (patient == null) {
                    // Email not found: store form data and redirect to register
                    Map<String, Object> formData = new HashMap<>();
                    formData.put("email", email);
                    formData.put("appointmentTypeId", appointmentTypeId);
                    formData.put("typeName", typeName);
                    formData.put("appointmentDate", appointmentDateStr);
                    formData.put("timeSlot", timeSlot);
                    formData.put("requiresSpecialist", requiresSpecialist);
                    formData.put("finalPrice", serverPrice.toString());
                    // Find type description
                    AppointmentType selectedType = appointmentTypes.stream()
                            .filter(type -> type.getAppointmentTypeId() == appointmentTypeId)
                            .findFirst()
                            .orElse(null);
                    formData.put("typeDescription", selectedType != null ? selectedType.getDescription() : "");

                    session.setAttribute("appointmentFormData", formData);
                    response.sendRedirect(request.getContextPath() + "/register");
                    return;
                } else {
                    // Email exists: use patient ID
                    patientId = patient.getPatientId();
                    session.setAttribute("bookingEmail", email);
                }
            }

            // Create appointment
            Appointment appointment = Appointment.builder()
                    .patientId(patientId)
                    .appointmentTypeId(appointmentTypeId)
                    .appointmentDate(appointmentDate)
                    .timeSlot(timeSlot)
                    .requiresSpecialist(requiresSpecialist)
                    .status("Unpay")
                    .createdAt(new Timestamp(System.currentTimeMillis()))
                    .updatedAt(new Timestamp(System.currentTimeMillis()))
                    .build();

            // Save to database
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            int appointmentId = appointmentDAO.insertAndReturnID(appointment);
            LOGGER.info("Successfully inserted appointment for patientId=" + patientId + ", appointmentId=" + appointmentId);

            // Redirect to appointment details
            response.sendRedirect(request.getContextPath() + "/appointments/details?id=" + appointmentId);
        } catch (IllegalArgumentException e) {
            LOGGER.warning("Invalid input: " + e.getMessage());
            request.setAttribute("errorMsg", e.getMessage());

            // Reload appointment types
            request.setAttribute("appointmentTypes", appointmentTypes);

            // Send back form data for redisplay
            Map<String, Object> formData = new HashMap<>();
            formData.put("email", request.getParameter("email"));
            formData.put("appointmentTypeId", request.getParameter("appointmentTypeId"));
            formData.put("typeName", request.getParameter("typeName"));
            formData.put("appointmentDate", request.getParameter("appointmentDate"));
            formData.put("timeSlot", request.getParameter("timeSlot"));
            formData.put("requiresSpecialist", "on".equals(request.getParameter("requiresSpecialist")));
            formData.put("finalPrice", request.getParameter("finalPrice"));
            request.setAttribute("formData", formData);

            request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
        } catch (RuntimeException e) {
            LOGGER.severe("Error processing appointment: " + e.getMessage());
            request.setAttribute("errorMsg", "Unable to save appointment: " + e.getMessage());
            request.setAttribute("appointmentTypes", appointmentTypes);
            request.setAttribute("formData", session.getAttribute("appointmentFormData"));
            request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error");
        }
    }
}