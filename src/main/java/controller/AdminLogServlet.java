package controller;

import model.Log;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import view.LogDAO;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/admin/logs")
public class AdminLogServlet extends HttpServlet {
    private static final Logger logger = LogManager.getLogger(AdminLogServlet.class);
    private LogDAO logDAO;

    // Initialize LogDAO
    @Override
    public void init() throws ServletException {
        logDAO = new LogDAO();
        logger.info("LogServlet initialized");
    }

    // Handles GET requests to display logs or fetch new logs via AJAX
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get pagination parameters
            int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
            int limit = 10;
            int offset = (page - 1) * limit;

            // Get filter parameters
            String username = request.getParameter("username");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String sortOrder = request.getParameter("sortOrder");
            String roleName = request.getParameter("roleName");
            String logLevel = request.getParameter("logLevel");

            // Log request
            logger.info("Processing log request: page={}, username={}, startDate={}, endDate={}, sortOrder={}, roleName={}, logLevel={}",
                    page, username, startDate, endDate, sortOrder, roleName, logLevel);

            // Handle AJAX request for new logs
            if ("true".equals(request.getParameter("ajax"))) {
                int latestLogId = Integer.parseInt(request.getParameter("latestLogId"));
                List<Log> newLogs = logDAO.getLogs(0, 10, username, startDate, endDate, sortOrder, roleName, logLevel)
                        .stream()
                        .filter(log -> log.getLogId() > latestLogId)
                        .collect(Collectors.toList());
                response.setContentType("application/json");
                response.getWriter().write(new Gson().toJson(newLogs));
                logger.debug("Fetched {} new logs via AJAX", newLogs.size());
                return;
            }

            // Fetch logs and total count
            List<Log> logs = logDAO.getLogs(offset, 10, username, startDate, endDate, sortOrder, roleName, logLevel);
            int totalLogs = logDAO.countLogs(username, startDate, endDate, roleName, logLevel);
            int totalPages = (int) Math.ceil((double) totalLogs / limit);

            // Set attributes for JSP
            request.setAttribute("logs", logs);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("username", username);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("sortOrder", sortOrder);
            request.setAttribute("roleName", roleName);
            request.setAttribute("logLevel", logLevel);
            request.setAttribute("latestLogId", logDAO.getLatestLogId());

            // Forward to logList.jsp
            request.getRequestDispatcher("/admin/logs/logList.jsp").forward(request, response);
            logger.debug("Forwarded to logList.jsp with {} logs", logs.size());
        } catch (SQLException e) {
            logger.error("Error fetching logs", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching logs");
        }
    }
}
