package view;

import dto.ActivityReport;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.*;

public class ReportDAO extends DBContext<Object> {

    public List<ActivityReport> filterReports(Date fromDate, Date toDate, Integer month, Integer year, String keyword) {
        List<ActivityReport> list = new ArrayList<>();

        String sql = "SELECT a.created_at, a.updated_at, at.type_name AS service_name, " +
                "d.employee_id AS doctor_id, d.full_name AS doctor_name, " +
                "p.patient_id AS patient_id, p.full_name AS patient_name, " +
                "pm.amount AS total_amount " +
                "FROM Appointments a " +
                "JOIN AppointmentType at ON a.appointmenttype_id = at.appointmenttype_id " +
                "JOIN Employees d ON a.doctor_id = d.employee_id " +
                "JOIN Patients p ON a.patient_id = p.patient_id " +
                "INNER JOIN Payments pm ON a.appointment_id = pm.appointment_id AND pm.status = 'Paid' " +
                "WHERE 1=1 ";

        if (fromDate != null) {
            sql += "AND a.created_at >= ? ";
        }
        if (toDate != null) {
            sql += "AND a.updated_at <= ? ";
        }
        if (month != null && year != null) {
            sql += "AND MONTH(a.created_at) = ? AND YEAR(a.created_at) = ? ";
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += "AND (at.type_name LIKE ? OR d.full_name LIKE ? OR p.full_name LIKE ?) ";
        }

        sql += "ORDER BY a.created_at ASC, a.updated_at ASC";

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int i = 1;
            if (fromDate != null) ps.setDate(i++, fromDate);
            if (toDate != null) ps.setDate(i++, toDate);
            if (month != null && year != null) {
                ps.setInt(i++, month);
                ps.setInt(i++, year);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(i++, kw);
                ps.setString(i++, kw);
                ps.setString(i++, kw);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ActivityReport report = new ActivityReport(
                        rs.getDate("created_at"),
                        rs.getDate("updated_at"),
                        rs.getString("service_name"),
                        rs.getString("doctor_name"),
                        rs.getString("patient_name"),
                        rs.getBigDecimal("total_amount"),
                        rs.getInt("doctor_id"),
                        rs.getInt("patient_id")
                );

                list.add(report);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    public List<String> getPopularServicesLimit(int limit) {
        List<String> topServices = new ArrayList<>();
        String sql = """
                    SELECT TOP (?) at.type_name, COUNT(*) AS cnt
                    FROM Appointments a
                    JOIN AppointmentType at ON a.appointmenttype_id = at.appointmenttype_id
                    WHERE a.status IN ('Confirmed', 'Completed')
                    GROUP BY at.type_name
                    ORDER BY cnt DESC
                """;
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                topServices.add(rs.getString("type_name") + " (" + rs.getInt("cnt") + " appointments)");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return topServices;
    }

    public List<String> getTopDoctorsLimit(int limit) {
        List<String> topDoctors = new ArrayList<>();
        String sql = """
                    SELECT TOP (?) e.full_name, SUM(p.amount) AS income
                    FROM Payments p
                    JOIN Appointments a ON p.appointment_id = a.appointment_id
                    JOIN Employees e ON a.doctor_id = e.employee_id
                    WHERE p.status = 'Paid'
                    GROUP BY e.full_name
                    ORDER BY income DESC
                """;
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String row = rs.getString("full_name") + " – " +
                        String.format("%,.0f VND", rs.getDouble("income"));
                topDoctors.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return topDoctors;
    }

    public Map<String, Double> getIncomeByDoctor() {
        Map<String, Double> map = new LinkedHashMap<>();
        String sql = """
                    SELECT TOP 5 e.full_name AS doctor_name, SUM(p.amount) AS total_income
                    FROM Payments p
                    JOIN Appointments a ON p.appointment_id = a.appointment_id
                    JOIN Employees e ON a.doctor_id = e.employee_id
                    WHERE p.status = 'Paid'
                    GROUP BY e.full_name
                    ORDER BY total_income DESC
                """;
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getString("doctor_name"), rs.getDouble("total_income"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public List<Double> getGrowthTwoRecentMonths() {
        List<Double> incomeList = new ArrayList<>();
        String sql = """
                    SELECT TOP 2 FORMAT(created_at, 'yyyy-MM') AS month, SUM(amount) AS total
                    FROM Payments
                    WHERE status = 'Paid'
                    GROUP BY FORMAT(created_at, 'yyyy-MM')
                    ORDER BY month DESC
                """;
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                incomeList.add(rs.getDouble("total"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return incomeList;
    }

    public Map<String, Double> getMonthlyIncome() {
        Map<String, Double> map = new LinkedHashMap<>();
        String sql = """
                    SELECT FORMAT(created_at, 'yyyy-MM') AS month, SUM(amount) as total
                    FROM Payments
                    WHERE status = 'Paid'
                    GROUP BY FORMAT(created_at, 'yyyy-MM')
                    ORDER BY month
                """;
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getString("month"), rs.getDouble("total"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public Map<String, Integer> getAppointmentTypeDistribution() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = """
                    SELECT at.type_name, COUNT(*) as count
                    FROM Appointments a
                    JOIN AppointmentType at ON a.appointmenttype_id = at.appointmenttype_id
                    GROUP BY at.type_name
                """;
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getString("type_name"), rs.getInt("count"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    // === CRUD methods (required but unused in this context) ===

    @Override
    public List<Object> select() {
        return Collections.emptyList();
    }

    @Override
    public Object select(int... id) {
        return null;
    }

    @Override
    public int insert(Object obj) {
        return 0;
    }

    @Override
    public int update(Object obj) {
        return 0;
    }

    @Override
    public int delete(int... id) {
        return 0;
    }
}
