package view;

import model.Appointment;
import model.AppointmentType;
import model.Patient;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO extends DBContext<Appointment> {
    public AppointmentDAO() {
        super();
    }

    public void createAppointment(Appointment appointment) throws SQLException {
        String query = "INSERT INTO Appointments (patient_id, appointment_date, appointmenttype_id, time_slot, requires_specialist, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, appointment.getPatientId());
            stmt.setDate(2, appointment.getAppointmentDate());
            stmt.setInt(3, appointment.getAppointmentTypeId());
            stmt.setString(4, appointment.getTimeSlot());
            stmt.setBoolean(5, appointment.isRequiresSpecialist());
            stmt.setString(6, appointment.getStatus());
            stmt.setTimestamp(7, appointment.getCreatedAt());
            stmt.setTimestamp(8, appointment.getUpdatedAt());
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
                list.add(mapResultSetToAppointment(rs));
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
                list.add(mapResultSetToAppointment(rs));
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
                return mapResultSetToAppointment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(Appointment appointment) {
        String query = "INSERT INTO Appointments (patient_id, doctor_id, appointmenttype_id, appointment_date, time_slot, requires_specialist, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, appointment.getPatientId());
            stmt.setInt(2, appointment.getDoctorId());
            stmt.setInt(3, appointment.getAppointmentTypeId());
            stmt.setDate(4, appointment.getAppointmentDate());
            stmt.setString(5, appointment.getTimeSlot());
            stmt.setBoolean(6, appointment.isRequiresSpecialist());
            stmt.setString(7, appointment.getStatus());
            stmt.setTimestamp(8, appointment.getCreatedAt());
            stmt.setTimestamp(9, appointment.getUpdatedAt());
            return stmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("SQL Insert Exception: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int update(Appointment appointment) {
        String query = "UPDATE Appointments SET patient_id = ?, doctor_id = ?, appointmenttype_id = ?, appointment_date = ?, time_slot = ?, requires_specialist = ?, status = ?, updated_at = ? WHERE appointment_id = ?";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, appointment.getPatientId());
            stmt.setInt(2, appointment.getDoctorId());
            stmt.setInt(3, appointment.getAppointmentTypeId());
            stmt.setDate(4, appointment.getAppointmentDate());
            stmt.setString(5, appointment.getTimeSlot());
            stmt.setBoolean(6, appointment.isRequiresSpecialist());
            stmt.setString(7, appointment.getStatus());
            stmt.setTimestamp(8, appointment.getUpdatedAt());
            stmt.setInt(9, appointment.getAppointmentId());
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
                return mapResultSetToAppointment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Appointment appointment = Appointment.builder()
                .appointmentId(rs.getInt("appointment_id"))
                .patientId(rs.getInt("patient_id"))
                .doctorId(rs.getInt("doctor_id"))
                .appointmentTypeId(rs.getInt("appointmenttype_id"))
                .appointmentDate(rs.getDate("appointment_date"))
                .timeSlot(rs.getString("time_slot"))
                .requiresSpecialist(rs.getBoolean("requires_specialist"))
                .status(rs.getString("status"))
                .createdAt(rs.getTimestamp("created_at"))
                .updatedAt(rs.getTimestamp("updated_at"))
                .build();

        System.out.println("Mapped Appointment: " + appointment.getAppointmentId());

        // Lấy thông tin Patient từ ResultSet và gán vào Appointment
        Patient patient = mapResultSetToPatient(rs);
        appointment.setPatient(patient);  // Gán đối tượng Patient vào Appointment

        // Lấy thông tin AppointmentType từ ResultSet và gán vào Appointment
        AppointmentType appointmentType = mapResultSetToAppointmentType(rs);
        appointment.setAppointmentType(appointmentType);  // Gán đối tượng AppointmentType vào Appointment

        return appointment;
    }
    private Patient mapResultSetToPatient(ResultSet rs) throws SQLException {
        return Patient.builder()
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
                .patientAvaUrl(rs.getString("patient_ava_url") != null ? rs.getString("patient_ava_url") : "")
                .build();
    }

    // Phương thức ánh xạ AppointmentType từ ResultSet
    private AppointmentType mapResultSetToAppointmentType(ResultSet rs) throws SQLException {
        return AppointmentType.builder()
                .appointmentTypeId(rs.getInt("appointmenttype_id"))
                .typeName(rs.getString("type_name"))
                .description(rs.getString("description"))
                .price(rs.getBigDecimal("price"))
                .build();
    }

    // Helper
    private Appointment mapResultSet(ResultSet rs) throws SQLException {
        return mapResultSetToAppointment(rs);
    }

    //PhongLPH
    public List<Appointment> getAppointmentsByDoctorId(int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, p.insurance_number, p.full_name, at.type_name, at.description, at.price " +
                "FROM Appointments a " +
                "JOIN Patients p ON a.patient_id = p.patient_id " +
                "JOIN AppointmentType at ON a.appointmenttype_id = at.appointmenttype_id " +
                "WHERE a.doctor_id = ? " +
                "ORDER BY a.appointment_date DESC";
        try (Connection conn = getConn();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, doctorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    System.out.println("appointment_id: " + rs.getInt("appointment_id"));
                    System.out.println("patient_id: " + rs.getInt("patient_id"));
                    System.out.println("doctor_id: " + rs.getInt("doctor_id"));
                    Appointment appointment = new Appointment();
                    appointment.setAppointmentId(rs.getInt("appointment_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setAppointmentDate(rs.getDate("appointment_date"));
                    appointment.setTimeSlot(rs.getString("time_slot"));
                    appointment.setRequiresSpecialist(rs.getBoolean("requires_specialist"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setCreatedAt(rs.getTimestamp("created_at"));
                    appointment.setUpdatedAt(rs.getTimestamp("updated_at"));

                    // Lấy thông tin bệnh nhân và loại cuộc hẹn
                    Patient patient = new Patient();
                    patient.setFullName(rs.getString("full_name"));
                    patient.setInsuranceNumber(rs.getString("insurance_number"));
                    appointment.setPatient(patient);

                    AppointmentType appointmentType = new AppointmentType();
                    appointmentType.setTypeName(rs.getString("type_name"));
                    appointment.setAppointmentType(appointmentType);

                    appointments.add(appointment);

                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }

    public List<Appointment> searchAppointments(int doctorId, String fullName, String insuranceNumber, String typeName, String timeSlot) {
        List<Appointment> appointments = new ArrayList<>();
        // Xây dựng câu truy vấn với các điều kiện linh hoạt
        StringBuilder query = new StringBuilder(
                "SELECT a.*, p.insurance_number, p.full_name, at.type_name, at.description, at.price " +
                        "FROM Appointments a " +
                        "JOIN Patients p ON a.patient_id = p.patient_id " +
                        "JOIN AppointmentType at ON a.appointmenttype_id = at.appointmenttype_id " +
                        "WHERE a.doctor_id = ?"
        );

        // Điều kiện tìm kiếm
        if (fullName != null && !fullName.isEmpty()) {
            query.append(" AND p.full_name LIKE ?");
        }
        if (insuranceNumber != null && !insuranceNumber.isEmpty()) {
            query.append(" AND p.insurance_number LIKE ?");
        }
        if (typeName != null && !typeName.isEmpty()) {
            query.append(" AND at.type_name LIKE ?");
        }
        if (timeSlot != null && !timeSlot.isEmpty()) {
            query.append(" AND a.time_slot LIKE ?");
        }

        query.append(" ORDER BY a.appointment_date DESC");

        try (Connection conn = getConn();
             PreparedStatement stmt = conn.prepareStatement(query.toString())) {

            stmt.setInt(1, doctorId);

            // Thiết lập các tham số tìm kiếm (nếu có)
            int index = 2;  // Bắt đầu từ vị trí tham số thứ hai vì tham số đầu tiên là doctorId
            if (fullName != null && !fullName.isEmpty()) {
                stmt.setString(index++, "%" + fullName + "%");
            }
            if (insuranceNumber != null && !insuranceNumber.isEmpty()) {
                stmt.setString(index++, "%" + insuranceNumber + "%");
            }
            if (typeName != null && !typeName.isEmpty()) {
                stmt.setString(index++, "%" + typeName + "%");
            }
            if (timeSlot != null && !timeSlot.isEmpty()) {
                stmt.setString(index++, "%" + timeSlot + "%");
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setAppointmentId(rs.getInt("appointment_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setAppointmentDate(rs.getDate("appointment_date"));
                    appointment.setTimeSlot(rs.getString("time_slot"));
                    appointment.setRequiresSpecialist(rs.getBoolean("requires_specialist"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setCreatedAt(rs.getTimestamp("created_at"));
                    appointment.setUpdatedAt(rs.getTimestamp("updated_at"));

                    // Lấy thông tin bệnh nhân và loại cuộc hẹn
                    Patient patient = new Patient();
                    patient.setFullName(rs.getString("full_name"));
                    patient.setInsuranceNumber(rs.getString("insurance_number"));
                    appointment.setPatient(patient);

                    AppointmentType appointmentType = new AppointmentType();
                    appointmentType.setTypeName(rs.getString("type_name"));
                    appointment.setAppointmentType(appointmentType);

                    appointments.add(appointment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return appointments;
    }


    //PhongLPH
    public int doctorInsert(Appointment appointment) {
        String sql = "INSERT INTO Appointments (patient_id, doctor_id, appointmenttype_id, appointment_date, time_slot, requires_specialist, status, created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointment.getPatientId());
            ps.setInt(2, appointment.getDoctorId());
            ps.setInt(3, appointment.getAppointmentTypeId());
            ps.setDate(4, appointment.getAppointmentDate());
            ps.setString(5, appointment.getTimeSlot());
            ps.setBoolean(6, appointment.isRequiresSpecialist());
            ps.setString(7, appointment.getStatus());
            ps.setTimestamp(8, appointment.getCreatedAt());
            ps.setTimestamp(9, appointment.getUpdatedAt());

            return ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
    //PhongLPH
    public boolean updateAppointmentByDoctor(int appointmentId,
                                             String fullName, String dob, String gender,
                                             String phone, String address, String insuranceNumber,
                                             String emergencyContact, String status, String appointmentDate,
                                             int appointmentTypeId, String typeDescription) {

        String sql = """
                    UPDATE Appointments
                    SET appointment_date = ?, status = ?, appointmenttype_id = ?, updated_at = GETDATE()
                    WHERE appointment_id = ?;
                
                    UPDATE Patients
                    SET full_name = ?, dob = ?, gender = ?, phone = ?, address = ?, 
                        insurance_number = ?, emergency_contact = ?
                    WHERE patient_id = (
                        SELECT patient_id FROM Appointments WHERE appointment_id = ?
                    );
                
                    UPDATE AppointmentType
                    SET description = ?
                    WHERE appointmenttype_id = ?;
                """;

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // 1. Update Appointments
            ps.setDate(1, java.sql.Date.valueOf(appointmentDate));
            ps.setString(2, status);
            ps.setInt(3, appointmentTypeId);
            ps.setInt(4, appointmentId);

            // 2. Update Patients
            ps.setString(5, fullName);
            ps.setDate(6, java.sql.Date.valueOf(dob));
            ps.setString(7, gender);
            ps.setString(8, phone);
            ps.setString(9, address);
            ps.setString(10, insuranceNumber);
            ps.setString(11, emergencyContact);
            ps.setInt(12, appointmentId);

            // 3. Update AppointmentType
            ps.setString(13, typeDescription);
            ps.setInt(14, appointmentTypeId);

            int affected = ps.executeUpdate();
            return affected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //PhongLPH
    public Appointment getAppointmentDetailById(int appointmentId) {
        String sql = "SELECT " +
                "a.appointment_id, a.patient_id, a.doctor_id, a.appointmenttype_id, " +
                "a.appointment_date, a.time_slot, a.requires_specialist, a.status, " +
                "a.created_at, a.updated_at, " +

                "p.patient_id, p.username, p.password_hash, p.full_name, p.dob, p.gender, " +
                "p.email, p.phone, p.address, p.insurance_number, p.emergency_contact, p.patient_ava_url, " +

                "at.appointmenttype_id, at.type_name, at.description, at.price " +

                "FROM Appointments a " +
                "JOIN Patients p ON a.patient_id = p.patient_id " +
                "JOIN AppointmentType at ON a.appointmenttype_id = at.appointmenttype_id " +
                "WHERE a.appointment_id = ?";

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs); // mapping đúng, đủ cả Appointment, Patient, AppointmentType
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Appointment> getCompletedAppointmentsByDoctorId(int doctorId, String fullName, String insuranceNumber, String typeName, String timeSlot) {
        List<Appointment> appointments = new ArrayList<>();

        // Xây dựng câu truy vấn với các điều kiện linh hoạt
        StringBuilder query = new StringBuilder(
                "SELECT a.*, p.insurance_number, p.full_name, at.type_name, at.description, at.price " +
                        "FROM Appointments a " +
                        "JOIN Patients p ON a.patient_id = p.patient_id " +
                        "JOIN AppointmentType at ON a.appointmenttype_id = at.appointmenttype_id " +
                        "WHERE a.doctor_id = ? AND a.status = 'completed' "
        );

        // Điều kiện tìm kiếm
        if (fullName != null && !fullName.isEmpty()) {
            query.append("AND p.full_name LIKE ? ");
        }
        if (insuranceNumber != null && !insuranceNumber.isEmpty()) {
            query.append("AND p.insurance_number LIKE ? ");
        }
        if (typeName != null && !typeName.isEmpty()) {
            query.append("AND at.type_name LIKE ? ");
        }
        if (timeSlot != null && !timeSlot.isEmpty()) {
            query.append("AND a.time_slot LIKE ? ");
        }

        query.append("ORDER BY a.appointment_date DESC");

        try (Connection conn = getConn();
             PreparedStatement stmt = conn.prepareStatement(query.toString())) {

            int index = 1;
            stmt.setInt(index++, doctorId);  // Đặt doctorId vào tham số thứ nhất

            // Thiết lập các tham số tìm kiếm (nếu có)
            if (fullName != null && !fullName.isEmpty()) {
                stmt.setString(index++, "%" + fullName + "%");
            }
            if (insuranceNumber != null && !insuranceNumber.isEmpty()) {
                stmt.setString(index++, "%" + insuranceNumber + "%");
            }
            if (typeName != null && !typeName.isEmpty()) {
                stmt.setString(index++, "%" + typeName + "%");
            }
            if (timeSlot != null && !timeSlot.isEmpty()) {
                stmt.setString(index++, "%" + timeSlot + "%");
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setAppointmentId(rs.getInt("appointment_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setAppointmentDate(rs.getDate("appointment_date"));
                    appointment.setTimeSlot(rs.getString("time_slot"));
                    appointment.setRequiresSpecialist(rs.getBoolean("requires_specialist"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setCreatedAt(rs.getTimestamp("created_at"));
                    appointment.setUpdatedAt(rs.getTimestamp("updated_at"));

                    Patient patient = new Patient();
                    patient.setFullName(rs.getString("full_name"));
                    patient.setInsuranceNumber(rs.getString("insurance_number"));
                    appointment.setPatient(patient);

                    AppointmentType appointmentType = new AppointmentType();
                    appointmentType.setTypeName(rs.getString("type_name"));
                    appointment.setAppointmentType(appointmentType);

                    appointments.add(appointment);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return appointments;
    }
}
