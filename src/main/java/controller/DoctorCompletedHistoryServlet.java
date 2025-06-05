package controller;

import model.Appointment;
import model.Employee;
import view.AppointmentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
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
        String fullName = request.getParameter("fullName");
        String insuranceNumber = request.getParameter("insuranceNumber");
        String appointmentType = request.getParameter("appointmentType");

        try {
            AppointmentDAO dao = new AppointmentDAO();
            List<Appointment> completedList;

            // Kiểm tra nếu có tiêu chí tìm kiếm, thì gọi hàm tìm kiếm tương ứng
            if (fullName != null && !fullName.isEmpty()) {
                fullName = fullName.replaceAll("\\s+", " ").trim();
                completedList = dao.searchCompletedAppointmentsByDoctorAndFullName(doctor.getEmployeeId(), fullName);
            } else if (insuranceNumber != null && !insuranceNumber.isEmpty()) {
                insuranceNumber = insuranceNumber.replaceAll("\\s+", " ").trim();
                completedList = dao.searchCompletedAppointmentsByDoctorAndInsuranceNumber(doctor.getEmployeeId(), insuranceNumber);
            } else if (appointmentType != null && !appointmentType.isEmpty()) {
                completedList = dao.searchCompletedAppointmentsByDoctorAndAppointmentType(doctor.getEmployeeId(), appointmentType);
            } else {
                completedList = dao.getCompletedAppointmentsByDoctor(doctor.getEmployeeId()); // Lấy tất cả các cuộc hẹn đã hoàn thành
            }

            request.setAttribute("doctor", doctor);
            request.setAttribute("completedAppointments", completedList);

            // Chuyển tiếp đến JSP để hiển thị
            request.getRequestDispatcher("doctor-completed-history.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
