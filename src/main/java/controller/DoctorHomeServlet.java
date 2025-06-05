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
        String fullName = request.getParameter("fullName");
        String insuranceNumber = request.getParameter("insuranceNumber");
        String appointmentType = request.getParameter("appointmentType");
        String customAppointmentType = request.getParameter("customAppointmentType");

        List<Appointment> list = new ArrayList<>();

        try {
            AppointmentDAO dao = new AppointmentDAO();

            // Tìm kiếm theo tên bệnh nhân
            if (fullName != null && !fullName.isEmpty()) {
                fullName = fullName.replaceAll("\\s+", " ").trim();
                list = dao.searchAppointmentsByDoctorAndFullName(doctor.getEmployeeId(), fullName);
            }
            // Tìm kiếm theo mã bệnh nhân
            else if (insuranceNumber != null && !insuranceNumber.isEmpty()) {
                //list = dao.searchAppointmentsByDoctorAndInsuranceNumber(doctor.getEmployeeId(), insuranceNumber);
                //String fullInsuranceNumber = "INS" + insuranceNumber;
                insuranceNumber = insuranceNumber.replaceAll("\\s+", " ").trim();
                list = dao.searchAppointmentsByDoctorAndInsuranceNumber(doctor.getEmployeeId(), insuranceNumber);
            }
            // Tìm kiếm theo loại cuộc hẹn
            else if (appointmentType != null && !appointmentType.isEmpty()) {
                if (appointmentType.equals("custom") && customAppointmentType != null && !customAppointmentType.isEmpty()) {
                    list = dao.searchAppointmentsByDoctorAndAppointmentType(doctor.getEmployeeId(), customAppointmentType);
                } else {
                    list = dao.searchAppointmentsByDoctorAndAppointmentType(doctor.getEmployeeId(), appointmentType);
                }
            }
            // Nếu không có từ khóa tìm kiếm, lấy tất cả cuộc hẹn của bác sĩ
            else {
                list = dao.getAppointmentsByDoctorId(doctor.getEmployeeId());
            }

            // Đặt dữ liệu vào request để hiển thị trên trang doctor-home.jsp
            request.setAttribute("doctor", doctor);
            request.setAttribute("appointments", list);
            request.getRequestDispatcher("doctor-home.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
