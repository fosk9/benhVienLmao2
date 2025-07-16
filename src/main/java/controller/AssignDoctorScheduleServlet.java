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
            logger.info("Loading doctor schedule management view...");

            // Lấy các thống kê để hiển thị ở dashboard
            int appointmentsToday = dao.getTotalAppointmentsToday();
            int totalStaff = dao.getTotalStaff();
            int activeDoctors = dao.getActiveDoctorsToday();

            // Lấy tham số tìm kiếm & lọc
            String keyword = request.getParameter("keyword");
            String status = request.getParameter("status"); // Lọc theo status của ca trực hôm nay

            // Phân trang
            int page = 1;
            int limit = 5;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    page = Integer.parseInt(pageParam);
                }
            } catch (NumberFormatException ignored) {}

            int offset = (page - 1) * limit;

            // Lấy danh sách bác sĩ có lịch hôm nay
            List<DoctorShiftView> scheduleList = dao.getDoctorSummarySchedule(keyword, status, offset, limit);
            int totalRecords = dao.countDoctorSummarySchedule(keyword, status);
            int totalPages = (int) Math.ceil((double) totalRecords / limit);

            // Gửi sang JSP
            request.setAttribute("appointmentsToday", appointmentsToday);
            request.setAttribute("totalStaff", totalStaff);
            request.setAttribute("activeDoctors", activeDoctors);

            request.setAttribute("scheduleList", scheduleList);
            request.setAttribute("keyword", keyword);
            request.setAttribute("status", status);

            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

        } catch (Exception e) {
            logger.severe("Error loading doctor schedule view: " + e.getMessage());
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
                        logger.warning("Duplicate shift for doctorId=" + doctorId);
                    } else {
                        dao.insert(shift);
                        session.setAttribute("success", "Tạo lịch trực thành công.");
                        logger.info("Created shift for doctorId=" + doctorId);
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
                request.getSession().setAttribute("success", "Xóa lịch trực thành công.");
                logger.info("Deleted shiftId=" + shiftId);
            }

        } catch (Exception e) {
            logger.severe("Error processing doctor shift: " + e.getMessage());
            request.getSession().setAttribute("error", "Lỗi xử lý ca trực: " + e.getMessage());
        }

        response.sendRedirect("assign-doctor-schedule");
    }
}
