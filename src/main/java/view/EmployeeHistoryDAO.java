package view;

import model.EmployeeHistory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeHistoryDAO extends DBContext<EmployeeHistory> {

    public List<EmployeeHistory> getHistoryByEmployeeId(int employeeId) {
        List<EmployeeHistory> list = new ArrayList<>();
        String sql = "SELECT * FROM EmployeeHistory WHERE employee_id = ? ORDER BY date DESC, history_id DESC";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToEmployeeHistory(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int insertHistory(int employeeId, int roleId, Date date) {
        String sql = "INSERT INTO EmployeeHistory (employee_id, role_id, date) VALUES (?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, roleId);
            ps.setDate(3, date);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int deleteHistoryByEmployeeId(int employeeId) {
        String sql = "DELETE FROM EmployeeHistory WHERE employee_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private EmployeeHistory mapResultSetToEmployeeHistory(ResultSet rs) throws SQLException {
        return EmployeeHistory.builder()
                .historyId(rs.getInt("history_id"))
                .employeeId(rs.getInt("employee_id"))
                .roleId(rs.getInt("role_id"))
                .date(rs.getDate("date"))
                .build();
    }

    // Not used, but required by DBContext
    @Override
    public List<EmployeeHistory> select() {
        return null;
    }

    @Override
    public EmployeeHistory select(int... id) {
        return null;
    }

    @Override
    public int insert(EmployeeHistory entity) {
        return 0;
    }

    @Override
    public int update(EmployeeHistory entity) {
        return 0;
    }

    @Override
    public int delete(int... id) {
        return 0;
    }
}
