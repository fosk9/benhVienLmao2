package test;

import model.Patient;
import view.PatientDAO;

public class TestPatientLogin {
    public static void main(String[] args) {
        PatientDAO patientDAO = new PatientDAO();

        // Thay bằng tài khoản tồn tại trong database của bạn
        String username = "john_doe";
        String password = "123456";  // Nếu bạn đang hash password, bạn cần dùng password đã hash hoặc xử lý tương ứng

        Patient patient = patientDAO.login(username, password);

        if (patient != null) {
            System.out.println("Login successful!");
            System.out.println("Patient ID: " + patient.getPatientId());
            System.out.println("Full Name: " + patient.getFullName());
            System.out.println("Email: " + patient.getEmail());
            // Thêm các field khác nếu cần
        } else {
            System.out.println("Login failed. Invalid username or password.");
        }
    }
}