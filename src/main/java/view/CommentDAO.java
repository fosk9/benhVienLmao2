package view;

import model.Comment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO extends DBContext<Comment> {

    public List<Comment> selectByBlogId(int blogId) {
        List<Comment> list = new ArrayList<>();

        String sql = "SELECT cm.comment_id, cm.blog_id, cm.patient_id, cm.content, cm.date, p.full_name " +
                "FROM Comment cm " +  // thêm dấu cách ở cuối
                "LEFT JOIN Patients p ON cm.patient_id = p.patient_id " +
                "WHERE cm.blog_id = ? " +
                "ORDER BY cm.date DESC";


        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, blogId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(Comment.builder()
                            .commentId(rs.getInt("comment_id"))
                            .blogId(rs.getInt("blog_id"))
                            .patientId(rs.getInt("patient_id"))
                            .content(rs.getString("content"))
                            .date(rs.getDate("date"))
                            .patientName(rs.getString("full_name"))
                            .build());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Comment> select() {
        throw new UnsupportedOperationException("Use selectByBlogId instead.");
    }

    @Override
    public Comment select(int... id) {
        throw new UnsupportedOperationException("Use selectByBlogId instead.");
    }

    @Override
    public int insert(Comment comment) {
        String sql = "INSERT INTO Comment (blog_id, patient_id, content, date) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, comment.getBlogId());
            ps.setInt(2, comment.getPatientId());
            ps.setString(3, comment.getContent());
            ps.setDate(4, comment.getDate());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public int update(Comment comment) {
        throw new UnsupportedOperationException("Update not supported for comments.");
    }

    @Override
    public int delete(int... id) {
        throw new UnsupportedOperationException("Delete not supported for comments.");
    }
}
