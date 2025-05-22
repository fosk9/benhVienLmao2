package view;

import model.ConsultantProfile;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConsultantProfileDAO extends DBContext<ConsultantProfile> {

    @Override
    public List<ConsultantProfile> select() {
        List<ConsultantProfile> list = new ArrayList<>();
        String sql = "SELECT * FROM ConsultantProfiles";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ConsultantProfile c = ConsultantProfile.builder()
                        .consultantId(rs.getInt("consultant_id"))
                        .fullName(rs.getString("full_name"))
                        .dob(rs.getDate("dob"))
                        .gender(rs.getString("gender"))
                        .email(rs.getString("email"))
                        .phone(rs.getString("phone"))
                        .expertiseArea(rs.getString("expertise_area"))
                        .degree(rs.getString("degree"))
                        .build();
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public ConsultantProfile select(int... id) {
        if (id.length < 1) return null;
        String sql = "SELECT * FROM ConsultantProfiles WHERE consultant_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return ConsultantProfile.builder()
                            .consultantId(rs.getInt("consultant_id"))
                            .fullName(rs.getString("full_name"))
                            .dob(rs.getDate("dob"))
                            .gender(rs.getString("gender"))
                            .email(rs.getString("email"))
                            .phone(rs.getString("phone"))
                            .expertiseArea(rs.getString("expertise_area"))
                            .degree(rs.getString("degree"))
                            .build();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(ConsultantProfile obj) {
        String sql = "INSERT INTO ConsultantProfiles (consultant_id, full_name, dob, gender, email, phone, expertise_area, degree) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, obj.getConsultantId());
            ps.setString(2, obj.getFullName());
            ps.setDate(3, obj.getDob());
            ps.setString(4, obj.getGender());
            ps.setString(5, obj.getEmail());
            ps.setString(6, obj.getPhone());
            ps.setString(7, obj.getExpertiseArea());
            ps.setString(8, obj.getDegree());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(ConsultantProfile obj) {
        String sql = "UPDATE ConsultantProfiles SET full_name = ?, dob = ?, gender = ?, email = ?, phone = ?, expertise_area = ?, degree = ? WHERE consultant_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, obj.getFullName());
            ps.setDate(2, obj.getDob());
            ps.setString(3, obj.getGender());
            ps.setString(4, obj.getEmail());
            ps.setString(5, obj.getPhone());
            ps.setString(6, obj.getExpertiseArea());
            ps.setString(7, obj.getDegree());
            ps.setInt(8, obj.getConsultantId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(int... id) {
        if (id.length < 1) return 0;
        String sql = "DELETE FROM ConsultantProfiles WHERE consultant_id = ?";
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
