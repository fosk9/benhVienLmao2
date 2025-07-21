package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.DoctorShift;
import util.HeaderController;
import view.DoctorShiftDAO;
import util.ScheduleUtils;

import java.io.IOException;
import java.sql.Date;
import java.time.*;
import java.util.*;

@WebServlet("/view-doctor-schedule")
public class DoctorScheduleViewServlet extends HttpServlet {
    private final DoctorShiftDAO shiftDAO = new DoctorShiftDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Set navigation items for the header
        HeaderController headerController = new HeaderController();
        req.setAttribute("systemItems", headerController.getNavigationItems(1, "Navigation"));

        // Nhận tham số
        String doctorIdParam = req.getParameter("doctorId");
        String startParam = req.getParameter("startDate");
        String yearParam = req.getParameter("year");
        String offsetParam = req.getParameter("weekOffset");

        // Kiểm tra doctorId
        if (doctorIdParam == null || doctorIdParam.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing doctorId");
            return;
        }

        int doctorId = Integer.parseInt(doctorIdParam);

        // Xác định năm
        int selectedYear = (yearParam != null && !yearParam.isEmpty())
                ? Integer.parseInt(yearParam)
                : LocalDate.now().getYear();

        // Lấy danh sách các tuần trong năm đó
        List<Date[]> weeks = ScheduleUtils.generateWeekRangesOfYear(selectedYear);
        req.setAttribute("weeks", weeks);
        req.setAttribute("years", ScheduleUtils.generateYearList());

        // Xác định thứ Hai đầu tuần
        LocalDate mondayLD;
        if (startParam != null && !startParam.isEmpty()) {
            mondayLD = LocalDate.parse(startParam);
            int weekOffset = (offsetParam != null && !offsetParam.isEmpty()) ? Integer.parseInt(offsetParam) : 0;
            mondayLD = mondayLD.plusWeeks(weekOffset);
        } else {
            mondayLD = LocalDate.now().with(DayOfWeek.MONDAY);
        }

        Date monday = Date.valueOf(mondayLD);
        Date sunday = Date.valueOf(mondayLD.plusDays(6));

        // Lấy danh sách ca làm trong tuần cho bác sĩ
        List<DoctorShift> shifts = shiftDAO.selectByDoctorAndDateRange(doctorId, monday, sunday);

        // Tạo map: Date -> TimeSlot -> DoctorShift
        Map<Date, Map<String, DoctorShift>> shiftMap = new TreeMap<>();
        for (DoctorShift shift : shifts) {
            shiftMap
                    .computeIfAbsent(shift.getShiftDate(), d -> new HashMap<>())
                    .put(shift.getTimeSlot(), shift);
        }

        // Truyền dữ liệu sang JSP
        req.setAttribute("doctorId", doctorId);
        req.setAttribute("shiftMap", shiftMap);
        req.setAttribute("monday", monday);
        req.setAttribute("sunday", sunday);
        req.setAttribute("weekRange", monday + " To " + sunday);
        req.setAttribute("selectedYear", selectedYear);
        req.setAttribute("selectedWeekStart", monday);

        req.getRequestDispatcher("/Manager/view-doctor-weekly-schedule.jsp").forward(req, resp);
    }
}
