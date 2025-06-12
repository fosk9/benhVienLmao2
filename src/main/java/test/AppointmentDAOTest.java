package test;

import model.Appointment;
import view.AppointmentDAO;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

public class AppointmentDAOTest {
    public static void main(String[] args) {
//
        int doctorId = 1;

        // Tạo đối tượng của lớp chứa hàm getAppointmentsByDoctorId
        AppointmentDAO appointmentDAO = new AppointmentDAO();

        // Lấy danh sách các cuộc hẹn
        List<Appointment> appointments = appointmentDAO.getAppointmentsByDoctorId(doctorId);

        // Kiểm tra và in kết quả
        if (appointments != null && !appointments.isEmpty()) {
            System.out.println("Danh sách các cuộc hẹn của bác sĩ với ID " + doctorId + ":");
            for (Appointment appointment : appointments) {
                // Giả sử bạn đã định nghĩa phương thức toString() trong lớp Appointment để hiển thị thông tin cần thiết
                System.out.println(appointment);
            }
        } else {
            System.out.println("Không có cuộc hẹn nào cho bác sĩ với ID " + doctorId);
        }
    }
}
