package view;

import model.Employee;
import model.Patient;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO extends DBContext<Employee> {

    public Employee login(String username, String password) {
        String sql = "SELECT * FROM Employees WHERE username = ? AND password_hash = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEmployee(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public Employee getEmployeeByUsername(String username) {
        String sql = "SELECT * FROM Employees WHERE username = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToEmployee(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int updatePasswordByUsername(String username, String newPasswordHash) {
        String sql = "UPDATE Employees SET password_hash=? WHERE username=?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setString(2, username);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Employee> select() {
        List<Employee> list = new ArrayList<>();
        String sql = "SELECT * FROM Employees";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToEmployee(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Employee select(int... id) {
        if (id.length == 0) return null;
        String sql = "SELECT * FROM Employees WHERE employee_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEmployee(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(Employee e) {
        String sql = "INSERT INTO Employees (username, password_hash, full_name, dob, gender, email, phone, role_id, specialization_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setPreparedStatementFromEmployee(ps, e);
            return ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(Employee e) {
        String sql = "UPDATE Employees SET username=?, password_hash=?, full_name=?, dob=?, gender=?, email=?, phone=?, role_id=?, specialization_id=? WHERE employee_id=?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setPreparedStatementFromEmployee(ps, e);
            ps.setInt(10, e.getEmployeeId());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(int... id) {
        if (id.length == 0) return 0;
        String sql = "DELETE FROM Employees WHERE employee_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            return ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    private Employee mapResultSetToEmployee(ResultSet rs) throws SQLException {
        return Employee.builder()
                .employeeId(rs.getInt("employee_id"))
                .username(rs.getString("username"))
                .passwordHash(rs.getString("password_hash"))
                .fullName(rs.getString("full_name"))
                .dob(rs.getDate("dob"))
                .gender(rs.getString("gender"))
                .email(rs.getString("email"))
                .phone(rs.getString("phone"))
                .roleId(rs.getInt("role_id"))
                .specializationId(rs.getObject("specialization_id") != null ? rs.getInt("specialization_id") : null)
                .build();
    }


    private void setPreparedStatementFromEmployee(PreparedStatement ps, Employee e) throws SQLException {
        ps.setString(1, e.getUsername());
        ps.setString(2, e.getPasswordHash());
        ps.setString(3, e.getFullName());
        if (e.getDob() != null) {
            ps.setDate(4, e.getDob());
        } else {
            ps.setNull(4, Types.DATE);
        }
        ps.setString(5, e.getGender());
        ps.setString(6, e.getEmail());
        ps.setString(7, e.getPhone());
        ps.setInt(8, e.getRoleId());
        if (e.getSpecializationId() != null) {
            ps.setInt(9, e.getSpecializationId());
        } else {
            ps.setNull(9, Types.INTEGER);
        }
    }

}
