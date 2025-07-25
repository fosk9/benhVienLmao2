package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.DoctorShiftView;
import dal.DoctorShiftDAO;

import java.io.IOException;
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

}
