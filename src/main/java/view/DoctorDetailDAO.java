package view;

import model.DoctorDetail;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DoctorDetailDAO extends DBContext<DoctorDetail> {

    @Override
    public List<DoctorDetail> select() {
        List<DoctorDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM DoctorDetails";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(DoctorDetail.builder()
                        .doctorId(rs.getInt("doctor_id"))
                        .licenseNumber(rs.getString("license_number"))
                        .workSchedule(rs.getString("work_schedule"))
                        .rating(rs.getBigDecimal("rating"))
                        .build());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public DoctorDetail select(int... id) {
        if (id.length == 0) return null;
        String sql = "SELECT * FROM DoctorDetails WHERE doctor_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return DoctorDetail.builder()
                            .doctorId(rs.getInt("doctor_id"))
                            .licenseNumber(rs.getString("license_number"))
                            .workSchedule(rs.getString("work_schedule"))
                            .rating(rs.getBigDecimal("rating"))
                            .build();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(DoctorDetail d) {
        String sql = "INSERT INTO DoctorDetails (doctor_id, license_number, work_schedule, rating) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, d.getDoctorId());
            ps.setString(2, d.getLicenseNumber());
            ps.setString(3, d.getWorkSchedule());
            ps.setBigDecimal(4, d.getRating());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(DoctorDetail d) {
        String sql = "UPDATE DoctorDetails SET license_number = ?, work_schedule = ?, rating = ? WHERE doctor_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, d.getLicenseNumber());
            ps.setString(2, d.getWorkSchedule());
            ps.setBigDecimal(3, d.getRating());
            ps.setInt(4, d.getDoctorId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(int... id) {
        if (id.length == 0) return 0;
        String sql = "DELETE FROM DoctorDetails WHERE doctor_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
