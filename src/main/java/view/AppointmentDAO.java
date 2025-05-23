package view;

import model.DAO.DBContext;
import model.Appointment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {
    // Find appointment by ID
    public Appointment findById(int appointmentId) throws SQLException {
        String sql = "SELECT * FROM Appointments WHERE appointment_id = ?";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointmentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Appointment(
                            rs.getInt("appointment_id"),
                            rs.getInt("patient_id"),
                            rs.getInt("doctor_id"),
                            rs.getObject("appointment_date", LocalDateTime.class),
                            rs.getString("status"),
                            rs.getObject("created_at", LocalDateTime.class),
                            rs.getObject("updated_at", LocalDateTime.class)
                    );
                }
            }
        }
        return null;
    }

    // Find all appointments
    public List<Appointment> findAll() throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT * FROM Appointments";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                appointments.add(new Appointment(
                        rs.getInt("appointment_id"),
                        rs.getInt("patient_id"),
                        rs.getInt("doctor_id"),
                        rs.getObject("appointment_date", LocalDateTime.class),
                        rs.getString("status"),
                        rs.getObject("created_at", LocalDateTime.class),
                        rs.getObject("updated_at", LocalDateTime.class)
                ));
            }
        }
        return appointments;
    }

    // Save new appointment
    public void save(Appointment appointment) throws SQLException {
        String sql = "INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointment.getPatientId());
            stmt.setInt(2, appointment.getDoctorId());
            stmt.setObject(3, appointment.getAppointmentDate());
            stmt.setString(4, appointment.getStatus());
            stmt.setObject(5, appointment.getCreatedAt());
            stmt.setObject(6, appointment.getUpdatedAt());
            stmt.executeUpdate();
        }
    }

    // Update existing appointment
    public void update(Appointment appointment) throws SQLException {
        String sql = "UPDATE Appointments SET patient_id = ?, doctor_id = ?, appointment_date = ?, status = ?, created_at = ?, updated_at = ? WHERE appointment_id = ?";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointment.getPatientId());
            stmt.setInt(2, appointment.getDoctorId());
            stmt.setObject(3, appointment.getAppointmentDate());
            stmt.setString(4, appointment.getStatus());
            stmt.setObject(5, appointment.getCreatedAt());
            stmt.setObject(6, appointment.getUpdatedAt());
            stmt.setInt(7, appointment.getAppointmentId());
            stmt.executeUpdate();
        }
    }

    // Delete appointment
    public void delete(int appointmentId) throws SQLException {
        String sql = "DELETE FROM Appointments WHERE appointment_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointmentId);
            stmt.executeUpdate();
        }
    }
}