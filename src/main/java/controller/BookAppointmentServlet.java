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
        try {
            // Retrieve form parameters
            int appointmentTypeId = Integer.parseInt(request.getParameter("appointmentTypeId"));
            String typeName = request.getParameter("typeName"); // For logging
            String appointmentDateStr = request.getParameter("appointmentDate");
            String timeSlot = request.getParameter("timeSlot");
            boolean requiresSpecialist = "on".equals(request.getParameter("requiresSpecialist"));

            // Lấy giá tiền thực tế từ client gửi lên (đã tính toán ở client)
            String finalPriceStr = request.getParameter("finalPrice");
            BigDecimal clientFinalPrice = null;
            if (finalPriceStr != null && !finalPriceStr.isEmpty()) {
                try {
                    clientFinalPrice = new BigDecimal(finalPriceStr);
                } catch (NumberFormatException ex) {
                    clientFinalPrice = null;
                }
            }

            LOGGER.info("Received form data: appointmentTypeId=" + appointmentTypeId + ", typeName=" + typeName +
                    ", appointmentDate=" + appointmentDateStr + ", timeSlot=" + timeSlot +
                    ", requiresSpecialist=" + requiresSpecialist);

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

            // Get appointment type details
            AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();
            AppointmentType appointmentType = appointmentTypeDAO.select(appointmentTypeId);
            if (appointmentType == null) {
                throw new IllegalArgumentException("Invalid appointment type");
            }

            // Calculate price (apply 50% increase if specialist is required)
            BigDecimal price = appointmentType.getPrice();
            if (requiresSpecialist) {
                price = price.multiply(new BigDecimal("1.5"));
            }

            // Nếu clientFinalPrice khác với giá tính toán ở server, dùng giá server (tránh gian lận)
            if (clientFinalPrice == null || price.compareTo(clientFinalPrice) != 0) {
                clientFinalPrice = price;
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
            // Reload appointment types for the form
            AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();
            request.setAttribute("appointmentTypes", appointmentTypeDAO.select());
            // Truyền lại giá tiền nếu có lỗi
            request.setAttribute("finalPrice", request.getParameter("finalPrice"));
            request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
        } catch (RuntimeException e) {
            LOGGER.severe("Error processing appointment: " + e.getMessage());
            request.setAttribute("errorMsg", "Unable to save appointment: " + e.getMessage());
            AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();
            request.setAttribute("appointmentTypes", appointmentTypeDAO.select());
            request.setAttribute("finalPrice", request.getParameter("finalPrice"));
            request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error");
        }
    }
}
