package view;

import model.DAO.DBContext;
import model.Feedback;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    // Find feedback by ID
    public Feedback findById(int feedbackId) throws SQLException {
        String sql = "SELECT * FROM Feedbacks WHERE feedback_id = ?";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, feedbackId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Feedback(
                            rs.getInt("feedback_id"),
                            rs.getInt("employee_id"),
                            rs.getInt("patient_id"),
                            rs.getInt("rating"),
                            rs.getString("comments"),
                            rs.getObject("created_at", LocalDateTime.class)
                    );
                }
            }
        }
        return null;
    }

    // Find all feedbacks
    public List<Feedback> findAll() throws SQLException {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT * FROM Feedbacks";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                feedbacks.add(new Feedback(
                        rs.getInt("feedback_id"),
                        rs.getInt("employee_id"),
                        rs.getInt("patient_id"),
                        rs.getInt("rating"),
                        rs.getString("comments"),
                        rs.getObject("created_at", LocalDateTime.class)
                ));
            }
        }
        return feedbacks;
    }

    // Save new feedback
    public void save(Feedback feedback) throws SQLException {
        String sql = "INSERT INTO Feedbacks (employee_id, patient_id, rating, comments, created_at) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, feedback.getEmployeeId());
            stmt.setInt(2, feedback.getPatientId());
            stmt.setInt(3, feedback.getRating());
            stmt.setString(4, feedback.getComments());
            stmt.setObject(5, feedback.getCreatedAt());
            stmt.executeUpdate();
        }
    }

    // Update existing feedback
    public void update(Feedback feedback) throws SQLException {
        String sql = "UPDATE Feedbacks SET employee_id = ?, patient_id = ?, rating = ?, comments = ?, created_at = ? WHERE feedback_id = ?";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, feedback.getEmployeeId());
            stmt.setInt(2, feedback.getPatientId());
            stmt.setInt(3, feedback.getRating());
            stmt.setString(4, feedback.getComments());
            stmt.setObject(5, feedback.getCreatedAt());
            stmt.setInt(6, feedback.getFeedbackId());
            stmt.executeUpdate();
        }
    }

    // Delete feedback
    public void delete(int feedbackId) throws SQLException {
        String sql = "DELETE FROM Feedbacks WHERE feedback_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, feedbackId);
            stmt.executeUpdate();
        }
    }
}