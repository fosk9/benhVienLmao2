package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.AppointmentType;
import view.AppointmentTypeDAO;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet("/services")
public class ServiceListServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ServiceListServlet.class.getName());
    private final AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("search");
        List<AppointmentType> services;

        try {
            // Fetch all appointment types
            services = appointmentTypeDAO.select();

            // Apply search filter if query is provided
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                searchQuery = searchQuery.trim().toLowerCase();
                final String finalQuery = searchQuery;
                services = services.stream()
                        .filter(type -> type.getTypeName().toLowerCase().contains(finalQuery))
                        .collect(Collectors.toList());
                LOGGER.info("Filtered services with query: " + searchQuery + ", found " + services.size() + " results");
            }

            request.setAttribute("services", services);
            request.setAttribute("searchQuery", searchQuery);

            // Forward to index.jsp (or a specific services JSP if separated)
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error fetching services: " + e.getMessage());
            request.setAttribute("errorMsg", "Unable to load services: " + e.getMessage());
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}