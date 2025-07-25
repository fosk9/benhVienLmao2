package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Appointment;
import model.Patient;
import dal.AppointmentDAO;
import dal.AppointmentTypeDAO;
import dal.PatientDAO;
import model.AppointmentType;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.Random;

@WebServlet("/book-appointment")
public class BookAppointmentServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(BookAppointmentServlet.class.getName());

    // Retrieve price for an appointment type by ID
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
        AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();
        List<AppointmentType> appointmentTypes = appointmentTypeDAO.select();
        if (appointmentTypes.isEmpty()) {
            LOGGER.severe("No appointment types available");
            request.setAttribute("errorMsg", "No appointment types available. Please contact support.");
            request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
            return;
        }
        request.setAttribute("appointmentTypes", appointmentTypes);

        // Handle appointmentTypeId from query parameter (e.g., from appointment-list.jsp)
        String appointmentTypeIdParam = request.getParameter("appointmentTypeId");
        if (appointmentTypeIdParam != null) {
            try {
                int appointmentTypeId = Integer.parseInt(appointmentTypeIdParam);
                AppointmentType selectedType = appointmentTypeDAO.select(appointmentTypeId);
                if (selectedType != null) {
                    Map<String, Object> formData = new HashMap<>();
                    formData.put("appointmentTypeId", appointmentTypeId);
                    formData.put("typeName", selectedType.getTypeName());
                    formData.put("typeDescription", selectedType.getDescription());
                    formData.put("finalPrice", selectedType.getPrice() != null ? selectedType.getPrice().toString() : "0");
                    formData.put("requiresSpecialist", false); // Default to false
                    request.setAttribute("formData", formData);
                }
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid appointmentTypeId: " + appointmentTypeIdParam);
            }
        }

        // Restore form data if available from session
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("appointmentFormData") != null) {
            Map<String, Object> formData = (Map<String, Object>) session.getAttribute("appointmentFormData");
            // Set finalPrice to base price (no specialist multiplier)
            try {
                int appointmentTypeId = Integer.parseInt((String) formData.get("appointmentTypeId"));
                BigDecimal price = getPriceByTypeId(appointmentTypes, appointmentTypeId);
                formData.put("finalPrice", price != null ? price.toString() : "0");
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid appointmentTypeId in session formData: " + formData.get("appointmentTypeId"));
                formData.put("finalPrice", "0");
            }
            request.setAttribute("formData", formData);
        }

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
            String email = request.getParameter("email");
            int appointmentTypeId = Integer.parseInt(request.getParameter("appointmentTypeId"));
            String typeName = request.getParameter("typeName");
            String appointmentDateStr = request.getParameter("appointmentDate");
            String timeSlot = request.getParameter("timeSlot");
            boolean requiresSpecialist = "on".equals(request.getParameter("requiresSpecialist"));
            String finalPriceStr = request.getParameter("finalPrice");

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

            BigDecimal price = getPriceByTypeId(appointmentTypes, appointmentTypeId);
            if (price == null) {
                throw new IllegalArgumentException("Invalid appointment type or price not found");
            }

            // Use base price without specialist multiplier
            BigDecimal serverPrice = price;

            if (clientFinalPrice != null && serverPrice.compareTo(clientFinalPrice) != 0) {
                LOGGER.warning("Client price mismatch: client=" + clientFinalPrice + ", server=" + serverPrice);
                clientFinalPrice = serverPrice;
            }

            Integer patientId = (Integer) session.getAttribute("patientId");
            PatientDAO patientDAO = new PatientDAO();

            if (patientId == null) {
                if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
                    throw new IllegalArgumentException("Invalid email format");
                }

                Patient patient = patientDAO.getPatientByEmail(email);
                if (patient == null) {
                    Map<String, Object> formData = new HashMap<>();
                    formData.put("email", email);
                    formData.put("appointmentTypeId", String.valueOf(appointmentTypeId));
                    formData.put("typeName", typeName);
                    formData.put("appointmentDate", appointmentDateStr);
                    formData.put("timeSlot", timeSlot);
                    formData.put("requiresSpecialist", requiresSpecialist);
                    formData.put("finalPrice", serverPrice.toString());
                    AppointmentType selectedType = appointmentTypes.stream()
                            .filter(type -> type.getAppointmentTypeId() == appointmentTypeId)
                            .findFirst()
                            .orElse(null);
                    formData.put("typeDescription", selectedType != null ? selectedType.getDescription() : "");

                    // Generate unique username
                    String baseUsername = email.substring(0, email.indexOf('@'));
                    String username = baseUsername;
                    int count = 1;
                    while (patientDAO.isUsernameTaken(username)) {
                        username = baseUsername + count++;
                    }

                    // Generate random password (plain text for simplicity, assume no hash)
                    String rawPass = generateRandomPassword(8);

                    // Create tempPatient
                    Patient tempPatient = Patient.builder()
                            .username(username)
                            .passwordHash(rawPass) // Assuming plain text storage
                            .fullName("") // Default empty
                            .email(email)
                            .accStatus(1)
                            .build();

                    session.setAttribute("tempPatient", tempPatient);
                    session.setAttribute("generatedPassword", rawPass);
                    session.setAttribute("appointmentFormData", formData);

                    // Generate OTP
                    String otp = String.format("%06d", new Random().nextInt(999999));
                    session.setAttribute("otp", otp);
                    session.setAttribute("otpGeneratedTime", System.currentTimeMillis());

                    // Send OTP email
                    new SendingEmail().sendEmail(email, "OTP for Registration", "Dear user,\n\nYour OTP for registration is: " + otp + ".\nIt expires in 5 minutes.\n\nBest regards,\nHospital Team");

                    response.sendRedirect("otp-verification.jsp");
                    return;
                } else {
                    patientId = patient.getPatientId();
                    session.setAttribute("bookingEmail", email);
                }
            }

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

            AppointmentDAO appointmentDAO = new AppointmentDAO();
            int appointmentId = appointmentDAO.insertAndReturnID(appointment);
            LOGGER.info("Successfully inserted appointment for patientId=" + patientId + ", appointmentId=" + appointmentId);

            response.sendRedirect(request.getContextPath() + "/appointments/details?id=" + appointmentId);
        } catch (IllegalArgumentException e) {
            LOGGER.warning("Invalid input: " + e.getMessage());
            request.setAttribute("errorMsg", e.getMessage());
            request.setAttribute("appointmentTypes", appointmentTypes);
            Map<String, Object> formData = new HashMap<>();
            formData.put("email", request.getParameter("email"));
            String appointmentTypeIdStr = request.getParameter("appointmentTypeId");
            formData.put("appointmentTypeId", appointmentTypeIdStr);
            formData.put("typeName", request.getParameter("typeName"));
            formData.put("appointmentDate", request.getParameter("appointmentDate"));
            formData.put("timeSlot", request.getParameter("timeSlot"));
            boolean requiresSpecialist = "on".equals(request.getParameter("requiresSpecialist"));
            formData.put("requiresSpecialist", requiresSpecialist);
            // Set finalPrice to base price (no specialist multiplier)
            try {
                int appointmentTypeId = Integer.parseInt(appointmentTypeIdStr);
                BigDecimal price = getPriceByTypeId(appointmentTypes, appointmentTypeId);
                formData.put("finalPrice", price != null ? price.toString() : "0");
                AppointmentType selectedType = appointmentTypes.stream()
                        .filter(type -> type.getAppointmentTypeId() == appointmentTypeId)
                        .findFirst()
                        .orElse(null);
                formData.put("typeDescription", selectedType != null ? selectedType.getDescription() : "");
            } catch (NumberFormatException ex) {
                LOGGER.warning("Invalid appointmentTypeId in formData: " + appointmentTypeIdStr);
                formData.put("finalPrice", "0");
                formData.put("typeDescription", "");
            }
            request.setAttribute("formData", formData);
            request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
        } catch (RuntimeException e) {
            LOGGER.severe("Error processing appointment: " + e.getMessage());
            request.setAttribute("errorMsg", "Unable to save appointment: " + e.getMessage());
            request.setAttribute("appointmentTypes", appointmentTypes);
            Map<String, Object> formData = (Map<String, Object>) session.getAttribute("appointmentFormData");
            if (formData != null) {
                // Set finalPrice to base price (no specialist multiplier)
                try {
                    int appointmentTypeId = Integer.parseInt((String) formData.get("appointmentTypeId"));
                    BigDecimal price = getPriceByTypeId(appointmentTypes, appointmentTypeId);
                    formData.put("finalPrice", price != null ? price.toString() : "0");
                } catch (NumberFormatException ex) {
                    LOGGER.warning("Invalid appointmentTypeId in session formData: " + formData.get("appointmentTypeId"));
                    formData.put("finalPrice", "0");
                }
                request.setAttribute("formData", formData);
            }
            request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error");
        }
    }

    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        Random rnd = new Random();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }
}