package test;

import model.Appointment;
import view.AppointmentDAO;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

public class TestAppointmentDAOforP {
    public static void main(String[] args) {
        testInsertFull();
        testInsertNoDoctor();
        testInsertWrongDate();
        testSelectAll();
        testUpdate();
    }

    static void testInsertFull() {
        try {
            AppointmentDAO dao = new AppointmentDAO();
            Appointment appt = Appointment.builder()
                    .patientId(1)
                    .doctorId(1)
                    .appointmentTypeId(1)
                    .appointmentDate(Date.valueOf("2025-06-01"))
                    .timeSlot("Morning")
                    .requiresSpecialist(false)
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
                    .appointmentTypeId(2)
                    .appointmentDate(Date.valueOf("2025-06-01"))
                    .timeSlot("Afternoon")
                    .requiresSpecialist(false)
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
                    .appointmentTypeId(3)
                    .appointmentDate(null) // Sai ngày
                    .timeSlot("Evening")
                    .requiresSpecialist(false)
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

    static void testSelectAll() {
        try {
            AppointmentDAO dao = new AppointmentDAO();
            List<Appointment> list = dao.select();
            System.out.println("Appointments in DB:");
            for (Appointment a : list) {
                System.out.println(a);
            }
        } catch (Exception e) {
            System.out.println("❌ Select all EXCEPTION: " + e.getMessage());
            e.printStackTrace();
        }
    }

    static void testUpdate() {
        try {
            AppointmentDAO dao = new AppointmentDAO();
            List<Appointment> list = dao.select();
            if (!list.isEmpty()) {
                Appointment appt = list.get(0);
                appt.setAppointmentTypeId(2);
                appt.setAppointmentDate(Date.valueOf("2025-07-01"));
                appt.setTimeSlot("Evening");
                appt.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
                int result = dao.update(appt);
                System.out.println(result > 0 ? "✅ Update OK" : "❌ Update FAIL");
            } else {
                System.out.println("❌ No appointment to update");
            }
        } catch (Exception e) {
            System.out.println("❌ Update EXCEPTION: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
