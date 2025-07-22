package view;

import model.Log;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// DAO class for system log operations, extending DBContext
public class LogDAO extends DBContext<Log> {

    public LogDAO() {
        super();
    }

    // Retrieves logs with pagination and filtering
    public List<Log> getLogs(int offset, int limit, String username, String startDate, String endDate, String sortOrder, String roleName, String logLevel) throws SQLException {
        List<Log> logs = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT l.log_id, l.employee_id, l.patient_id, l.action, l.log_level, l.created_at, " +
                        "COALESCE(e.full_name, p.full_name, 'System') AS user_name, " +
                        "COALESCE(r.role_name, 'Patient') AS role_name " +
                        "FROM SystemLogs l " +
                        "LEFT JOIN Employees e ON l.employee_id = e.employee_id " +
                        "LEFT JOIN Patients p ON l.patient_id = p.patient_id " +
                        "LEFT JOIN Roles r ON e.role_id = r.role_id " +
                        "WHERE 1=1"
        );

        List<Object> params = new ArrayList<>();
        if (username != null && !username.isEmpty()) {
            query.append(" AND (LOWER(COALESCE(e.full_name, p.full_name, '')) LIKE ?)");
            params.add("%" + username.toLowerCase() + "%");
        }
        if (startDate != null && !startDate.isEmpty()) {
            query.append(" AND l.created_at >= ?");
            params.add(startDate + " 00:00:00");
        }
        if (endDate != null && !endDate.isEmpty()) {
            query.append(" AND l.created_at <= ?");
            params.add(endDate + " 23:59:59");
        }
        if (roleName != null && !roleName.isEmpty()) {
            query.append(" AND COALESCE(r.role_name, 'Patient') = ?");
            params.add(roleName);
        }
        if (logLevel != null && !logLevel.isEmpty()) {
            query.append(" AND l.log_level = ?");
            params.add(logLevel);
        }

        query.append(" ORDER BY l.created_at ").append("newest".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC");
        query.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConn();
             PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            stmt.setInt(params.size() + 1, offset);
            stmt.setInt(params.size() + 2, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Log log = new Log();
                    log.setLogId(rs.getInt("log_id"));
                    log.setEmployeeId(rs.getObject("employee_id") != null ? rs.getInt("employee_id") : null);
                    log.setPatientId(rs.getObject("patient_id") != null ? rs.getInt("patient_id") : null);
                    log.setUserName(rs.getString("user_name"));
                    log.setRoleName(rs.getString("role_name"));
                    log.setAction(rs.getString("action"));
                    log.setLogLevel(rs.getString("log_level"));
                    log.setCreatedAt(rs.getTimestamp("created_at"));
                    logs.add(log);
                }
            }
        }
        return logs;
    }

    // Counts total logs with filtering
    public int countLogs(String username, String startDate, String endDate, String roleName, String logLevel) throws SQLException {
        StringBuilder query = new StringBuilder(
                "SELECT COUNT(*) AS total " +
                        "FROM SystemLogs l " +
                        "LEFT JOIN Employees e ON l.employee_id = e.employee_id " +
                        "LEFT JOIN Patients p ON l.patient_id = p.patient_id " +
                        "LEFT JOIN Roles r ON e.role_id = r.role_id " +
                        "WHERE 1=1"
        );

        List<Object> params = new ArrayList<>();
        if (username != null && !username.isEmpty()) {
            query.append(" AND (LOWER(COALESCE(e.full_name, p.full_name, '')) LIKE ?)");
            params.add("%" + username.toLowerCase() + "%");
        }
        if (startDate != null && !startDate.isEmpty()) {
            query.append(" AND l.created_at >= ?");
            params.add(startDate + " 00:00:00");
        }
        if (endDate != null && !endDate.isEmpty()) {
            query.append(" AND l.created_at <= ?");
            params.add(endDate + " 23:59:59");
        }
        if (roleName != null && !roleName.isEmpty()) {
            query.append(" AND COALESCE(r.role_name, 'Patient') = ?");
            params.add(roleName);
        }
        if (logLevel != null && !logLevel.isEmpty()) {
            query.append(" AND l.log_level = ?");
            params.add(logLevel);
        }

        try (Connection conn = getConn();
             PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }

    // Gets the latest log ID for real-time updates
    public int getLatestLogId() throws SQLException {
        String query = "SELECT MAX(log_id) AS latest_id FROM SystemLogs";
        try (Connection conn = getConn();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("latest_id");
            }
        }
        return 0;
    }

    // Implements DBContext methods
    @Override
    public List<Log> select() {
        try {
            return getLogs(0, Integer.MAX_VALUE, null, null, null, "newest", null, null);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    @Override
    public Log select(int... id) {
        if (id.length == 0) return null;
        String query = "SELECT l.log_id, l.employee_id, l.patient_id, l.action, l.log_level, l.created_at, " +
                "COALESCE(e.full_name, p.full_name, 'System') AS user_name, " +
                "COALESCE(r.role_name, 'Patient') AS role_name " +
                "FROM SystemLogs l " +
                "LEFT JOIN Employees e ON l.employee_id = e.employee_id " +
                "LEFT JOIN Patients p ON l.patient_id = p.patient_id " +
                "LEFT JOIN Roles r ON e.role_id = r.role_id " +
                "WHERE l.log_id = ?";
        try (Connection conn = getConn();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id[0]);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Log log = new Log();
                    log.setLogId(rs.getInt("log_id"));
                    log.setEmployeeId(rs.getObject("employee_id") != null ? rs.getInt("employee_id") : null);
                    log.setPatientId(rs.getObject("patient_id") != null ? rs.getInt("patient_id") : null);
                    log.setUserName(rs.getString("user_name"));
                    log.setRoleName(rs.getString("role_name"));
                    log.setAction(rs.getString("action"));
                    log.setLogLevel(rs.getString("log_level"));
                    log.setCreatedAt(rs.getTimestamp("created_at"));
                    return log;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(Log log) {
        String query = "INSERT INTO SystemLogs (employee_id, patient_id, action, log_level, created_at) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            if (log.getEmployeeId() != null) {
                stmt.setInt(1, log.getEmployeeId());
                stmt.setNull(2, java.sql.Types.INTEGER);
            } else if (log.getPatientId() != null) {
                stmt.setNull(1, java.sql.Types.INTEGER);
                stmt.setInt(2, log.getPatientId());
            } else {
                stmt.setNull(1, java.sql.Types.INTEGER);
                stmt.setNull(2, java.sql.Types.INTEGER);
            }
            stmt.setString(3, log.getAction());
            stmt.setString(4, log.getLogLevel());
            stmt.setTimestamp(5, log.getCreatedAt());
            return stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int update(Log obj) {
        // Logs are typically immutable
        return 0;
    }

    @Override
    public int delete(int... id) {
        if (id.length == 0) return 0;
        String query = "DELETE FROM SystemLogs WHERE log_id = ?";
        try (Connection conn = getConn();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id[0]);
            return stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
}