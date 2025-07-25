package dal;

import model.ChangeHistory;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ChangeHistoryDAO extends DBContext<ChangeHistory> {

    private ChangeHistory map(ResultSet rs) throws SQLException {
        return ChangeHistory.builder()
                .changeId(rs.getInt("change_id"))
                .managerId(rs.getInt("manager_id"))
                .managerName(rs.getString("manager_name"))
                .targetUserId(rs.getInt("target_user_id"))
                .targetUserName(rs.getString("target_user_name"))
                .targetSource(rs.getString("target_source"))
                .action(rs.getString("action"))
                .changeTime(rs.getTimestamp("change_time"))
                .build();
    }

    @Override
    public List<ChangeHistory> select() {
        List<ChangeHistory> list = new ArrayList<>();
        String sql = "SELECT * FROM ChangeHistory ORDER BY change_time DESC";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public ChangeHistory select(int... id) {
        if (id.length == 0) return null;
        String sql = "SELECT * FROM ChangeHistory WHERE change_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(ChangeHistory history) {
        String sql = "INSERT INTO ChangeHistory (manager_id, manager_name, target_user_id, target_user_name, target_source, action, change_time) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, history.getManagerId());
            ps.setString(2, history.getManagerName());
            ps.setInt(3, history.getTargetUserId());
            ps.setString(4, history.getTargetUserName());
            ps.setString(5, history.getTargetSource());
            ps.setString(6, history.getAction());
            ps.setTimestamp(7, new Timestamp(history.getChangeTime().getTime()));
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(ChangeHistory obj) {
        return 0; // Không cần update lịch sử thay đổi
    }

    @Override
    public int delete(int... id) {
        if (id.length == 0) return 0;
        String sql = "DELETE FROM ChangeHistory WHERE change_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM ChangeHistory";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }


    public int countFiltered(String keyword, String source, String action, Date from, Date to) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM ChangeHistory WHERE 1=1");

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (manager_name LIKE ? OR target_user_name LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }

        if (source != null && !source.trim().isEmpty()) {
            sql.append(" AND LOWER(target_source) = ?");
            params.add(source.toLowerCase());
        }

        if (action != null && !action.trim().isEmpty()) {
            switch (action.toLowerCase()) {
                case "create":
                    sql.append(" AND LOWER(action) LIKE '%create%'");
                    break;
                case "update":
                    sql.append(" AND LOWER(action) LIKE '%update%'");
                    break;
                case "delete":
                    sql.append(" AND LOWER(action) LIKE '%delete%'");
                    break;
                case "other":
                    sql.append(" AND LOWER(action) NOT LIKE '%create%'")
                            .append(" AND LOWER(action) NOT LIKE '%update%'")
                            .append(" AND LOWER(action) NOT LIKE '%delete%'");
                    break;
            }
        }


        if (from != null) {
            sql.append(" AND change_time >= ?");
            params.add(new Timestamp(from.getTime()));
        }

        if (to != null) {
            sql.append(" AND change_time <= ?");
            params.add(new Timestamp(to.getTime()));
        }

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return count;
    }


    public List<ChangeHistory> selectFiltered(int offset, int limit, String keyword, String source, String action, Date from, Date to) {
        List<ChangeHistory> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM ChangeHistory WHERE 1=1");

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (manager_name LIKE ? OR target_user_name LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }

        if (source != null && !source.trim().isEmpty()) {
            sql.append(" AND LOWER(target_source) = ?");
            params.add(source.toLowerCase());
        }

        if (action != null && !action.trim().isEmpty()) {
            switch (action.toLowerCase()) {
                case "create":
                    sql.append(" AND LOWER(action) LIKE '%create%'");
                    break;
                case "update":
                    sql.append(" AND LOWER(action) LIKE '%update%'");
                    break;
                case "delete":
                    sql.append(" AND LOWER(action) LIKE '%delete%'");
                    break;
                case "other":
                    sql.append(" AND LOWER(action) NOT LIKE '%create%'")
                            .append(" AND LOWER(action) NOT LIKE '%update%'")
                            .append(" AND LOWER(action) NOT LIKE '%delete%'");
                    break;
            }
        }


        if (from != null) {
            sql.append(" AND change_time >= ?");
            params.add(new Timestamp(from.getTime()));
        }

        if (to != null) {
            sql.append(" AND change_time <= ?");
            params.add(new Timestamp(to.getTime()));
        }

        sql.append(" ORDER BY change_time DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }


    public int countToday() {
        String sql = "SELECT COUNT(*) FROM ChangeHistory WHERE CAST(change_time AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countLast24h() {
        String sql = "SELECT COUNT(*) FROM ChangeHistory WHERE change_time >= DATEADD(HOUR, -24, GETDATE())";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countActiveManagers() {
        String sql = "SELECT COUNT(*) FROM Employees WHERE acc_status = 1 AND role_id IN (SELECT role_id FROM Roles WHERE role_name LIKE '%manager%')";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
