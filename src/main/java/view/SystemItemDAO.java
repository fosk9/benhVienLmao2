package view;

import model.SystemItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * Data Access Object for SystemItem table, extending DBContext.
 */
public class SystemItemDAO extends DBContext<SystemItem> {
    private static final Logger LOGGER = Logger.getLogger(SystemItemDAO.class.getName());

    public SystemItemDAO() {
        super();
    }

    /**
     * Retrieves all SystemItem entries.
     */
    @Override
    public List<SystemItem> select() {
        List<SystemItem> items = new ArrayList<>();
        String sql = "SELECT item_id, item_name, item_url, display_order, item_type FROM SystemItems";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SystemItem item = SystemItem.builder()
                            .itemId(rs.getInt("item_id"))
                            .itemName(rs.getString("item_name"))
                            .itemUrl(rs.getString("item_url"))
                            .displayOrder(rs.getObject("display_order") != null ? rs.getInt("display_order") : null)
                            .itemType(rs.getString("item_type"))
                            .build();
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching SystemItems: " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return items;
    }

    /**
     * Retrieves a SystemItem by ID.
     */
    @Override
    public SystemItem select(int... id) {
        if (id.length == 0) return null;
        SystemItem item = null;
        String sql = "SELECT item_id, item_name, item_url, display_order, item_type FROM SystemItems WHERE item_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id[0]);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        item = SystemItem.builder()
                                .itemId(rs.getInt("item_id"))
                                .itemName(rs.getString("item_name"))
                                .itemUrl(rs.getString("item_url"))
                                .displayOrder(rs.getObject("display_order") != null ? rs.getInt("display_order") : null)
                                .itemType(rs.getString("item_type"))
                                .build();
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching SystemItem with ID " + id[0] + ": " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return item;
    }

    /**
     * Inserts a new SystemItem and returns its generated ID.
     * @return the ID of the inserted SystemItem, or -1 if insertion fails
     */
    @Override
    public int insert(SystemItem item) {
        String sql = "INSERT INTO SystemItems (item_name, item_url, display_order, item_type) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        int generatedId = -1;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, item.getItemName());
                stmt.setString(2, item.getItemUrl());
                if (item.getDisplayOrder() != null) {
                    stmt.setInt(3, item.getDisplayOrder());
                } else {
                    stmt.setNull(3, java.sql.Types.INTEGER);
                }
                stmt.setString(4, item.getItemType());
                int affectedRows = stmt.executeUpdate();
                if (affectedRows > 0) {
                    try (ResultSet rs = stmt.getGeneratedKeys()) {
                        if (rs.next()) {
                            generatedId = rs.getInt(1);
                            LOGGER.info("Inserted SystemItem: " + item.getItemName() + " with ID: " + generatedId);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error inserting SystemItem: " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return generatedId;
    }

    /**
     * Updates an existing SystemItem.
     */
    @Override
    public int update(SystemItem item) {
        String sql = "UPDATE SystemItems SET item_name = ?, item_url = ?, display_order = ?, item_type = ? WHERE item_id = ?";
        Connection conn = null;
        int affectedRows = 0;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, item.getItemName());
                stmt.setString(2, item.getItemUrl());
                if (item.getDisplayOrder() != null) {
                    stmt.setInt(3, item.getDisplayOrder());
                } else {
                    stmt.setNull(3, java.sql.Types.INTEGER);
                }
                stmt.setString(4, item.getItemType());
                stmt.setInt(5, item.getItemId());
                affectedRows = stmt.executeUpdate();
                LOGGER.info("Updated SystemItem ID: " + item.getItemId());
            }
        } catch (SQLException e) {
            LOGGER.severe("Error updating SystemItem ID " + item.getItemId() + ": " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return affectedRows;
    }

    /**
     * Deletes a SystemItem by ID.
     */
    @Override
    public int delete(int... id) {
        if (id.length == 0) return 0;
        String sql = "DELETE FROM SystemItems WHERE item_id = ?";
        Connection conn = null;
        int affectedRows = 0;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id[0]);
                affectedRows = stmt.executeUpdate();
                LOGGER.info("Deleted SystemItem ID: " + id[0]);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error deleting SystemItem ID " + id[0] + ": " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return affectedRows;
    }

    /**
     * Retrieves active SystemItems by role, optionally filtering by item type.
     * If itemType is null, fetches all types (Navigation and Feature).
     */
    public List<SystemItem> getActiveItemsByRoleAndType(int roleId, String itemType) {
        List<SystemItem> items = new ArrayList<>();
        String sql = "SELECT si.item_id, si.item_name, si.item_url, si.display_order, si.item_type " +
                "FROM SystemItems si " +
                "JOIN RoleSystemItems rsi ON si.item_id = rsi.item_id " +
                "WHERE rsi.role_id = ?" +
                (itemType != null ? " AND si.item_type = ?" : "");
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, roleId);
                if (itemType != null) {
                    stmt.setString(2, itemType);
                }
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        SystemItem item = SystemItem.builder()
                                .itemId(rs.getInt("item_id"))
                                .itemName(rs.getString("item_name"))
                                .itemUrl(rs.getString("item_url"))
                                .displayOrder(rs.getObject("display_order") != null ? rs.getInt("display_order") : null)
                                .itemType(rs.getString("item_type"))
                                .build();
                        items.add(item);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching SystemItems for role " + roleId + ": " + e.getMessage());
            return null; // Return null to indicate failure
        } finally {
            closeConnection(conn);
        }
        return items;
    }

    /**
     * Retrieves a list of role IDs associated with a specific SystemItem.
     */
    public List<Integer> getRoleIdsByItemId(int itemId) {
        List<Integer> roleIds = new ArrayList<>();
        String sql = "SELECT role_id FROM RoleSystemItems WHERE item_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, itemId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        roleIds.add(rs.getInt("role_id"));
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching roles for SystemItem: " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return roleIds;
    }

    /**
     * Adds a role to a SystemItem.
     */
    public int addRoleToItem(int roleId, int itemId) {
        String sql = "INSERT INTO RoleSystemItems (role_id, item_id) VALUES (?, ?)";
        Connection conn = null;
        int affectedRows = 0;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, roleId);
                stmt.setInt(2, itemId);
                affectedRows = stmt.executeUpdate();
                LOGGER.info("Added role ID " + roleId + " to SystemItem ID " + itemId);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error adding role to SystemItem: " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return affectedRows;
    }

    /**
     * Deletes all roles associated with a specific SystemItem.
     */
    public int deleteRolesOfItem(int itemId) {
        String sql = "DELETE FROM RoleSystemItems WHERE item_id = ?";
        Connection conn = null;
        int affectedRows = 0;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, itemId);
                affectedRows = stmt.executeUpdate();
                LOGGER.info("Deleted all roles for SystemItem ID: " + itemId);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error deleting roles of SystemItem: " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return affectedRows;
    }

    /**
     * Retrieves the last inserted ID after an insert operation.
     * This is specific to SQL Server using SCOPE_IDENTITY().
     */
    public int getLastInsertId() {
        String sql = "SELECT SCOPE_IDENTITY() AS last_id";
        Connection conn = null;
        int id = -1;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    id = rs.getInt("last_id");
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting last insert id: " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return id;
    }
}