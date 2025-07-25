package dal;

import model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext<User> {

    public List<User> selectAllUsers() {
        List<User> list = new ArrayList<>();
        String empSQL = "SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, created_at, acc_status FROM Employees e JOIN Roles r ON e.role_id = r.role_id";
        String patSQL = "SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, created_at, acc_status FROM Patients";


        try (Connection conn = getConn();
             Statement st = conn.createStatement()) {

            ResultSet rs = st.executeQuery(empSQL);
            while (rs.next()) {
                User u = new User(rs.getInt("user_id"), rs.getString("full_name"), rs.getString("email"), rs.getString("phone"), rs.getString("role_name"), rs.getString("source"),rs.getInt("acc_status"), rs.getDate("created_at"));
                list.add(u);
            }

            rs = st.executeQuery(patSQL);
            while (rs.next()) {
                User u = new User(rs.getInt("user_id"), rs.getString("full_name"), rs.getString("email"), rs.getString("phone"), rs.getString("role_name"), rs.getString("source"),rs.getInt("acc_status"), rs.getDate("created_at"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countAllUsers() {
        String sql = "SELECT (SELECT COUNT(*) FROM Employees WHERE acc_status = 1) + (SELECT COUNT(*) FROM Patients WHERE acc_status = 1) AS total";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countEmployeeByRole(String roleName) {
        String sql = "SELECT COUNT(*) AS total FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE r.role_name = ? AND acc_status = 1";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roleName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countPatients() {
        String sql = "SELECT COUNT(*) AS total FROM Patients WHERE acc_status = 1";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void updateEmployeeRole(int employeeId, int roleId) {
        String sql = "UPDATE Employees SET role_id = ? WHERE employee_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ps.setInt(2, employeeId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public User getUserByIdAndSource(int id, String source) {
        String sql;

        if ("employee".equalsIgnoreCase(source)) {
            sql = "SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, created_at, acc_status " +
                    "FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE employee_id = ?";
        } else if ("patient".equalsIgnoreCase(source)) {
            sql = "SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, created_at, acc_status " +
                    "FROM Patients WHERE patient_id = ?";
        } else {
            return null; // không xác định được nguồn
        }

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            id,
                            rs.getString("full_name"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getString("role_name"),
                            rs.getString("source"),
                            rs.getInt("acc_status"),
                            rs.getDate("created_at")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }


    public void updateAccStatus(int id, int status, String source) {
        String sql;
        if ("employee".equalsIgnoreCase(source)) {
            sql = "UPDATE Employees SET acc_status = ? WHERE employee_id = ?";
        } else {
            sql = "UPDATE Patients SET acc_status = ? WHERE patient_id = ?";
        }

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean deleteEmployee(int id) {
        String sql = "DELETE FROM Employees WHERE employee_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            System.err.println("Can't delete this account because violation system. " + e.getMessage());
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public boolean deletePatient(int id) {
        String sql = "DELETE FROM Patients WHERE patient_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            System.err.println("Can't delete this account because violation system: " + e.getMessage());
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public List<User> selectPagedUsers(int offset, int limit) {
        List<User> list = new ArrayList<>();
        String sql =
                "SELECT * FROM (" +
                "   SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, acc_status, created_at " +
                "   FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE acc_status IN (0,1) " +
                "   UNION ALL " +
                "   SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, acc_status, created_at " +
                "   FROM Patients WHERE acc_status IN (0,1)" +
                ") AS all_users " +
                "ORDER BY created_at DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("role_name"),
                        rs.getString("source"),
                        rs.getInt("acc_status"),
                        rs.getDate("created_at")
                );
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tìm kiếm user theo keyword (tên, email, phone), có phân trang
    public List<User> searchByKeyword(String keyword, int offset, int limit) {
        List<User> users = new ArrayList<>();
        String sql =
                "SELECT * FROM (" +
                "   SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, acc_status, created_at " +
                "   FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE acc_status IN (0,1) " +
                "   UNION ALL " +
                "   SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, acc_status, created_at " +
                "   FROM Patients WHERE acc_status IN (0,1)" +
                ") AS all_users " +
                "WHERE LOWER(full_name) LIKE ? OR LOWER(email) LIKE ? OR phone LIKE ? " +
                "ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        String kw = "%" + keyword.toLowerCase() + "%";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setInt(4, offset);
            ps.setInt(5, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("role_name"),
                        rs.getString("source"),
                        rs.getInt("acc_status"),
                        rs.getDate("created_at")
                );
                users.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Đếm user theo keyword
    public int countByKeyword(String keyword) {
        String sql =
                "SELECT COUNT(*) AS total FROM (" +
                "   SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, acc_status, created_at " +
                "   FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE acc_status IN (0,1) " +
                "   UNION ALL " +
                "   SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, acc_status, created_at " +
                "   FROM Patients WHERE acc_status IN (0,1)" +
                ") AS all_users " +
                "WHERE LOWER(full_name) LIKE ? OR LOWER(email) LIKE ? OR phone LIKE ?";
        String kw = "%" + keyword.toLowerCase() + "%";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tìm kiếm user theo role, có phân trang
    public List<User> searchByRole(String role, int offset, int limit) {
        List<User> users = new ArrayList<>();
        String sql =
                "SELECT * FROM (" +
                "   SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, acc_status, created_at " +
                "   FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE acc_status IN (0,1) " +
                "   UNION ALL " +
                "   SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, acc_status, created_at " +
                "   FROM Patients WHERE acc_status IN (0,1)" +
                ") AS all_users " +
                "WHERE LOWER(role_name) = ? " +
                "ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role.toLowerCase());
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("role_name"),
                        rs.getString("source"),
                        rs.getInt("acc_status"),
                        rs.getDate("created_at")
                );
                users.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Đếm user theo role
    public int countByRole(String role) {
        String sql =
                "SELECT COUNT(*) AS total FROM (" +
                "   SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, acc_status, created_at " +
                "   FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE acc_status IN (0,1) " +
                "   UNION ALL " +
                "   SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, acc_status, created_at " +
                "   FROM Patients WHERE acc_status IN (0,1)" +
                ") AS all_users " +
                "WHERE LOWER(role_name) = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role.toLowerCase());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tìm kiếm user theo status, có phân trang
    public List<User> searchByStatus(int status, int offset, int limit) {
        List<User> users = new ArrayList<>();
        String sql =
                "SELECT * FROM (" +
                "   SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, acc_status, created_at " +
                "   FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE acc_status IN (0,1) " +
                "   UNION ALL " +
                "   SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, acc_status, created_at " +
                "   FROM Patients WHERE acc_status IN (0,1)" +
                ") AS all_users " +
                "WHERE acc_status = ? " +
                "ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("role_name"),
                        rs.getString("source"),
                        rs.getInt("acc_status"),
                        rs.getDate("created_at")
                );
                users.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Đếm user theo status
    public int countByStatus(int status) {
        String sql =
                "SELECT COUNT(*) AS total FROM (" +
                "   SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, acc_status, created_at " +
                "   FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE acc_status IN (0,1) " +
                "   UNION ALL " +
                "   SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, acc_status, created_at " +
                "   FROM Patients WHERE acc_status IN (0,1)" +
                ") AS all_users " +
                "WHERE acc_status = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tìm kiếm user theo keyword + role + status, có phân trang
    public List<User> searchByKeywordRoleStatus(String keyword, String role, int status, int offset, int limit) {
        List<User> users = new ArrayList<>();
        String sql =
                "SELECT * FROM (" +
                "   SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, acc_status, created_at " +
                "   FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE acc_status IN (0,1) " +
                "   UNION ALL " +
                "   SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, acc_status, created_at " +
                "   FROM Patients WHERE acc_status IN (0,1)" +
                ") AS all_users " +
                "WHERE (LOWER(full_name) LIKE ? OR LOWER(email) LIKE ? OR phone LIKE ?) " +
                "AND LOWER(role_name) = ? AND acc_status = ? " +
                "ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        String kw = "%" + keyword.toLowerCase() + "%";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setString(4, role.toLowerCase());
            ps.setInt(5, status);
            ps.setInt(6, offset);
            ps.setInt(7, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("role_name"),
                        rs.getString("source"),
                        rs.getInt("acc_status"),
                        rs.getDate("created_at")
                );
                users.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Đếm user theo keyword + role + status
    public int countByKeywordRoleStatus(String keyword, String role, int status) {
        String sql =
                "SELECT COUNT(*) AS total FROM (" +
                "   SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, acc_status, created_at " +
                "   FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE acc_status IN (0,1) " +
                "   UNION ALL " +
                "   SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, acc_status, created_at " +
                "   FROM Patients WHERE acc_status IN (0,1)" +
                ") AS all_users " +
                "WHERE (LOWER(full_name) LIKE ? OR LOWER(email) LIKE ? OR phone LIKE ?) " +
                "AND LOWER(role_name) = ? AND acc_status = ?";
        String kw = "%" + keyword.toLowerCase() + "%";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setString(4, role.toLowerCase());
            ps.setInt(5, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tìm kiếm user theo keyword + role, có phân trang
    public List<User> searchByKeywordAndRole(String keyword, String role, int offset, int limit) {
        List<User> users = new ArrayList<>();
        String sql =
                "SELECT * FROM (" +
                "   SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, acc_status, created_at " +
                "   FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE acc_status IN (0,1) " +
                "   UNION ALL " +
                "   SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, acc_status, created_at " +
                "   FROM Patients WHERE acc_status IN (0,1)" +
                ") AS all_users " +
                "WHERE (LOWER(full_name) LIKE ? OR LOWER(email) LIKE ? OR phone LIKE ?) " +
                "AND LOWER(role_name) = ? " +
                "ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        String kw = "%" + keyword.toLowerCase() + "%";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setString(4, role.toLowerCase());
            ps.setInt(5, offset);
            ps.setInt(6, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("role_name"),
                        rs.getString("source"),
                        rs.getInt("acc_status"),
                        rs.getDate("created_at")
                );
                users.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Đếm user theo keyword + role
    public int countByKeywordAndRole(String keyword, String role) {
        String sql =
                "SELECT COUNT(*) AS total FROM (" +
                "   SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, acc_status, created_at " +
                "   FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE acc_status IN (0,1) " +
                "   UNION ALL " +
                "   SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, acc_status, created_at " +
                "   FROM Patients WHERE acc_status IN (0,1)" +
                ") AS all_users " +
                "WHERE (LOWER(full_name) LIKE ? OR LOWER(email) LIKE ? OR phone LIKE ?) " +
                "AND LOWER(role_name) = ?";
        String kw = "%" + keyword.toLowerCase() + "%";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setString(4, role.toLowerCase());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tìm kiếm user theo keyword + status, có phân trang
    public List<User> searchByKeywordAndStatus(String keyword, int status, int offset, int limit) {
        List<User> users = new ArrayList<>();
        String sql =
                "SELECT * FROM (" +
                "   SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, acc_status, created_at " +
                "   FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE acc_status IN (0,1) " +
                "   UNION ALL " +
                "   SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, acc_status, created_at " +
                "   FROM Patients WHERE acc_status IN (0,1)" +
                ") AS all_users " +
                "WHERE (LOWER(full_name) LIKE ? OR LOWER(email) LIKE ? OR phone LIKE ?) " +
                "AND acc_status = ? " +
                "ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        String kw = "%" + keyword.toLowerCase() + "%";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setInt(4, status);
            ps.setInt(5, offset);
            ps.setInt(6, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("role_name"),
                        rs.getString("source"),
                        rs.getInt("acc_status"),
                        rs.getDate("created_at")
                );
                users.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Đếm user theo keyword + status
    public int countByKeywordAndStatus(String keyword, int status) {
        String sql =
                "SELECT COUNT(*) AS total FROM (" +
                "   SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, acc_status, created_at " +
                "   FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE acc_status IN (0,1) " +
                "   UNION ALL " +
                "   SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, acc_status, created_at " +
                "   FROM Patients WHERE acc_status IN (0,1)" +
                ") AS all_users " +
                "WHERE (LOWER(full_name) LIKE ? OR LOWER(email) LIKE ? OR phone LIKE ?) " +
                "AND acc_status = ?";
        String kw = "%" + keyword.toLowerCase() + "%";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setInt(4, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tìm kiếm user theo role + status, có phân trang
    public List<User> searchByRoleAndStatus(String role, int status, int offset, int limit) {
        List<User> users = new ArrayList<>();
        String sql =
                "SELECT * FROM (" +
                "   SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, acc_status, created_at " +
                "   FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE acc_status IN (0,1) " +
                "   UNION ALL " +
                "   SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, acc_status, created_at " +
                "   FROM Patients WHERE acc_status IN (0,1)" +
                ") AS all_users " +
                "WHERE LOWER(role_name) = ? AND acc_status = ? " +
                "ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role.toLowerCase());
            ps.setInt(2, status);
            ps.setInt(3, offset);
            ps.setInt(4, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("role_name"),
                        rs.getString("source"),
                        rs.getInt("acc_status"),
                        rs.getDate("created_at")
                );
                users.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Đếm user theo role + status
    public int countByRoleAndStatus(String role, int status) {
        String sql =
                "SELECT COUNT(*) AS total FROM (" +
                "   SELECT employee_id AS user_id, full_name, email, phone, role_name, 'employee' AS source, acc_status, created_at " +
                "   FROM Employees e JOIN Roles r ON e.role_id = r.role_id WHERE acc_status IN (0,1) " +
                "   UNION ALL " +
                "   SELECT patient_id AS user_id, full_name, email, phone, 'Patient' AS role_name, 'patient' AS source, acc_status, created_at " +
                "   FROM Patients WHERE acc_status IN (0,1)" +
                ") AS all_users " +
                "WHERE LOWER(role_name) = ? AND acc_status = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role.toLowerCase());
            ps.setInt(2, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<User> select() {
        return selectAllUsers();
    }

    @Override
    public User select(int... id) {
        return null;
    }

    @Override
    public int insert(User obj) {
        return 0;
    }

    @Override
    public int update(User obj) {
        return 0;
    }

    @Override
    public int delete(int... id) {
        return 0;
    }

    // Hàm test cho các chức năng chính của UserDAO
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();

        System.out.println("=== Test selectAllUsers ===");
        List<User> allUsers = dao.selectAllUsers();
        for (User u : allUsers) {
            System.out.println(u);
        }

        System.out.println("=== Test countAllUsers ===");
        System.out.println("Total users: " + dao.countAllUsers());

        System.out.println("=== Test countEmployeeByRole ===");
        System.out.println("Doctors: " + dao.countEmployeeByRole("Doctor"));
        System.out.println("Receptionists: " + dao.countEmployeeByRole("Receptionist"));

        System.out.println("=== Test countPatients ===");
        System.out.println("Patients: " + dao.countPatients());

        System.out.println("=== Test selectPagedUsers (offset 0, limit 5) ===");
        List<User> paged = dao.selectPagedUsers(0, 5);
        for (User u : paged) {
            System.out.println(u);
        }

        System.out.println("=== Test searchByKeyword (keyword='nguyen', offset 0, limit 5) ===");
        List<User> search = dao.searchByKeyword("nguyen", 0, 5);
        for (User u : search) {
            System.out.println(u);
        }

        System.out.println("=== Test countByKeyword (keyword='nguyen') ===");
        System.out.println("Count: " + dao.countByKeyword("nguyen"));

        System.out.println("=== Test searchByRole (role='doctor', offset 0, limit 5) ===");
        List<User> byRole = dao.searchByRole("doctor", 0, 5);
        for (User u : byRole) {
            System.out.println(u);
        }

        System.out.println("=== Test countByRole (role='doctor') ===");
        System.out.println("Count: " + dao.countByRole("doctor"));

        System.out.println("=== Test searchByStatus (status=1, offset 0, limit 5) ===");
        List<User> byStatus = dao.searchByStatus(1, 0, 5);
        for (User u : byStatus) {
            System.out.println(u);
        }

        System.out.println("=== Test countByStatus (status=1) ===");
        System.out.println("Count: " + dao.countByStatus(1));

        System.out.println("=== Test searchByKeywordRoleStatus (keyword='nguyen', role='doctor', status=1, offset 0, limit 5) ===");
        List<User> combo = dao.searchByKeywordRoleStatus("nguyen", "doctor", 1, 0, 5);
        for (User u : combo) {
            System.out.println(u);
        }

        System.out.println("=== Test countByKeywordRoleStatus (keyword='nguyen', role='doctor', status=1) ===");
        System.out.println("Count: " + dao.countByKeywordRoleStatus("nguyen", "doctor", 1));

        System.out.println("=== Test searchByKeywordAndRole (keyword='nguyen', role='doctor', offset 0, limit 5) ===");
        List<User> kwRole = dao.searchByKeywordAndRole("nguyen", "doctor", 0, 5);
        for (User u : kwRole) {
            System.out.println(u);
        }

        System.out.println("=== Test countByKeywordAndRole (keyword='nguyen', role='doctor') ===");
        System.out.println("Count: " + dao.countByKeywordAndRole("nguyen", "doctor"));

        System.out.println("=== Test searchByKeywordAndStatus (keyword='nguyen', status=1, offset 0, limit 5) ===");
        List<User> kwStatus = dao.searchByKeywordAndStatus("nguyen", 1, 0, 5);
        for (User u : kwStatus) {
            System.out.println(u);
        }

        System.out.println("=== Test countByKeywordAndStatus (keyword='nguyen', status=1) ===");
        System.out.println("Count: " + dao.countByKeywordAndStatus("nguyen", 1));

        System.out.println("=== Test searchByRoleAndStatus (role='doctor', status=1, offset 0, limit 5) ===");
        List<User> roleStatus = dao.searchByRoleAndStatus("doctor", 1, 0, 5);
        for (User u : roleStatus) {
            System.out.println(u);
        }

        System.out.println("=== Test countByRoleAndStatus (role='doctor', status=1) ===");
        System.out.println("Count: " + dao.countByRoleAndStatus("doctor", 1));
    }
}