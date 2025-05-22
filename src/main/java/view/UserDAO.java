
package view;

import model.*;

import java.sql.*;
import java.util.*;

public class UserDAO extends DBContext<User> {
    @Override
    public List<User> select() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password_hash"),
                        rs.getInt("role_id"),
                        null
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public User select(int... id) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password_hash"),
                        rs.getInt("role_id"),
                        null
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(User obj) {
        String sql = "INSERT INTO Users (username, password_hash, role_id) VALUES (?, ?, ?)";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, obj.getUsername());
            ps.setString(2, obj.getPasswordHash());
            ps.setInt(3, obj.getRoleId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(User obj) {
        String sql = "UPDATE Users SET username = ?, password_hash = ?, role_id = ? WHERE user_id = ?";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, obj.getUsername());
            ps.setString(2, obj.getPasswordHash());
            ps.setInt(3, obj.getRoleId());
            ps.setInt(4, obj.getUserId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(int... id) {
        String sql = "DELETE FROM Users WHERE user_id = ?";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}

