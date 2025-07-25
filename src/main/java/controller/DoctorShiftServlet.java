package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.DoctorShift;
import model.Employee;
import model.Patient;
import util.HeaderController;
import dal.AppointmentDAO;
import dal.DoctorShiftDAO;
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
        // Set navigation items for the header
        HeaderController headerController = new HeaderController();
        req.setAttribute("systemItems", headerController.getNavigationItems(1, "Navigation"));

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
            // Có sẵn startDate từ form
            mondayLD = LocalDate.parse(weekStartParam);
            int weekOffset = offsetParam != null ? Integer.parseInt(offsetParam) : 0;
            mondayLD = mondayLD.plusWeeks(weekOffset);
        } else if (yearParam != null && !yearParam.isEmpty()) {
            // ✅ Có year nhưng chưa có startDate => lấy tuần đầu tiên của năm đó
            int year = Integer.parseInt(yearParam);
            List<Date[]> weeksOfYear = ScheduleUtils.generateWeekRangesOfYear(year);
            mondayLD = weeksOfYear.get(0)[0].toLocalDate();
        } else {
            // ✅ Trường hợp đầu tiên, mặc định lấy tuần hiện tại
            LocalDate today = LocalDate.now();
            mondayLD = today.with(DayOfWeek.MONDAY);
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

        AppointmentDAO appointmentDAO = new AppointmentDAO();
        List<Patient> patients = appointmentDAO.getPatientsByShift(
                shift.getDoctorId(),
                shift.getShiftDate(),
                shift.getTimeSlot()
        );
        req.setAttribute("patients", patients); // Gửi danh sách bệnh nhân

        // ✅ Thêm ngày hôm nay để so sánh trong JSP
        req.setAttribute("today", new java.sql.Date(System.currentTimeMillis()));

        req.getRequestDispatcher("doctor-shift-detail.jsp").forward(req, resp);
    }

    private void handleLeaveRequest(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int shiftId = Integer.parseInt(req.getParameter("shiftId"));
        int doctorId = Integer.parseInt(req.getParameter("doctorId"));

        shiftDAO.markPendingLeave(shiftId, doctorId);

        // Gửi message qua query string
        resp.sendRedirect(req.getContextPath() + "/doctor-shift-detail?shiftId=" + shiftId + "&msg=Leave+request+submitted+successfully");
    }

}
