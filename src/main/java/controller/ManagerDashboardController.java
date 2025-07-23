package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Employee;
import view.EmployeeDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/testdashboard")
public class ManagerDashboardController extends HttpServlet {
    private final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        EmployeeDAO dao = new EmployeeDAO();

        // ===== Tổng quan Dashboard =====
        int totalStaff = dao.countTotalEmployees();
        int activeDoctors = dao.countActiveDoctorsToday();
        int todaysAppointments = dao.countAppointmentsToday();

        request.setAttribute("totalStaff", totalStaff);
        request.setAttribute("activeDoctors", activeDoctors);
        request.setAttribute("todaysAppointments", todaysAppointments);

        // ===== Tìm kiếm + phân trang nhân viên =====
        String name = request.getParameter("name") != null ? request.getParameter("name") : "";
        String roleRaw = request.getParameter("role");
        String pageRaw = request.getParameter("page");

        int roleId = 0;
        int page = 1;

        try {
            if (roleRaw != null && !roleRaw.isEmpty()) {
                roleId = Integer.parseInt(roleRaw);
            }
            if (pageRaw != null) {
                page = Integer.parseInt(pageRaw);
            }
        } catch (NumberFormatException e) {
            // giữ giá trị mặc định
        }

        List<Employee> employeeList = dao.searchByNameAndRole(name, roleId, page, PAGE_SIZE);
        int totalResult = dao.countSearchByNameAndRole(name, roleId);
        int totalPages = (int) Math.ceil((double) totalResult / PAGE_SIZE);

        request.setAttribute("employeeList", employeeList);
        request.setAttribute("name", name);
        request.setAttribute("roleId", roleId);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/manager-dashboard.jsp").forward(request, response);
    }
}
