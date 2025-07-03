package view;

import model.DoctorShift;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DoctorShiftDAO extends DBContext<DoctorShift> {

    public List<DoctorShift> getDoctorsForSlot(Date date, String timeSlot) {
        List<DoctorShift> list = new ArrayList<>();
        String sql = """
                    SELECT * FROM DoctorShifts
                    WHERE shift_date = ? AND time_slot = ? AND status = 'Working'
                """;
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, date);
            ps.setString(2, timeSlot);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToDoctorShift(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<DoctorShift> select() {
        List<DoctorShift> list = new ArrayList<>();
        String sql = "SELECT * FROM DoctorShifts";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToDoctorShift(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public DoctorShift select(int... id) {
        if (id.length == 0) return null;
        String sql = "SELECT * FROM DoctorShifts WHERE shift_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDoctorShift(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(DoctorShift s) {
        String sql = "INSERT INTO DoctorShifts (doctor_id, shift_date, time_slot, status, manager_id, requested_at, approved_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setPreparedStatementFromDoctorShift(ps, s);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(DoctorShift s) {
        String sql = "UPDATE DoctorShifts SET doctor_id=?, shift_date=?, time_slot=?, status=?, manager_id=?, requested_at=?, approved_at=? WHERE shift_id=?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setPreparedStatementFromDoctorShift(ps, s);
            ps.setInt(8, s.getShiftId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(int... id) {
        if (id.length == 0) return 0;
        String sql = "DELETE FROM DoctorShifts WHERE shift_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ======================= PHỤC VỤ DoctorShiftServlet =======================

    public List<DoctorShift> selectByDoctorAndDateRange(int doctorId, Date from, Date to) {
        List<DoctorShift> list = new ArrayList<>();
        String sql = "SELECT * FROM DoctorShifts WHERE doctor_id = ? AND shift_date BETWEEN ? AND ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.setDate(2, from);
            ps.setDate(3, to);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToDoctorShift(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int markPendingLeave(int shiftId, int doctorId) {
        String sql = "UPDATE DoctorShifts SET status='PendingLeave', requested_at=GETDATE() WHERE shift_id=? AND doctor_id=?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shiftId);
            ps.setInt(2, doctorId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ======================= MAP - SET =======================

    private DoctorShift mapResultSetToDoctorShift(ResultSet rs) throws SQLException {
        return DoctorShift.builder()
                .shiftId(rs.getInt("shift_id"))
                .doctorId(rs.getInt("doctor_id"))
                .shiftDate(rs.getDate("shift_date"))
                .timeSlot(rs.getString("time_slot"))
                .status(rs.getString("status"))
                .managerId(rs.getObject("manager_id") != null ? rs.getInt("manager_id") : null)
                .requestedAt(rs.getTimestamp("requested_at"))
                .approvedAt(rs.getTimestamp("approved_at"))
                .build();
    }

    private void setPreparedStatementFromDoctorShift(PreparedStatement ps, DoctorShift s) throws SQLException {
        ps.setInt(1, s.getDoctorId());
        ps.setDate(2, s.getShiftDate());
        ps.setString(3, s.getTimeSlot());
        ps.setString(4, s.getStatus());

        if (s.getManagerId() != null) {
            ps.setInt(5, s.getManagerId());
        } else {
            ps.setNull(5, Types.INTEGER);
        }

        if (s.getRequestedAt() != null) {
            ps.setTimestamp(6, s.getRequestedAt());
        } else {
            ps.setNull(6, Types.TIMESTAMP);
        }

        if (s.getApprovedAt() != null) {
            ps.setTimestamp(7, s.getApprovedAt());
        } else {
            ps.setNull(7, Types.TIMESTAMP);
        }
    }
}
