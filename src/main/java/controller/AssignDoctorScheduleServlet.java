package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.DoctorShift;
import model.DoctorShiftView;
import view.DoctorShiftDAO;

import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/assign-doctor-schedule")
public class AssignDoctorScheduleServlet extends HttpServlet {
    private DoctorShiftDAO dao;
    private static final Logger logger = Logger.getLogger(AssignDoctorScheduleServlet.class.getName());

    @Override
    public void init() {
        dao = new DoctorShiftDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            logger.info("Loading statistics and doctor schedules...");

            int appointmentsToday = dao.getTotalAppointmentsToday();
            int totalStaff = dao.getTotalStaff();
            int activeDoctors = dao.getActiveDoctorsToday();

            String keyword = request.getParameter("keyword");
            String from = request.getParameter("dateFrom");
            String to = request.getParameter("dateTo");
            String status = request.getParameter("status"); // ✅ NEW: lọc theo trạng thái hôm nay

            Date fromDate = (from != null && !from.isEmpty()) ? Date.valueOf(from) : null;
            Date toDate = (to != null && !to.isEmpty()) ? Date.valueOf(to) : null;

            int page = 1, limit = 5;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    page = Integer.parseInt(pageParam);
                }
            } catch (NumberFormatException ignored) {}
            int offset = (page - 1) * limit;

            // ✅ Truyền thêm status
            List<DoctorShiftView> scheduleList = dao.getDoctorSummarySchedule(keyword, fromDate, toDate, status, offset, limit);
            int totalRecords = dao.countDoctorSummarySchedule(keyword, fromDate, toDate, status);
            int totalPages = (int) Math.ceil((double) totalRecords / limit);

            // Gửi sang JSP
            request.setAttribute("appointmentsToday", appointmentsToday);
            request.setAttribute("totalStaff", totalStaff);
            request.setAttribute("activeDoctors", activeDoctors);

            request.setAttribute("scheduleList", scheduleList);
            request.setAttribute("keyword", keyword);
            request.setAttribute("dateFrom", from);
            request.setAttribute("dateTo", to);
            request.setAttribute("status", status); // ✅ giữ giá trị chọn lại

            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

        } catch (Exception e) {
            logger.severe("Error in doGet: " + e.getMessage());
            request.setAttribute("error", "Lỗi tải dữ liệu: " + e.getMessage());
        }

        request.getRequestDispatcher("/Manager/assign-doctor-schedule.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            HttpSession session = request.getSession();
            Integer managerId = (Integer) session.getAttribute("managerId");
            if (managerId == null) managerId = 1;

            if ("create".equals(action) || "update".equals(action)) {
                int doctorId = Integer.parseInt(request.getParameter("doctorId"));
                Date shiftDate = Date.valueOf(request.getParameter("shiftDate"));
                String timeSlot = request.getParameter("timeSlot");
                String status = request.getParameter("status");

                DoctorShift shift = DoctorShift.builder()
                        .doctorId(doctorId)
                        .shiftDate(shiftDate)
                        .timeSlot(timeSlot)
                        .status(status)
                        .managerId(managerId)
                        .requestedAt(new Timestamp(System.currentTimeMillis()))
                        .approvedAt(new Timestamp(System.currentTimeMillis()))
                        .build();

                if ("create".equals(action)) {
                    if (dao.existsShift(doctorId, shiftDate, timeSlot)) {
                        session.setAttribute("error", "Lịch trực đã tồn tại cho bác sĩ này.");
                        logger.warning("Duplicate shift detected: doctorId=" + doctorId);
                    } else {
                        dao.insert(shift);
                        session.setAttribute("success", "Tạo lịch trực thành công.");
                        logger.info("Created shift: doctorId=" + doctorId);
                    }
                } else {
                    int shiftId = Integer.parseInt(request.getParameter("shiftId"));
                    shift.setShiftId(shiftId);
                    dao.update(shift);
                    session.setAttribute("success", "Cập nhật lịch trực thành công.");
                    logger.info("Updated shiftId=" + shiftId);
                }

            } else if ("delete".equals(action)) {
                int shiftId = Integer.parseInt(request.getParameter("shiftId"));
                dao.delete(shiftId);
                session.setAttribute("success", "Xóa lịch trực thành công.");
                logger.info("Deleted shiftId=" + shiftId);
            }

        } catch (Exception e) {
            logger.severe("Error in doPost: " + e.getMessage());
            request.getSession().setAttribute("error", "Lỗi xử lý ca trực: " + e.getMessage());
        }

        response.sendRedirect("assign-doctor-schedule");
    }
}
