package view;

import model.Employee;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO extends DBContext<Employee> {

    public int countTotalEmployees() {
        String sql = "SELECT COUNT(*) FROM Employees";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countActiveDoctorsToday() {
        String sql = "SELECT COUNT(DISTINCT doctor_id) FROM DoctorShifts WHERE shift_date = CAST(GETDATE() AS DATE)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countAppointmentsToday() {
        String sql = "SELECT COUNT(*) FROM Appointments WHERE CAST(date AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    public List<Employee> searchByNameAndRole(String name, int roleId, int page, int recordsPerPage) {
        List<Employee> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Employees WHERE 1=1 ");

        if (name != null && !name.trim().isEmpty()) {
            sql.append("AND full_name LIKE ? ");
        }
        if (roleId > 0) {
            sql.append("AND role_id = ? ");
        }
        sql.append("ORDER BY employee_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (name != null && !name.trim().isEmpty()) {
                ps.setString(idx++, "%" + name.trim() + "%");
            }
            if (roleId > 0) {
                ps.setInt(idx++, roleId);
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

    public int countSearchByNameAndRole(String name, int roleId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Employees WHERE 1=1 ");
        if (name != null && !name.trim().isEmpty()) {
            sql.append("AND full_name LIKE ? ");
        }
        if (roleId > 0) {
            sql.append("AND role_id = ? ");
        }

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (name != null && !name.trim().isEmpty()) {
                ps.setString(idx++, "%" + name.trim() + "%");
            }
            if (roleId > 0) {
                ps.setInt(idx++, roleId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Employee> searchFilterSortDoctors(String search, String gender,
                                                  String sortBy, String sortDir,
                                                  int page, int recordsPerPage) {
        List<Employee> list = new ArrayList<>();
        List<String> allowedSortBy = List.of("full_name", "dob", "email", "employee_id");
        if (sortBy == null || !allowedSortBy.contains(sortBy)) {
            sortBy = "employee_id";
        }
        if (!"desc".equalsIgnoreCase(sortDir)) {
            sortDir = "asc";
        }

        StringBuilder sql = new StringBuilder("SELECT * FROM Employees WHERE role_id = 1 ");

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (full_name LIKE ? OR email LIKE ?) ");
        }
        if (gender != null && (gender.equalsIgnoreCase("M") || gender.equalsIgnoreCase("F"))) {
            sql.append("AND gender = ? ");
        }
        // specializationId đã bị loại bỏ khỏi bảng Employees

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
            // Không còn specializationId

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

    public int countFilteredDoctors(String search, String gender) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Employees WHERE role_id = 1 ");

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (full_name LIKE ? OR email LIKE ?) ");
        }
        if (gender != null && (gender.equalsIgnoreCase("M") || gender.equalsIgnoreCase("F"))) {
            sql.append("AND gender = ? ");
        }
        // specializationId đã bị loại bỏ khỏi bảng Employees

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
            // Không còn specializationId

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
        String query = "SELECT * FROM Employees WHERE email = ?";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToEmployee(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Employee getEmployeeByUsername(String username) {
        String query = "SELECT * FROM Employees WHERE username = ?";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToEmployee(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int updatePasswordByUsername(String username, String newPasswordHash) {
        String query = "UPDATE Employees SET password_hash = ? WHERE username = ?";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, newPasswordHash);
            stmt.setString(2, username);
            return stmt.executeUpdate();
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
        String sql = "INSERT INTO Employees (username, password_hash, full_name, dob, gender, email, phone, role_id, employee_ava_url) " +
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
        String sql = "UPDATE Employees SET username=?, password_hash=?, full_name=?, dob=?, gender=?, email=?, phone=?, role_id=?, employee_ava_url=? WHERE employee_id=?";
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

    // For admin user management: search, filter, pagination
    public List<Employee> searchFilterSort(String searchName, String searchEmail, String searchUsername, String searchRoleId, int page, int pageSize) {
        List<Employee> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Employees WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (searchName != null && !searchName.isEmpty()) {
            sql.append("AND full_name LIKE ? ");
            params.add("%" + searchName + "%");
        }
        if (searchEmail != null && !searchEmail.isEmpty()) {
            sql.append("AND email LIKE ? ");
            params.add("%" + searchEmail + "%");
        }
        if (searchUsername != null && !searchUsername.isEmpty()) {
            sql.append("AND username LIKE ? ");
            params.add("%" + searchUsername + "%");
        }
        if (searchRoleId != null && !searchRoleId.isEmpty()) {
            sql.append("AND role_id = ? ");
            params.add(Integer.parseInt(searchRoleId));
        }
        sql.append("ORDER BY employee_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Object param : params) {
                ps.setObject(idx++, param);
            }
            ps.setInt(idx++, (page - 1) * pageSize);
            ps.setInt(idx, pageSize);

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

    public int countFiltered(String searchName, String searchEmail, String searchUsername, String searchRoleId) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Employees WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (searchName != null && !searchName.isEmpty()) {
            sql.append("AND full_name LIKE ? ");
            params.add("%" + searchName + "%");
        }
        if (searchEmail != null && !searchEmail.isEmpty()) {
            sql.append("AND email LIKE ? ");
            params.add("%" + searchEmail + "%");
        }
        if (searchUsername != null && !searchUsername.isEmpty()) {
            sql.append("AND username LIKE ? ");
            params.add("%" + searchUsername + "%");
        }
        if (searchRoleId != null && !searchRoleId.isEmpty()) {
            sql.append("AND role_id = ? ");
            params.add(Integer.parseInt(searchRoleId));
        }

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Object param : params) {
                ps.setObject(idx++, param);
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
                .employeeAvaUrl(rs.getString("employee_ava_url"))
                .accStatus(rs.getObject("acc_status") != null ? rs.getInt("acc_status") : null)
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
        ps.setString(9, e.getEmployeeAvaUrl() != null ? e.getEmployeeAvaUrl() : "");
        ps.setInt(10,  e.getAccStatus() != null ? e.getAccStatus() : 1);
    }

    // Test main method for EmployeeDAO
    public static void main(String[] args) {
        EmployeeDAO dao = new EmployeeDAO();

        System.out.println("=== Test countTotalEmployees ===");
        System.out.println("Total employees: " + dao.countTotalEmployees());

        System.out.println("=== Test countActiveDoctorsToday ===");
        System.out.println("Active doctors today: " + dao.countActiveDoctorsToday());

        System.out.println("=== Test countAppointmentsToday ===");
        System.out.println("Appointments today: " + dao.countAppointmentsToday());

        System.out.println("=== Test select() all ===");
        for (Employee e : dao.select()) {
            System.out.println(e);
        }

        System.out.println("=== Test select(id) ===");
        Employee emp = dao.select(1);
        System.out.println(emp);

        System.out.println("=== Test searchByNameAndRole ===");
        for (Employee e : dao.searchByNameAndRole("Nguyễn", 1, 1, 5)) {
            System.out.println(e);
        }

        System.out.println("=== Test countSearchByNameAndRole ===");
        System.out.println("Count: " + dao.countSearchByNameAndRole("Nguyễn", 1));

        System.out.println("=== Test searchFilterSortDoctors ===");
        for (Employee e : dao.searchFilterSortDoctors("An", "M", "full_name", "asc", 1, 5)) {
            System.out.println(e);
        }

        System.out.println("=== Test countFilteredDoctors ===");
        System.out.println("Count: " + dao.countFilteredDoctors("An", "M"));

        System.out.println("=== Test getEmployeeByEmail ===");
        System.out.println(dao.getEmployeeByEmail("dr.an@hospital.com"));

        System.out.println("=== Test getEmployeeByUsername ===");
        System.out.println(dao.getEmployeeByUsername("an.nguyen"));

        System.out.println("=== Test login ===");
        System.out.println(dao.login("an.nguyen", "password123"));

        // Uncomment below to test insert/update/delete (be careful with real DB)
        /*
        Employee newEmp = Employee.builder()
                .username("testuser")
                .passwordHash("testpass")
                .fullName("Test User")
                .dob(java.sql.Date.valueOf("1990-01-01"))
                .gender("M")
                .email("test@hospital.com")
                .phone("0999999999")
                .roleId(2)
                .employeeAvaUrl("")
                .build();
        int inserted = dao.insert(newEmp);
        System.out.println("Inserted: " + inserted);

        newEmp.setFullName("Test User Updated");
        int updated = dao.update(newEmp);
        System.out.println("Updated: " + updated);

        int deleted = dao.delete(newEmp.getEmployeeId());
        System.out.println("Deleted: " + deleted);
        */
    }

}