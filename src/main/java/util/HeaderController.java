package util;

import dal.SystemItemDAO;
import model.SystemItem;

import java.util.List;

public class HeaderController {

    private SystemItemDAO systemItemDAO;

    public HeaderController() {
        this.systemItemDAO = new SystemItemDAO();
    }
    /**
     * Retrieves active SystemItems for navigation by role and type.
     * @param roleId The ID of the role.
     * @param itemType The type of system item (e.g., "Navigation").
     * @return List of active SystemItems.
     */
    public List<SystemItem> getNavigationItems(int roleId, String itemType) {
        return systemItemDAO.getActiveItemsByRoleAndType(roleId, itemType);
    }

}
