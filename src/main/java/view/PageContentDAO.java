package view;

import model.PageContent;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * Data Access Object for PageContent table, extending DBContext.
 */
public class PageContentDAO extends DBContext<PageContent> {
    private static final Logger LOGGER = Logger.getLogger(PageContentDAO.class.getName());

    public PageContentDAO() {
        super();
    }

    public PageContentDAO(String url, String user, String pass) {
        super(url, user, pass);
    }

    /**
     * Retrieves all PageContent entries, optionally filtered by pageName.
     */
    public List<PageContent> select(String pageName) {
        List<PageContent> contents = new ArrayList<>();
        String sql = pageName == null ?
                "SELECT * FROM PageContent WHERE page_name IS NOT NULL AND content_key IS NOT NULL" :
                "SELECT * FROM PageContent WHERE page_name = ? AND page_name IS NOT NULL AND content_key IS NOT NULL";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                if (pageName != null) {
                    stmt.setString(1, pageName);
                }
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        PageContent content = new PageContent();
                        content.setContentId(rs.getInt("content_id"));
                        content.setPageName(rs.getString("page_name"));
                        content.setContentKey(rs.getString("content_key"));
                        content.setContentValue(rs.getString("content_value"));
                        content.setActive(rs.getBoolean("is_active")); // Maps to isActive
                        content.setImageUrl(rs.getString("image_url"));
                        content.setVideoUrl(rs.getString("video_url"));
                        content.setButtonUrl(rs.getString("button_url"));
                        content.setButtonText(rs.getString("button_text"));
                        contents.add(content);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching PageContent: " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return contents;
    }

    @Override
    public List<PageContent> select() {
        return null;
    }

    @Override
    public PageContent select(int... id) {
        if (id.length == 0) return null;
        PageContent content = null;
        String sql = "SELECT * FROM PageContent WHERE content_id = ? AND page_name IS NOT NULL AND content_key IS NOT NULL";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id[0]);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        content = new PageContent();
                        content.setContentId(rs.getInt("content_id"));
                        content.setPageName(rs.getString("page_name"));
                        content.setContentKey(rs.getString("content_key"));
                        content.setContentValue(rs.getString("content_value"));
                        content.setActive(rs.getBoolean("is_active"));
                        content.setImageUrl(rs.getString("image_url"));
                        content.setVideoUrl(rs.getString("video_url"));
                        content.setButtonUrl(rs.getString("button_url"));
                        content.setButtonText(rs.getString("button_text"));
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching PageContent with ID " + id[0] + ": " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return content;
    }

    @Override
    public int insert(PageContent content) {
        if (content.getPageName() == null || content.getContentKey() == null) {
            LOGGER.warning("Cannot insert PageContent with null pageName or contentKey");
            return 0;
        }
        String sql = "INSERT INTO PageContent (page_name, content_key, content_value, is_active, image_url, video_url, button_url, button_text) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        int affectedRows = 0;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, content.getPageName());
                stmt.setString(2, content.getContentKey());
                stmt.setString(3, content.getContentValue());
                stmt.setBoolean(4, content.isActive());
                stmt.setString(5, content.getImageUrl());
                stmt.setString(6, content.getVideoUrl());
                stmt.setString(7, content.getButtonUrl());
                stmt.setString(8, content.getButtonText());
                affectedRows = stmt.executeUpdate();
                LOGGER.info("Inserted PageContent: " + content.getContentKey());
            }
        } catch (SQLException e) {
            LOGGER.severe("Error inserting PageContent: " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return affectedRows;
    }

    @Override
    public int update(PageContent content) {
        if (content.getPageName() == null || content.getContentKey() == null) {
            LOGGER.warning("Cannot update PageContent with null pageName or contentKey");
            return 0;
        }
        String sql = "UPDATE PageContent SET page_name = ?, content_key = ?, content_value = ?, is_active = ?, image_url = ?, video_url = ?, button_url = ?, button_text = ? WHERE content_id = ?";
        Connection conn = null;
        int affectedRows = 0;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, content.getPageName());
                stmt.setString(2, content.getContentKey());
                stmt.setString(3, content.getContentValue());
                stmt.setBoolean(4, content.isActive());
                stmt.setString(5, content.getImageUrl());
                stmt.setString(6, content.getVideoUrl());
                stmt.setString(7, content.getButtonUrl());
                stmt.setString(8, content.getButtonText());
                stmt.setInt(9, content.getContentId());
                affectedRows = stmt.executeUpdate();
                LOGGER.info("Updated PageContent ID: " + content.getContentId());
            }
        } catch (SQLException e) {
            LOGGER.severe("Error updating PageContent ID " + content.getContentId() + ": " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return affectedRows;
    }

    @Override
    public int delete(int... id) {
        if (id.length == 0) return 0;
        String sql = "DELETE FROM PageContent WHERE content_id = ?";
        Connection conn = null;
        int affectedRows = 0;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id[0]);
                affectedRows = stmt.executeUpdate();
                LOGGER.info("Deleted PageContent ID: " + id[0]);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error deleting PageContent ID " + id[0] + ": " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return affectedRows;
    }
}