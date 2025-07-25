package dal;

import model.Diagnosis;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class DiagnosisDAO extends DBContext<Diagnosis> {
    private static final Logger LOGGER = Logger.getLogger(DiagnosisDAO.class.getName());

    public Diagnosis getByAppointmentId(int appointmentId) {
        String sql = "SELECT TOP 1 * FROM Diagnoses WHERE appointment_id = ?";
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
            LOGGER.severe("Error fetching diagnosis by appointment_id=" + appointmentId + ": " + e.getMessage());
            throw new RuntimeException("Failed to fetch diagnosis", e);
        } finally {
            closeConnection(conn);
        }
        return null;
    }

    public List<Diagnosis> getListByAppointmentId(int appointmentId) {
        List<Diagnosis> list = new ArrayList<>();
        String sql = "SELECT * FROM Diagnoses WHERE appointment_id = ?";
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
            LOGGER.severe("Error fetching diagnoses by appointment_id=" + appointmentId + ": " + e.getMessage());
            throw new RuntimeException("Failed to fetch diagnoses", e);
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    private Diagnosis mapResultSet(ResultSet rs) throws SQLException {
        return Diagnosis.builder()
                .diagnosisId(rs.getInt("diagnosis_id"))
                .appointmentId(rs.getInt("appointment_id"))
                .notes(rs.getString("notes"))
                .createdAt(rs.getTimestamp("created_at"))
                .build();
    }

    @Override
    public List<Diagnosis> select() {
        List<Diagnosis> list = new ArrayList<>();
        String sql = "SELECT * FROM Diagnoses";
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
            LOGGER.severe("Error selecting all diagnoses: " + e.getMessage());
            throw new RuntimeException("Failed to select diagnoses", e);
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    @Override
    public Diagnosis select(int... id) {
        if (id.length < 1) return null;
        String sql = "SELECT * FROM Diagnoses WHERE diagnosis_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id[0]);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error selecting diagnosis id=" + id[0] + ": " + e.getMessage());
            throw new RuntimeException("Failed to select diagnosis", e);
        } finally {
            closeConnection(conn);
        }
        return null;
    }

    @Override
    public int insert(Diagnosis d) {
        String sql = "INSERT INTO Diagnoses (appointment_id, notes, created_at) VALUES (?, ?, ?)";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, d.getAppointmentId());
                stmt.setString(2, d.getNotes());
                stmt.setTimestamp(3, d.getCreatedAt());
                int rows = stmt.executeUpdate();
                LOGGER.info("Inserted diagnosis, rows affected: " + rows);
                return rows;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error inserting diagnosis: " + e.getMessage());
            throw new RuntimeException("Failed to insert diagnosis", e);
        } finally {
            closeConnection(conn);
        }
    }

    @Override
    public int update(Diagnosis d) {
        String sql = "UPDATE Diagnoses SET appointment_id = ?, notes = ?, created_at = ? WHERE diagnosis_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, d.getAppointmentId());
                stmt.setString(2, d.getNotes());
                stmt.setTimestamp(3, (d.getCreatedAt()));
                stmt.setInt(4, d.getDiagnosisId());
                int rows = stmt.executeUpdate();
                LOGGER.info("Updated diagnosis_id=" + d.getDiagnosisId() + ", rows affected: " + rows);
                return rows;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error updating diagnosis: " + e.getMessage());
            throw new RuntimeException("Failed to update diagnosis", e);
        } finally {
            closeConnection(conn);
        }
    }

    @Override
    public int delete(int... id) {
        if (id.length < 1) return 0;
        String sql = "DELETE FROM Diagnoses WHERE diagnosis_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id[0]);
                int rows = stmt.executeUpdate();
                LOGGER.info("Deleted diagnosis_id=" + id[0] + ", rows affected: " + rows);
                return rows;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error deleting diagnosis: " + e.getMessage());
            throw new RuntimeException("Failed to delete diagnosis", e);
        } finally {
            closeConnection(conn);
        }
    }
}
