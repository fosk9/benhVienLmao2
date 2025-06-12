package controller;

import model.Appointment;
import model.Employee;
import model.AppointmentType;
import view.AppointmentDAO;
import view.AppointmentTypeDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/view-detail")
public class DoctorViewDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object acc = (session != null) ? session.getAttribute("account") : null;

        if (acc == null || !(acc instanceof Employee)) {
            response.sendRedirect("login.jsp");
            return;
        }

        Employee doctor = (Employee) acc;

        // Kiểm tra quyền của bác sĩ
        if (doctor.getRoleId() != 1) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy appointmentId từ URL
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr == null || !appointmentIdStr.matches("\\d+")) {
            response.sendRedirect("doctor-home");
            return;
        }

        int appointmentId = Integer.parseInt(appointmentIdStr);

        try {
            AppointmentDAO dao = new AppointmentDAO();
            Appointment appointment = dao.getAppointmentDetailById(appointmentId);

            if (appointment == null) {
                response.sendRedirect("doctor-home");
                return;
            }

            // Truyền appointmentType list nếu đang ở chế độ edit
            String isEdit = request.getParameter("edit");
            if ("true".equals(isEdit)) {
                AppointmentTypeDAO typeDAO = new AppointmentTypeDAO();
                List<AppointmentType> appointmentTypes = typeDAO.getAllAppointmentTypes();
                request.setAttribute("appointmentTypes", appointmentTypes);
            }

            request.setAttribute("appointment", appointment);
            request.getRequestDispatcher("doctor-view-detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("doctor-home"); // hoặc quay lại trang chính cho an toàn
        }
    }
}
