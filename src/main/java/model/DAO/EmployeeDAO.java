package model.DAO;

import model.object.DBContext;
import model.object.Employee;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
                            rs.getString("full_name"),
                            rs.getString("dob"),
                            rs.getString("gender"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getInt("role_id")
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
                        rs.getString("full_name"),
                        rs.getString("dob"),
                        rs.getString("gender"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getInt("role_id")
                ));
            }
        }
        return employees;
    }

    // Save new employee
    public void save(Employee employee) throws SQLException {
        String sql = "INSERT INTO Employees (employee_id, full_name, dob, gender, email, phone, role_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, employee.getEmployeeId());
            stmt.setString(2, employee.getFullName());
            stmt.setString(3, employee.getDob());
            stmt.setString(4, employee.getGender());
            stmt.setString(5, employee.getEmail());
            stmt.setString(6, employee.getPhone());
            stmt.setInt(7, employee.getRoleId());
            stmt.executeUpdate();
        }
    }

    // Update existing employee
    public void update(Employee employee) throws SQLException {
        String sql = "UPDATE Employees SET full_name = ?, dob = ?, gender = ?, email = ?, phone = ?, role_id = ? WHERE employee_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, employee.getFullName());
            stmt.setString(2, employee.getDob());
            stmt.setString(3, employee.getGender());
            stmt.setString(4, employee.getEmail());
            stmt.setString(5, employee.getPhone());
            stmt.setInt(6, employee.getRoleId());
            stmt.setInt(7, employee.getEmployeeId());
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