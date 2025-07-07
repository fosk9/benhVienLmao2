package view;

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

    // Create a new appointment
    public void createAppointment(Appointment appointment) {
        String query = "INSERT INTO Appointments (patient_id, appointment_date, appointmenttype_id, time_slot, requires_specialist, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, appointment.getPatientId());
                stmt.setDate(2, appointment.getAppointmentDate());
                stmt.setInt(3, appointment.getAppointmentTypeId());
                stmt.setString(4, appointment.getTimeSlot());
                stmt.setBoolean(5, appointment.isRequiresSpecialist());
                stmt.setString(6, appointment.getStatus());
                stmt.setTimestamp(7, appointment.getCreatedAt());
                stmt.setTimestamp(8, appointment.getUpdatedAt());
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected == 0) {
                    LOGGER.severe("Failed to insert appointment: No rows affected for patient_id=" + appointment.getPatientId());
                    throw new RuntimeException("Failed to create appointment: No rows affected");
                }
                LOGGER.info("Created appointment for patient_id=" + appointment.getPatientId());
            }
        } catch (SQLException e) {
            LOGGER.severe("Error creating appointment for patient_id=" + appointment.getPatientId() + ": " + e.getMessage());
            throw new RuntimeException("Failed to create appointment", e);
        } finally {
            closeConnection(conn);
        }
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

    // Fetch the last appointment ID
    public int takeID() {
        String query = "SELECT TOP 1 appointment_id FROM Appointments ORDER BY appointment_id DESC";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(query);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("appointment_id");
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching last appointment ID: " + e.getMessage());
            throw new RuntimeException("Failed to fetch last appointment ID", e);
        } finally {
            closeConnection(conn);
        }
        return -1; // Return -1 if no appointments found
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

    // Get today's appointment stats by doctor ID
    public int[] getTodayStatsByDoctorId(int doctorId) {
        int[] stats = new int[4];
        String sql = "SELECT status, COUNT(*) as count FROM Appointments WHERE doctor_id = ? AND CAST(appointment_date AS DATE) = ? GROUP BY status";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
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
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching stats for doctor_id=" + doctorId + ": " + e.getMessage());
            throw new RuntimeException("Failed to fetch doctor stats", e);
        } finally {
            closeConnection(conn);
        }
        return stats;
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

    // Get appointments by doctor ID
    public List<Appointment> getAppointmentsByDoctorId(int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, p.insurance_number, p.full_name FROM Appointments a JOIN Patients p ON a.patient_id = p.patient_id WHERE a.doctor_id = ? ORDER BY a.appointment_date ASC";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, doctorId);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    appointments.add(mapResultSetToAppointment(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching appointments for doctor_id=" + doctorId + ": " + e.getMessage());
            throw new RuntimeException("Failed to fetch appointments", e);
        } finally {
            closeConnection(conn);
        }
        return appointments;
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
}
