package view;

import model.PageContent;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PageContentDAO extends DBContext<PageContent> {

    public PageContentDAO() {
        super();
    }

    public PageContentDAO(String url, String user, String pass) {
        super(url, user, pass);
    }

    public List<PageContent> selectByPage(String pageName) {
        List<PageContent> contents = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConn();
            String sql = "SELECT content_id, page_name, content_key, content_value, is_active " +
                    "FROM PageContent WHERE page_name = ? AND is_active = 1";
            ps = conn.prepareStatement(sql);
            ps.setString(1, pageName);
            rs = ps.executeQuery();
            while (rs.next()) {
                PageContent content = new PageContent();
                content.setContentId(rs.getInt("content_id"));
                content.setPageName(rs.getString("page_name"));
                content.setContentKey(rs.getString("content_key"));
                content.setContentValue(rs.getString("content_value"));
                content.setActive(rs.getBoolean("is_active"));
                contents.add(content);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            closeConnection(conn);
        }
        return contents;
    }

    @Override
    public List<PageContent> select() {
        List<PageContent> contents = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConn();
            String sql = "SELECT content_id, page_name, content_key, content_value, is_active " +
                    "FROM PageContent ORDER BY page_name, content_key";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                PageContent content = new PageContent();
                content.setContentId(rs.getInt("content_id"));
                content.setPageName(rs.getString("page_name"));
                content.setContentKey(rs.getString("content_key"));
                content.setContentValue(rs.getString("content_value"));
                content.setActive(rs.getBoolean("is_active"));
                contents.add(content);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            closeConnection(conn);
        }
        return contents;
    }

    @Override
    public PageContent select(int... id) {
        if (id.length == 0) return null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConn();
            String sql = "SELECT content_id, page_name, content_key, content_value, is_active " +
                    "FROM PageContent WHERE content_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id[0]);
            rs = ps.executeQuery();
            if (rs.next()) {
                PageContent content = new PageContent();
                content.setContentId(rs.getInt("content_id"));
                content.setPageName(rs.getString("page_name"));
                content.setContentKey(rs.getString("content_key"));
                content.setContentValue(rs.getString("content_value"));
                content.setActive(rs.getBoolean("is_active"));
                return content;
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
    public int insert(PageContent content) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConn();
            String sql = "INSERT INTO PageContent (page_name, content_key, content_value, is_active) " +
                    "VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, content.getPageName());
            ps.setString(2, content.getContentKey());
            ps.setString(3, content.getContentValue());
            ps.setBoolean(4, content.isActive());
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
    public int update(PageContent content) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConn();
            String sql = "UPDATE PageContent SET page_name = ?, content_key = ?, content_value = ?, is_active = ? " +
                    "WHERE content_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, content.getPageName());
            ps.setString(2, content.getContentKey());
            ps.setString(3, content.getContentValue());
            ps.setBoolean(4, content.isActive());
            ps.setInt(5, content.getContentId());
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
            String sql = "DELETE FROM PageContent WHERE content_id = ?";
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
}