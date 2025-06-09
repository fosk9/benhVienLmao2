package view;

import model.AppointmentType;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class AppointmentTypeDAO extends DBContext<AppointmentType> {
    private static final Logger LOGGER = Logger.getLogger(AppointmentTypeDAO.class.getName());

    @Override
    public List<AppointmentType> select() {
        List<AppointmentType> list = new ArrayList<>();
        String sql = "SELECT * FROM AppointmentType";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToAppointmentType(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public AppointmentType select(int... id) {
        if (id.length < 1) return null;
        String sql = "SELECT * FROM AppointmentType WHERE appointmenttype_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToAppointmentType(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(AppointmentType obj) {
        String sql = "INSERT INTO AppointmentType (type_name, description, price) VALUES (?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, obj.getTypeName());
            ps.setString(2, obj.getDescription());
            ps.setBigDecimal(3, obj.getPrice());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int update(AppointmentType obj) {
        String sql = "UPDATE AppointmentType SET type_name = ?, description = ?, price = ? WHERE appointmenttype_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, obj.getTypeName());
            ps.setString(2, obj.getDescription());
            ps.setBigDecimal(3, obj.getPrice());
            ps.setInt(4, obj.getAppointmentTypeId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int delete(int... id) {
        if (id.length < 1) return 0;
        String sql = "DELETE FROM AppointmentType WHERE appointmenttype_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public BigDecimal getPrice(int appointmenttype_id) {
        String sql = "SELECT price FROM AppointmentType WHERE appointmenttype_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, appointmenttype_id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    BigDecimal price = rs.getBigDecimal("price");
                    if (price == null) {
                        LOGGER.warning("Null price found for appointmenttype_id=" + appointmenttype_id);
                    } else {
                        LOGGER.info("Retrieved price=" + price + " for appointmenttype_id=" + appointmenttype_id);
                    }
                    return price;
                } else {
                    LOGGER.warning("No price found for appointmenttype_id=" + appointmenttype_id);
                    return null;
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving price for appointmenttype_id=" + appointmenttype_id + ": " + e.getMessage());
            throw new RuntimeException("Failed to retrieve price", e);
        } finally {
            closeConnection(conn);
        }
    }


    private AppointmentType mapResultSetToAppointmentType(ResultSet rs) throws SQLException {
        return AppointmentType.builder()
                .appointmentTypeId(rs.getInt("appointmenttype_id"))
                .typeName(rs.getString("type_name"))
                .description(rs.getString("description"))
                .price(rs.getBigDecimal("price"))
                .build();
    }
}
