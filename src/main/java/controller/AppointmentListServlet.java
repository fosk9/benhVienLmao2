package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.HeaderController;
import view.AppointmentTypeDAO;
import model.AppointmentType;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

/**
 * Servlet to handle the appointment types list page.
 * Fetches all AppointmentType records and forwards to appointment-list.jsp.
 */
@WebServlet("/appointment/list")
public class AppointmentListServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AppointmentListServlet.class.getName());

    /**
     * Handles GET requests to display the appointment types list.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Initialize DAO to fetch appointment types
        AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();
        try {
            // Fetch all appointment types from the database
            List<AppointmentType> appointmentTypes = appointmentTypeDAO.select();
            LOGGER.info("Fetched " + appointmentTypes.size() + " appointment types");

            // Set appointment types as request attribute
            request.setAttribute("appointmentTypes", appointmentTypes);

            // Set navigation items for the header
//            HeaderController headerController = new HeaderController();
//            request.setAttribute("systemItems", headerController.getNavigationItems(5, "Navigation"));

            // Forward to appointment-list.jsp
            request.getRequestDispatcher("/Pact/appointment-list.jsp").forward(request, response);
        } catch (Exception e) {
            // Log error and redirect to error page
            LOGGER.severe("Error fetching appointment types: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/error");
        }
    }
}