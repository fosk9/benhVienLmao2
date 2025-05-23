package model.DAO;

import model.object.Employee;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {
    // Find employee by ID
    public Employee findById(int employeeId) throws SQLException {
        String sql = "SELECT * FROM Employees WHERE employee_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, employeeId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Employee(
                            rs.getInt("employee_id"),
                            rs.getString("username"),
                            rs.getString("password_hash"),
                            rs.getString("full_name"),
                            rs.getObject("dob", LocalDate.class),
                            rs.getString("gender"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getInt("role_id"),
                            rs.getObject("specialization_id", Integer.class)
                    );
                }
            }
        }
        return null;
    }

    // Find employee by username
    public Employee findByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM Employees WHERE username = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Employee(
                            rs.getInt("employee_id"),
                            rs.getString("username"),
                            rs.getString("password_hash"),
                            rs.getString("full_name"),
                            rs.getObject("dob", LocalDate.class),
                            rs.getString("gender"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getInt("role_id"),
                            rs.getObject("specialization_id", Integer.class)
                    );
                }
            }
        }
        return null;
    }

    // Find all employees
    public List<Employee> findAll() throws SQLException {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT * FROM Employees";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                employees.add(new Employee(
                        rs.getInt("employee_id"),
                        rs.getString("username"),
                        rs.getString("password_hash"),
                        rs.getString("full_name"),
                        rs.getObject("dob", LocalDate.class),
                        rs.getString("gender"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getInt("role_id"),
                        rs.getObject("specialization_id", Integer.class)
                ));
            }
        }
        return employees;
    }

    // Save new employee
    public void save(Employee employee) throws SQLException {
        String sql = "INSERT INTO Employees (username, password_hash, full_name, dob, gender, email, phone, role_id, specialization_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, employee.getUsername());
            stmt.setString(2, employee.getPasswordHash());
            stmt.setString(3, employee.getFullName());
            stmt.setObject(4, employee.getDob());
            stmt.setString(5, employee.getGender());
            stmt.setString(6, employee.getEmail());
            stmt.setString(7, employee.getPhone());
            stmt.setInt(8, employee.getRoleId());
            stmt.setObject(9, employee.getSpecializationId());
            stmt.executeUpdate();
        }
    }

    // Update existing employee
    public void update(Employee employee) throws SQLException {
        String sql = "UPDATE Employees SET username = ?, password_hash = ?, full_name = ?, dob = ?, gender = ?, email = ?, phone = ?, role_id = ?, specialization_id = ? WHERE employee_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, employee.getUsername());
            stmt.setString(2, employee.getPasswordHash());
            stmt.setString(3, employee.getFullName());
            stmt.setObject(4, employee.getDob());
            stmt.setString(5, employee.getGender());
            stmt.setString(6, employee.getEmail());
            stmt.setString(7, employee.getPhone());
            stmt.setInt(8, employee.getRoleId());
            stmt.setObject(9, employee.getSpecializationId());
            stmt.setInt(10, employee.getEmployeeId());
            stmt.executeUpdate();
        }
    }

    // Delete employee
    public void delete(int employeeId) throws SQLException {
        String sql = "DELETE FROM Employees WHERE employee_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, employeeId);
            stmt.executeUpdate();
        }
    }
}