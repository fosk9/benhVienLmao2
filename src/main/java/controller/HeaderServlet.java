package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Employee;
import model.SystemItem;
import view.SystemItemDAO;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet to provide dynamic header data (navigation items, home URL, etc.) as JSON.
 * This allows header.js to build the navbar based on the user's role.
 */
@WebServlet("/header-data")
public class HeaderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Avoid creating a new session
        String loginAs = (session != null) ? (String) session.getAttribute("login-as") : null;
        int roleId;
        boolean isLoggedIn;

        // Determine roleId based on login status and login-as attribute
        if (session == null || loginAs == null || loginAs.isEmpty()) {
            roleId = 6; // Default to Guest role if not logged in or login-as is invalid
            isLoggedIn = false;
        } else {
            if ("patient".equalsIgnoreCase(loginAs)) {
                roleId = 5; // Patient role
                isLoggedIn = session.getAttribute("patientId") != null; // Verify patient login
            } else if ("employee".equalsIgnoreCase(loginAs)) {
                Employee employee = (Employee) session.getAttribute("account");
                roleId = (employee != null && employee.getRoleId() > 0) ? employee.getRoleId() : 6; // Fallback to Guest if invalid
                isLoggedIn = employee != null && employee.getRoleId() > 0;
            } else {
                roleId = 6; // Fallback to Guest for any unexpected login-as value
                isLoggedIn = false;
            }
        }

        // Fetch navigation items for the determined role
        SystemItemDAO dao = new SystemItemDAO();
        List<SystemItem> items = dao.getActiveItemsByRoleAndType(roleId, "Navigation");
        if (items == null) {
            items = dao.getActiveItemsByRoleAndType(6, "Navigation"); // Fallback to Guest navigation items if null
        }

        // Set home URL based on roleId
        String homeUrl;
        switch (roleId) {
            case 1: // Doctor
                homeUrl = "/doctor-home";
                break;
            case 2: // Receptionist
                homeUrl = "/receptionist-dashboard";
                break;
            case 3: // Admin
                homeUrl = "/admin/home";
                break;
            case 4: // Manager
                homeUrl = "/manager-dashboard";
                break;
            case 5: // Patient
                homeUrl = "/pactHome";
                break;
            default: // Guest
                homeUrl = "/index";
                break;
        }

        // Prepare response data
        Map<String, Object> data = new HashMap<>();
        data.put("homeUrl", request.getContextPath() + homeUrl);
        data.put("items", items);
        data.put("roleId", roleId);
        data.put("isLoggedIn", isLoggedIn);

        // Send JSON response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        out.print(gson.toJson(data));
        out.flush();
    }
}