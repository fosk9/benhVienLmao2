package test;

import view.AppointmentDAO;
import model.Appointment;

import java.util.List;

public class AppointmentDAOTest {
    public static void main(String[] args) {
        AppointmentDAO dao = new AppointmentDAO();

        // Thay doctorId này bằng ID đang có trong CSDL
        int testDoctorId = 1;

        List<Appointment> appointments = dao.getAppointmentsByDoctorId(testDoctorId);

        System.out.println("Appointments for doctor ID: " + testDoctorId);
        for (Appointment appt : appointments) {
            System.out.println("ID: " + appt.getAppointmentId()
                    + ", Patient: " + appt.getPatientId()
                    + ", Date: " + appt.getAppointmentDate()
                    + ", Type: " + (appt.getAppointmentType() != null ? appt.getAppointmentType().getTypeName() : "N/A")
                    + ", Status: " + appt.getStatus());
        }
    }
}
