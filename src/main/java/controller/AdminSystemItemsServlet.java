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
import java.util.List;
import java.util.logging.Logger;
import java.util.stream.Collectors;

/**
 * Servlet for managing SystemItems in the admin panel.
 */
@WebServlet("/admin/system-items")
public class AdminSystemItemsServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminSystemItemsServlet.class.getName());
    private final SystemItemDAO systemItemDAO = new SystemItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and has admin role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            LOGGER.warning("User not logged in");
            return;
        }

        Object accountObj = session.getAttribute("account");
        Integer roleId = null;
        if (accountObj instanceof model.Employee) {
            model.Employee employee = (model.Employee) accountObj;
            roleId = employee.getRoleId();
        }

        if (roleId == null || roleId != 3) { // Admin role_id = 3
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                request.getRequestDispatcher("/admin/system-items/add.jsp").forward(request, response);
                break;
            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                SystemItem item = systemItemDAO.select(id);
                request.setAttribute("item", item);
                request.getRequestDispatcher("/admin/system-items/edit.jsp").forward(request, response);
                break;
            case "delete":
                id = Integer.parseInt(request.getParameter("id"));
                int deleted = systemItemDAO.delete(id);
                if (deleted > 0) {
                    LOGGER.info("Successfully deleted SystemItem ID: " + id);
                } else {
                    LOGGER.warning("Failed to delete SystemItem ID: " + id);
                }
                response.sendRedirect(request.getContextPath() + "/admin/system-items");
                break;
            case "list":
            default:
                List<SystemItem> allItems = systemItemDAO.select();

                // Lọc theo search nếu có, xử lý khoảng trắng
                String searchName = request.getParameter("searchName");
                String searchUrl = request.getParameter("searchUrl");
                String searchType = request.getParameter("searchType");

                if (searchName != null) searchName = searchName.trim();
                if (searchUrl != null) searchUrl = searchUrl.trim();
                if (searchType != null) searchType = searchType.trim();

                List<SystemItem> filteredItems = allItems;
                if ((searchName != null && !searchName.isEmpty()) ||
                    (searchUrl != null && !searchUrl.isEmpty()) ||
                    (searchType != null && !searchType.isEmpty())) {
                    String finalSearchName = searchName;
                    String finalSearchUrl = searchUrl;
                    String finalSearchType = searchType;
                    filteredItems = allItems.stream()
                        .filter(systemItem -> (finalSearchName == null || finalSearchName.isEmpty() || systemItem.getItemName().toLowerCase().contains(finalSearchName.toLowerCase())))
                        .filter(systemItem -> (finalSearchUrl == null || finalSearchUrl.isEmpty() || (systemItem.getItemUrl() != null && systemItem.getItemUrl().toLowerCase().contains(finalSearchUrl.toLowerCase()))))
                        .filter(systemItem -> (finalSearchType == null || finalSearchType.isEmpty() || (systemItem.getItemType() != null && systemItem.getItemType().equalsIgnoreCase(finalSearchType))))
                        .collect(Collectors.toList());
                }

                request.setAttribute("items", filteredItems);
                request.getRequestDispatcher("/admin/system-items/list.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and has admin role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            LOGGER.warning("User not logged in");
            return;
        }

        Object accountObj = session.getAttribute("account");
        Integer roleId = null;
        if (accountObj instanceof model.Employee) {
            model.Employee employee = (model.Employee) accountObj;
            roleId = employee.getRoleId();
        }

        if (roleId == null || roleId != 3) { // Admin role_id = 3
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        String action = request.getParameter("action");
        SystemItem item = new SystemItem();
        item.setItemName(request.getParameter("itemName"));
        item.setItemUrl(request.getParameter("itemUrl"));
        String displayOrder = request.getParameter("displayOrder");
        item.setDisplayOrder(displayOrder == null || displayOrder.isEmpty() ? null : Integer.parseInt(displayOrder));
        item.setItemType(request.getParameter("itemType"));

        if ("add".equals(action)) {
            int inserted = systemItemDAO.insert(item);
            if (inserted > 0) {
                LOGGER.info("Successfully inserted SystemItem: " + item.getItemName());
            } else {
                LOGGER.warning("Failed to insert SystemItem: " + item.getItemName());
            }
        } else if ("edit".equals(action)) {
            item.setItemId(Integer.parseInt(request.getParameter("id")));
            int updated = systemItemDAO.update(item);
            if (updated > 0) {
                LOGGER.info("Successfully updated SystemItem ID: " + item.getItemId());
            } else {
                LOGGER.warning("Failed to update SystemItem ID: " + item.getItemId());
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/system-items");
    }
}