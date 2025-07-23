package view;

import model.Treatment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class TreatmentDAO extends DBContext<Treatment> {
    private static final Logger LOGGER = Logger.getLogger(TreatmentDAO.class.getName());

    public Treatment getByAppointmentId(int appointmentId) {
        String sql = "SELECT TOP 1 * FROM Treatment WHERE appointment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, appointmentId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching treatment by appointment_id=" + appointmentId + ": " + e.getMessage());
            throw new RuntimeException("Failed to fetch treatment", e);
        } finally {
            closeConnection(conn);
        }
        return null;
    }

    public List<Treatment> getListByAppointmentId(int appointmentId) {
        List<Treatment> list = new ArrayList<>();
        String sql = "SELECT * FROM Treatment WHERE appointment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, appointmentId);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching treatments by appointment_id=" + appointmentId + ": " + e.getMessage());
            throw new RuntimeException("Failed to fetch treatments", e);
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    private Treatment mapResultSet(ResultSet rs) throws SQLException {
        return Treatment.builder()
                .treatmentId(rs.getInt("treatment_id"))
                .appointmentId(rs.getInt("appointment_id"))
                .treatmentType(rs.getString("treatment_type"))
                .treatmentNotes(rs.getString("treatment_notes"))
                .createdAt(rs.getTimestamp("created_at"))
                .build();
    }

    @Override
    public List<Treatment> select() {
        List<Treatment> list = new ArrayList<>();
        String sql = "SELECT * FROM Treatment";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error selecting treatments: " + e.getMessage());
            throw new RuntimeException("Failed to select treatments", e);
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    @Override
    public Treatment select(int... id) {
        if (id.length < 1) return null;
        String sql = "SELECT * FROM Treatment WHERE treatment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id[0]);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) return mapResultSet(rs);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error selecting treatment id=" + id[0] + ": " + e.getMessage());
            throw new RuntimeException("Failed to select treatment", e);
        } finally {
            closeConnection(conn);
        }
        return null;
    }

    @Override
    public int insert(Treatment t) {
        String sql = "INSERT INTO Treatment (appointment_id, treatment_type, treatment_notes, created_at) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, t.getAppointmentId());
                stmt.setString(2, t.getTreatmentType());
                stmt.setString(3, t.getTreatmentNotes());
                stmt.setDate(4, new java.sql.Date(t.getCreatedAt().getTime()));
                int rows = stmt.executeUpdate();
                LOGGER.info("Inserted treatment, rows affected: " + rows);
                return rows;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error inserting treatment: " + e.getMessage());
            throw new RuntimeException("Failed to insert treatment", e);
        } finally {
            closeConnection(conn);
        }
    }

    @Override
    public int update(Treatment t) {
        String sql = "UPDATE Treatment SET appointment_id = ?, treatment_type = ?, treatment_notes = ?, created_at = ? WHERE treatment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, t.getAppointmentId());
                stmt.setString(2, t.getTreatmentType());
                stmt.setString(3, t.getTreatmentNotes());
                stmt.setDate(4, new java.sql.Date(t.getCreatedAt().getTime()));
                stmt.setInt(5, t.getTreatmentId());
                int rows = stmt.executeUpdate();
                LOGGER.info("Updated treatment_id=" + t.getTreatmentId() + ", rows affected: " + rows);
                return rows;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error updating treatment: " + e.getMessage());
            throw new RuntimeException("Failed to update treatment", e);
        } finally {
            closeConnection(conn);
        }
    }

    @Override
    public int delete(int... id) {
        if (id.length < 1) return 0;
        String sql = "DELETE FROM Treatment WHERE treatment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id[0]);
                int rows = stmt.executeUpdate();
                LOGGER.info("Deleted treatment_id=" + id[0] + ", rows affected: " + rows);
                return rows;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error deleting treatment: " + e.getMessage());
            throw new RuntimeException("Failed to delete treatment", e);
        } finally {
            closeConnection(conn);
        }
    }

    // Get all treatments by appointmentId
    public List<Treatment> getTreatmentsByAppointmentId(int appointmentId) {
        List<Treatment> list = new ArrayList<>();
        String sql = "SELECT * FROM Treatment WHERE appointment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, appointmentId);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching treatments by appointment_id=" + appointmentId + ": " + e.getMessage());
            throw new RuntimeException("Failed to fetch treatments", e);
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    // Get all treatments by patientId
    public List<Treatment> getTreatmentsByPatientId(int patientId) {
        List<Treatment> list = new ArrayList<>();
        String sql = "SELECT t.* FROM Treatment t JOIN Appointments a ON t.appointment_id = a.appointment_id WHERE a.patient_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, patientId);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching treatments by patient_id=" + patientId + ": " + e.getMessage());
            throw new RuntimeException("Failed to fetch treatments", e);
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    // Get all treatments
    public List<Treatment> getAllTreatments() {
        List<Treatment> list = new ArrayList<>();
        String sql = "SELECT * FROM Treatment";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error selecting all treatments: " + e.getMessage());
            throw new RuntimeException("Failed to select all treatments", e);
        } finally {
            closeConnection(conn);
        }
        return list;
    }


}
