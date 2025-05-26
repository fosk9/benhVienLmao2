package view;

import model.Appointment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO extends DBContext<Appointment> {
    public AppointmentDAO() {
        super();
    }

    public void createAppointment(Appointment appointment) throws SQLException {
        String query = "INSERT INTO Appointments (patient_id, appointment_date, appointment_type, status, created_at) VALUES (?, ?, ?, ?, GETDATE())";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, appointment.getPatientId());
            stmt.setTimestamp(2, Timestamp.valueOf(appointment.getAppointmentDate()));
            stmt.setString(3, appointment.getAppointmentType());
            stmt.setString(4, appointment.getStatus());
            stmt.executeUpdate();
        }
    }

    @Override
    public List<Appointment> select() {
        throw new UnsupportedOperationException("Not implemented");
    }

    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT * FROM Appointments WHERE patient_id = ?";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, patientId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Timestamp appointmentDateTs = rs.getTimestamp("appointment_date");
                Timestamp createdAtTs = rs.getTimestamp("created_at");
                Timestamp updatedAtTs = rs.getTimestamp("updated_at");

                appointments.add(Appointment.builder()
                        .appointmentId(rs.getInt("appointment_id"))
                        .patientId(rs.getInt("patient_id"))
                        .doctorId(rs.getInt("doctor_id"))
                        .appointmentDate(appointmentDateTs != null ? appointmentDateTs.toLocalDateTime() : null)
                        .appointmentType(rs.getString("appointment_type"))
                        .status(rs.getString("status"))
                        .createdAt(createdAtTs != null ? createdAtTs.toLocalDateTime() : null)
                        .updatedAt(updatedAtTs != null ? updatedAtTs.toLocalDateTime() : null)
                        .build());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }

    @Override
    public Appointment select(int... id) {
        if (id.length != 1) {
            throw new IllegalArgumentException("One ID is required");
        }
        String query = "SELECT * FROM Appointments WHERE appointment_id = ?";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id[0]);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Timestamp appointmentDateTs = rs.getTimestamp("appointment_date");
                Timestamp createdAtTs = rs.getTimestamp("created_at");
                Timestamp updatedAtTs = rs.getTimestamp("updated_at");

                return Appointment.builder()
                        .appointmentId(rs.getInt("appointment_id"))
                        .patientId(rs.getInt("patient_id"))
                        .doctorId(rs.getInt("doctor_id"))
                        .appointmentDate(appointmentDateTs != null ? appointmentDateTs.toLocalDateTime() : null)
                        .appointmentType(rs.getString("appointment_type"))
                        .status(rs.getString("status"))
                        .createdAt(createdAtTs != null ? createdAtTs.toLocalDateTime() : null)
                        .updatedAt(updatedAtTs != null ? updatedAtTs.toLocalDateTime() : null)
                        .build();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(Appointment obj) {
        throw new UnsupportedOperationException("Not implemented");
    }

    @Override
    public int update(Appointment appointment) {
        String query = "UPDATE Appointments SET appointment_date = ?, appointment_type = ?, updated_at = GETDATE() WHERE appointment_id = ?";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setTimestamp(1, Timestamp.valueOf(appointment.getAppointmentDate()));
            stmt.setString(2, appointment.getAppointmentType());
            stmt.setInt(3, appointment.getAppointmentId());
            return stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int delete(int... id) {
        if (id.length != 1) {
            throw new IllegalArgumentException("One ID is required");
        }
        String query = "DELETE FROM Appointments WHERE appointment_id = ?";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id[0]);
            return stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
}