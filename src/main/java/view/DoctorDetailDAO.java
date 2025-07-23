package view;

import model.DoctorDetail;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DoctorDetailDAO extends DBContext<DoctorDetail> {

    public DoctorDetail getByEmployeeId(int employeeId) {
        String sql = "SELECT * FROM DoctorDetails WHERE doctor_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return DoctorDetail.builder()
                            .doctorId(rs.getInt("doctor_id"))
                            .licenseNumber(rs.getString("license_number"))
                            .specialist(rs.getBoolean("is_specialist"))
                            .rating(rs.getBigDecimal("rating"))
                            .build();
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi getByEmployeeId(" + employeeId + "): " + e.getMessage());
        }

        return null;
    }

    public boolean updateDoctorDetails(DoctorDetail doc) {
        String sql = "UPDATE DoctorDetails SET license_number = ?, is_specialist = ?, rating = ? WHERE doctor_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, doc.getLicenseNumber());
            ps.setBoolean(2, doc.isSpecialist());
            ps.setBigDecimal(3, doc.getRating());
            ps.setInt(4, doc.getDoctorId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi updateDoctorDetails: " + e.getMessage());
            return false;
        }
    }


    @Override
    public List<DoctorDetail> select() {
        List<DoctorDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM DoctorDetails";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToDoctorDetail(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace(); // nên thay bằng logger nếu có
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
                    return mapResultSetToDoctorDetail(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(DoctorDetail d) {
        String sql = "INSERT INTO DoctorDetails (doctor_id, license_number, is_specialist, rating) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, d.getDoctorId());
            ps.setString(2, d.getLicenseNumber());
            ps.setBoolean(3, d.isSpecialist());
            ps.setBigDecimal(4, d.getRating());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(DoctorDetail d) {
        String sql = "UPDATE DoctorDetails SET license_number = ?, is_specialist = ?, rating = ? WHERE doctor_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, d.getLicenseNumber());
            ps.setBoolean(2, d.isSpecialist());
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

    private DoctorDetail mapResultSetToDoctorDetail(ResultSet rs) throws SQLException {
        return DoctorDetail.builder()
                .doctorId(rs.getInt("doctor_id"))
                .licenseNumber(rs.getString("license_number"))
                .specialist(rs.getBoolean("is_specialist"))
                .rating(rs.getBigDecimal("rating"))
                .build();
    }
}
