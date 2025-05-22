package view;

import model.PatientProfile;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientProfileDAO extends DBContext<PatientProfile> {
    @Override
    public List<PatientProfile> select() {
        List<PatientProfile> list = new ArrayList<>();
        String sql = "SELECT * FROM PatientProfiles";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PatientProfile patient = PatientProfile.builder()
                        .patientId(rs.getInt("patient_id"))
                        .fullName(rs.getString("full_name"))
                        .dob(rs.getDate("dob"))
                        .gender(rs.getString("gender"))
                        .email(rs.getString("email"))
                        .phone(rs.getString("phone"))
                        .address(rs.getString("address"))
                        .insuranceNumber(rs.getString("insurance_number"))
                        .emergencyContact(rs.getString("emergency_contact"))
                        .build();
                list.add(patient);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public PatientProfile select(int... id) {
        if (id.length < 1) return null;
        String sql = "SELECT * FROM PatientProfiles WHERE patient_id = ?";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return PatientProfile.builder()
                            .patientId(rs.getInt("patient_id"))
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
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(PatientProfile obj) {
        String sql = "INSERT INTO PatientProfiles (patient_id, full_name, dob, gender, email, phone, address, insurance_number, emergency_contact) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, obj.getPatientId());
            ps.setString(2, obj.getFullName());
            ps.setDate(3, obj.getDob());
            ps.setString(4, obj.getGender());
            ps.setString(5, obj.getEmail());
            ps.setString(6, obj.getPhone());
            ps.setString(7, obj.getAddress());
            ps.setString(8, obj.getInsuranceNumber());
            ps.setString(9, obj.getEmergencyContact());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(PatientProfile obj) {
        String sql = "UPDATE PatientProfiles SET full_name = ?, dob = ?, gender = ?, email = ?, phone = ?, address = ?, insurance_number = ?, emergency_contact = ? WHERE patient_id = ?";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, obj.getFullName());
            ps.setDate(2, obj.getDob());
            ps.setString(3, obj.getGender());
            ps.setString(4, obj.getEmail());
            ps.setString(5, obj.getPhone());
            ps.setString(6, obj.getAddress());
            ps.setString(7, obj.getInsuranceNumber());
            ps.setString(8, obj.getEmergencyContact());
            ps.setInt(9, obj.getPatientId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(int... id) {
        if (id.length < 1) return 0;
        String sql = "DELETE FROM PatientProfiles WHERE patient_id = ?";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
