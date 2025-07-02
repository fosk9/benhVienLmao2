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
                    SystemItem item = new SystemItem();
                    item.setItemId(rs.getInt("item_id"));
                    item.setItemName(rs.getString("item_name"));
                    item.setItemUrl(rs.getString("item_url"));
                    item.setDisplayOrder(rs.getObject("display_order") != null ? rs.getInt("display_order") : null);
                    item.setItemType(rs.getString("item_type"));
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
                        item = new SystemItem();
                        item.setItemId(rs.getInt("item_id"));
                        item.setItemName(rs.getString("item_name"));
                        item.setItemUrl(rs.getString("item_url"));
                        item.setDisplayOrder(rs.getObject("display_order") != null ? rs.getInt("display_order") : null);
                        item.setItemType(rs.getString("item_type"));
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
     * Inserts a new SystemItem.
     */
    @Override
    public int insert(SystemItem item) {
        String sql = "INSERT INTO SystemItems (item_name, item_url, display_order, item_type) VALUES (?, ?, ?, ?)";
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
                affectedRows = stmt.executeUpdate();
                LOGGER.info("Inserted SystemItem: " + item.getItemName());
            }
        } catch (SQLException e) {
            LOGGER.severe("Error inserting SystemItem: " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return affectedRows;
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
     * Retrieves active SystemItems by role and type.
     */
    public List<SystemItem> getActiveItemsByRoleAndType(int roleId, String itemType) {
        List<SystemItem> items = new ArrayList<>();
        String sql = "SELECT si.item_id, si.item_name, si.item_url, si.display_order, si.item_type FROM SystemItems si " +
                "JOIN RoleSystemItems rsi ON si.item_id = rsi.item_id " +
                "WHERE rsi.role_id = ? AND si.item_type = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, roleId);
                stmt.setString(2, itemType);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        SystemItem item = new SystemItem();
                        item.setItemId(rs.getInt("item_id"));
                        item.setItemName(rs.getString("item_name"));
                        item.setItemUrl(rs.getString("item_url"));
                        item.setDisplayOrder(rs.getObject("display_order") != null ? rs.getInt("display_order") : null);
                        item.setItemType(rs.getString("item_type"));
                        items.add(item);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching active SystemItems for role " + roleId + ": " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return items;
    }
}