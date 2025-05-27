package view;

import model.Appointment;
import model.Patient;

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

    // Lấy danh sách lịch hẹn theo doctorId
    public List<Appointment> getAppointmentsByDoctorId(int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, p.insurance_number, p.full_name " +
                "FROM Appointments a JOIN Patients p ON a.patient_id = p.patient_id " +
                "WHERE a.doctor_id = ? ORDER BY a.appointment_date ASC";
        try (Connection conn = getConn();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, doctorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    appointments.add(mapResultSetToAppointment(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }

    // Helper method để map ResultSet thành Appointment object
    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Timestamp appointmentDateTs = rs.getTimestamp("appointment_date");
        Timestamp createdAtTs = rs.getTimestamp("created_at");
        Timestamp updatedAtTs = rs.getTimestamp("updated_at");

        return Appointment.builder()
                .appointmentId(rs.getInt("appointment_id"))
                .patientId(rs.getInt("patient_id"))
                .doctorId(rs.getInt("doctor_id"))
                .appointmentDate(rs.getDate("appointment_date"))
                .appointmentType(rs.getString("appointment_type"))
                .status(rs.getString("status"))
                .createdAt(rs.getDate("created_at"))
                .updatedAt(rs.getDate("updated_at"))
                .insuranceNumber(rs.getString("insurance_number"))  // Lấy trường mới
                .patientFullName(rs.getString("full_name"))        // Lấy trường mới
                .build();
    }

    @Override
    public List<Appointment> select() {
        throw new UnsupportedOperationException("Not implemented yet");
    }

    @Override
    public Appointment select(int... id) {
        throw new UnsupportedOperationException("Not implemented yet");
    }

    @Override
    public int insert(Appointment appointment) {
        String sql = "INSERT INTO Appointments (patient_id, doctor_id, appointment_type, appointment_date, status, created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointment.getPatientId());
            ps.setInt(2, appointment.getDoctorId());
            ps.setString(3, appointment.getAppointmentType());

            if (appointment.getAppointmentDate() != null) {
                ps.setTimestamp(4, new Timestamp(appointment.getAppointmentDate().getTime()));
            } else {
                ps.setTimestamp(4, null);
            }

            ps.setString(5, appointment.getStatus());

            if (appointment.getCreatedAt() != null) {
                ps.setTimestamp(6, new Timestamp(appointment.getCreatedAt().getTime()));
            } else {
                ps.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
            }

            if (appointment.getUpdatedAt() != null) {
                ps.setTimestamp(7, new Timestamp(appointment.getUpdatedAt().getTime()));
            } else {
                ps.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
            }

            return ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int update(Appointment obj) {
        throw new UnsupportedOperationException("Not implemented yet");
    }

    @Override
    public int delete(int... id) {
        throw new UnsupportedOperationException("Not implemented yet");
    }

    public boolean updateStatus(int appointmentId, String status) {
        String sql = "UPDATE Appointments SET status = ? WHERE appointment_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, appointmentId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Appointment getAppointmentDetailById(int appointmentId) {
        String sql = "SELECT a.*, p.patient_id, p.username, p.password_hash, p.full_name, p.dob, p.gender, " +
                "p.email, p.phone, p.address, p.insurance_number, p.emergency_contact " +
                "FROM Appointments a JOIN Patients p ON a.patient_id = p.patient_id " +
                "WHERE a.appointment_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Appointment a = mapResultSetToAppointment(rs);

                    Patient patient = Patient.builder()
                            .patientId(rs.getInt("patient_id"))
                            .username(rs.getString("username"))
                            .passwordHash(rs.getString("password_hash"))
                            .fullName(rs.getString("full_name"))
                            .dob(rs.getDate("dob"))
                            .gender(rs.getString("gender"))
                            .email(rs.getString("email"))
                            .phone(rs.getString("phone"))
                            .address(rs.getString("address"))
                            .insuranceNumber(rs.getString("insurance_number"))
                            .emergencyContact(rs.getString("emergency_contact"))
                            .build();

                    a.setPatient(patient);

                    return a;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }


}

//
//import model.Appointment;
//
//import java.sql.*;
//import java.time.LocalDate;
//import java.time.LocalDateTime;
//import java.util.ArrayList;
//import java.util.List;
//
//public class AppointmentDAO extends DBContext<Appointment> {
//
//    public void createAppointment(Appointment appointment) throws SQLException {
//        String query = "INSERT INTO Appointments (patient_id, appointment_date, appointment_type, status, created_at) VALUES (?, ?, ?, ?, GETDATE())";
//        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
//            stmt.setInt(1, appointment.getPatientId());
//            stmt.setTimestamp(2, Timestamp.valueOf(appointment.getAppointmentDate()));
//            stmt.setString(3, appointment.getAppointmentType());
//            stmt.setString(4, appointment.getStatus());
//            stmt.executeUpdate();
//        }
//    }
//
//    public List<Appointment> getAppointmentsByPatientId(int patientId) {
//        List<Appointment> list = new ArrayList<>();
//        String sql = "SELECT * FROM Appointments WHERE patient_id = ? ORDER BY appointment_date DESC";
//        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, patientId);
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                list.add(mapResultSet(rs));
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//
//
//    // CRUD methods
//    @Override
//    public List<Appointment> select() {
//        List<Appointment> list = new ArrayList<>();
//        String sql = "SELECT * FROM Appointments";
//        try (Connection conn = getConn();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) {
//                Appointment a = mapResultSet(rs);
//                list.add(a);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//
//    @Override
//    public Appointment select(int... id) {
//        if (id.length < 1) return null;
//        String sql = "SELECT * FROM Appointments WHERE appointment_id = ?";
//        try (Connection conn = getConn();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, id[0]);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                return mapResultSet(rs);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//
//    // Insert a new appointment (used by BookAppointmentServlet)
//    @Override
//    public int insert(Appointment appointment) {
//        String query = "INSERT INTO Appointments (patient_id, appointment_date, appointment_type, status, created_at) VALUES (?, ?, ?, ?, GETDATE())";
//        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
//            stmt.setInt(1, appointment.getPatientId());
//            stmt.setTimestamp(2, Timestamp.valueOf(appointment.getAppointmentDate()));
//            stmt.setString(3, appointment.getAppointmentType());
//            stmt.setString(4, appointment.getStatus());
//            return stmt.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return 0;
//        }
//    }
//
//    // Update an existing appointment
//    @Override
//    public int update(Appointment appointment) {
//        String query = "UPDATE Appointments SET appointment_date = ?, appointment_type = ?, updated_at = GETDATE() WHERE appointment_id = ?";
//        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
//            stmt.setTimestamp(1, Timestamp.valueOf(appointment.getAppointmentDate()));
//            stmt.setString(2, appointment.getAppointmentType());
//            stmt.setInt(3, appointment.getAppointmentId());
//            return stmt.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return 0;
//        }
//    }
//
//    @Override
//    public int delete(int... id) {
//        if (id.length < 1) return 0;
//        String sql = "DELETE FROM Appointments WHERE appointment_id = ?";
//        try (Connection conn = getConn();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, id[0]);
//            return ps.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return 0;
//    }
//
//    // Custom methods
//
//    public int[] getTodayStatsByDoctorId(int doctorId) {
//        int[] stats = new int[4];
//        String sql = "SELECT status, COUNT(*) as count FROM Appointments " +
//                "WHERE doctor_id = ? AND CAST(appointment_date AS DATE) = ? GROUP BY status";
//        try (Connection conn = getConn();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, doctorId);
//            ps.setDate(2, Date.valueOf(LocalDate.now()));
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                switch (rs.getString("status")) {
//                    case "Pending" -> stats[0] = rs.getInt("count");
//                    case "Confirmed" -> stats[1] = rs.getInt("count");
//                    case "Completed" -> stats[2] = rs.getInt("count");
//                    case "Cancelled" -> stats[3] = rs.getInt("count");
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return stats;
//    }
//
//    public List<Appointment> getAppointmentsByDoctorId(int doctorId) {
//        List<Appointment> list = new ArrayList<>();
//        String sql = "SELECT * FROM Appointments WHERE doctor_id = ? ORDER BY appointment_date ASC";
//        try (Connection conn = getConn();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, doctorId);
//            ResultSet rs = ps.executeQuery();
//
//            while (rs.next()) {
//                Timestamp apptDate = rs.getTimestamp("appointment_date");
//                Timestamp createdAt = rs.getTimestamp("created_at");
//                Timestamp updatedAt = rs.getTimestamp("updated_at");
//
//                Appointment appt = Appointment.builder()
//                        .appointmentId(rs.getInt("appointment_id"))
//                        .patientId(rs.getInt("patient_id"))
//                        .doctorId(rs.getInt("doctor_id"))
//                        .appointmentDate(apptDate != null ? apptDate.toLocalDateTime() : null)
//                        .appointmentType(rs.getString("appointment_type"))
//                        .status(rs.getString("status"))
//                        .createdAt(createdAt != null ? createdAt.toLocalDateTime() : null)
//                        .updatedAt(updatedAt != null ? updatedAt.toLocalDateTime() : null)
//                        .build();
//
//                list.add(appt);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//
//
//    public Appointment getAppointmentById(int appointmentId) {
//        String sql = "SELECT * FROM Appointments WHERE appointment_id = ?";
//        try (Connection conn = getConn();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, appointmentId);
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                Timestamp apptDate = rs.getTimestamp("appointment_date");
//                Timestamp createdAt = rs.getTimestamp("created_at");
//                Timestamp updatedAt = rs.getTimestamp("updated_at");
//
//                return Appointment.builder()
//                        .appointmentId(rs.getInt("appointment_id"))
//                        .patientId(rs.getInt("patient_id"))
//                        .doctorId(rs.getInt("doctor_id"))
//                        .appointmentDate(apptDate != null ? apptDate.toLocalDateTime() : null)
//                        .appointmentType(rs.getString("appointment_type"))
//                        .status(rs.getString("status"))
//                        .createdAt(createdAt != null ? createdAt.toLocalDateTime() : null)
//                        .updatedAt(updatedAt != null ? updatedAt.toLocalDateTime() : null)
//                        .build();
//            }
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//
//    public boolean updateStatus(int appointmentId, String newStatus) {
//        String sql = "UPDATE Appointments SET status = ? WHERE appointment_id = ?";
//        try (Connection conn = getConn();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, newStatus);
//            ps.setInt(2, appointmentId);
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//
//    public List<Appointment> getCompletedAppointmentsByDoctor(int doctorId) {
//        List<Appointment> list = new ArrayList<>();
//        String sql = "SELECT * FROM Appointments WHERE doctor_id = ? AND status = 'Completed' ORDER BY appointment_date DESC";
//        try (Connection conn = getConn();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, doctorId);
//            ResultSet rs = ps.executeQuery();
//
//            while (rs.next()) {
//                Timestamp apptDate = rs.getTimestamp("appointment_date");
//                Timestamp createdAt = rs.getTimestamp("created_at");
//                Timestamp updatedAt = rs.getTimestamp("updated_at");
//
//                Appointment appt = Appointment.builder()
//                        .appointmentId(rs.getInt("appointment_id"))
//                        .patientId(rs.getInt("patient_id"))
//                        .doctorId(rs.getInt("doctor_id"))
//                        .appointmentDate(apptDate != null ? apptDate.toLocalDateTime() : null)
//                        .appointmentType(rs.getString("appointment_type"))
//                        .status(rs.getString("status"))
//                        .createdAt(createdAt != null ? createdAt.toLocalDateTime() : null)
//                        .updatedAt(updatedAt != null ? updatedAt.toLocalDateTime() : null)
//                        .build();
//
//                list.add(appt);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//
//
//    // Helper
//    private Appointment mapResultSet(ResultSet rs) throws SQLException {
//        Timestamp ts = rs.getTimestamp("appointment_date");
//        Timestamp created = rs.getTimestamp("created_at");
//        Timestamp updated = rs.getTimestamp("updated_at");
//
//        return Appointment.builder()
//                .appointmentId(rs.getInt("appointment_id"))
//                .patientId(rs.getInt("patient_id"))
//                .doctorId(rs.getInt("doctor_id"))
//                .appointmentType(rs.getString("appointment_type"))
//                .appointmentDate(ts != null ? ts.toLocalDateTime() : null)
//                .status(rs.getString("status"))
//                .createdAt(created != null ? created.toLocalDateTime() : null)
//                .updatedAt(updated != null ? updated.toLocalDateTime() : null)
//                .build();
//    }
//
//}