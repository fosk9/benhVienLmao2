package test;

import model.DoctorShift;
import model.DoctorShiftView;
import dal.DoctorShiftDAO;

import java.sql.Date;
import java.util.List;

public class TestDoctorShiftDAO {
    public static void main(String[] args) {
        DoctorShiftDAO dao = new DoctorShiftDAO();

        System.out.println("== Total Appointments Today ==");
        System.out.println(dao.getTotalAppointmentsToday());

        System.out.println("== Total Staff ==");
        System.out.println(dao.getTotalStaff());

        System.out.println("== Active Doctors Today ==");
        System.out.println(dao.getActiveDoctorsToday());

        System.out.println("== Filtered Doctor Shifts ==");
        List<DoctorShiftView> shifts = dao.filterShiftWithDoctor("Ng", null, null, 0, 5);
        for (DoctorShiftView shift : shifts) {
            System.out.println(shift);
        }

        System.out.println("== Total Filtered Records ==");
        System.out.println(dao.getTotalFilteredDoctorShifts("Ng", null, null));

        System.out.println("== Insert Test ==");
        DoctorShift newShift = DoctorShift.builder()
                .doctorId(1)
                .shiftDate(Date.valueOf("2025-07-20"))
                .timeSlot("Morning")
                .status("Working")
                .managerId(1)
                .build();
       if(dao.insert(newShift) == 1){
            System.out.println("New shift inserted with ID: " + newShift.getShiftId());
        } else {
            System.out.println("Insert failed.");
        }

        System.out.println("== Delete Test ==");
        if(dao.delete(newShift.getShiftId()) == 1)
        {
            System.out.println("Delete successful.");
        }
    }
}
