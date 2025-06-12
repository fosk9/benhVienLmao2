package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;
import view.AppointmentDAO;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/update-appointment")
public class DoctorUpdateAppointment extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        try {
            // Lấy tất cả dữ liệu từ form
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String fullName = request.getParameter("fullName");
            String dob = request.getParameter("dob");
            String gender = request.getParameter("gender");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String insuranceNumber = request.getParameter("insuranceNumber");
            String emergencyContact = request.getParameter("emergencyContact");
            String status = request.getParameter("status");
            String appointmentDate = request.getParameter("appointmentDate");
            int appointmentTypeId = Integer.parseInt(request.getParameter("appointmentTypeId"));
            String typeDescription = request.getParameter("typeDescription");

            // Validate Patient Name
            if (fullName == null || !isValidFullName(fullName)) {
                request.setAttribute("errorMessage", "Invalid patient name.");
                request.getRequestDispatcher("edit-appointment.jsp").forward(request, response);
                return;
            }

            // Validate Phone
            if (phone == null || !isValidPhone(phone)) {
                request.setAttribute("errorMessage", "Invalid phone number. It must be 10 digits.");
                request.getRequestDispatcher("edit-appointment.jsp").forward(request, response);
                return;
            }

            // Validate Insurance Number (Remove spaces)
            if (insuranceNumber != null) {
                insuranceNumber = insuranceNumber.trim();
            }

            // Gọi DAO để cập nhật thông tin
            AppointmentDAO dao = new AppointmentDAO();
            boolean success = dao.updateAppointmentByDoctor(
                    appointmentId, fullName, dob, gender, phone, address,
                    insuranceNumber, emergencyContact, status, appointmentDate,
                    appointmentTypeId, typeDescription
            );

            // Quay lại trang detail
            response.sendRedirect(request.getContextPath() + "/view-detail?id=" + appointmentId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    // Hàm validate patient name
    private boolean isValidFullName(String fullName) {
        // Loại bỏ khoảng trắng ở đầu và cuối, và kiểm tra giữa các từ có một khoảng trắng duy nhất
        String trimmedName = fullName.trim().replaceAll("\\s+", " ");
        if (!trimmedName.matches("[A-Za-z\\s]+")) {
            return false; // Chỉ cho phép chữ cái và khoảng trắng
        }
        return trimmedName.equals(fullName.trim()); // Kiểm tra nếu không có khoảng trắng dư
    }

    // Hàm validate phone number
    private boolean isValidPhone(String phone) {
        // Kiểm tra phone là số và có đúng 10 chữ số
        return phone != null && phone.matches("\\d{10}");
    }
}
