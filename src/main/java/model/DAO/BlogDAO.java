package model.DAO;

import model.object.Blog;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class BlogDAO {
    // Find blog by ID
    public Blog findById(int blogId) throws SQLException {
        String sql = "SELECT * FROM Blog WHERE blog_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, blogId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Blog(
                            rs.getInt("blog_id"),
                            rs.getString("blog_name"),
                            rs.getString("content"),
                            rs.getString("image"),
                            rs.getString("author"),
                            rs.getObject("date", LocalDate.class),
                            rs.getByte("type_id"),
                            rs.getByte("selected_banner")
                    );
                }
            }
        }
        return null;
    }

    // Find all blogs
    public List<Blog> findAll() throws SQLException {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT * FROM Blog";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                blogs.add(new Blog(
                        rs.getInt("blog_id"),
                        rs.getString("blog_name"),
                        rs.getString("content"),
                        rs.getString("image"),
                        rs.getString("author"),
                        rs.getObject("date", LocalDate.class),
                        rs.getByte("type_id"),
                        rs.getByte("selected_banner")
                ));
            }
        }
        return blogs;
    }

    // Save new blog
    public void save(Blog blog) throws SQLException {
        String sql = "INSERT INTO Blog (blog_name, content, image, author, date, type_id, selected_banner) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, blog.getBlogName());
            stmt.setString(2, blog.getContent());
            stmt.setString(3, blog.getImage());
            stmt.setString(4, blog.getAuthor());
            stmt.setObject(5, blog.getDate());
            stmt.setByte(6, blog.getTypeId());
            stmt.setByte(7, blog.getSelectedBanner());
            stmt.executeUpdate();
        }
    }

    // Update existing blog
    public void update(Blog blog) throws SQLException {
        String sql = "UPDATE Blog SET blog_name = ?, content = ?, image = ?, author = ?, date = ?, type_id = ?, selected_banner = ? WHERE blog_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, blog.getBlogName());
            stmt.setString(2, blog.getContent());
            stmt.setString(3, blog.getImage());
            stmt.setString(4, blog.getAuthor());
            stmt.setObject(5, blog.getDate());
            stmt.setByte(6, blog.getTypeId());
            stmt.setByte(7, blog.getSelectedBanner());
            stmt.setInt(8, blog.getBlogId());
            stmt.executeUpdate();
        }
    }

    // Delete blog
    public void delete(int blogId) throws SQLException {
        String sql = "DELETE FROM Blog WHERE blog_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, blogId);
            stmt.executeUpdate();
        }
    }
}
//i created this file for my blog.jsp files and servelet
//package dao;
//
//import model.Blog;
//import utils.DBContext;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class BlogDAO {
//
//    public List<Blog> getAllBlogs() {
//        List<Blog> list = new ArrayList<>();
//        String sql = "SELECT * FROM Blog ORDER BY date DESC";
//        try (Connection conn = DBContext.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) {
//                Blog blog = new Blog(
//                    rs.getInt("blog_id"),
//                    rs.getString("blog_name"),
//                    rs.getString("content"),
//                    rs.getString("image"),
//                    rs.getString("author"),
//                    rs.getDate("date").toLocalDate(),
//                    rs.getInt("type_id"),
//                    rs.getBoolean("selected_banner")
//                );
//                list.add(blog);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//
//    public Blog getBlogById(int id) {
//        String sql = "SELECT * FROM Blog WHERE blog_id = ?";
//        try (Connection conn = DBContext.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, id);
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) {
//                    return new Blog(
//                        rs.getInt("blog_id"),
//                        rs.getString("blog_name"),
//                        rs.getString("content"),
//                        rs.getString("image"),
//                        rs.getString("author"),
//                        rs.getDate("date").toLocalDate(),
//                        rs.getInt("type_id"),
//                        rs.getBoolean("selected_banner")
//                    );
//                }
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//    public void insertBlog(Blog blog) {
//        String sql = "INSERT INTO Blog(blog_name, content, image, author, date, type_id, selected_banner) VALUES (?, ?, ?, ?, ?, ?, ?)";
//        try (Connection conn = DBContext.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, blog.getBlogName());
//            ps.setString(2, blog.getContent());
//            ps.setString(3, blog.getImage());
//            ps.setString(4, blog.getAuthor());
//            ps.setDate(5, Date.valueOf(blog.getDate()));
//            ps.setInt(6, blog.getTypeId());
//            ps.setBoolean(7, blog.isSelectedBanner());
//            ps.executeUpdate();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//
//    public Blog getBannerBlog() {
//        String sql = "SELECT * FROM Blog WHERE selected_banner = 1 ORDER BY date DESC";
//        try (Connection conn = DBContext.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//            if (rs.next()) {
//                return new Blog(
//                    rs.getInt("blog_id"),
//                    rs.getString("blog_name"),
//                    rs.getString("content"),
//                    rs.getString("image"),
//                    rs.getString("author"),
//                    rs.getDate("date").toLocalDate(),
//                    rs.getInt("type_id"),
//                    rs.getBoolean("selected_banner")
//                );
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//}