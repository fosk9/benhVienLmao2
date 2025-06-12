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

@WebServlet("/doctor-home")
public class DoctorHomeServlet extends HttpServlet {

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

        // List để chứa các cuộc hẹn của bác sĩ
        List<Appointment> list = new ArrayList<>();
        int rowsPerPage = 5;  // Số bản ghi trên mỗi trang
        int currentPage = 1;  // Mặc định trang 1

        try {
            // Kiểm tra tham số page trên URL
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                currentPage = Integer.parseInt(pageParam);
            }

            // Nhận các tham số tìm kiếm từ request
            String fullName = request.getParameter("fullName");
            String insuranceNumber = request.getParameter("insuranceNumber");
            String typeName = request.getParameter("typeName");
            String timeSlot = request.getParameter("timeSlot");

            // Lấy danh sách các cuộc hẹn của bác sĩ từ AppointmentDAO với tìm kiếm
            AppointmentDAO dao = new AppointmentDAO();
            list = dao.searchAppointments(doctor.getEmployeeId(), fullName, insuranceNumber, typeName, timeSlot);

            // Tính toán phân trang
            int totalAppointments = list.size();
            int totalPages = (int) Math.ceil((double) totalAppointments / rowsPerPage);

            // Xác định vị trí bắt đầu và kết thúc của cuộc hẹn trên trang hiện tại
            int startIndex = (currentPage - 1) * rowsPerPage;
            int endIndex = Math.min(startIndex + rowsPerPage, totalAppointments);

            // Lấy danh sách cuộc hẹn cho trang hiện tại
            List<Appointment> pageAppointments = list.subList(startIndex, endIndex);

            // Đặt các giá trị vào request để hiển thị trên JSP
            request.setAttribute("doctor", doctor);
            request.setAttribute("appointments", pageAppointments);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("startIndex", startIndex);  // Truyền startIndex vào request để tính số thứ tự toàn cục

            // Đặt các tham số tìm kiếm vào request để giữ lại khi hiển thị trang
            request.setAttribute("fullName", fullName);
            request.setAttribute("insuranceNumber", insuranceNumber);
            request.setAttribute("typeName", typeName);
            request.setAttribute("timeSlot", timeSlot);

            request.getRequestDispatcher("doctor-home.jsp").forward(request, response); // Chuyển hướng đến JSP

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp"); // Điều hướng tới trang lỗi nếu có lỗi
        }
    }
}

