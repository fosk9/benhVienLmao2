package view;

import model.DoctorScheduleSummary;
import model.DoctorShift;
import model.DoctorShiftView;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class DoctorShiftDAO extends DBContext<DoctorShift> {

    public boolean hasAppointmentsForDoctorInShift(int doctorId, Date shiftDate, String timeSlot) {
        String sql = """
            SELECT 1 FROM Appointments
            WHERE doctor_id = ? AND appointment_date = ? AND time_slot = ?
        """;
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.setDate(2, shiftDate);
            ps.setString(3, timeSlot);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


    public int countDoctorSummarySchedule(String keyword, Date from, Date to, String statusFilter) {
        String sql = """
        SELECT COUNT(*) AS total
        FROM (
            SELECT e.employee_id
            FROM Employees e
            LEFT JOIN DoctorShifts s ON e.employee_id = s.doctor_id
            WHERE e.role_id = 1
              AND (? IS NULL OR e.full_name LIKE ?)
              AND (? IS NULL OR s.shift_date >= ?)
              AND (? IS NULL OR s.shift_date <= ?)
            GROUP BY e.employee_id, e.full_name, e.email
            HAVING (? IS NULL OR MAX(CASE WHEN s.shift_date = CAST(GETDATE() AS DATE) THEN s.status ELSE NULL END) = ?)
        ) AS filtered
    """;

        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int i = 1;

            if (keyword == null || keyword.trim().isEmpty()) {
                ps.setNull(i++, Types.VARCHAR);
                ps.setNull(i++, Types.VARCHAR);
            } else {
                ps.setString(i++, keyword);
                ps.setString(i++, "%" + keyword + "%");
            }

            if (from == null) {
                ps.setNull(i++, Types.DATE);
                ps.setNull(i++, Types.DATE);
            } else {
                ps.setDate(i++, from);
                ps.setDate(i++, from);
            }

            if (to == null) {
                ps.setNull(i++, Types.DATE);
                ps.setNull(i++, Types.DATE);
            } else {
                ps.setDate(i++, to);
                ps.setDate(i++, to);
            }

            if (statusFilter == null || statusFilter.equalsIgnoreCase("All") || statusFilter.isEmpty()) {
                ps.setNull(i++, Types.VARCHAR);
                ps.setNull(i++, Types.VARCHAR);
            } else {
                ps.setString(i++, statusFilter);
                ps.setString(i++, statusFilter);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }


    public List<DoctorShiftView> getDoctorSummarySchedule(String keyword, Date from, Date to, String statusFilter, int offset, int limit) {
        List<DoctorShiftView> list = new ArrayList<>();
        String sql = """
        SELECT 
            e.employee_id,
            e.full_name,
            e.email,
            COUNT(CASE 
                      WHEN MONTH(s.shift_date) = MONTH(GETDATE()) 
                       AND YEAR(s.shift_date) = YEAR(GETDATE()) THEN 1 
                      ELSE NULL 
                 END) AS working_days_this_month,
            MAX(CASE WHEN s.shift_date = CAST(GETDATE() AS DATE) THEN s.status ELSE NULL END) AS status_today
        FROM Employees e
        LEFT JOIN DoctorShifts s ON e.employee_id = s.doctor_id
        WHERE e.role_id = 1
          AND (? IS NULL OR e.full_name LIKE ?)
          AND (? IS NULL OR s.shift_date >= ?)
          AND (? IS NULL OR s.shift_date <= ?)
        GROUP BY e.employee_id, e.full_name, e.email
        HAVING (? IS NULL OR MAX(CASE WHEN s.shift_date = CAST(GETDATE() AS DATE) THEN s.status ELSE NULL END) = ?)
        ORDER BY e.full_name
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int i = 1;

            // keyword
            if (keyword == null || keyword.trim().isEmpty()) {
                ps.setNull(i++, Types.VARCHAR);
                ps.setNull(i++, Types.VARCHAR);
            } else {
                ps.setString(i++, keyword);
                ps.setString(i++, "%" + keyword + "%");
            }

            // from
            if (from == null) {
                ps.setNull(i++, Types.DATE);
                ps.setNull(i++, Types.DATE);
            } else {
                ps.setDate(i++, from);
                ps.setDate(i++, from);
            }

            // to
            if (to == null) {
                ps.setNull(i++, Types.DATE);
                ps.setNull(i++, Types.DATE);
            } else {
                ps.setDate(i++, to);
                ps.setDate(i++, to);
            }

            // statusToday filter
            if (statusFilter == null || statusFilter.equalsIgnoreCase("All") || statusFilter.isEmpty()) {
                ps.setNull(i++, Types.VARCHAR);
                ps.setNull(i++, Types.VARCHAR);
            } else {
                ps.setString(i++, statusFilter);
                ps.setString(i++, statusFilter);
            }

            // offset + limit
            ps.setInt(i++, offset);
            ps.setInt(i, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(DoctorShiftView.builder()
                            .doctorId(rs.getInt("employee_id"))
                            .doctorName(rs.getString("full_name"))
                            .doctorEmail(rs.getString("email"))
                            .workingDaysThisMonth(rs.getInt("working_days_this_month"))
                            .statusToday(rs.getString("status_today"))
                            .build());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }



    public List<DoctorScheduleSummary> getDoctorShiftSummaryForMonth(LocalDate today) {
        List<DoctorScheduleSummary> list = new ArrayList<>();
        String sql = """
        SELECT 
            e.employee_id,
            e.full_name,
            e.email,
            SUM(CASE WHEN MONTH(s.shift_date) = ? AND YEAR(s.shift_date) = ? THEN 1 ELSE 0 END) AS working_days_this_month,
            MAX(CASE WHEN s.shift_date = ? THEN s.status ELSE NULL END) AS status_today
        FROM Employees e
        LEFT JOIN DoctorShifts s ON e.employee_id = s.doctor_id
        WHERE e.role_id = 2  -- chỉ lấy bác sĩ
        GROUP BY e.employee_id, e.full_name, e.email
    """;
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, today.getMonthValue());
            ps.setInt(2, today.getYear());
            ps.setDate(3, Date.valueOf(today));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(DoctorScheduleSummary.builder()
                            .doctorId(rs.getInt("employee_id"))
                            .doctorName(rs.getString("full_name"))
                            .doctorEmail(rs.getString("email"))
                            .workingDaysThisMonth(rs.getInt("working_days_this_month"))
                            .statusToday(rs.getString("status_today")) // null nếu không có lịch
                            .build());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    public int getTotalFilteredDoctorShifts(String keyword, Date from, Date to) {
        String sql = """
        SELECT COUNT(*)
        FROM DoctorShifts s
        JOIN Employees e ON s.doctor_id = e.employee_id
        WHERE (? IS NULL OR e.full_name LIKE ?)
          AND (? IS NULL OR s.shift_date >= ?)
          AND (? IS NULL OR s.shift_date <= ?)
    """;
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (keyword == null || keyword.trim().isEmpty()) {
                ps.setNull(1, Types.VARCHAR);
                ps.setNull(2, Types.VARCHAR);
            } else {
                ps.setString(1, keyword);
                ps.setString(2, "%" + keyword + "%");
            }
            if (from == null) {
                ps.setNull(3, Types.DATE);
                ps.setNull(4, Types.DATE);
            } else {
                ps.setDate(3, from);
                ps.setDate(4, from);
            }
            if (to == null) {
                ps.setNull(5, Types.DATE);
                ps.setNull(6, Types.DATE);
            } else {
                ps.setDate(5, to);
                ps.setDate(6, to);
            }

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }


    public List<DoctorShiftView> filterShiftWithDoctor(String keyword, Date from, Date to, int offset, int limit) {
        List<DoctorShiftView> list = new ArrayList<>();
        String sql = """
        SELECT s.shift_id, s.doctor_id, e.full_name AS doctor_name, e.email AS doctor_email,
               s.shift_date, s.time_slot, s.status, s.manager_id, s.requested_at, s.approved_at
        FROM DoctorShifts s
        JOIN Employees e ON s.doctor_id = e.employee_id
        WHERE (? IS NULL OR e.full_name LIKE ?)
          AND (? IS NULL OR s.shift_date >= ?)
          AND (? IS NULL OR s.shift_date <= ?)
        ORDER BY s.shift_date DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (keyword == null || keyword.trim().isEmpty()) {
                ps.setNull(1, Types.VARCHAR);
                ps.setNull(2, Types.VARCHAR);
            } else {
                ps.setString(1, keyword);
                ps.setString(2, "%" + keyword + "%");
            }
            if (from == null) {
                ps.setNull(3, Types.DATE);
                ps.setNull(4, Types.DATE);
            } else {
                ps.setDate(3, from);
                ps.setDate(4, from);
            }
            if (to == null) {
                ps.setNull(5, Types.DATE);
                ps.setNull(6, Types.DATE);
            } else {
                ps.setDate(5, to);
                ps.setDate(6, to);
            }

            ps.setInt(7, offset);
            ps.setInt(8, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(DoctorShiftView.builder()
                            .shiftId(rs.getInt("shift_id"))
                            .doctorId(rs.getInt("doctor_id"))
                            .doctorName(rs.getString("doctor_name"))
                            .doctorEmail(rs.getString("doctor_email"))
                            .shiftDate(rs.getDate("shift_date"))
                            .timeSlot(rs.getString("time_slot"))
                            .status(rs.getString("status"))
                            .managerId(rs.getObject("manager_id") != null ? rs.getInt("manager_id") : null)
                            .requestedAt(rs.getTimestamp("requested_at"))
                            .approvedAt(rs.getTimestamp("approved_at"))
                            .build());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }



    public int getTotalAppointmentsToday() {
        String sql = "SELECT COUNT(*) FROM Appointments WHERE appointment_date = CAST(GETDATE() AS DATE)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
    public int getTotalStaff() {
        String sql = "SELECT COUNT(*) FROM Employees";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
    public int getActiveDoctorsToday() {
        String sql = "SELECT COUNT(DISTINCT doctor_id) FROM DoctorShifts WHERE shift_date = CAST(GETDATE() AS DATE)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }


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
    public boolean existsShift(int doctorId, Date shiftDate, String timeSlot) {
        String sql = "SELECT 1 FROM DoctorShifts WHERE doctor_id=? AND shift_date=? AND time_slot=?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.setDate(2, shiftDate);
            ps.setString(3, timeSlot);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Có tồn tại lịch trùng
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


    @Override
    public int insert(DoctorShift s) {
        if (existsShift(s.getDoctorId(), s.getShiftDate(), s.getTimeSlot())) {
            System.out.println("Duplicate shift detected. Insert aborted.");
            return -1; // Lịch đã tồn tại
        }

        String sql = "INSERT INTO DoctorShifts (doctor_id, shift_date, time_slot, status, manager_id, requested_at, approved_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            setPreparedStatementFromDoctorShift(ps, s);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        s.setShiftId(rs.getInt(1));
                    }
                }
            }
            return rows;
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
