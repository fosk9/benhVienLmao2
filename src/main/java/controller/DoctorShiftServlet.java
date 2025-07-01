package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.DoctorShift;
import model.Employee;
import view.DoctorShiftDAO;
import util.ScheduleUtils;

import java.io.IOException;
import java.sql.Date;
import java.time.*;
import java.util.*;

@WebServlet(name = "DoctorShiftServlet", urlPatterns = {"/doctor-schedule",         // Hiển thị lịch tuần
        "/doctor-shift-detail",     // Chi tiết một ca
        "/request-doctor-leave"     // Đăng ký nghỉ
})
public class DoctorShiftServlet extends HttpServlet {

    private final DoctorShiftDAO shiftDAO = new DoctorShiftDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        switch (path) {
            case "/doctor-schedule":
                showWeeklySchedule(req, resp);
                break;
            case "/doctor-shift-detail":
                showShiftDetail(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String path = req.getServletPath();

        if ("/request-doctor-leave".equals(path)) {
            handleLeaveRequest(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showWeeklySchedule(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Employee doctor = (Employee) req.getSession().getAttribute("account");
        if (doctor == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int doctorId = doctor.getEmployeeId();
        String weekStartParam = req.getParameter("startDate");
        String yearParam = req.getParameter("year");
        String offsetParam = req.getParameter("weekOffset");

        // 1. Lấy selectedYear từ request trước
        int selectedYear = (yearParam != null && !yearParam.isEmpty())
                ? Integer.parseInt(yearParam)
                : LocalDate.now().getYear();

// 2. Generate weeks list ngay theo selectedYear
        List<Date[]> weeks = ScheduleUtils.generateWeekRangesOfYear(selectedYear);
        req.setAttribute("weeks", weeks);

// 3. Xử lý mondayLD
        LocalDate mondayLD;
        if (weekStartParam != null && !weekStartParam.isEmpty()) {
            mondayLD = LocalDate.parse(weekStartParam);
            int weekOffset = offsetParam != null ? Integer.parseInt(offsetParam) : 0;
            mondayLD = mondayLD.plusWeeks(weekOffset);
        } else {
            mondayLD = weeks.get(0)[0].toLocalDate(); // tuần đầu tiên
        }


        Date monday = Date.valueOf(mondayLD);
        Date sunday = Date.valueOf(mondayLD.plusDays(6));

        List<DoctorShift> shifts = shiftDAO.selectByDoctorAndDateRange(doctorId, monday, sunday);
        Map<Date, Map<String, DoctorShift>> shiftMap = new TreeMap<>();
        for (DoctorShift shift : shifts) {
            shiftMap.computeIfAbsent(shift.getShiftDate(), d -> new HashMap<>())
                    .put(shift.getTimeSlot(), shift);
        }

        req.setAttribute("shiftMap", shiftMap);
        req.setAttribute("monday", monday);
        req.setAttribute("sunday", sunday);
        req.setAttribute("weekRange", monday + " To " + sunday);
        req.setAttribute("doctorId", doctorId);
        req.setAttribute("selectedYear", selectedYear);
        req.setAttribute("selectedWeekStart", monday);
        req.setAttribute("years", ScheduleUtils.generateYearList());

        req.getRequestDispatcher("doctor-schedule.jsp").forward(req, resp);
    }


    private void showShiftDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int shiftId = Integer.parseInt(req.getParameter("shiftId"));
        DoctorShift shift = shiftDAO.select(shiftId);
        req.setAttribute("shift", shift);
        req.getRequestDispatcher("doctor-shift-detail.jsp").forward(req, resp);
    }

    private void handleLeaveRequest(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int shiftId = Integer.parseInt(req.getParameter("shiftId"));
        int doctorId = Integer.parseInt(req.getParameter("doctorId"));

        shiftDAO.markPendingLeave(shiftId, doctorId);
        resp.sendRedirect("doctor-schedule?doctorId=" + doctorId);
    }
}
