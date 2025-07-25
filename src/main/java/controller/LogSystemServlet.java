
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.LogSystem;
import view.LogSystemDAO;

import java.io.IOException;
import java.util.List;

/**
 * Handles GET requests for /admin/logs, filtering logs based on query parameters.
 * Forwards results to logs.jsp for display.
 */
@WebServlet("/admin/logs")
public class LogSystemServlet extends HttpServlet {
    private final LogSystemDAO logDAO = new LogSystemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve query parameters
        String username = request.getParameter("username");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String role = request.getParameter("role");
        String logLevel = request.getParameter("logLevel");
        String sortOrder = request.getParameter("sortOrder");

        // Validate logLevel
        if (logLevel != null && !logLevel.isEmpty() && !List.of("INFO", "WARN", "ERROR", "DEBUG").contains(logLevel)) {
            request.setAttribute("error", "Invalid log level selected.");
            request.getRequestDispatcher("/admin/logs/logs.jsp").forward(request, response);
            return;
        }

        // Validate dates
        if (fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()) {
            try {
                java.time.LocalDate from = java.time.LocalDate.parse(fromDate);
                java.time.LocalDate to = java.time.LocalDate.parse(toDate);
                if (to.isBefore(from)) {
                    request.setAttribute("error", "To Date cannot be earlier than From Date.");
                    request.getRequestDispatcher("/admin/logs/logs.jsp").forward(request, response);
                    return;
                }
            } catch (java.time.format.DateTimeParseException e) {
                request.setAttribute("error", "Invalid date format.");
                request.getRequestDispatcher("/admin/logs/logs.jsp").forward(request, response);
                return;
            }
        }

        // Fetch filtered logs
        List<LogSystem> logs = logDAO.filter(
                username,
                fromDate,
                toDate,
                role,
                logLevel, // Will be null if 'All Levels' is selected
                sortOrder != null ? sortOrder : "Newest First"
        );

        // Set logs attribute and forward to JSP
        request.setAttribute("logs", logs);
        request.getRequestDispatcher("/admin/logs/logs.jsp").forward(request, response);
    }
}
