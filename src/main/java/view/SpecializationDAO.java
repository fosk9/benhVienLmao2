package view;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SpecializationDAO extends DBContext<String> {
    public SpecializationDAO() {
        super();
    }

    // Fetch the specialization name by specialization_id
    public String getSpecializationName(int specializationId) {
        String query = "SELECT name FROM Specializations WHERE specialization_id = ?";
        try (Connection conn = getConn(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, specializationId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("name");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public java.util.List<String> select() {
        throw new UnsupportedOperationException("Not implemented");
    }

    @Override
    public String select(int... id) {
        throw new UnsupportedOperationException("Not implemented");
    }

    @Override
    public int insert(String obj) {
        throw new UnsupportedOperationException("Not implemented");
    }

    @Override
    public int update(String obj) {
        throw new UnsupportedOperationException("Not implemented");
    }

    @Override
    public int delete(int... id) {
        throw new UnsupportedOperationException("Not implemented");
    }
}