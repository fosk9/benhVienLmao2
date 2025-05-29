package view;

import model.Employee;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO extends DBContext<Employee> {

    public List<Employee> searchFilterSortDoctors(String search, String gender, Integer specializationId,
                                                  String sortBy, String sortDir,
                                                  int page, int recordsPerPage) {
        List<Employee> list = new ArrayList<>();
        // Validate sortBy và sortDir để tránh SQL Injection (chỉ cho phép một số trường)
        List<String> allowedSortBy = List.of("full_name", "dob", "email", "employee_id");
        if (sortBy == null || !allowedSortBy.contains(sortBy)) {
            sortBy = "employee_id"; // default
        }
        if (!"desc".equalsIgnoreCase(sortDir)) {
            sortDir = "asc";
        }

        StringBuilder sql = new StringBuilder("SELECT * FROM Employees WHERE role_id = 1 "); // role_id=1 là bác sĩ

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (full_name LIKE ? OR email LIKE ?) ");
        }
        if (gender != null && (gender.equalsIgnoreCase("M") || gender.equalsIgnoreCase("F"))) {
            sql.append("AND gender = ? ");
        }
        if (specializationId != null && specializationId > 0) {
            sql.append("AND specialization_id = ? ");
        }

        sql.append("ORDER BY ").append(sortBy).append(" ").append(sortDir).append(" ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                String likeSearch = "%" + search.trim() + "%";
                ps.setString(idx++, likeSearch);
                ps.setString(idx++, likeSearch);
            }
            if (gender != null && (gender.equalsIgnoreCase("M") || gender.equalsIgnoreCase("F"))) {
                ps.setString(idx++, gender);
            }
            if (specializationId != null && specializationId > 0) {
                ps.setInt(idx++, specializationId);
            }

            ps.setInt(idx++, (page - 1) * recordsPerPage);
            ps.setInt(idx, recordsPerPage);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToEmployee(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countFilteredDoctors(String search, String gender, Integer specializationId) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Employees WHERE role_id = 1 ");

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (full_name LIKE ? OR email LIKE ?) ");
        }
        if (gender != null && (gender.equalsIgnoreCase("M") || gender.equalsIgnoreCase("F"))) {
            sql.append("AND gender = ? ");
        }
        if (specializationId != null && specializationId > 0) {
            sql.append("AND specialization_id = ? ");
        }

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                String likeSearch = "%" + search.trim() + "%";
                ps.setString(idx++, likeSearch);
                ps.setString(idx++, likeSearch);
            }
            if (gender != null && (gender.equalsIgnoreCase("M") || gender.equalsIgnoreCase("F"))) {
                ps.setString(idx++, gender);
            }
            if (specializationId != null && specializationId > 0) {
                ps.setInt(idx++, specializationId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

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

    public Employee getEmployeeByEmail(String email) {
        String sql = "SELECT * FROM Employees WHERE email = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
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
       