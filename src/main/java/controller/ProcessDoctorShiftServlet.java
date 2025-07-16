package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.DoctorShift;
import view.DoctorShiftDAO;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet("/process-doctor-shift")
public class ProcessDoctorShiftServlet extends HttpServlet {
    private final DoctorShiftDAO shiftDAO = new DoctorShiftDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int doctorId = Integer.parseInt(req.getParameter("doctorId"));
            Date date = Date.valueOf(req.getParameter("date"));
            String slot = req.getParameter("slot");
            String status = req.getParameter("status");

            String shiftIdParam = req.getParameter("shiftId");
            boolean isEdit = shiftIdParam != null && !shiftIdParam.isEmpty();

            if (isEdit) {
                int shiftId = Integer.parseInt(shiftIdParam);
                DoctorShift shift = shiftDAO.select(shiftId);
                if (shift != null) {
                    shift.setStatus(status);
                    shiftDAO.update(shift);
                }
            } else {
                DoctorShift newShift = new DoctorShift();
                newShift.setDoctorId(doctorId);
                newShift.setShiftDate(date);
                newShift.setTimeSlot(slot);
                newShift.setStatus(status);
                shiftDAO.insert(newShift);
            }

            // Tính lại ngày thứ Hai của tuần chứa ngày vừa thêm
            LocalDate mondayOfWeek = date.toLocalDate().with(java.time.DayOfWeek.MONDAY);
            resp.sendRedirect(req.getContextPath() + "/view-doctor-schedule?doctorId=" + doctorId + "&startDate=" + mondayOfWeek);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(400, "Error processing shift");
        }
    }
}
