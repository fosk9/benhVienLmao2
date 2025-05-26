package model.DAO;

import model.object.Comment;
import view.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {

    public void addComment(Comment c) {
        String sql = "INSERT INTO Comment (content, date, blog_id, patient_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getContent());
            ps.setDate(2, Date.valueOf(c.getDate()));
            ps.setInt(3, c.getBlogId());
            ps.setInt(4, c.getPatientId());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Comment> getCommentsByBlogId(int blogId) {
        List<Comment> list = new ArrayList<>();
        String sql = "SELECT * FROM Comment WHERE blog_id = ? ORDER BY date DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, blogId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Comment c = new Comment();
                c.setCommentId(rs.getInt("comment_id"));
                c.setContent(rs.getString("content"));
                c.setDate(rs.getDate("date").toLocalDate());
                c.setBlogId(rs.getInt("blog_id"));
                c.setPatientId(rs.getInt("patient_id"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

