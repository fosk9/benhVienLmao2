package test;

import view.AppointmentDAO;
import view.DoctorShiftDAO;

import java.sql.Date;

public class AppointmentDAOTest {
    public static void main(String[] args) {
        AppointmentDAO dao = new AppointmentDAO();

        // Test case 1: Có lịch hẹn thật trong DB
        int doctorId1 = 1; // đảm bảo ID này có thật trong DB
        Date date1 = Date.valueOf("2025-06-23"); // ngày thật
        String slot1 = "Morning";

        boolean has1 = dao.hasAppointment(doctorId1, date1, slot1);
        System.out.println("Test 1 - Có lịch: " + has1); // true expected

        // Test case 2: Không có lịch (id ảo hoặc ngày không có lịch)
        int doctorId2 = 9999;
        Date date2 = Date.valueOf("2030-01-01");
        String slot2 = "Evening";

        boolean has2 = dao.hasAppointment(doctorId2, date2, slot2);
        System.out.println("Test 2 - Không có lịch: " + has2); // false expected
    }
}
