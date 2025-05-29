package view;

import model.Patient;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO extends DBContext<Patient> {

    public List<Patient> select(int page, int pageSize) {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT * FROM Patients ORDER BY patient_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    patients.add(mapResultSetToPatient(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM Patients";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Patient> searchFilterSort(String search, String gender, String sortBy, String sortDir, int page, int pageSize) {
        List<Patient> patients = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Patients WHERE 1=1");

        if (search != null && !search.isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ?)");
        }

        if (gender != null && !gender.isEmpty()) {
            sql.append(" AND gender = ?");
        }

        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY ").append(sortBy);
            if (sortDir != null && !sortDir.isEmpty()) {
                sql.append(" ").append(sortDir);
            }
        } else {
            sql.append(" ORDER BY patient_id");
        }

        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
                ps.setString(paramIndex++, "%" + search + "%");
            }

            if (gender != null && !gender.isEmpty()) {
                ps.setString(paramIndex++, gender);
            }

            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    patients.add(mapResultSetToPatient(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return patients;
    }

    public int countFiltered(String search, String gender) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Patients WHERE 1=1");

        if (search != null && !search.isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ?)");
        }

        if (gender != null && !gender.isEmpty()) {
            sql.append(" AND gender = ?");
        }

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
                ps.setString(paramIndex++, "%" + search + "%");
            }

            if (gender != null && !gender.isEmpty()) {
                ps.setString(paramIndex++, gender);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<Patient> searchFilterSort(String search, String gender, String sortBy, String sortDir) {
        List<Patient> patients = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM Patients WHERE 1=1");

        if (search != null && !search.isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ?)");
        }

        if (gender != null && !gender.isEmpty()) {
            sql.append(" AND gender = ?");
        }

        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY ").append(sortBy);
            if (sortDir != null && !sortDir.isEmpty()) {
                sql.append(" ").append(sortDir);
            }
        }

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
                ps.setString(paramIndex++, "%" + search + "%");
            }

            if (gender != null && !gender.isEmpty()) {
                ps.setString(paramIndex++, gender);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    patients.add(mapResultSetToPatient(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return patients;
    }

    public Patient login(String username, String password) {
        String sql = "SELECT * FROM Patients WHERE username = ? AND password_hash = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPatient(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Patient getPatientByUsername(String username) {
        String query = "SELECT * FROM Patients WHERE username = ?";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
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
                        .build();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Patient getPatientByEmail(String email) {
        String query = "SELECT * FROM Patients WHERE email = ?";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
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
                        .patientAvaUrl(rs.getString("patient_ava_url")) // Lấy ảnh đại diện
                        .build();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int updatePasswordByUsername(String username, String newPasswordHash) {
        String query = "UPDATE Patients SET password_hash = ? WHERE username = ?";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, newPasswordHash);
            stmt.setString(2, username);
            return stmt.executeUpdate(); // Trả về số dòng bị ảnh hưởng
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }



    @Override
    public List<Patient> select() {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT * FROM Patients";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                patients.add(mapResultSetToPatient(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;
    }

    @Override
    public Patient select(int... id) {
        if (id.length == 0) return null;
        String sql = "SELECT * FROM Patients WHERE patient_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPatient(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(Patient patient) {
        String sql = "INSERT INTO Patients (username, password_hash, full_name, dob, gender, email, phone, address, patient_ava_url, insurance_number, emergency_contact) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setPreparedStatementFromPatient(ps, patient);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(Patient patient) {
        String sql = "UPDATE Patients SET username=?, password_hash=?, full_name=?, dob=?, gender=?, email=?, phone=?, address=?, patient_ava_url=?, insurance_number=?, emergency_contact=? WHERE patient_id=?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setPreparedStatementFromPatient(ps, patient);
            ps.setInt(12, patient.getPatientId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(int... id) {
        if (id.length == 0) return 0;
        String sql = "DELETE FROM Patients WHERE patient_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
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
                .patientAvaUrl( rs.getString("patient_ava_url") != null ? rs.getString("patient_ava_url") : "")
                .build();
    }


    private void setPreparedStatementFromPatient(PreparedStatement ps, Patient p) throws SQLException {
        ps.setString(1, p.getUsername());
        ps.setString(2, p.getPasswordHash());
        ps.setString(3, p.getFullName());
        if (p.getDob() != null) {
            ps.setDate(4, p.getDob());
        } else {
            ps.setNull(4, Types.DATE);
        }
        ps.setString(5, p.getGender());
        ps.setString(6, p.getEmail());
        ps.setString(7, p.getPhone());
        ps.setString(8, p.getAddress());
        ps.setString(9, p.getPatientAvaUrl() != null ? p.getPatientAvaUrl() : "");
        ps.setString(10, p.getInsuranceNumber());
        ps.setString(11, p.getEmergencyContact());
    }

}
