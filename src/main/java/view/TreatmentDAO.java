package view;

import model.Treatment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TreatmentDAO {
    private Connection getConnection() throws SQLException {
        // Sử dụng DriverManager, thay đổi URL, user, pass cho phù hợp cấu hình của bạn
        String url = "jdbc:sqlserver://localhost:1433;databaseName=benhvienlmao;encrypt=false";
        String user = "sa";
        String pass = "123456";
        return DriverManager.getConnection(url, user, pass);
    }

    public List<Treatment> getTreatmentsByAppointmentId(int appointmentId) {
        List<Treatment> list = new ArrayList<>();
        String sql = "SELECT * FROM Treatment WHERE appointment_id = ? ORDER BY created_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Treatment t = new Treatment(
                        rs.getInt("treatment_id"),
                        rs.getInt("appointment_id"),
                        rs.getString("treatment_type"),
                        rs.getString("treatment_notes"),
                        rs.getTimestamp("created_at")
                );
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Treatment> getTreatmentsByPatientId(int patientId) {
        List<Treatment> list = new ArrayList<>();
        String sql = "SELECT t.* FROM Treatment t JOIN Appointments a ON t.appointment_id = a.appointment_id WHERE a.patient_id = ? ORDER BY t.created_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Treatment t = new Treatment(
                        rs.getInt("treatment_id"),
                        rs.getInt("appointment_id"),
                        rs.getString("treatment_type"),
                        rs.getString("treatment_notes"),
                        rs.getTimestamp("created_at")
                );
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void addTreatment(Treatment treatment) {
        String sql = "INSERT INTO Treatment (appointment_id, treatment_type, treatment_notes, created_at) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, treatment.getAppointmentId());
            ps.setString(2, treatment.getTreatmentType());
            ps.setString(3, treatment.getTreatmentNotes());
            ps.setTimestamp(4, treatment.getCreatedAt());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Treatment> getAllTreatments() {
        List<Treatment> list = new ArrayList<>();
        String sql = "SELECT * FROM Treatment ORDER BY created_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Treatment t = new Treatment(
                        rs.getInt("treatment_id"),
                        rs.getInt("appointment_id"),
                        rs.getString("treatment_type"),
                        rs.getString("treatment_notes"),
                        rs.getTimestamp("created_at")
                );
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Treatment> getByAppointmentId(int appointmentId) {
        List<Treatment> list = new ArrayList<>();
        String sql = "SELECT * FROM Treatment WHERE appointment_id = ? ORDER BY created_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Treatment t = new Treatment(
                        rs.getInt("treatment_id"),
                        rs.getInt("appointment_id"),
                        rs.getString("treatment_type"),
                        rs.getString("treatment_notes"),
                        rs.getTimestamp("created_at")
                );
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
