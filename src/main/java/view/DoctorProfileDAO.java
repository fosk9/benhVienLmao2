package view;

import model.DoctorProfile;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DoctorProfileDAO extends DBContext<DoctorProfile> {

    @Override
    public List<DoctorProfile> select() {
        List<DoctorProfile> list = new ArrayList<>();
        String sql = "SELECT * FROM DoctorProfiles";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                DoctorProfile doctor = DoctorProfile.builder()
                        .doctorId(rs.getInt("doctor_id"))
                        .fullName(rs.getString("full_name"))
                        .dob(rs.getDate("dob"))
                        .gender(rs.getString("gender"))
                        .email(rs.getString("email"))
                        .phone(rs.getString("phone"))
                        .licenseNumber(rs.getString("license_number"))
                        .specializationId(rs.getInt("specialization_id"))
                        .workSchedule(rs.getString("work_schedule"))
                        .build();
                list.add(doctor);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public DoctorProfile select(int... id) {
        if (id.length < 1) return null;
        String sql = "SELECT * FROM DoctorProfiles WHERE doctor_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return DoctorProfile.builder()
                            .doctorId(rs.getInt("doctor_id"))
                            .fullName(rs.getString("full_name"))
                            .dob(rs.getDate("dob"))
                            .gender(rs.getString("gender"))
                            .email(rs.getString("email"))
                            .phone(rs.getString("phone"))
                            .licenseNumber(rs.getString("license_number"))
                            .specializationId(rs.getInt("specialization_id"))
                            .workSchedule(rs.getString("work_schedule"))
                            .build();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(DoctorProfile obj) {
        String sql = "INSERT INTO DoctorProfiles (doctor_id, full_name, dob, gender, email, phone, license_number, specialization_id, work_schedule) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, obj.getDoctorId());
            ps.setString(2, obj.getFullName());
            ps.setDate(3, obj.getDob());
            ps.setString(4, obj.getGender());
            ps.setString(5, obj.getEmail());
            ps.setString(6, obj.getPhone());
            ps.setString(7, obj.getLicenseNumber());
            ps.setInt(8, obj.getSpecializationId());
            ps.setString(9, obj.getWorkSchedule());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(DoctorProfile obj) {
        String sql = "UPDATE DoctorProfiles SET full_name = ?, dob = ?, gender = ?, email = ?, phone = ?, license_number = ?, specialization_id = ?, work_schedule = ? WHERE doctor_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, obj.getFullName());
            ps.setDate(2, obj.getDob());
            ps.setString(3, obj.getGender());
            ps.setString(4, obj.getEmail());
            ps.setString(5, obj.getPhone());
            ps.setString(6, obj.getLicenseNumber());
            ps.setInt(7, obj.getSpecializationId());
            ps.setString(8, obj.getWorkSchedule());
            ps.setInt(9, obj.getDoctorId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(int... id) {
        if (id.length < 1) return 0;
        String sql = "DELETE FROM DoctorProfiles WHERE doctor_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
