package view;

import model.Comment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO extends DBContext<Comment> {

    // Lấy các bình luận của blog với phân trang
    public List<Comment> getCommentsByBlogId(int blogId, int offset, int pageSize) {
        System.out.println("[LOG] selectCommentsByBlogId called with blogId=" + blogId + ", offset=" + offset + ", pageSize=" + pageSize);
        List<Comment> list = new ArrayList<>();

        // SQL query với phân trang
        String sql = "SELECT cm.comment_id, cm.blog_id, cm.patient_id, cm.content, cm.date, p.full_name, p.patient_ava_url " +
                "FROM Comment cm " +
                "LEFT JOIN Patients p ON cm.patient_id = p.patient_id " +
                "WHERE cm.blog_id = ? " +
                "ORDER BY cm.comment_id DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"; // Sử dụng OFFSET và FETCH cho SQL Server

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, blogId);    // Set blogId vào câu truy vấn
            ps.setInt(2, offset);     // Set offset cho phân trang
            ps.setInt(3, pageSize);   // Set số lượng bình luận trên mỗi trang

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Comment comment = Comment.builder()
                            .commentId(rs.getInt("comment_id"))
                            .blogId(rs.getInt("blog_id"))
                            .patientId(rs.getInt("patient_id"))
                            .content(rs.getString("content"))
                            .date(rs.getDate("date"))
                            .patientName(rs.getString("full_name"))
                            .patientImage(rs.getString("patient_ava_url"))
                            .build();
                    System.out.println("[LOG] Retrieved comment: " + comment);
                    list.add(comment);
                }
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] selectCommentsByBlogId: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("[LOG] selectCommentsByBlogId returning list size: " + list.size());
        return list;
    }

    // Lấy tổng số bình luận của một bài viết
    public int getTotalCommentsByBlogId(int blogId) {
        String sql = "SELECT COUNT(*) FROM Comment WHERE blog_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, blogId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }


    public List<Comment> selectCommentsByBlogId(int blogId) {
        System.out.println("[LOG] selectByBlogId called with blogId=" + blogId);
        List<Comment> list = new ArrayList<>();

        String sql = "SELECT cm.comment_id, cm.blog_id, cm.patient_id, cm.content, cm.date, p.full_name, p.patient_ava_url " +
                "FROM Comment cm " +
                "LEFT JOIN Patients p ON cm.patient_id = p.patient_id " +
                "WHERE cm.blog_id = ? " +
                "ORDER BY cm.comment_id DESC";

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, blogId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Comment comment = Comment.builder()
                            .commentId(rs.getInt("comment_id"))
                            .blogId(rs.getInt("blog_id"))
                            .patientId(rs.getInt("patient_id"))
                            .content(rs.getString("content"))
                            .date(rs.getDate("date"))
                            .patientName(rs.getString("full_name"))
                            .patientImage(rs.getString("patient_ava_url")) // hoặc "patient_image" nếu đúng tên cột
                            .build();
                    System.out.println("[LOG] Retrieved comment: " + comment);
                    list.add(comment);
                }
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] selectByBlogId: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("[LOG] selectByBlogId returning list size: " + list.size());
        return list;
    }

    public int deleteCommentsByBlogId(int blogId) {
        System.out.println("[LOG] deleteCommentsByBlogId called with blogId=" + blogId);

        String sql = "DELETE FROM Comment WHERE blog_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, blogId);
            int result = ps.executeUpdate();
            System.out.println("[LOG] deleteCommentsByBlogId result: " + result);
            return result;
        } catch (SQLException e) {
            System.out.println("[ERROR] deleteCommentsByBlogId: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }


    @Override
    public List<Comment> select() {
        System.out.println("[LOG] select() called");
        throw new UnsupportedOperationException("Use selectByBlogId instead.");
    }

    @Override
    public Comment select(int... id) {
        System.out.println("[LOG] select(int...) called with id=" + java.util.Arrays.toString(id));
        throw new UnsupportedOperationException("Use selectByBlogId instead.");
    }

    @Override
    public int insert(Comment comment) {
        System.out.println("[LOG] insert called with comment: " + comment);
        String sql = "INSERT INTO Comment (blog_id, patient_id, content, date) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, comment.getBlogId());
            ps.setInt(2, comment.getPatientId());
            ps.setString(3, comment.getContent());
            ps.setDate(4, comment.getDate());
            int result = ps.executeUpdate();
            System.out.println("[LOG] insert result: " + result);
            return result;
        } catch (SQLException e) {
            System.out.println("[ERROR] insert: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public int update(Comment comment) {
        System.out.println("[LOG] update called");
        throw new UnsupportedOperationException("Update not supported for comments.");
    }

    @Override
    public int delete(int... id) {
        System.out.println("[LOG] delete called with id=" + java.util.Arrays.toString(id));
        throw new UnsupportedOperationException("Delete not supported for comments.");
    }
}