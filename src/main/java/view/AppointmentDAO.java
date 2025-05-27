package view;

import model.Appointment;
import model.Patient;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.sql.Timestamp;

public  class AppointmentDAO  {
    private final Connection conn;

    public AppointmentDAO(Connection conn) {
        this.conn = conn;
    }

    public  int[] getTodayStatsByDoctorId(int doctorId) throws SQLException {
        String sql = "SELECT status, COUNT(*) as count FROM Appointments "+
                "WHERE doctor_id = ? AND CAST(appointment_date AS DATE) = ? GROUP BY status";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, doctorId);
        ps.setDate(2, Date.valueOf(LocalDate.now()));
        ResultSet rs = ps.executeQuery();

        int[] stats = new int[4]; //[Pending, Confirmed, Complete, Cancelled]
        while (rs.next()) {
            switch (rs.getString("status")) {
                case "Pending": stats[0] = rs.getInt("count"); break;
                case "Confirmed": stats[1] = rs.getInt("count"); break;
                case "Completed": stats[2] = rs.getInt("count"); break;
                case "Cancelled": stats[3] = rs.getInt("count"); break;
            }
        }
        return stats;
    }

    public List<Appointment> getAppointmentsByDoctorId(int doctorId) throws SQLException {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, p.full_name FROM Appointments a " +
                "JOIN Patients p ON a.patient_id = p.patient_id " +
                "WHERE a.doctor_id = ? ORDER BY a.appointment_date ASC";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, doctorId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Appointment a = new Appointment();
            a.setAppointmentId(rs.getInt("appointment_id"));
            a.setDoctorId(rs.getInt("doctor_id"));
            a.setPatientId(rs.getInt("patient_id"));
            a.setAppointmentDate(rs.getTimestamp("appointment_date").toLocalDateTime());
            a.setStatus(rs.getString("status"));
            a.setPatientName(rs.getString("full_name"));
            list.add(a);
        }
        return list;
    }

    public Appointment getAppointmentsDetailById(int appointmentId) throws SQLException {
        String sql = "SELECT a.*, p.full_name, p.email, p.phone FROM Appointments a " +
                "JOIN Patients p ON a.patient_id = p.patient_id WHERE a.appointment_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("appointment_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setDoctorId(rs.getInt("doctor_id"));

                Timestamp ts = rs.getTimestamp("appointment_date");
                a.setAppointmentDate(ts != null ? ts.toLocalDateTime() : null);

                a.setStatus(rs.getString("status"));
                a.setPatientName(rs.getString("full_name"));
                a.setPatientEmail(rs.getString("email"));
                a.setPatientPhone(rs.getString("phone"));
                return a;
            }
        }
        return null;
    }

    public boolean updateStatus(int appointmentId, String newStatus) throws SQLException {
        String sql = "UPDATE appointments SET status = ? WHERE appointment_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, appointmentId);
            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        }
    }

    public void createAppointment(int patientId, int doctorId, LocalDateTime date, String status) throws SQLException {
        String sql = "INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, created_at) VALUES (?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ps.setInt(2, doctorId);
            ps.setTimestamp(3, Timestamp.valueOf(date));
            ps.setString(4, status);
            ps.executeUpdate();
        }
    }
}
