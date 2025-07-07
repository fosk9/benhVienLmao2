package test;

import model.Appointment;
import view.AppointmentDAO;
import view.AppointmentTypeDAO;
import model.AppointmentType;

import java.sql.Date;
import java.sql.Timestamp;
import java.math.BigDecimal;
import java.util.Scanner;

public class AppointmentDAOTest {
    public static void main(String[] args) {
        AppointmentDAO dao = new AppointmentDAO();
        AppointmentTypeDAO typeDAO = new AppointmentTypeDAO();
        Scanner scanner = new Scanner(System.in);

        System.out.print("Nhập patientId: ");
        int patientId = Integer.parseInt(scanner.nextLine());

        System.out.print("Nhập doctorId: ");
        int doctorId = Integer.parseInt(scanner.nextLine());

        System.out.print("Nhập appointmentTypeId: ");
        int appointmentTypeId = Integer.parseInt(scanner.nextLine());

        AppointmentType type = typeDAO.select(appointmentTypeId);
        BigDecimal basePrice = type != null ? type.getPrice() : null;
        System.out.println("Base price for type " + appointmentTypeId + ": " + basePrice);

        System.out.print("Nhập ngày hẹn (yyyy-MM-dd): ");
        Date appointmentDate = Date.valueOf(scanner.nextLine());

        System.out.print("Nhập timeSlot (Morning/Afternoon/Evening): ");
        String timeSlot = scanner.nextLine();

        System.out.print("Có cần bác sĩ chuyên gia không? (true/false): ");
        boolean requiresSpecialist = Boolean.parseBoolean(scanner.nextLine());

        System.out.print("Nhập status: ");
        String status = scanner.nextLine();

        Appointment appt = Appointment.builder()
                .patientId(patientId)
                .doctorId(doctorId)
                .appointmentTypeId(appointmentTypeId)
                .appointmentDate(appointmentDate)
                .timeSlot(timeSlot)
                .requiresSpecialist(requiresSpecialist)
                .status(status)
                .createdAt(new Timestamp(System.currentTimeMillis()))
                .updatedAt(new Timestamp(System.currentTimeMillis()))
                .build();

        int insertResult = dao.insert(appt);
        System.out.println(insertResult > 0 ? "✅ Insert success!" : "❌ Insert failed!");

        // Lấy lại bản ghi vừa insert (giả sử lấy bản ghi mới nhất của bệnh nhân này)
        Appointment inserted = null;
        for (Appointment a : dao.select()) {
            if (a.getPatientId() == patientId
                    && a.getAppointmentDate().equals(appointmentDate)
                    && a.getTimeSlot().equals(timeSlot)) {
                inserted = a;
            }
        }
        if (inserted != null) {
            System.out.println("Thông tin lịch hẹn vừa tạo:");
            System.out.println("ID: " + inserted.getAppointmentId());
            System.out.println("PatientId: " + inserted.getPatientId());
            System.out.println("DoctorId: " + inserted.getDoctorId());
            System.out.println("AppointmentTypeId: " + inserted.getAppointmentTypeId());
            System.out.println("AppointmentDate: " + inserted.getAppointmentDate());
            System.out.println("TimeSlot: " + inserted.getTimeSlot());
            System.out.println("RequiresSpecialist: " + inserted.isRequiresSpecialist());
            System.out.println("Status: " + inserted.getStatus());
            System.out.println("CreatedAt: " + inserted.getCreatedAt());
            System.out.println("UpdatedAt: " + inserted.getUpdatedAt());

            // Tính giá
            if (basePrice != null) {
                BigDecimal finalPrice = basePrice;
                if (requiresSpecialist) {
                    finalPrice = basePrice.multiply(new BigDecimal("1.5"));
                }
                System.out.println("Giá cuối cùng: " + finalPrice);
            }
        } else {
            System.out.println("❌ Không tìm thấy lịch hẹn vừa tạo!");
        }

        // Cleanup: xóa bản ghi vừa tạo
        if (inserted != null) {
            int deleteResult = dao.delete(inserted.getAppointmentId());
            System.out.println(deleteResult > 0 ? "Đã xóa lịch hẹn test." : "Không xóa được lịch hẹn test.");
        }
    }
}
