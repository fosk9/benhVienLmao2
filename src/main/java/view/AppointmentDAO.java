//package view;
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