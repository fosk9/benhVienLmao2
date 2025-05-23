package model.DAO;

import model.object.DBContext;
import model.object.Patient;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {
    // Find patient by ID
    public Patient findById(int patientId) throws SQLException {
        String sql = "SELECT * FROM Patients WHERE patient_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Patient(
                            rs.getInt("patient_id"),
                            rs.getString("full_name"),
                            rs.getString("dob"),
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
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                patients.add(new Patient(
                        rs.getInt("patient_id"),
                        rs.getString("full_name"),
                        rs.getString("dob"),
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
        String sql = "INSERT INTO Patients (patient_id, full_name, dob, gender, email, phone, address, insurance_number, emergency_contact) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patient.getPatientId());
            stmt.setString(2, patient.getFullName());
            stmt.setString(3, patient.getDob());
            stmt.setString(4, patient.getGender());
            stmt.setString(5, patient.getEmail());
            stmt.setString(6, patient.getPhone());
            stmt.setString(7, patient.getAddress());
            stmt.setString(8, patient.getInsuranceNumber());
            stmt.setString(9, patient.getEmergencyContact());
            stmt.executeUpdate();
        }
    }

    // Update existing patient
    public void update(Patient patient) throws SQLException {
        String sql = "UPDATE Patients SET full_name = ?, dob = ?, gender = ?, email = ?, phone = ?, address = ?, insurance_number = ?, emergency_contact = ? WHERE patient_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, patient.getFullName());
            stmt.setString(2, patient.getDob());
            stmt.setString(3, patient.getGender());
            stmt.setString(4, patient.getEmail());
            stmt.setString(5, patient.getPhone());
            stmt.setString(6, patient.getAddress());
            stmt.setString(7, patient.getInsuranceNumber());
            stmt.setString(8, patient.getEmergencyContact());
            stmt.setInt(9, patient.getPatientId());
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