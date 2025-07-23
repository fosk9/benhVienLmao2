package view;

import model.Prescription;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class PrescriptionDAO extends DBContext<Prescription> {
    private static final Logger LOGGER = Logger.getLogger(PrescriptionDAO.class.getName());

    public Prescription getByAppointmentId(int appointmentId) {
        String sql = "SELECT TOP 1 * FROM Prescriptions WHERE appointment_id = ?";
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
            LOGGER.severe("Error fetching prescription by appointment_id=" + appointmentId + ": " + e.getMessage());
            throw new RuntimeException("Failed to fetch prescription", e);
        } finally {
            closeConnection(conn);
        }
        return null;
    }

    public List<Prescription> getListByAppointmentId(int appointmentId) {
        List<Prescription> list = new ArrayList<>();
        String sql = "SELECT * FROM Prescriptions WHERE appointment_id = ?";
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
            LOGGER.severe("Error fetching prescriptions by appointment_id=" + appointmentId + ": " + e.getMessage());
            throw new RuntimeException("Failed to fetch prescriptions", e);
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    private Prescription mapResultSet(ResultSet rs) throws SQLException {
        return Prescription.builder()
                .prescriptionId(rs.getInt("prescription_id"))
                .appointmentId(rs.getInt("appointment_id"))
                .medicationDetails(rs.getString("medication_details"))
                .createdAt(rs.getTimestamp("created_at"))
                .build();
    }

    @Override
    public List<Prescription> select() {
        List<Prescription> list = new ArrayList<>();
        String sql = "SELECT * FROM Prescriptions";
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
            LOGGER.severe("Error selecting prescriptions: " + e.getMessage());
            throw new RuntimeException("Failed to select prescriptions", e);
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    @Override
    public Prescription select(int... id) {
        if (id.length < 1) return null;
        String sql = "SELECT * FROM Prescriptions WHERE prescription_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id[0]);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) return mapResultSet(rs);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error selecting prescription id=" + id[0] + ": " + e.getMessage());
            throw new RuntimeException("Failed to select prescription", e);
        } finally {
            closeConnection(conn);
        }
        return null;
    }

    @Override
    public int insert(Prescription p) {
        String sql = "INSERT INTO Prescriptions (appointment_id, medication_details, created_at) VALUES (?, ?, ?)";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, p.getAppointmentId());
                stmt.setString(2, p.getMedicationDetails());
                stmt.setTimestamp(3, p.getCreatedAt());
                int rows = stmt.executeUpdate();
                LOGGER.info("Inserted prescription, rows affected: " + rows);
                return rows;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error inserting prescription: " + e.getMessage());
            throw new RuntimeException("Failed to insert prescription", e);
        } finally {
            closeConnection(conn);
        }
    }

    @Override
    public int update(Prescription p) {
        String sql = "UPDATE Prescriptions SET appointment_id = ?, medication_details = ?, created_at = ? WHERE prescription_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, p.getAppointmentId());
                stmt.setString(2, p.getMedicationDetails());
                stmt.setTimestamp(3, p.getCreatedAt());
                stmt.setInt(4, p.getPrescriptionId());
                int rows = stmt.executeUpdate();
                LOGGER.info("Updated prescription_id=" + p.getPrescriptionId() + ", rows affected: " + rows);
                return rows;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error updating prescription: " + e.getMessage());
            throw new RuntimeException("Failed to update prescription", e);
        } finally {
            closeConnection(conn);
        }
    }

    @Override
    public int delete(int... id) {
        if (id.length < 1) return 0;
        String sql = "DELETE FROM Prescriptions WHERE prescription_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id[0]);
                int rows = stmt.executeUpdate();
                LOGGER.info("Deleted prescription_id=" + id[0] + ", rows affected: " + rows);
                return rows;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error deleting prescription: " + e.getMessage());
            throw new RuntimeException("Failed to delete prescription", e);
        } finally {
            closeConnection(conn);
        }
    }
}
