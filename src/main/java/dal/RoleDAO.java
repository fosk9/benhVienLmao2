// ===== RoleDAO.java (chuẩn hoá theo DBContext mẫu của bạn) =====
package dal;

import model.Role;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO extends DBContext<Role> {

    @Override
    public List<Role> select() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT * FROM Roles";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(Role.builder()
                        .roleId(rs.getInt("role_id"))
                        .roleName(rs.getString("role_name"))
                        .build());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Role select(int... id) {
        if (id.length == 0) return null;
        String sql = "SELECT * FROM Roles WHERE role_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Role.builder()
                            .roleId(rs.getInt("role_id"))
                            .roleName(rs.getString("role_name"))
                            .build();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(Role r) {
        String sql = "INSERT INTO Roles (role_name) VALUES (?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getRoleName());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(Role r) {
        String sql = "UPDATE Roles SET role_name = ? WHERE role_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getRoleName());
            ps.setInt(2, r.getRoleId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(int... id) {
        if (id.length == 0) return 0;
        String sql = "DELETE FROM Roles WHERE role_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Role> getAllRoles() {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT role_id, role_name FROM Roles";

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Role role = Role.builder()
                        .roleId(rs.getInt("role_id"))
                        .roleName(rs.getString("role_name"))
                        .build();
                roles.add(role);
            }

        } catch (SQLException e) {
            System.err.println("Error loading roles: " + e.getMessage());
        }

        return roles;
    }

    public int getRoleIdByName(String roleName) {
        String sql = "SELECT role_id FROM Roles WHERE LOWER(role_name) = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roleName.toLowerCase());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("role_id");
            }

        } catch (SQLException e) {
            System.err.println("Error getting role_id: " + e.getMessage());
        }
        return -1; // không tìm thấy
    }
}
