package view;

import model.Comment;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO extends DBContext<Comment> {

    @Override
    public List<Comment> select() {
        List<Comment> list = new ArrayList<>();
        String sql = "SELECT * FROM Comment";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Comment c = mapResultSet(rs);
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Comment select(int... id) {
        if (id.length < 1) return null;
        String sql = "SELECT * FROM Comment WHERE comment_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(Comment obj) {
        String sql = "INSERT INTO Comment (content, date, blog_id, patient_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, obj.getContent());
            ps.setDate(2, Date.valueOf(obj.getDate()));
            ps.setInt(3, obj.getBlogId());
            ps.setInt(4, obj.getPatientId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(Comment obj) {
        String sql = "UPDATE Comment SET content = ?, date = ?, blog_id = ?, patient_id = ? WHERE comment_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, obj.getContent());
            ps.setDate(2, Date.valueOf(obj.getDate()));
            ps.setInt(3, obj.getBlogId());
            ps.setInt(4, obj.getPatientId());
            ps.setInt(5, obj.getCommentId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(int... id) {
        if (id.length < 1) return 0;
        String sql = "DELETE FROM Comment WHERE comment_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Comment mapResultSet(ResultSet rs) throws SQLException {
        return Comment.builder()
                .commentId(rs.getInt("comment_id"))
                .content(rs.getString("content"))
                .date(rs.getDate("date").toLocalDate())
                .blogId(rs.getInt("blog_id"))
                .patientId(rs.getInt("patient_id"))
                .build();
    }
}
