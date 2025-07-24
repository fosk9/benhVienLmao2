package view;

import dto.AppointmentDTO;
import dto.ConsultationHistoryDTO;
import dto.ExaminationHistoryDTO;
import model.Appointment;
import model.AppointmentType;
import model.Patient;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class AppointmentDAO extends DBContext<Appointment> {
    private static final Logger LOGGER = Logger.getLogger(AppointmentDAO.class.getName());

    public AppointmentDAO() {
        super();
    }

    public int transferAppointments(int oldDoctorId, int newDoctorId, Date date, String timeSlot) {
        String sql = """
                    UPDATE Appointments
                    SET doctor_id = ?
                    WHERE doctor_id = ? AND appointment_date = ? AND time_slot = ?
                """;
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newDoctorId);
            ps.setInt(2, oldDoctorId);
            ps.setDate(3, date);
            ps.setString(4, timeSlot);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<AppointmentDTO> getAppointmentsByDoctorAndDate(int doctorId, Date date, List<String> statusList) {
        List<AppointmentDTO> list = new ArrayList<>();

        // Tạo chuỗi dấu hỏi (?) theo số lượng status
        String placeholders = String.join(",", statusList.stream().map(s -> "?").toArray(String[]::new));

        String sql = """
                SELECT 
                    a.appointment_id,
                    a.appointment_date,
                    a.time_slot,
                    a.status,
                    p.full_name AS patient_name,
                    t.type_name AS appointment_type
                FROM Appointments a
                JOIN Patients p ON a.patient_id = p.patient_id
                JOIN AppointmentType t ON a.appointmenttype_id = t.appointmenttype_id
                WHERE a.doctor_id = ? AND a.appointment_date = ? AND a.status IN (""" + placeholders + ")";

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ps.setDate(2, date);
            for (int i = 0; i < statusList.size(); i++) {
                ps.setString(i + 3, statusList.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AppointmentDTO dto = new AppointmentDTO();
                    dto.setAppointmentId(rs.getInt("appointment_id"));
                    dto.setAppointmentDate(rs.getDate("appointment_date"));
                    dto.setTimeSlot(rs.getString("time_slot"));
                    dto.setStatus(rs.getString("status"));
                    dto.setPatientName(rs.getString("patient_name"));
                    dto.setAppointmentType(rs.getString("appointment_type"));
                    list.add(dto);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // 3. Đếm số lịch hẹn hôm nay
    public int countAppointmentsToday() {
        String sql = "SELECT COUNT(*) FROM Appointments WHERE CAST(appointment_date AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }


    // 4. Đếm số lịch hẹn hôm nay đang Pending
    public int countPendingAppointmentsToday() {
        String sql = "SELECT COUNT(*) FROM Appointments WHERE status = 'Pending'";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 5. Kiểm tra bác sĩ có lịch trong khung giờ hôm nay
    public boolean hasAppointment(int doctorId, Date date, String timeSlot) {
        String sql = """
                    SELECT 1 FROM Appointments 
                    WHERE doctor_id = ? AND appointment_date = ? AND time_slot = ?
                """;
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.setDate(2, date);
            ps.setString(3, timeSlot);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // true nếu có ít nhất 1 lịch
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get appointments by patient ID
    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointments WHERE patient_id = ? ORDER BY appointment_date DESC";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, patientId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    list.add(mapResultSetToAppointment(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching appointments for patient_id=" + patientId + ": " + e.getMessage());
            throw new RuntimeException("Failed to fetch appointments", e);
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    // Select all appointments
    @Override
    public List<Appointment> select() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointments";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToAppointment(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error selecting all appointments: " + e.getMessage());
            throw new RuntimeException("Failed to select appointments", e);
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    // Select appointment by ID
    @Override
    public Appointment select(int... id) {
        if (id.length < 1) return null;
        String sql = "SELECT * FROM Appointments WHERE appointment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id[0]);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    return mapResultSetToAppointment(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error selecting appointment with id=" + id[0] + ": " + e.getMessage());
            throw new RuntimeException("Failed to select appointment", e);
        } finally {
            closeConnection(conn);
        }
        return null;
    }

    // Insert appointment and return generated ID
    public int insertAndReturnID(Appointment appointment) {
        String query = "INSERT INTO Appointments (patient_id, doctor_id, appointmenttype_id, appointment_date, time_slot, requires_specialist, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, appointment.getPatientId());
                if (appointment.getDoctorId() == 0) {
                    stmt.setNull(2, Types.INTEGER);
                } else {
                    stmt.setInt(2, appointment.getDoctorId());
                }
                stmt.setInt(3, appointment.getAppointmentTypeId());
                stmt.setDate(4, appointment.getAppointmentDate());
                stmt.setString(5, appointment.getTimeSlot());
                stmt.setBoolean(6, appointment.isRequiresSpecialist());
                stmt.setString(7, appointment.getStatus());
                stmt.setTimestamp(8, appointment.getCreatedAt());
                stmt.setTimestamp(9, appointment.getUpdatedAt());
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected == 0) {
                    LOGGER.severe("Failed to insert appointment: No rows affected for patient_id=" + appointment.getPatientId());
                    throw new RuntimeException("Failed to insert appointment: No rows affected");
                }
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int newId = generatedKeys.getInt(1);
                        LOGGER.info("Inserted appointment for patient_id=" + appointment.getPatientId() + ", new appointment_id=" + newId);
                        return newId;
                    } else {
                        LOGGER.severe("Failed to retrieve generated appointment_id after insert");
                        throw new RuntimeException("Failed to retrieve appointment ID after insert");
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("SQL Insert Exception for patient_id=" + appointment.getPatientId() + ": " + e.getMessage());
            throw new RuntimeException("Failed to insert appointment: " + e.getMessage(), e);
        } finally {
            closeConnection(conn);
        }
    }

    // Search and sort appointments with pagination, including AppointmentType data
    public List<Appointment> searchAndSortAppointments(int patientId, String appointmentDate, String timeSlot,
                                                       Integer appointmentTypeId, Boolean requiresSpecialist, String status,
                                                       String sortBy, String sortDir, int page, int pageSize) {
        List<Appointment> appointments = new ArrayList<>();
        // Log search parameters for debugging
        LOGGER.info("Searching appointments for patient_id=" + patientId +
                ", appointmentDate=" + appointmentDate +
                ", timeSlot=" + timeSlot +
                ", appointmentTypeId=" + appointmentTypeId +
                ", requiresSpecialist=" + requiresSpecialist +
                ", status=" + status +
                ", sortBy=" + sortBy +
                ", sortDir=" + sortDir +
                ", page=" + page +
                ", pageSize=" + pageSize);

        // Build SQL query to include AppointmentType data
        StringBuilder sql = new StringBuilder("SELECT a.*, at.type_name, at.description, at.price ");
        sql.append("FROM Appointments a ");
        sql.append("LEFT JOIN AppointmentType at ON a.appointmenttype_id = at.appointmenttype_id ");
        sql.append("WHERE a.patient_id = ?");

        // Add search filters
        List<Object> params = new ArrayList<>();
        params.add(patientId);

        if (appointmentDate != null && !appointmentDate.isEmpty()) {
            sql.append(" AND a.appointment_date = ?");
            params.add(Date.valueOf(appointmentDate));
        }

        if (timeSlot != null && !timeSlot.isEmpty()) {
            sql.append(" AND a.time_slot = ?");
            params.add(timeSlot);
        }

        if (appointmentTypeId != null) {
            sql.append(" AND a.appointmenttype_id = ?");
            params.add(appointmentTypeId);
        }

        if (requiresSpecialist != null) {
            sql.append(" AND a.requires_specialist = ?");
            params.add(requiresSpecialist);
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND a.status = ?");
            params.add(status);
        }

        // Add sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            switch (sortBy) {
                case "typeName":
                    sql.append(" ORDER BY at.type_name");
                    break;
                case "createdAt":
                    sql.append(" ORDER BY a.created_at");
                    break;
                case "appointmentDate":
                    sql.append(" ORDER BY a.appointment_date");
                    break;
                case "status":
                    sql.append(" ORDER BY a.status");
                    break;
                default:
                    sql.append(" ORDER BY a.created_at"); // Default to newest first
            }
            if (sortDir != null && sortDir.equalsIgnoreCase("DESC")) {
                sql.append(" DESC");
            } else {
                sql.append(" ASC");
            }
        } else {
            sql.append(" ORDER BY a.created_at DESC"); // Default to newest first
        }

        // Add pagination
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        // Log the generated SQL query
        LOGGER.fine("Executing SQL: " + sql.toString() + " with params: " + params);

        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                // Set parameters
                for (int i = 0; i < params.size(); i++) {
                    ps.setObject(i + 1, params.get(i));
                }

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Appointment appointment = mapResultSetToAppointment(rs);
                        // Map AppointmentType data from the same ResultSet
                        AppointmentType type = AppointmentType.builder()
                                .appointmentTypeId(rs.getInt("appointmenttype_id"))
                                .typeName(rs.getString("type_name"))
                                .description(rs.getString("description"))
                                .price(rs.getBigDecimal("price"))
                                .build();
                        appointment.setAppointmentType(type);
                        appointments.add(appointment);
                    }
                    LOGGER.info("Found " + appointments.size() + " appointments for patient_id=" + patientId);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error searching/sorting appointments for patient_id=" + patientId + ": " + e.getMessage());
            throw new RuntimeException("Failed to search appointments", e);
        } finally {
            closeConnection(conn);
        }
        return appointments;
    }

    // Count filtered appointments for pagination
    public int countFilteredAppointments(int patientId, String appointmentDate, String timeSlot,
                                         Integer appointmentTypeId, Boolean requiresSpecialist, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Appointments a ");
        sql.append("LEFT JOIN AppointmentType at ON a.appointmenttype_id = at.appointmenttype_id ");
        sql.append("WHERE a.patient_id = ?");

        List<Object> params = new ArrayList<>();
        params.add(patientId);

        if (appointmentDate != null && !appointmentDate.isEmpty()) {
            sql.append(" AND a.appointment_date = ?");
            params.add(Date.valueOf(appointmentDate));
        }

        if (timeSlot != null && !timeSlot.isEmpty()) {
            sql.append(" AND a.time_slot = ?");
            params.add(timeSlot);
        }

        if (appointmentTypeId != null) {
            sql.append(" AND a.appointmenttype_id = ?");
            params.add(appointmentTypeId);
        }

        if (requiresSpecialist != null) {
            sql.append(" AND a.requires_specialist = ?");
            params.add(requiresSpecialist);
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND a.status = ?");
            params.add(status);
        }

        // Log the count query
        LOGGER.fine("Executing count SQL: " + sql.toString() + " with params: " + params);

        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    ps.setObject(i + 1, params.get(i));
                }
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int count = rs.getInt(1);
                        LOGGER.info("Counted " + count + " appointments for patient_id=" + patientId);
                        return count;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error counting appointments for patient_id=" + patientId + ": " + e.getMessage());
            throw new RuntimeException("Failed to count appointments", e);
        } finally {
            closeConnection(conn);
        }
        return 0;
    }

    // Insert appointment
    @Override
    public int insert(Appointment appointment) {
        String query = "INSERT INTO Appointments (patient_id, doctor_id, appointmenttype_id, appointment_date, time_slot, requires_specialist, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, appointment.getPatientId());
                if (appointment.getDoctorId() == 0) {
                    stmt.setNull(2, Types.INTEGER);
                } else {
                    stmt.setInt(2, appointment.getDoctorId());
                }
                stmt.setInt(3, appointment.getAppointmentTypeId());
                stmt.setDate(4, appointment.getAppointmentDate());
                stmt.setString(5, appointment.getTimeSlot());
                stmt.setBoolean(6, appointment.isRequiresSpecialist());
                stmt.setString(7, appointment.getStatus());
                stmt.setTimestamp(8, appointment.getCreatedAt());
                stmt.setTimestamp(9, appointment.getUpdatedAt());
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected == 0) {
                    LOGGER.severe("Failed to insert appointment: No rows affected for patient_id=" + appointment.getPatientId());
                    throw new RuntimeException("Failed to insert appointment: No rows affected");
                }
                LOGGER.info("Inserted appointment for patient_id=" + appointment.getPatientId());
                return rowsAffected;
            }
        } catch (SQLException e) {
            LOGGER.severe("SQL Insert Exception for patient_id=" + appointment.getPatientId() + ": " + e.getMessage());
            throw new RuntimeException("Failed to insert appointment: " + e.getMessage(), e);
        } finally {
            closeConnection(conn);
        }
    }

    // Update appointment
    @Override
    public int update(Appointment appointment) {
        String query = "UPDATE Appointments SET patient_id = ?, doctor_id = ?, appointmenttype_id = ?, appointment_date = ?, time_slot = ?, requires_specialist = ?, status = ?, updated_at = ? WHERE appointment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, appointment.getPatientId());
                if (appointment.getDoctorId() == 0) {
                    stmt.setNull(2, Types.INTEGER);
                } else {
                    stmt.setInt(2, appointment.getDoctorId());
                }
                stmt.setInt(3, appointment.getAppointmentTypeId());
                stmt.setDate(4, appointment.getAppointmentDate());
                stmt.setString(5, appointment.getTimeSlot());
                stmt.setBoolean(6, appointment.isRequiresSpecialist());
                stmt.setString(7, appointment.getStatus());
                stmt.setTimestamp(8, appointment.getUpdatedAt());
                stmt.setInt(9, appointment.getAppointmentId());
                int rowsAffected = stmt.executeUpdate();
                LOGGER.info("Updated appointment_id=" + appointment.getAppointmentId() + ", rowsAffected=" + rowsAffected);
                return rowsAffected;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error updating appointment_id=" + appointment.getAppointmentId() + ": " + e.getMessage());
            throw new RuntimeException("Failed to update appointment", e);
        } finally {
            closeConnection(conn);
        }
    }

    // Delete appointment
    @Override
    public int delete(int... id) {
        if (id.length < 1) return 0;
        String sql = "DELETE FROM Appointments WHERE appointment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id[0]);
                int rowsAffected = ps.executeUpdate();
                LOGGER.info("Deleted appointment_id=" + id[0] + ", rowsAffected=" + rowsAffected);
                return rowsAffected;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error deleting appointment_id=" + id[0] + ": " + e.getMessage());
            throw new RuntimeException("Failed to delete appointment", e);
        } finally {
            closeConnection(conn);
        }
    }

    // Get appointment by ID with type details
    public Appointment getAppointmentById(int appointmentId) {
        String sql = "SELECT a.*, at.type_name, at.description, at.price " +
                "FROM Appointments a " +
                "JOIN AppointmentType at ON a.appointmenttype_id = at.appointmenttype_id " +
                "WHERE a.appointment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, appointmentId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    Appointment appointment = mapResultSetToAppointment(rs);
                    AppointmentType type = AppointmentType.builder()
                            .appointmentTypeId(rs.getInt("appointmenttype_id"))
                            .typeName(rs.getString("type_name"))
                            .description(rs.getString("description"))
                            .price(rs.getBigDecimal("price"))
                            .build();
                    appointment.setAppointmentType(type);
                    return appointment;
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching appointment_id=" + appointmentId + ": " + e.getMessage());
            throw new RuntimeException("Failed to fetch appointment", e);
        } finally {
            closeConnection(conn);
        }
        return null;
    }

    // Map ResultSet to Appointment object
    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        return Appointment.builder()
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
    }

    // Insert appointment by doctor
    public int doctorInsert(Appointment appointment) {
        String query = "INSERT INTO Appointments (patient_id, doctor_id, appointmenttype_id, appointment_date, time_slot, requires_specialist, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setInt(1, appointment.getPatientId());
                if (appointment.getDoctorId() == 0) {
                    ps.setNull(2, Types.INTEGER);
                } else {
                    ps.setInt(2, appointment.getDoctorId());
                }
                ps.setInt(3, appointment.getAppointmentTypeId());
                ps.setDate(4, appointment.getAppointmentDate());
                ps.setString(5, appointment.getTimeSlot());
                ps.setBoolean(6, appointment.isRequiresSpecialist());
                ps.setString(7, appointment.getStatus());
                ps.setTimestamp(8, appointment.getCreatedAt());
                ps.setTimestamp(9, appointment.getUpdatedAt());
                int rowsAffected = ps.executeUpdate();
                if (rowsAffected == 0) {
                    LOGGER.severe("Failed to insert appointment: No rows affected for patient_id=" + appointment.getPatientId());
                    throw new RuntimeException("Failed to insert appointment: No rows affected");
                }
                LOGGER.info("Inserted appointment for patient_id=" + appointment.getPatientId() + " via doctorInsert");
                return rowsAffected;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error inserting appointment for patient_id=" + appointment.getPatientId() + ": " + e.getMessage());
            throw new RuntimeException("Failed to insert appointment", e);
        } finally {
            closeConnection(conn);
        }
    }

    // Update appointment status
    public boolean updateStatus(int appointmentId, String status) {
        String sql = "UPDATE Appointments SET status = ? WHERE appointment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, status);
                ps.setInt(2, appointmentId);
                int affectedRows = ps.executeUpdate();
                LOGGER.info("Updated status for appointment_id=" + appointmentId + " to " + status);
                return affectedRows > 0;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error updating status for appointment_id=" + appointmentId + ": " + e.getMessage());
            throw new RuntimeException("Failed to update appointment status", e);
        } finally {
            closeConnection(conn);
        }
    }

    // Get appointment details with patient info
    public Appointment getAppointmentDetailById(int appointmentId) {
        String sql = "SELECT a.*, p.patient_id, p.username, p.password_hash, p.full_name, p.dob, p.gender, p.email, p.phone, p.address, p.insurance_number, p.emergency_contact, at.appointmenttype_id, at.type_name, at.description, at.price " +
                "FROM Appointments a " +
                "JOIN Patients p ON a.patient_id = p.patient_id " +
                "LEFT JOIN AppointmentType at ON a.appointmenttype_id = at.appointmenttype_id " +
                "WHERE a.appointment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, appointmentId);
                ResultSet rs = ps.executeQuery();
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
                    // Set AppointmentType if available
                    if (rs.getObject("appointmenttype_id") != null) {
                        model.AppointmentType type = model.AppointmentType.builder()
                                .appointmentTypeId(rs.getInt("appointmenttype_id"))
                                .typeName(rs.getString("type_name"))
                                .description(rs.getString("description"))
                                .price(rs.getBigDecimal("price"))
                                .build();
                        a.setAppointmentType(type);
                    }
                    return a;
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching details for appointment_id=" + appointmentId + ": " + e.getMessage());
            throw new RuntimeException("Failed to fetch appointment details", e);
        } finally {
            closeConnection(conn);
        }
        return null;
    }

    // Get completed appointments by doctor
    public List<Appointment> getCompletedAppointmentsByDoctor(int doctorId) {
        List<Appointment> completedAppointments = new ArrayList<>();
        String query = "SELECT a.*, p.insurance_number, p.full_name FROM Appointments a JOIN Patients p ON a.patient_id = p.patient_id WHERE a.doctor_id = ? AND a.status = 'Completed' ORDER BY a.appointment_date DESC";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, doctorId);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    completedAppointments.add(mapResultSetToAppointment(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching completed appointments for doctor_id=" + doctorId + ": " + e.getMessage());
            throw new RuntimeException("Failed to fetch completed appointments", e);
        } finally {
            closeConnection(conn);
        }
        return completedAppointments;
    }

    public List<ConsultationHistoryDTO> searchAndSortCompletedByDoctor(int doctorId, String search,
                                                                       String sortBy, String sortDir,
                                                                       int page, int recordsPerPage) {
        List<ConsultationHistoryDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                    SELECT a.appointment_id, a.appointment_date, a.time_slot,
                           t.type_name AS appointmentTypeName,
                           p.full_name AS patientName,
                           a.status
                    FROM Appointments a
                    JOIN AppointmentType t ON a.appointmenttype_id = t.appointmenttype_id
                    JOIN Patients p ON a.patient_id = p.patient_id
                    WHERE a.doctor_id = ? AND a.status = 'Completed'
                """);

        if (search != null && !search.isEmpty()) {
            sql.append("""
                        AND (
                            p.full_name LIKE ? OR 
                            a.time_slot LIKE ? OR 
                            t.type_name LIKE ?
                        )
                    """);
        }

        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY ");
            switch (sortBy) {
                case "appointment_date", "time_slot", "status" -> sql.append("a.").append(sortBy);
                case "patientName" -> sql.append("p.full_name");
                case "appointmentTypeName" -> sql.append("t.type_name");
                default -> sql.append("a.appointment_date");
            }

            if ("desc".equalsIgnoreCase(sortDir)) {
                sql.append(" DESC ");
            } else {
                sql.append(" ASC ");
            }
        } else {
            sql.append(" ORDER BY a.appointment_date DESC ");
        }

        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

        Connection conn = null;
        try {
            conn = getConn();
            PreparedStatement stmt = conn.prepareStatement(sql.toString());
            int paramIndex = 1;
            stmt.setInt(paramIndex++, doctorId);

            if (search != null && !search.isEmpty()) {
                String keyword = "%" + search.trim() + "%";
                stmt.setString(paramIndex++, keyword); // full_name
                stmt.setString(paramIndex++, keyword); // time_slot
                stmt.setString(paramIndex++, keyword); // type_name
            }

            stmt.setInt(paramIndex++, (page - 1) * recordsPerPage);
            stmt.setInt(paramIndex, recordsPerPage);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ConsultationHistoryDTO dto = ConsultationHistoryDTO.builder()
                        .appointmentId(rs.getInt("appointment_id"))
                        .appointmentDate(rs.getDate("appointment_date"))
                        .timeSlot(rs.getString("time_slot"))
                        .appointmentTypeName(rs.getString("appointmentTypeName"))
                        .patientName(rs.getString("patientName"))
                        .status(rs.getString("status"))
                        .build();
                list.add(dto);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error in searchAndSortCompletedByDoctor: " + e.getMessage());
            throw new RuntimeException("Error fetching completed appointments with search/sort", e);
        } finally {
            closeConnection(conn);
        }

        return list;
    }

    public int countSearchCompletedByDoctor(int doctorId, String search) {
        StringBuilder sql = new StringBuilder("""
                    SELECT COUNT(*)
                    FROM Appointments a
                    JOIN AppointmentType t ON a.appointmenttype_id = t.appointmenttype_id
                    JOIN Patients p ON a.patient_id = p.patient_id
                    WHERE a.doctor_id = ? AND a.status = 'Completed'
                """);

        if (search != null && !search.isEmpty()) {
            sql.append("""
                        AND (
                            p.full_name LIKE ? OR 
                            a.time_slot LIKE ? OR 
                            t.type_name LIKE ?
                        )
                    """);
        }

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, doctorId);

            if (search != null && !search.isEmpty()) {
                String keyword = "%" + search.trim() + "%";
                ps.setString(paramIndex++, keyword);
                ps.setString(paramIndex++, keyword);
                ps.setString(paramIndex++, keyword);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.severe("Error counting consultations: " + e.getMessage());
            throw new RuntimeException(e);
        }

        return 0;
    }

    public List<Patient> getPatientsByShift(int doctorId, Date shiftDate, String timeSlot) {
        List<Patient> patients = new ArrayList<>();
        String query = """
                    SELECT DISTINCT p.*
                    FROM Appointments a
                    JOIN Patients p ON a.patient_id = p.patient_id
                    WHERE a.doctor_id = ? AND a.appointment_date = ? AND a.time_slot = ?
                """;
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, doctorId);
                stmt.setDate(2, shiftDate);
                stmt.setString(3, timeSlot);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
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
                    patients.add(patient);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching patients by shift: " + e.getMessage());
            throw new RuntimeException("Failed to fetch patients by shift", e);
        } finally {
            closeConnection(conn);
        }
        return patients;
    }

    public List<ExaminationHistoryDTO> searchAndSortCompletedByPatient(int patientId, String search, String sortBy, String sortDir, int page, int recordsPerPage) {
        List<ExaminationHistoryDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                    SELECT a.appointment_id, a.appointment_date, a.time_slot,
                           t.type_name AS appointmentTypeName,
                           p.full_name AS patientName,
                           a.status
                    FROM Appointments a
                    JOIN AppointmentType t ON a.appointmenttype_id = t.appointmenttype_id
                    JOIN Patients p ON a.patient_id = p.patient_id
                    WHERE a.patient_id = ? AND a.status = 'Completed'
                """);

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (t.type_name LIKE ? OR a.time_slot LIKE ?) ");
        }

        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY ").append(switch (sortBy) {
                case "appointment_date" -> "a.appointment_date";
                case "appointment_type" -> "t.type_name";
                default -> "a.appointment_id";
            }).append(" ").append("desc".equalsIgnoreCase(sortDir) ? "DESC" : "ASC");
        } else {
            sql.append(" ORDER BY a.appointment_date DESC");
        }

        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int i = 1;
            ps.setInt(i++, patientId);
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(i++, "%" + search + "%");
                ps.setString(i++, "%" + search + "%");
            }
            ps.setInt(i++, (page - 1) * recordsPerPage);
            ps.setInt(i, recordsPerPage);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ExaminationHistoryDTO(
                            rs.getInt("appointment_id"),
                            rs.getDate("appointment_date"),
                            rs.getString("time_slot"),
                            rs.getString("appointmentTypeName"),
                            rs.getString("patientName"),
                            rs.getString("status")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countSearchCompletedByPatient(int patientId, String search) {
        StringBuilder sql = new StringBuilder("""
                    SELECT COUNT(*) FROM Appointments a
                    JOIN AppointmentType t ON a.appointmenttype_id = t.appointmenttype_id
                    WHERE a.patient_id = ? AND a.status = 'Completed'
                """);

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (t.type_name LIKE ? OR a.time_slot LIKE ?) ");
        }

        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int i = 1;
            ps.setInt(i++, patientId);
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(i++, "%" + search + "%");
                ps.setString(i, "%" + search + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Appointment> getUnassignedAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointments WHERE doctor_id IS NULL";
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

    public int assignDoctor(int appointmentId, int doctorId) {
        String sql = "UPDATE Appointments SET doctor_id = ?, updated_at = GETDATE() WHERE appointment_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

}
