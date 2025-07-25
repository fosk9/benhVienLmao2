package dal;

import model.LogSystem;
import websocket.LogSystemWebSocket;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LogSystemDAO extends DBContext<LogSystem> {

    public LogSystemDAO() {
        super();
    }

    @Override
    public List<LogSystem> select() {
        List<LogSystem> list = new ArrayList<>();
        String sql = "SELECT * FROM LogSystem ORDER BY log_id DESC";
        try (Connection con = getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }

        } catch (Exception e) {
            logError("SELECT ALL", e);
        }
        return list;
    }

    /**
     * Filters logs based on provided criteria.
     * @param username Filters by user_name (LIKE search)
     * @param fromDate Filters by created_at >= fromDate
     * @param toDate Filters by created_at <= toDate
     * @param role Filters by role_name
     * @param logLevel Filters by log_level; ignored if null or empty
     * @param sortOrder Orders by created_at ('Newest First' or 'Oldest First')
     * @return List of filtered LogSystem entries
     */
    public List<LogSystem> filter(String username, String fromDate, String toDate, String role, String logLevel, String sortOrder) {
        List<LogSystem> logs = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT log_id, employee_id, patient_id, user_name, role_name, action, log_level, created_at " +
                        "FROM LogSystem WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        // Add filters
        if (username != null && !username.isEmpty()) {
            sql.append(" AND user_name LIKE ?");
            params.add("%" + username + "%");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND created_at >= ?");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND created_at <= ?");
            params.add(toDate + " 23:59:59");
        }
        if (role != null && !role.isEmpty()) {
            sql.append(" AND role_name = ?");
            params.add(role);
        }
        if (logLevel != null && !logLevel.isEmpty()) {
            sql.append(" AND log_level = ?");
            params.add(logLevel);
        }

        // Add sorting
        sql.append(" ORDER BY created_at");
        if ("Oldest First".equals(sortOrder)) {
            sql.append(" ASC");
        } else {
            sql.append(" DESC");
        }

        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
                // Set parameters
                for (int i = 0; i < params.size(); i++) {
                    stmt.setObject(i + 1, params.get(i));
                }
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        LogSystem log = LogSystem.builder()
                                .logId(rs.getInt("log_id"))
                                .employeeId(rs.getObject("employee_id") != null ? rs.getInt("employee_id") : null)
                                .patientId(rs.getObject("patient_id") != null ? rs.getInt("patient_id") : null)
                                .userName(rs.getString("user_name"))
                                .roleName(rs.getString("role_name"))
                                .action(rs.getString("action"))
                                .logLevel(rs.getString("log_level"))
                                .createdAt(rs.getTimestamp("created_at"))
                                .build();
                        logs.add(log);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error filtering logs: " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return logs;
    }

    @Override
    public LogSystem select(int... id) {
        if (id.length == 0) return null;
        String sql = "SELECT * FROM LogSystem WHERE log_id = ?";
        try (Connection con = getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id[0]);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    LogSystem log = mapResultSet(rs);
                    log.setLogLevel("DEBUG");
                    broadcast(log);
                    return log;
                }
            }

        } catch (Exception e) {
            logError("SELECT BY ID", e);
        }
        return null;
    }

    @Override
    public int insert(LogSystem log) {
        String sql = "INSERT INTO LogSystem (employee_id, patient_id, user_name, role_name, action, log_level, created_at) VALUES (?,?,?,?,?,?,?)";
        try (Connection con = getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            log.setLogLevel("INFO"); // CRUD: Create = INFO

            ps.setObject(1, log.getEmployeeId(), Types.INTEGER);
            ps.setObject(2, log.getPatientId(), Types.INTEGER);
            ps.setString(3, log.getUserName());
            ps.setString(4, log.getRoleName());
            ps.setString(5, log.getAction());
            ps.setString(6, log.getLogLevel());
            ps.setTimestamp(7, log.getCreatedAt());

            int row = ps.executeUpdate();
            broadcast(log);

            return row;

        } catch (Exception e) {
            logError("INSERT LOG", e);
        }
        return 0;
    }

    @Override
    public int update(LogSystem log) {
        String sql = "UPDATE LogSystem SET employee_id=?, patient_id=?, user_name=?, role_name=?, action=?, log_level=?, created_at=? WHERE log_id=?";
        try (Connection con = getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            log.setLogLevel("WARN"); // CRUD: Update = WARN

            ps.setObject(1, log.getEmployeeId(), Types.INTEGER);
            ps.setObject(2, log.getPatientId(), Types.INTEGER);
            ps.setString(3, log.getUserName());
            ps.setString(4, log.getRoleName());
            ps.setString(5, log.getAction());
            ps.setString(6, log.getLogLevel());
            ps.setTimestamp(7, log.getCreatedAt());
            ps.setInt(8, log.getLogId());

            int row = ps.executeUpdate();
            broadcast(log);

            return row;

        } catch (Exception e) {
            logError("UPDATE LOG", e);
        }
        return 0;
    }

    @Override
    public int delete(int... id) {
        if (id.length == 0) return 0;
        String sql = "DELETE FROM LogSystem WHERE log_id = ?";
        try (Connection con = getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int logId = id[0];
            ps.setInt(1, logId);
            int row = ps.executeUpdate();

            // Tạo log cho Delete
            LogSystem log = LogSystem.builder()
                    .logId(logId)
                    .action("Deleted log_id = " + logId)
                    .logLevel("ERROR") // CRUD: Delete = ERROR
                    .createdAt(new Timestamp(System.currentTimeMillis()))
                    .build();

            broadcast(log);

            return row;

        } catch (Exception e) {
            logError("DELETE LOG", e);
        }
        return 0;
    }

    private LogSystem mapResultSet(ResultSet rs) throws SQLException {
        return LogSystem.builder()
                .logId(rs.getInt("log_id"))
                .employeeId((Integer) rs.getObject("employee_id"))
                .patientId((Integer) rs.getObject("patient_id"))
                .userName(rs.getString("user_name"))
                .roleName(rs.getString("role_name"))
                .action(rs.getString("action"))
                .logLevel(rs.getString("log_level"))
                .createdAt(rs.getTimestamp("created_at"))
                .build();
    }

    private void broadcast(LogSystem log) {
        LogSystemWebSocket.broadcast("[" + log.getLogLevel() + "] " + log.getAction());
    }

    private void logError(String action, Exception e) {
        System.out.println("[" + action + " ERROR] " + e.getMessage());
        e.printStackTrace();
    }
}
