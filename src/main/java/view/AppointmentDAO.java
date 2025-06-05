package view;

import model.Appointment;
import model.Patient;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO extends DBContext<Appointment> {
    public AppointmentDAO() {
        super();
    }

    public void createAppointment(Appointment appointment) throws SQLException {
        String query = "INSERT INTO Appointments (patient_id, appointment_date, appointment_type, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, appointment.getPatientId());
            stmt.setTimestamp(2, appointment.getAppointmentDate());
            stmt.setString(3, appointment.getAppointmentType());
            stmt.setString(4, appointment.getStatus());
            stmt.setTimestamp(5, appointment.getCreatedAt());
            stmt.setTimestamp(6, appointment.getUpdatedAt());
            stmt.executeUpdate();
        }
    }

    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointments WHERE patient_id = ? ORDER BY appointment_date DESC";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Appointment> select() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointments";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Appointment a = mapResultSet(rs);
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Appointment select(int... id) {
        if (id.length < 1) return null;
        String sql = "SELECT * FROM Appointments WHERE appointment_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(Appointment appointment) {
        String query = "INSERT INTO Appointments (patient_id, doctor_id, appointment_date, appointment_type, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, appointment.getPatientId());
            if (appointment.getDoctorId() == 0) {
                stmt.setNull(2, java.sql.Types.INTEGER);
            } else {
                stmt.setInt(2, appointment.getDoctorId());
            }
            stmt.setTimestamp(3, appointment.getAppointmentDate());
            stmt.setString(4, appointment.getAppointmentType());
            stmt.setString(5, appointment.getStatus());
            stmt.setTimestamp(6, appointment.getCreatedAt());
            stmt.setTimestamp(7, appointment.getUpdatedAt());
            return stmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("SQL Insert Exception: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int update(Appointment appointment) {
        String query = "UPDATE Appointments SET appointment_date = ?, appointment_type = ?, updated_at = ? WHERE appointment_id = ?";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setTimestamp(1, appointment.getAppointmentDate());
            stmt.setString(2, appointment.getAppointmentType());
            stmt.setTimestamp(3, appointment.getUpdatedAt());
            stmt.setInt(4, appointment.getAppointmentId());
            return stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int delete(int... id) {
        if (id.length < 1) return 0;
        String sql = "DELETE FROM Appointments WHERE appointment_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int[] getTodayStatsByDoctorId(int doctorId) {
        int[] stats = new int[4];
        String sql = "SELECT status, COUNT(*) as count FROM Appointments " +
                "WHERE doctor_id = ? AND CAST(appointment_date AS DATE) = ? GROUP BY status";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.setDate(2, new Date(System.currentTimeMillis()));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                switch (rs.getString("status")) {
                    case "Pending" -> stats[0] = rs.getInt("count");
                    case "Confirmed" -> stats[1] = rs.getInt("count");
                    case "Completed" -> stats[2] = rs.getInt("count");
                    case "Cancelled" -> stats[3] = rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public Appointment getAppointmentById(int appointmentId) {
        String sql = "SELECT * FROM Appointments WHERE appointment_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Timestamp appointmentDateTs = rs.getTimestamp("appointment_date");
        Timestamp createdAtTs = rs.getTimestamp("created_at");
        Timestamp updatedAtTs = rs.getTimestamp("updated_at");

        return Appointment.builder()
                .appointmentId(rs.getInt("appointment_id"))
                .patientId(rs.getInt("patient_id"))
                .doctorId(rs.getInt("doctor_id"))
                .appointmentDate(appointmentDateTs)         // sửa ở đây
                .appointmentType(rs.getString("appointment_type"))
                .status(rs.getString("status"))
                .createdAt(createdAtTs)                      // sửa ở đây
                .updatedAt(updatedAtTs)                      // sửa ở đây
                .insuranceNumber(rs.getString("insurance_number"))
                .patientFullName(rs.getString("full_name"))
                .build();
    }

    // Helper
    private Appointment mapResultSet(ResultSet rs) throws SQLException {
        Timestamp apptDate = rs.getTimestamp("appointment_date");
        Timestamp createdAt = rs.getTimestamp("created_at");
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        return Appointment.builder()
                .appointmentId(rs.getInt("appointment_id"))
                .patientId(rs.getInt("patient_id"))
                .doctorId(rs.getInt("doctor_id"))
                .appointmentType(rs.getString("appointment_type"))
                .appointmentDate(apptDate)
                .status(rs.getString("status"))
                .createdAt(createdAt)
                .updatedAt(updatedAt)
                .build();
    }

    //PhongLPH
    public List<Appointment> getAppointmentsByDoctorId(int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, p.insurance_number, p.full_name " +
                "FROM Appointments a JOIN Patients p ON a.patient_id = p.patient_id " +
                "WHERE a.doctor_id = ? ORDER BY a.appointment_date DESC ";
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
    //PhongLPH
    public int doctorInsert(Appointment appointment) {
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
    //PhongLPH
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
    //PhongLPH
    public Appointment getAppointmentDetailById(int appointmentId) {
        String sql = "SELECT a.*, p.patient_id, p.username, p.password_hash, p.full_name, p.dob, p.gender, " +
                "p.email, p.phone, p.address, p.insurance_number, p.emergency_contact, a.appointment_type " +
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
                            .appointmentType(rs.getString("appointment_type"))
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
    //PhongLPH
    public List<Appointment> getCompletedAppointmentsByDoctor(int doctorId) {
        List<Appointment> completedAppointments = new ArrayList<>();
        String query = "SELECT a.*, p.insurance_number, p.full_name " +
                "FROM Appointments a JOIN Patients p ON a.patient_id = p.patient_id " +
                "WHERE a.doctor_id = ? AND a.status = 'Completed' " +
                "ORDER BY a.appointment_date DESC";
        try (Connection conn = getConn();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, doctorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    completedAppointments.add(mapResultSetToAppointment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return completedAppointments;
    }
    //PhongLPH
    public List<Appointment> searchAppointmentsByDoctor(int doctorId, String searchTerm)
    {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, p.insurance_number, p.full_name " +
                "FROM Appointments a " +
                "JOIN Patients p ON a.patient_id = p.patient_id " +
                "WHERE a.doctor_id = ? " +
                "AND (p.insurance_number LIKE ? " +
                "OR p.full_name LIKE ? " +
                "OR a.appointment_id LIKE ?) " +
                "ORDER BY a.appointment_date DESC";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, doctorId);
            stmt.setString(2, "%" + searchTerm + "%");  // Tìm kiếm theo mã bảo hiểm
            stmt.setString(3, "%" + searchTerm + "%");  // Tìm kiếm theo tên bệnh nhân
            stmt.setString(4, "%" + searchTerm + "%");  // Tìm kiếm theo mã cuộc hẹn
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
    //PhongLPH
    public List<Appointment> searchAppointmentsByDoctorAndFullName(int doctorId, String fullName) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, p.insurance_number, p.full_name " +
                "FROM Appointments a " +
                "JOIN Patients p ON a.patient_id = p.patient_id " +
                "WHERE a.doctor_id = ? " +
                "AND p.full_name LIKE ? " +
                "ORDER BY a.appointment_date DESC";
        try (Connection conn = getConn();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, doctorId);
            stmt.setString(2, "%" + fullName + "%");  // Tìm kiếm theo tên bệnh nhân
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
    //PhongLPH
    public List<Appointment> searchAppointmentsByDoctorAndInsuranceNumber(int doctorId, String insuranceNumber) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, p.insurance_number, p.full_name " +
                "FROM Appointments a " +
                "JOIN Patients p ON a.patient_id = p.patient_id " +
                "WHERE a.doctor_id = ? " +
                "AND p.insurance_number LIKE ? " +  // Tìm kiếm theo mã bảo hiểm
                "ORDER BY a.appointment_date DESC";
        try (Connection conn = getConn();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, doctorId);
            stmt.setString(2, "%" + insuranceNumber + "%");  // Tìm kiếm theo mã bảo hiểm
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
    //PhongLPH
    public List<Appointment> searchAppointmentsByDoctorAndAppointmentType(int doctorId, String appointmentType) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, p.insurance_number, p.full_name " +
                "FROM Appointments a " +
                "JOIN Patients p ON a.patient_id = p.patient_id " +
                "WHERE a.doctor_id = ? " +
                "AND a.appointment_type LIKE ? " +  // Tìm kiếm theo loại cuộc hẹn
                "ORDER BY a.appointment_date DESC";
        try (Connection conn = getConn();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, doctorId);
            stmt.setString(2, "%" + appointmentType + "%");  // Sử dụng loại cuộc hẹn đã chọn
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
    //PhongLPH
    public List<Appointment> searchCompletedAppointmentsByDoctorAndFullName(int doctorId, String fullName) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, p.insurance_number, p.full_name " +
                "FROM Appointments a " +
                "JOIN Patients p ON a.patient_id = p.patient_id " +
                "WHERE a.doctor_id = ? " +
                "AND p.full_name LIKE ? " +
                "AND a.status = 'Completed' " + // Thêm điều kiện status = 'Completed'
                "ORDER BY a.appointment_date DESC";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, doctorId);
            stmt.setString(2, "%" + fullName + "%");
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
    //PhongLPH
    public List<Appointment> searchCompletedAppointmentsByDoctorAndInsuranceNumber(int doctorId, String insuranceNumber) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, p.insurance_number, p.full_name " +
                "FROM Appointments a " +
                "JOIN Patients p ON a.patient_id = p.patient_id " +
                "WHERE a.doctor_id = ? " +
                "AND p.insurance_number LIKE ? " +
                "AND a.status = 'Completed' " + // Thêm điều kiện status = 'Completed'
                "ORDER BY a.appointment_date DESC";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, doctorId);
            stmt.setString(2, "%" + insuranceNumber + "%");
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
    //PhongLPH
    public List<Appointment> searchCompletedAppointmentsByDoctorAndAppointmentType(int doctorId, String appointmentType) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, p.insurance_number, p.full_name " +
                "FROM Appointments a " +
                "JOIN Patients p ON a.patient_id = p.patient_id " +
                "WHERE a.doctor_id = ? " +
                "AND a.appointment_type LIKE ? " +
                "AND a.status = 'Completed' " + // Thêm điều kiện status = 'Completed'
                "ORDER BY a.appointment_date DESC";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, doctorId);
            stmt.setString(2, "%" + appointmentType + "%");
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

    public boolean updateAppointmentType(int appointmentId, String appointmentType) {
        // SQL query để cập nhật loại cuộc hẹn
        String sql = "UPDATE Appointments SET appointment_type = ? WHERE appointment_id = ?";

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Cập nhật loại cuộc hẹn
            ps.setString(1, appointmentType);  // Gán giá trị appointmentType vào tham số đầu tiên
            ps.setInt(2, appointmentId);        // Gán giá trị appointmentId vào tham số thứ hai

            // Thực thi câu lệnh UPDATE và kiểm tra số lượng bản ghi bị ảnh hưởng
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;  // Nếu có ít nhất một bản ghi bị ảnh hưởng, trả về true
        } catch (SQLException e) {
            e.printStackTrace();  // In ra lỗi nếu có
            return false;         // Nếu có lỗi, trả về false
        }
    }

}

