package view;

import model.SystemItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SystemItemDAO extends DBContext<SystemItem> {

    public SystemItemDAO() {
        super();
    }

    public SystemItemDAO(String url, String user, String pass) {
        super(url, user, pass);
    }

    // Fetch active items by role and type
    public List<SystemItem> getActiveItemsByRoleAndType(int roleId, String itemType) throws SQLException {
        List<SystemItem> items = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConn();
            String sql = "SELECT si.item_id, si.item_name, si.item_url, si.image_url, si.is_active, si.display_order, si.parent_item_id, si.item_type " +
                    "FROM SystemItems si " +
                    "JOIN RoleSystemItems rsi ON si.item_id = rsi.item_id " +
                    "WHERE rsi.role_id = ? AND si.item_type = ? AND si.is_active = 1 " +
                    "ORDER BY si.display_order";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, roleId);
            ps.setString(2, itemType);
            rs = ps.executeQuery();
            while (rs.next()) {
                SystemItem item = new SystemItem();
                item.setItemId(rs.getInt("item_id"));
                item.setItemName(rs.getString("item_name"));
                item.setItemUrl(rs.getString("item_url"));
                item.setImageUrl(rs.getString("image_url"));
                item.setActive(rs.getBoolean("is_active"));
                item.setDisplayOrder(rs.getInt("display_order"));
                item.setParentItemId(rs.getInt("parent_item_id"));
                item.setItemType(rs.getString("item_type"));
                items.add(item);
            }
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            closeConnection(conn);
        }
        // Build hierarchy for navigation items
        if ("Navigation".equals(itemType)) {
            items = buildNavigationHierarchy(items);
        }
        return items;
    }

    @Override
    public List<SystemItem> select() {
        List<SystemItem> items = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConn();
            String sql = "SELECT item_id, item_name, item_url, image_url, is_active, display_order, parent_item_id, item_type " +
                    "FROM SystemItems ORDER BY item_type, display_order";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                SystemItem item = new SystemItem();
                item.setItemId(rs.getInt("item_id"));
                item.setItemName(rs.getString("item_name"));
                item.setItemUrl(rs.getString("item_url"));
                item.setImageUrl(rs.getString("image_url"));
                item.setActive(rs.getBoolean("is_active"));
                item.setDisplayOrder(rs.getInt("display_order"));
                item.setParentItemId(rs.getInt("parent_item_id"));
                item.setItemType(rs.getString("item_type"));
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            closeConnection(conn);
        }
        return items;
    }

    @Override
    public SystemItem select(int... id) {
        if (id.length == 0) return null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConn();
            String sql = "SELECT item_id, item_name, item_url, image_url, is_active, display_order, parent_item_id, item_type " +
                    "FROM SystemItems WHERE item_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id[0]);
            rs = ps.executeQuery();
            if (rs.next()) {
                SystemItem item = new SystemItem();
                item.setItemId(rs.getInt("item_id"));
                item.setItemName(rs.getString("item_name"));
                item.setItemUrl(rs.getString("item_url"));
                item.setImageUrl(rs.getString("image_url"));
                item.setActive(rs.getBoolean("is_active"));
                item.setDisplayOrder(rs.getInt("display_order"));
                item.setParentItemId(rs.getInt("parent_item_id"));
                item.setItemType(rs.getString("item_type"));
                return item;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            closeConnection(conn);
        }
        return null;
    }

    @Override
    public int insert(SystemItem item) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConn();
            String sql = "INSERT INTO SystemItems (item_name, item_url, image_url, is_active, display_order, parent_item_id, item_type) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, item.getItemName());
            ps.setString(2, item.getItemUrl());
            ps.setString(3, item.getImageUrl());
            ps.setBoolean(4, item.isActive());
            if (item.getDisplayOrder() != null) {
                ps.setInt(5, item.getDisplayOrder());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            if (item.getParentItemId() != null) {
                ps.setInt(6, item.getParentItemId());
            } else {
                ps.setNull(6, java.sql.Types.INTEGER);
            }
            ps.setString(7, item.getItemType());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            closeConnection(conn);
        }
    }

    @Override
    public int update(SystemItem item) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConn();
            String sql = "UPDATE SystemItems SET item_name = ?, item_url = ?, image_url = ?, is_active = ?, display_order = ?, parent_item_id = ?, item_type = ? " +
                    "WHERE item_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, item.getItemName());
            ps.setString(2, item.getItemUrl());
            ps.setString(3, item.getImageUrl());
            ps.setBoolean(4, item.isActive());
            if (item.getDisplayOrder() != null) {
                ps.setInt(5, item.getDisplayOrder());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            if (item.getParentItemId() != null) {
                ps.setInt(6, item.getParentItemId());
            } else {
                ps.setNull(6, java.sql.Types.INTEGER);
            }
            ps.setString(7, item.getItemType());
            ps.setInt(8, item.getItemId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            closeConnection(conn);
        }
    }

    @Override
    public int delete(int... id) {
        if (id.length == 0) return 0;
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConn();
            String sql = "DELETE FROM SystemItems WHERE item_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id[0]);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            closeConnection(conn);
        }
    }

    // Build navigation hierarchy
    private List<SystemItem> buildNavigationHierarchy(List<SystemItem> items) {
        List<SystemItem> rootItems = new ArrayList<>();
        for (SystemItem item : items) {
            if (item.getParentItemId() == null) {
                item.setSubItems(new ArrayList<>());
                rootItems.add(item);
            }
        }
        for (SystemItem item : items) {
            if (item.getParentItemId() != null) {
                for (SystemItem root : rootItems) {
                    if (root.getItemId() == item.getParentItemId()) {
                        root.getSubItems().add(item);
                        break;
                    }
                }
            }
        }
        return rootItems;
    }
}