package view;

import view.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

public class ReportDAO extends DBContext<Object> {

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

    public Map<String, Double> getIncomeByAppointmentType() {
        Map<String, Double> map = new LinkedHashMap<>();
        String sql = """
                    SELECT at.type_name, SUM(p.amount) AS total_income
                    FROM Payments p
                    JOIN Appointments a ON p.appointment_id = a.appointment_id
                    JOIN AppointmentType at ON a.appointmenttype_id = at.appointmenttype_id
                    WHERE p.status = 'Paid'
                    GROUP BY at.type_name
                    ORDER BY total_income DESC
                """;
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getString("type_name"), rs.getDouble("total_income"));
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

    public Map<String, Integer> getTopDiagnoses() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = """
                    SELECT TOP 5 notes, COUNT(*) AS freq
                    FROM Diagnoses
                    GROUP BY notes
                    ORDER BY freq DESC
                """;
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getString("notes"), rs.getInt("freq"));
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
