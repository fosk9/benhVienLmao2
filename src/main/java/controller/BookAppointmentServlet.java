package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Appointment;
import view.AppointmentDAO;
import view.AppointmentTypeDAO;
import model.AppointmentType;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("patientId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

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

        // Forward to JSP
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
            int appointmentTypeId = Integer.parseInt(request.getParameter("appointmentTypeId"));
            String typeName = request.getParameter("typeName");
            String appointmentDateStr = request.getParameter("appointmentDate");
            String timeSlot = request.getParameter("timeSlot");
            boolean requiresSpecialist = "on".equals(request.getParameter("requiresSpecialist"));

            // Retrieve client-side final price
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

            LOGGER.info("Received form data: appointmentTypeId=" + appointmentTypeId + ", typeName=" + typeName +
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

            // Validate time slot
            if (!List.of("Morning", "Afternoon", "Evening").contains(timeSlot)) {
                throw new IllegalArgumentException("Invalid time slot");
            }

            // Get price using lookup method
            BigDecimal price = getPriceByTypeId(appointmentTypes, appointmentTypeId);
            if (price == null) {
                throw new IllegalArgumentException("Invalid appointment type or price not found");
            }

            // Calculate final price with specialist multiplier
            if (requiresSpecialist) {
                price = price.multiply(new BigDecimal("1.5"));
            }

            // Validate client-side price against server-side calculation
            if (clientFinalPrice != null && price.compareTo(clientFinalPrice) != 0) {
                LOGGER.warning("Client price mismatch: client=" + clientFinalPrice + ", server=" + price);
                clientFinalPrice = price; // Use server-calculated price
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
            int rowsAffected = appointmentDAO.insert(appointment);
            LOGGER.info("Successfully inserted appointment for patientId=" + patientId);

            // Redirect to appointments list
            response.sendRedirect(request.getContextPath() + "/appointments");
        } catch (IllegalArgumentException e) {
            LOGGER.warning("Invalid input: " + e.getMessage());
            request.setAttribute("errorMsg", e.getMessage());

            // Reload appointment types
            request.setAttribute("appointmentTypes", appointmentTypes);

            // Send back form data for redisplay
            String appointmentTypeIdStr = request.getParameter("appointmentTypeId");
            request.setAttribute("selectedTypeId", appointmentTypeIdStr);
            request.setAttribute("requiresSpecialist", "on".equals(request.getParameter("requiresSpecialist")));

            // Calculate and send server-side price
            if (appointmentTypeIdStr != null) {
                try {
                    int appointmentTypeId = Integer.parseInt(appointmentTypeIdStr);
                    BigDecimal price = getPriceByTypeId(appointmentTypes, appointmentTypeId);
                    if (price != null) {
                        if ("on".equals(request.getParameter("requiresSpecialist"))) {
                            price = price.multiply(new BigDecimal("1.5"));
                        }
                        request.setAttribute("finalPrice", price.toString());
                    } else {
                        request.setAttribute("finalPrice", "0");
                    }
                } catch (NumberFormatException ex) {
                    LOGGER.warning("Invalid appointmentTypeId: " + appointmentTypeIdStr);
                    request.setAttribute("finalPrice", "0");
                }
            } else {
                request.setAttribute("finalPrice", "0");
            }

            request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
        } catch (RuntimeException e) {
            LOGGER.severe("Error processing appointment: " + e.getMessage());
            request.setAttribute("errorMsg", "Unable to save appointment: " + e.getMessage());
            request.setAttribute("appointmentTypes", appointmentTypes);
            request.setAttribute("selectedTypeId", request.getParameter("appointmentTypeId"));
            request.setAttribute("requiresSpecialist", "on".equals(request.getParameter("requiresSpecialist")));
            request.setAttribute("finalPrice", request.getParameter("finalPrice"));
            request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error");
        }
    }
}