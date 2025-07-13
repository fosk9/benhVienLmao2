package util;

import jakarta.servlet.http.HttpServletRequest;
import model.SystemItem;
import view.SystemItemDAO;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class NavigationUtil {
    private static final Logger LOGGER = Logger.getLogger(NavigationUtil.class.getName());
    private static final SystemItemDAO systemItemDAO = new SystemItemDAO();

    public static List<SystemItem> getNavigationItemsForRole(int roleId, HttpServletRequest request) {
        List<SystemItem> navItems = new ArrayList<>();
        try {
            navItems = systemItemDAO.getActiveItemsByRoleAndType(roleId, "Navigation");
            LOGGER.info("Fetched " + navItems.size() + " navigation items for role " + roleId);
        } catch (Exception e) {
            LOGGER.severe("Error fetching navigation items: " + e.getMessage());
            navItems = new ArrayList<>();
            if (request != null) {
                request.setAttribute("error", "Failed to load navigation items: " + e.getMessage());
            }
        }
        return navItems;
    }
}

