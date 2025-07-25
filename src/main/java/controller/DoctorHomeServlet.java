package controller;

import util.HeaderController;
import view.AppointmentDAO;
import view.DoctorDetailDAO;
import view.DoctorShiftDAO;
import dto.AppointmentDTO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.DoctorDetail;
import model.DoctorShift;
import model.Employee;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/doctor-home")
public class DoctorHomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy thông tin bác sĩ từ session
        HttpSession session = request.getSession(false);
        Employee doctor = (Employee) session.getAttribute("account");

        HeaderController headerController = new HeaderController();
        request.setAttribute("systemItems", headerController.getNavigationItems(1, "Navigation"));
        request.setAttribute("systemItems", headerController.getNavigationItems(1, "Feature"));

        if (doctor == null || doctor.getRoleId() != 1) { // 1 = Doctor
            response.sendRedirect("login.jsp");
            return;
        }

        int doctorId = doctor.getEmployeeId();

        // DAO
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        DoctorDetailDAO doctorDetailDAO = new DoctorDetailDAO();
        DoctorShiftDAO doctorShiftDAO = new DoctorShiftDAO();

        // 1. Lấy danh sách appointment hôm nay
        Date today = new Date(System.currentTimeMillis());
        List<AppointmentDTO> todayAppointments = appointmentDAO.getAppointmentsByDoctorAndDate(
                doctorId,
                today,
                List.of("Pending", "Confirmed", "Completed")
        );

        // 2. Lấy thông tin tổng quan bác sĩ
        DoctorDetail doctorDetails = doctorDetailDAO.getByEmployeeId(doctorId);

        // 3. Lấy thông tin ca làm việc hôm nay
        DoctorShift shiftToday = doctorShiftDAO.getShiftByDoctorAndDate(doctorId, today);

        // Đặt attribute để forward sang JSP
        request.setAttribute("todayAppointments", todayAppointments);
        request.setAttribute("doctorDetails", doctorDetails);
        request.setAttribute("shiftToday", shiftToday);

        // Forward đến JSP
        request.getRequestDispatcher("/doctor-home.jsp").forward(request, response);
    }
}
