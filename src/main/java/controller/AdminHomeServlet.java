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
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * Servlet for rendering the admin dashboard.
 */
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
            LOGGER.warning("User not logged in");
            return;
        }

        // Get account object from session
        Object accountObj = session.getAttribute("account");
        Integer roleId = null;
        String fullName = "Admin";
        if (accountObj instanceof model.Employee) {
            model.Employee employee = (model.Employee) accountObj;
            roleId = employee.getRoleId();
            fullName = employee.getFullName();
        }

        if (roleId == null || roleId != 3) { // Admin role_id = 3
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        // Fetch admin features for the user's role
        List<SystemItem> adminFeatures = new ArrayList<>();
        try {
            adminFeatures = systemItemDAO.getActiveItemsByRoleAndType(roleId, "Feature");
            LOGGER.info("Fetched " + adminFeatures.size() + " admin features for role " + roleId);
        } catch (Exception e) {
            LOGGER.severe("Error fetching admin features: " + e.getMessage());
        }

        // Determine the current page
        String currentPage = request.getParameter("page");
        if (currentPage == null && !adminFeatures.isEmpty()) {
            currentPage = adminFeatures.get(0).getItemUrl();
        }

        // Set attributes
        request.setAttribute("adminFeatures", adminFeatures);
        request.setAttribute("fullName", fullName);
        request.setAttribute("currentPage", currentPage);

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