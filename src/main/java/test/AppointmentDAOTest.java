package test;

import model.Appointment;
import view.AppointmentDAO;

import java.time.LocalDateTime;

public class AppointmentDAOTest {
    public static void main(String[] args) {
        AppointmentDAO dao = new AppointmentDAO();

        // Tạo một đối tượng Appointment mới
        Appointment newAppt = Appointment.builder()
                .patientId(1) // ID bệnh nhân tồn tại
                .doctorId(2)  // ID bác sĩ tồn tại
                .appointmentDate(LocalDateTime.of(2025, 6, 1, 10, 30)) // Ngày giờ khám
                .status("Pending")
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
