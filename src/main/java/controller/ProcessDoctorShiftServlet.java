package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.DoctorShift;
import model.Employee;
import util.HistoryLogger;
import dal.DoctorShiftDAO;

import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.DayOfWeek;
import java.time.LocalDate;

@WebServlet("/process-doctor-shift")
public class ProcessDoctorShiftServlet extends HttpServlet {
    private final DoctorShiftDAO shiftDAO = new DoctorShiftDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession();
            Employee manager = (Employee) session.getAttribute("account");
            if (manager == null || manager.getRoleId() != 4) {
                resp.sendRedirect("login.jsp");
                return;
            }

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
                    shift.setManagerId(manager.getEmployeeId());
                    shiftDAO.update(shift);

                    // ✅ Log cập nhật
                    HistoryLogger.log(
                            manager.getEmployeeId(),
                            manager.getFullName(),
                            doctorId,
                            "Doctor#" + doctorId,
                            "DoctorShifts",
                            "Update Shift [" + slot + " " + date + "]"
                    );
                }
            } else {
                DoctorShift newShift = DoctorShift.builder()
                        .doctorId(doctorId)
                        .shiftDate(date)
                        .timeSlot(slot)
                        .status(status)
                        .managerId(manager.getEmployeeId())
                        .requestedAt(new Timestamp(System.currentTimeMillis()))
                        .approvedAt(new Timestamp(System.currentTimeMillis()))
                        .build();
                shiftDAO.insert(newShift);

                // ✅ Log thêm mới
                HistoryLogger.log(
                        manager.getEmployeeId(),
                        manager.getFullName(),
                        doctorId,
                        "Doctor#" + doctorId,
                        "DoctorShifts",
                        "Create Shift [" + slot + " " + date + "]"
                );
            }

            // Redirect về tuần chứa ngày đó
            LocalDate mondayOfWeek = date.toLocalDate().with(DayOfWeek.MONDAY);
            resp.sendRedirect(req.getContextPath() + "/view-doctor-schedule?doctorId=" + doctorId + "&startDate=" + mondayOfWeek);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(400, "Lỗi xử lý dữ liệu ca trực");
        }
    }
}

