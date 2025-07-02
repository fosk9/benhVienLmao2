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

    // Insert appointment and return the last inserted ID
    public int insertAndReturnID(Appointment appointment) {
        String query = "INSERT INTO Appointments (patient_id, doctor_id, appointmenttype_id, appointment_date, time_slot, requires_specialist, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, appointment.getPatientId());
                // Set doctor_id to NULL if 0 (unassigned)
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

    // Insert appointment with error handling
    @Override
    public int insert(Appointment appointment) {
        String query = "INSERT INTO Appointments (patient_id, doctor_id, appointmenttype_id, appointment_date, time_slot, requires_specialist, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, appointment.getPatientId());
                // Set doctor_id to NULL if 0 (unassigned)
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

    public Appointment getAppointmentDetailById(int appointmentId) {
        String sql = "SELECT a.*, p.patient_id, p.username, p.password_hash, p.full_name, p.dob, p.gender, p.email, p.phone, p.address, p.insurance_number, p.emergency_contact FROM Appointments a JOIN Patients p ON a.patient_id = p.patient_id WHERE a.appointment_id = ?";
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