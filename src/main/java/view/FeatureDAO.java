package view;

import model.DAO.DBContext;
import model.Feature;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FeatureDAO {
    // Find feature by ID
    public Feature findById(int featureId) throws SQLException {
        String sql = "SELECT * FROM Features WHERE feature_id = ?";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, featureId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Feature(
                            rs.getInt("feature_id"),
                            rs.getString("feature_name")
                    );
                }
            }
        }
        return null;
    }

    // Find all features
    public List<Feature> findAll() throws SQLException {
        List<Feature> features = new ArrayList<>();
        String sql = "SELECT * FROM Features";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                features.add(new Feature(
                        rs.getInt("feature_id"),
                        rs.getString("feature_name")
                ));
            }
        }
        return features;
    }

    // Save new feature
    public void save(Feature feature) throws SQLException {
        String sql = "INSERT INTO Features (feature_name) VALUES (?)";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, feature.getFeatureName());
            stmt.executeUpdate();
        }
    }

    // Update existing feature
    public void update(Feature feature) throws SQLException {
        String sql = "UPDATE Features SET feature_name = ? WHERE feature_id = ?";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, feature.getFeatureName());
            stmt.setInt(2, feature.getFeatureId());
            stmt.executeUpdate();
        }
    }

    // Delete feature
    public void delete(int featureId) throws SQLException {
        String sql = "DELETE FROM Features WHERE feature_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, featureId);
            stmt.executeUpdate();
        }
    }
}