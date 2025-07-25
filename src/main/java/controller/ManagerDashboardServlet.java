package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.EmployeeWithStatus;
import view.AppointmentDAO;
import view.DoctorShiftDAO;
import view.EmployeeDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/manager-dashboard")
public class ManagerDashboardServlet extends HttpServlet {

    private EmployeeDAO employeeDAO;
    private DoctorShiftDAO doctorShiftDAO;
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
        doctorShiftDAO = new DoctorShiftDAO();
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== [ManagerDashboardServlet] Start ===");

        // === 1. Thống kê tổng quan ===
        int totalStaff = employeeDAO.countTotalStaff();
        int activeDoctors = doctorShiftDAO.countActiveDoctorsToday();
        int todayAppointments = appointmentDAO.countAppointmentsToday();
        int pendingAppointments = appointmentDAO.countPendingAppointmentsToday();

        System.out.println("📊 Total staff: " + totalStaff);
        System.out.println("🩺 Active doctors today: " + activeDoctors);
        System.out.println("📅 Today's appointments: " + todayAppointments);
        System.out.println("⏳ Pending appointments: " + pendingAppointments);

        // === 2. Đọc filter, keyword, phân trang ===
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        if (keyword == null) keyword = "";
        keyword = keyword.trim();

        if (status == null || (!status.equals("Working") && !status.equals("OnLeave") && !status.equals("Inactive"))) {
            status = "";
        }

        int page = 1;
        int pageSize = 5;
        try {
            page = Integer.parseInt(request.getParameter("page"));
            if (page < 1) page = 1;
        } catch (Exception e) {
            page = 1;
        }

        int offset = (page - 1) * pageSize;

        System.out.println("🔍 Keyword: " + keyword);
        System.out.println("📌 Status filter: " + status);
        System.out.println("📄 Page: " + page + ", Offset: " + offset);

        // === 3. Lấy danh sách nhân viên có trạng thái hôm nay ===
        List<EmployeeWithStatus> employeeList = employeeDAO.getEmployeesWithStatus(keyword, status, offset, pageSize);
        int totalEmployees = employeeDAO.countEmployeesWithStatus(keyword, status);
        System.out.println("📋 Filtered employees: " + totalEmployees + " | Page size: " + pageSize);
        int totalPage = (int) Math.ceil((double) totalEmployees / pageSize);

        System.out.println("👥 Filtered staff count: " + totalEmployees + " | totalPage = " + totalPage);
        for (EmployeeWithStatus e : employeeList) {
            System.out.println("➡️ " + e.getEmployee().getFullName() + " | Status: " + e.getStatusToday() + " | Role ID: " + e.getEmployee().getRoleId());
        }

        // === 4. Gửi dữ liệu sang JSP ===
        request.setAttribute("totalStaff", totalStaff);
        request.setAttribute("activeDoctors", activeDoctors);
        request.setAttribute("todayAppointments", todayAppointments);
        request.setAttribute("pendingAppointments", pendingAppointments);

        request.setAttribute("employeeList", employeeList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPage", totalPage);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.getRequestDispatcher("Manager/manager-dashboard.jsp").forward(request, response);
    }
}
