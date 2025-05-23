package view;

import model.DAO.DBContext;
import model.Patient;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {
    // Find patient by ID
    public Patient findById(int patientId) throws SQLException {
        String sql = "SELECT * FROM Patients WHERE patient_id = ?";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Patient(
                            rs.getInt("patient_id"),
                            rs.getString("username"),
                            rs.getString("password_hash"),
                            rs.getString("full_name"),
                            rs.getObject("dob", LocalDate.class),
                            rs.getString("gender"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getString("address"),
                            rs.getString("insurance_number"),
                            rs.getString("emergency_contact")
                    );
                }
            }
        }
        return null;
    }

    // Find patient by username
    public Patient findByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM Patients WHERE username = ?";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Patient(
                            rs.getInt("patient_id"),
                            rs.getString("username"),
                            rs.getString("password_hash"),
                            rs.getString("full_name"),
                            rs.getObject("dob", LocalDate.class),
                            rs.getString("gender"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getString("address"),
                            rs.getString("insurance_number"),
                            rs.getString("emergency_contact")
                    );
                }
            }
        }
        return null;
    }

    // Find all patients
    public List<Patient> findAll() throws SQLException {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT * FROM Patients";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                patients.add(new Patient(
                        rs.getInt("patient_id"),
                        rs.getString("username"),
                        rs.getString("password_hash"),
                        rs.getString("full_name"),
                        rs.getObject("dob", LocalDate.class),
                        rs.getString("gender"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getString("insurance_number"),
                        rs.getString("emergency_contact")
                ));
            }
        }
        return patients;
    }

    // Save new patient
    public void save(Patient patient) throws SQLException {
        String sql = "INSERT INTO Patients (username, password_hash, full_name, dob, gender, email, phone, address, insurance_number, emergency_contact) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, patient.getUsername());
            stmt.setString(2, patient.getPasswordHash());
            stmt.setString(3, patient.getFullName());
            stmt.setObject(4, patient.getDob());
            stmt.setString(5, patient.getGender());
            stmt.setString(6, patient.getEmail());
            stmt.setString(7, patient.getPhone());
            stmt.setString(8, patient.getAddress());
            stmt.setString(9, patient.getInsuranceNumber());
            stmt.setString(10, patient.getEmergencyContact());
            stmt.executeUpdate();
        }
    }

    // Update existing patient
    public void update(Patient patient) throws SQLException {
        String sql = "UPDATE Patients SET username = ?, password_hash = ?, full_name = ?, dob = ?, gender = ?, email = ?, phone = ?, address = ?, insurance_number = ?, emergency_contact = ? WHERE patient_id = ?";
        try (Connection conn = model.DAO.DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, patient.getUsername());
            stmt.setString(2, patient.getPasswordHash());
            stmt.setString(3, patient.getFullName());
            stmt.setObject(4, patient.getDob());
            stmt.setString(5, patient.getGender());
            stmt.setString(6, patient.getEmail());
            stmt.setString(7, patient.getPhone());
            stmt.setString(8, patient.getAddress());
            stmt.setString(9, patient.getInsuranceNumber());
            stmt.setString(10, patient.getEmergencyContact());
            stmt.setInt(11, patient.getPatientId());
            stmt.executeUpdate();
        }
    }

    // Delete patient
    public void delete(int patientId) throws SQLException {
        String sql = "DELETE FROM Patients WHERE patient_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.executeUpdate();
        }
    }
}