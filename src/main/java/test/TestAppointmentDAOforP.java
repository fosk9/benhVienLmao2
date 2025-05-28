package test;

import model.Appointment;
import view.AppointmentDAO;

import java.sql.Timestamp;

public class TestAppointmentDAOforP {
    public static void main(String[] args) {
        testInsertFull();
        testInsertNoDoctor();
        testInsertWrongDate();
    }

    static void testInsertFull() {
        try {
            AppointmentDAO dao = new AppointmentDAO();
            Appointment appt = Appointment.builder()
                    .patientId(1)
                    .doctorId(1)
                    .appointmentType("Test Full")
                    .appointmentDate(Timestamp.valueOf("2025-06-01 09:00:00"))
                    .status("Pending")
                    .createdAt(new Timestamp(System.currentTimeMillis()))
                    .updatedAt(new Timestamp(System.currentTimeMillis()))
                    .build();
            int result = dao.insert(appt);
            System.out.println(result > 0 ? "✅ Insert full OK" : "❌ Insert full FAIL");
        } catch (Exception e) {
            System.out.println("❌ Insert full EXCEPTION: " + e.getMessage());
            e.printStackTrace();
        }
    }

    static void testInsertNoDoctor() {
        try {
            AppointmentDAO dao = new AppointmentDAO();
            Appointment appt = Appointment.builder()
                    .patientId(1)
                    .doctorId(0)
                    .appointmentType("Test No Doctor")
                    .appointmentDate(Timestamp.valueOf("2025-06-01 10:00:00"))
                    .status("Pending")
                    .createdAt(new Timestamp(System.currentTimeMillis()))
                    .updatedAt(new Timestamp(System.currentTimeMillis()))
                    .build();
            int result = dao.insert(appt);
            System.out.println(result > 0 ? "✅ Insert no doctor OK" : "❌ Insert no doctor FAIL");
        } catch (Exception e) {
            System.out.println("❌ Insert no doctor EXCEPTION: " + e.getMessage());
            e.printStackTrace();
        }
    }

    static void testInsertWrongDate() {
        try {
            AppointmentDAO dao = new AppointmentDAO();
            Appointment appt = Appointment.builder()
                    .patientId(1)
                    .doctorId(1)
                    .appointmentType("Test Wrong Date")
                    .appointmentDate(null) // Sai ngày
                    .status("Pending")
                    .createdAt(new Timestamp(System.currentTimeMillis()))
                    .updatedAt(new Timestamp(System.currentTimeMillis()))
                    .build();
            int result = dao.insert(appt);
            System.out.println(result > 0 ? "✅ Insert wrong date OK" : "❌ Insert wrong date FAIL");
        } catch (Exception e) {
            System.out.println("❌ Insert wrong date EXCEPTION: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
