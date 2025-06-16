package controller;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.SystemItem;
import view.SystemItemDAO;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/admin/home")
public class AdminHomeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminHomeServlet.class.getName());
    private final SystemItemDAO systemItemDAO = new SystemItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            Logger.getLogger(AdminHomeServlet.class.getName()).warning("User not logged in");
            return;
        }

        // Lấy account object từ session
        Object accountObj = session.getAttribute("account");
        Integer roleId = null;
        String fullName = "Admin";
        if (accountObj != null && accountObj instanceof model.Employee) {
            model.Employee employee = (model.Employee) accountObj;
            roleId = employee.getRoleId();
            fullName = employee.getFullName();
        }

        if (roleId == null || (roleId != 3)) {
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        // Fetch admin features for the user’s role
        List<SystemItem> adminFeatures = new ArrayList<>();
        try {
            adminFeatures = systemItemDAO.getActiveItemsByRoleAndType(roleId, "Feature");
            LOGGER.info("Fetched " + adminFeatures.size() + " admin features for role " + roleId);
        } catch (SQLException e) {
            LOGGER.severe("Error fetching admin features: " + e.getMessage());
        }

        // Set attributes
        request.setAttribute("adminFeatures", adminFeatures);
        request.setAttribute("fullName", fullName);

        // Forward to admin-home.jsp
        LOGGER.info("Forwarding to admin-home.jsp");
        request.getRequestDispatcher("/admin/admin-home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}