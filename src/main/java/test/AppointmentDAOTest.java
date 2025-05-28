package test;

import model.Appointment;
import view.AppointmentDAO;

import java.sql.Timestamp;

public class AppointmentDAOTest {
    public static void main(String[] args) {
        AppointmentDAO dao = new AppointmentDAO();

        // Tạo một đối tượng Appointment mới
        Appointment newAppt = Appointment.builder()
                .patientId(1) // ID bệnh nhân tồn tại
                .doctorId(2)  // ID bác sĩ tồn tại
                .appointmentType("Khám tổng quát")
                .appointmentDate(Timestamp.valueOf("2025-06-01 09:00:00")) // Ngày & giờ khám
                .status("Pending")
                .createdAt(new Timestamp(System.currentTimeMillis()))
                .updatedAt(new Timestamp(System.currentTimeMillis()))
                .build();

        // Gọi hàm insert()
        int result = dao.insert(newAppt);

        if (result > 0) {
            System.out.println("✅ Insert appointment success!");
        } else {
            System.out.println("❌ Insert appointment failed!");
        }
    }
}
