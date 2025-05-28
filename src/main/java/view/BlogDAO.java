package view;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BlogDAO {

    public List<Blog> getAllBlogs() {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT * FROM Blog ORDER BY date DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Blog blog = new Blog(
                        rs.getInt("blog_id"),
                        rs.getString("blog_name"),
                        rs.getString("content"),
                        rs.getString("image"),
                        rs.getString("author"),
                        rs.getDate("date").toLocalDate(),
                        rs.getInt("type_id"),
                        rs.getBoolean("selected_banner")
                );
                list.add(blog);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Blog getBlogById(int id) {
        String sql = "SELECT * FROM Blog WHERE blog_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Blog(
                            rs.getInt("blog_id"),
                            rs.getString("blog_name"),
                            rs.getString("content"),
                            rs.getString("image"),
                            rs.getString("author"),
                            rs.getDate("date").toLocalDate(),
                            rs.getInt("type_id"),
                            rs.getBoolean("selected_banner")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insertBlog(Blog blog) {
        String sql = "INSERT INTO Blog(blog_name, content, image, author, date, type_id, selected_banner) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, blog.getBlogName());
            ps.setString(2, blog.getContent());
            ps.setString(3, blog.getImage());
            ps.setString(4, blog.getAuthor());
            ps.setDate(5, Date.valueOf(blog.getDate()));
            ps.setInt(6, blog.getTypeId());
            ps.setBoolean(7, blog.isSelectedBanner());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Blog getBannerBlog() {
        String sql = "SELECT * FROM Blog WHERE selected_banner = 1 ORDER BY date DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return new Blog(
                        rs.getInt("blog_id"),
                        rs.getString("blog_name"),
                        rs.getString("content"),
                        rs.getString("image"),
                        rs.getString("author"),
                        rs.getDate("date").toLocalDate(),
                        rs.getInt("type_id"),
                        rs.getBoolean("selected_banner")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public void deleteBlog(int id) throws Exception {
        String sql = "DELETE FROM Blog WHERE blog_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}