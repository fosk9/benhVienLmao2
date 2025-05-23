package model.DAO;

import model.object.DBContext;
import model.object.Role;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO {
    // Find role by ID
    public Role findById(int roleId) throws SQLException {
        String sql = "SELECT * FROM Roles WHERE role_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roleId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Role(
                            rs.getInt("role_id"),
                            rs.getString("role_name")
                    );
                }
            }
        }
        return null;
    }

    // Find all roles
    public List<Role> findAll() throws SQLException {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT * FROM Roles";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                roles.add(new Role(
                        rs.getInt("role_id"),
                        rs.getString("role_name")
                ));
            }
        }
        return roles;
    }

    // Save new role
    public void save(Role role) throws SQLException {
        String sql = "INSERT INTO Roles (role_name) VALUES (?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, role.getRoleName());
            stmt.executeUpdate();
        }
    }

    // Update existing role
    public void update(Role role) throws SQLException {
        String sql = "UPDATE Roles SET role_name = ? WHERE role_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, role.getRoleName());
            stmt.setInt(2, role.getRoleId());
            stmt.executeUpdate();
        }
    }

    // Delete role
    public void delete(int roleId) throws SQLException {
        String sql = "DELETE FROM Roles WHERE role_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roleId);
            stmt.executeUpdate();
        }
    }
}