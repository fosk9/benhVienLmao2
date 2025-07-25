package test;

import dal.PatientDAO;
import model.Patient;

public class TestPatientDAO {
    public static void main(String[] args) {
        PatientDAO patientDAO = new PatientDAO();

        // Thay username/password đúng với dữ liệu bạn đã nhập trong DB
        String testUsername = "patient001";
        String testPassword = "123"; // Không mã hóa, đúng như bạn yêu cầu

        Patient patient = patientDAO.login(testUsername, testPassword);

        if (patient != null) {
            System.out.println("✅ Login successful!");
            System.out.println("Patient ID: " + patient.getPatientId());
            System.out.println("Full Name: " + patient.getFullName());
        } else {
            System.out.println("❌ Login failed: Invalid username or password.");
        }
    }
}
