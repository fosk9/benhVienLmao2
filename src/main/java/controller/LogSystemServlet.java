package controller;

import view.LogSystemDAO;
import model.LogSystem;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/logs")
public class LogSystemServlet extends HttpServlet {

    LogSystemDAO logDAO = new LogSystemDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String role = request.getParameter("role");
        String logLevel = request.getParameter("logLevel");
        String sortOrder = request.getParameter("sortOrder");

        List<LogSystem> logs = logDAO.filter(username, fromDate, toDate, role, logLevel, sortOrder != null ? sortOrder : "Newest First");

        request.setAttribute("logs", logs);
        request.getRequestDispatcher("/admin/logs/logs.jsp").forward(request, response);
    }
}

