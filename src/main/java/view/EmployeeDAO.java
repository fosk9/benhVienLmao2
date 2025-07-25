package view;

import model.Employee;
import model.EmployeeWithStatus;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO extends DBContext<Employee> {

    public List<Employee> getAvailableDoctors(Date date, String timeSlot, int excludeDoctorId) {
        List<Employee> list = new ArrayList<>();
        String sql = """
                    SELECT * FROM Employees
                    WHERE role_id = (SELECT role_id FROM Roles WHERE role_name = 'Doctor')
                      AND employee_id != ?
                      AND employee_id NOT IN (
                          SELECT doctor_id FROM DoctorShifts
                          WHERE shift_date = ? AND time_slot = ? AND status IN ('Working', 'PendingLeave')
                      )
                """;
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, excludeDoctorId);
            ps.setDate(2, date);
            ps.setString(3, timeSlot);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToEmployee(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    public boolean updateEmployee(Employee e) {
        String sql = "UPDATE Employees SET full_name=?, email=?, phone=?, gender=?, dob=?, role_id=?, acc_status=?, employee_ava_url=? WHERE employee_id=?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, e.getFullName());
            ps.setString(2, e.getEmail());
            ps.setString(3, e.getPhone());
            ps.setString(4, e.getGender());
            ps.setDate(5, e.getDob());
            ps.setInt(6, e.getRoleId());
            ps.setInt(7, e.getAccStatus());
            ps.setString(8, e.getEmployeeAvaUrl());
            ps.setInt(9, e.getEmployeeId());

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("❌ Lỗi khi updateEmployee: " + ex.getMessage());
            return false;
        }
    }

    public List<EmployeeWithStatus> getEmployeesWithStatus(String keyword, String statusFilter, int offset, int limit) {
        List<EmployeeWithStatus> list = new ArrayList<>();

        String sql = """
                    SELECT e.*,
                           CASE 
                               WHEN e.acc_status != 1 THEN 'Inactive'
                               WHEN ds.doctor_id IS NOT NULL THEN 'Working'
                               ELSE 'OnLeave'
                           END AS status_today
                    FROM Employees e
                    LEFT JOIN (
                        SELECT DISTINCT doctor_id
                        FROM DoctorShifts
                        WHERE shift_date = CAST(GETDATE() AS DATE)
                    ) ds ON e.employee_id = ds.doctor_id    
                    WHERE e.role_id IN (1, 2) AND (? IS NULL OR e.full_name LIKE ?)
                """;

        if (statusFilter != null && !statusFilter.equalsIgnoreCase("All") && !statusFilter.isBlank()) {
            sql += " AND CASE WHEN e.acc_status != 1 THEN 'Inactive' WHEN ds.doctor_id IS NOT NULL THEN 'Working' ELSE 'OnLeave' END = ? ";
        }

        sql += " ORDER BY e.full_name OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int i = 1;

            // Keyword
            if (keyword == null || keyword.trim().isEmpty()) {
                ps.setNull(i++, Types.VARCHAR);
                ps.setNull(i++, Types.VARCHAR);
            } else {
                ps.setString(i++, keyword);
                ps.setString(i++, "%" + keyword + "%");
            }

            // Status filter
            if (statusFilter != null && !statusFilter.equalsIgnoreCase("All") && !statusFilter.isBlank()) {
                ps.setString(i++, statusFilter);
            }

            // Paging
            ps.setInt(i++, offset);
            ps.setInt(i, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Employee emp = mapResultSetToEmployee(rs);
                    String status = rs.getString("status_today");
                    list.add(new EmployeeWithStatus(emp, status));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countEmployeesWithStatus(String keyword, String statusFilter) {
        String sql = """
                    SELECT COUNT(*) FROM (
                        SELECT e.employee_id,
                               CASE 
                                   WHEN e.acc_status != 1 THEN 'Inactive'
                                   WHEN ds.doctor_id IS NOT NULL THEN 'Working'
                                   ELSE 'OnLeave'
                               END AS status_today
                        FROM Employees e
                        LEFT JOIN (
                            SELECT DISTINCT doctor_id
                            FROM DoctorShifts
                            WHERE shift_date = CAST(GETDATE() AS DATE)
                        ) ds ON e.employee_id = ds.doctor_id
                        WHERE (? IS NULL OR e.full_name LIKE ?)
                    ) AS filtered
                """;

        if (statusFilter != null && !statusFilter.equalsIgnoreCase("All") && !statusFilter.isBlank()) {
            sql += " WHERE status_today = ?";
        }

        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int i = 1;
            if (keyword == null || keyword.trim().isEmpty()) {
                ps.setNull(i++, Types.VARCHAR);
                ps.setNull(i++, Types.VARCHAR);
            } else {
                ps.setString(i++, keyword);
                ps.setString(i++, "%" + keyword + "%");
            }

            if (statusFilter != null && !statusFilter.equalsIgnoreCase("All") && !statusFilter.isBlank()) {
                ps.setString(i, statusFilter);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }


    public List<Employee> getActiveDoctorsToday(String keyword, String statusFilter, int offset, int limit) {
        List<Employee> list = new ArrayList<>();

        String sql = """
                    SELECT DISTINCT e.*
                    FROM Employees e
                    JOIN DoctorShifts s ON e.employee_id = s.doctor_id
                    WHERE e.role_id = 1
                      AND e.acc_status = 1
                      AND s.shift_date = CAST(GETDATE() AS DATE)
                      AND (? IS NULL OR e.full_name LIKE ?)
                      AND (
                        ? IS NULL OR ? = 'All' OR
                        EXISTS (
                          SELECT 1 FROM DoctorShifts s2
                          WHERE s2.doctor_id = e.employee_id
                            AND s2.shift_date = CAST(GETDATE() AS DATE)
                            AND s2.status = ?
                        )
                      )
                    ORDER BY e.full_name
                    OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;

        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int i = 1;
            // Keyword
            if (keyword == null || keyword.isEmpty()) {
                ps.setNull(i++, Types.VARCHAR);
                ps.setNull(i++, Types.VARCHAR);
            } else {
                ps.setString(i++, keyword);
                ps.setString(i++, "%" + keyword + "%");
            }

            // Status filter
            if (statusFilter == null || statusFilter.equalsIgnoreCase("All")) {
                ps.setNull(i++, Types.VARCHAR);
                ps.setNull(i++, Types.VARCHAR);
                ps.setNull(i++, Types.VARCHAR);
            } else {
                ps.setString(i++, statusFilter);
                ps.setString(i++, statusFilter);
                ps.setString(i++, statusFilter);
            }

            ps.setInt(i++, offset);
            ps.setInt(i, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Employee e = new Employee();
                    e.setEmployeeId(rs.getInt("employee_id"));
                    e.setFullName(rs.getString("full_name"));
                    e.setEmail(rs.getString("email"));
                    e.setPhone(rs.getString("phone"));
                    e.setRoleId(rs.getInt("role_id"));
                    e.setAccStatus(rs.getInt("acc_status"));
                    e.setEmployeeAvaUrl(rs.getString("employee_ava_url"));
                    list.add(e);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

//    public Employee getManagerProfileById(int managerId) {
//        String sql = """
//        SELECT e.employee_id, e.full_name, e.email, e.phone, e.dob, e.gender,
//               e.employee_ava_url, e.acc_status, r.role_name
//        FROM Employees e
//        JOIN Roles r ON e.role_id = r.role_id
//        WHERE e.employee_id = ? AND e.role_id = 4
//    """;
//
//        try (Connection conn = getConn();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, managerId);
//
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) {
//                    Employee e = new Employee();
//                    e.setEmployeeId(rs.getInt("employee_id"));
//                    e.setFullName(rs.getString("full_name"));
//                    e.setEmail(rs.getString("email"));
//                    e.setPhone(rs.getString("phone"));
//                    e.setDob(rs.getDate("dob"));
//                    e.setGender(rs.getString("gender"));
//                    e.setEmployeeAvaUrl(rs.getString("employee_ava_url"));
//                    e.setAccStatus(rs.getInt("acc_status"));
//                    return e;
//                }
//            }
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//
//        return null;
//    }


    public int countActiveDoctorsToday(String keyword, String statusFilter) {
        String sql = """
                    SELECT COUNT(DISTINCT e.employee_id)
                    FROM Employees e
                    JOIN DoctorShifts s ON e.employee_id = s.doctor_id
                    WHERE e.role_id = 1
                      AND e.acc_status = 1
                      AND s.shift_date = CAST(GETDATE() AS DATE)
                      AND (? IS NULL OR e.full_name LIKE ?)
                      AND (
                        ? IS NULL OR ? = 'All' OR
                        EXISTS (
                          SELECT 1 FROM DoctorShifts s2
                          WHERE s2.doctor_id = e.employee_id
                            AND s2.shift_date = CAST(GETDATE() AS DATE)
                            AND s2.status = ?
                        )
                      )
                """;

        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int i = 1;
            if (keyword == null || keyword.isEmpty()) {
                ps.setNull(i++, Types.VARCHAR);
                ps.setNull(i++, Types.VARCHAR);
            } else {
                ps.setString(i++, keyword);
                ps.setString(i++, "%" + keyword + "%");
            }

            if (statusFilter == null || statusFilter.equalsIgnoreCase("All")) {
                ps.setNull(i++, Types.VARCHAR);
                ps.setNull(i++, Types.VARCHAR);
                ps.setNull(i++, Types.VARCHAR);
            } else {
                ps.setString(i++, statusFilter);
                ps.setString(i++, statusFilter);
                ps.setString(i++, statusFilter);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }


    public Employee getEmployeeById(int id) {
        String sql = "SELECT * FROM Employees WHERE employee_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Employee employee = new Employee();
                    employee.setEmployeeId(rs.getInt("employee_id"));
                    employee.setUsername(rs.getString("username"));
                    employee.setPasswordHash(rs.getString("password_hash"));
                    employee.setFullName(rs.getString("full_name"));
                    employee.setDob(rs.getDate("dob"));
                    employee.setGender(rs.getString("gender"));
                    employee.setEmail(rs.getString("email"));
                    employee.setPhone(rs.getString("phone"));
                    employee.setRoleId(rs.getInt("role_id"));
                    employee.setEmployeeAvaUrl(rs.getString("employee_ava_url"));
                    employee.setCreatedAt(rs.getDate("created_at")); // ✅ Thêm dòng này
                    employee.setAccStatus(rs.getInt("acc_status"));

                    return employee;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    // 1. Đếm số staff: role_id khác Admin (3) và Manager (4)
    public int countTotalStaff() {
        String sql = "SELECT COUNT(*) FROM Employees WHERE role_id NOT IN (3, 4)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

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

    public boolean isUsernameTaken(String username) {
        String sql = "SELECT 1 FROM Employees WHERE username = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isEmailTaken(String email) {
        String sql = "SELECT 1 FROM Employees WHERE email = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int insertReturnId(Employee employee) {
        String sql = "INSERT INTO Employees " +
                "(username, [password_hash], full_name, dob, gender, email, phone, role_id, employee_ava_url, created_at, acc_status) " +
                "OUTPUT INSERTED.employee_id " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, employee.getUsername());
            ps.setString(2, employee.getPasswordHash());
            ps.setString(3, employee.getFullName());

            if (employee.getDob() != null)
                ps.setDate(4, employee.getDob());
            else
                ps.setNull(4, Types.DATE);

            ps.setString(5, employee.getGender());
            ps.setString(6, employee.getEmail());
            ps.setString(7, employee.getPhone());
            ps.setInt(8, employee.getRoleId());
            ps.setString(9, employee.getEmployeeAvaUrl());

            // created_at dùng timestamp hiện tại
            ps.setTimestamp(10, new java.sql.Timestamp(System.currentTimeMillis()));

            if (employee.getAccStatus() != null)
                ps.setInt(11, employee.getAccStatus());
            else
                ps.setNull(11, Types.INTEGER);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
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
                .accStatus(rs.getObject("acc_status") != null ? rs.getInt("acc_status") : null) // Sửa: lấy acc_status từ DB
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
        ps.setInt(10, e.getAccStatus() != null ? e.getAccStatus() : 1);
    }

    // Test main method for EmployeeDAO
    public static void main(String[] args) {
        EmployeeDAO dao = new EmployeeDAO();

        System.out.println("=== Test login ===");
        System.out.println(dao.login("dr_smith", "123456"));

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