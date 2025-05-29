package test;

import model.Patient;
import view.PatientDAO;

public class PatientDAOTest {
    public static void main(String[] args) {
        PatientDAO dao = new PatientDAO();

        // ✅ Test getPatientByEmail
        String testEmail = "example@gmail.com";
        Patient existing = dao.getPatientByEmail(testEmail);
        if (existing != null) {
            System.out.println("🔍 Đã tìm thấy bệnh nhân: " + existing.getFullName());
            System.out.println("Avatar URL: " + existing.getPatientAvtUrl());
        } else {
            System.out.println("❌ Không tìm thấy bệnh nhân với email: " + testEmail);
        }

        // ✅ Kiểm tra lại sau khi insert
        Patient inserted = dao.getPatientByEmail("newuser@gmail.com");
        if (inserted != null) {
            System.out.println("📌 Đã xác nhận thêm bệnh nhân: " + inserted.getFullName());
            System.out.println("Avatar URL: " + inserted.getPatientAvtUrl());
        }
    }
}
