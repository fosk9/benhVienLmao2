package view;

import model.AdminProfile;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminProfileDAO extends DBContext<AdminProfile> {

    @Override
    public List<AdminProfile> select() {
        List<AdminProfile> list = new ArrayList<>();
        String sql = "SELECT * FROM AdminProfiles";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AdminProfile admin = AdminProfile.builder()
                        .adminId(rs.getInt("admin_id"))
                        .fullName(rs.getString("full_name"))
                        .email(rs.getString("email"))
                        .phone(rs.getString("phone"))
                        .note(rs.getString("note"))
                        .build();
                list.add(admin);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public AdminProfile select(int... id) {
        if (id.length < 1) return null;
        String sql = "SELECT * FROM AdminProfiles WHERE admin_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return AdminProfile.builder()
                            .adminId(rs.getInt("admin_id"))
                            .fullName(rs.getString("full_name"))
                            .email(rs.getString("email"))
                            .phone(rs.getString("phone"))
                            .note(rs.getString("note"))
                            .build();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(AdminProfile obj) {
        String sql = "INSERT INTO AdminProfiles (admin_id, full_name, email, phone, note) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, obj.getAdminId());
            ps.setString(2, obj.getFullName());
            ps.setString(3, obj.getEmail());
            ps.setString(4, obj.getPhone());
            ps.setString(5, obj.getNote());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(AdminProfile obj) {
        String sql = "UPDATE AdminProfiles SET full_name = ?, email = ?, phone = ?, note = ? WHERE admin_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, obj.getFullName());
            ps.setString(2, obj.getEmail());
            ps.setString(3, obj.getPhone());
            ps.setString(4, obj.getNote());
            ps.setInt(5, obj.getAdminId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(int... id) {
        if (id.length < 1) return 0;
        String sql = "DELETE FROM AdminProfiles WHERE admin_id = ?";
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
