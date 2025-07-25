package view;

import model.LogSystem;
import websocket.LogSystemWebSocket;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LogSystemDAO extends DBContext<LogSystem> {

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

    public List<LogSystem> filter(String username, String fromDate, String toDate, String role, String logLevel, String sortOrder) {
        List<LogSystem> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM LogSystem WHERE 1=1");

        if (username != null && !username.isEmpty()) {
            sql.append(" AND user_name LIKE ?");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND created_at >= ?");
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND created_at <= ?");
        }
        if (role != null && !role.equals("All Roles")) {
            sql.append(" AND role_name = ?");
        }
        if (logLevel != null && !logLevel.equals("All Levels")) {
            sql.append(" AND log_level = ?");
        }

        sql.append(" ORDER BY created_at ");
        sql.append(sortOrder.equals("Oldest First") ? "ASC" : "DESC");

        try (Connection con = getConn();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int idx = 1;
            if (username != null && !username.isEmpty()) {
                ps.setString(idx++, "%" + username + "%");
            }
            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setDate(idx++, Date.valueOf(fromDate));
            }
            if (toDate != null && !toDate.isEmpty()) {
                ps.setDate(idx++, Date.valueOf(toDate));
            }
            if (role != null && !role.equals("All Roles")) {
                ps.setString(idx++, role);
            }
            if (logLevel != null && !logLevel.equals("All Levels")) {
                ps.setString(idx++, logLevel);
                System.out.println("FILTER LOGS logLevel: " + logLevel);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }

            System.out.println("FILTER LOGS sql query string: " + sql);

        } catch (Exception e) {
            logError("FILTER LOGS", e);
        }

        return list;
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
