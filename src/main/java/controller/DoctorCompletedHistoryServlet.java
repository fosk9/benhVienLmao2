package controller;

import model.Appointment;
import model.Employee;
import view.AppointmentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/completed-history")
public class DoctorCompletedHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object acc = (session != null) ? session.getAttribute("account") : null;

        if (acc == null || !(acc instanceof Employee) || ((Employee) acc).getRoleId() != 1) {
            response.sendRedirect("login.jsp");
            return;
        }

        Employee doctor = (Employee) acc;
        System.out.println("Logged in as Doctor: " + doctor.getFullName());
        System.out.println("Doctor ID from session: " + doctor.getEmployeeId());

        // Lấy các tham số phân trang và tìm kiếm từ request
        int rowsPerPage = 5;
        int currentPage = 1;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        // Các tham số tìm kiếm
        String fullName = request.getParameter("fullName");
        String insuranceNumber = request.getParameter("insuranceNumber");
        String typeName = request.getParameter("typeName");
        String timeSlot = request.getParameter("timeSlot");

        try {
            AppointmentDAO dao = new AppointmentDAO();
            // Lấy danh sách các cuộc hẹn hoàn thành của bác sĩ
            List<Appointment> list = dao.getCompletedAppointmentsByDoctorId(doctor.getEmployeeId(), fullName, insuranceNumber, typeName, timeSlot);

            // Tính toán phân trang
            int totalAppointments = list.size();
            int totalPages = (int) Math.ceil((double) totalAppointments / rowsPerPage);

            // Xác định vị trí bắt đầu và kết thúc của cuộc hẹn trên trang hiện tại
            int startIndex = (currentPage - 1) * rowsPerPage;
            int endIndex = Math.min(startIndex + rowsPerPage, totalAppointments);

            // Lấy danh sách cuộc hẹn hoàn thành cho trang hiện tại
            List<Appointment> pageAppointments = list.subList(startIndex, endIndex);

            // Đặt các giá trị vào request để hiển thị trên JSP
            request.setAttribute("doctor", doctor);
            request.setAttribute("appointments", pageAppointments);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("startIndex", startIndex);

            // Đặt các tham số tìm kiếm vào request để giữ lại khi hiển thị trang
            request.setAttribute("fullName", fullName);
            request.setAttribute("insuranceNumber", insuranceNumber);
            request.setAttribute("typeName", typeName);
            request.setAttribute("timeSlot", timeSlot);

            // Chuyển hướng tới JSP hiển thị danh sách cuộc hẹn hoàn thành
            request.getRequestDispatcher("doctor-completed-history.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra trong quá trình lấy dữ liệu. Vui lòng thử lại sau.");
            request.getRequestDispatcher("error.jsp").forward(request, response);  // Hiển thị trang lỗi với thông báo người dùng
        }
    }
}


