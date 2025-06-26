package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Appointment;
import model.Employee;
import validation.DoctorValidator;
import view.AppointmentDAO;

import java.io.IOException;

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

            // Kiểm tra tính hợp lệ của các trường nhập vào
            String errorMessage = null;

            // Kiểm tra tên
            if (!DoctorValidator.isValidFullName(fullName)) {
                errorMessage = "Họ tên không hợp lệ!";
            }
            // Kiểm tra số điện thoại
            else if (!DoctorValidator.isValidPhoneNumber(phone)) {
                errorMessage = "Số điện thoại không hợp lệ!";
            }
            // Kiểm tra số bảo hiểm
            else if (!DoctorValidator.isValidInsuranceNumber(insuranceNumber)) {
                errorMessage = "Số bảo hiểm không hợp lệ!";
            }

            // Nếu có lỗi, giữ lại trang chỉnh sửa và hiển thị thông báo lỗi
            if (errorMessage != null) {
                // Set thông báo lỗi
                request.setAttribute("errorMessage", errorMessage);

                // Giữ lại giá trị đã nhập
                request.setAttribute("fullName", fullName);
                request.setAttribute("phone", phone);
                request.setAttribute("insuranceNumber", insuranceNumber);
                request.setAttribute("dob", dob);
                request.setAttribute("address", address);
                request.setAttribute("emergencyContact", emergencyContact);
                request.setAttribute("appointmentDate", appointmentDate);

                // Trả về trang view-detail.jsp với chế độ chỉnh sửa
                AppointmentDAO dao = new AppointmentDAO();
                Appointment appointment = dao.getAppointmentDetailById(appointmentId);
                request.setAttribute("appointment", appointment);

                // Forward lại tới trang chỉnh sửa mà không chuyển hướng
                request.getRequestDispatcher("doctor-view-detail.jsp").forward(request, response);
                return;
            }

            // Nếu không có lỗi, gọi DAO để cập nhật thông tin
            AppointmentDAO dao = new AppointmentDAO();
            dao.updateAppointmentByDoctor(
                    appointmentId, fullName, dob, gender, phone, address,
                    insuranceNumber, emergencyContact, status, appointmentDate,
                    appointmentTypeId, typeDescription
            );

            // Quay lại trang detail sau khi cập nhật thành công
            response.sendRedirect(request.getContextPath() + "/view-detail?id=" + appointmentId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}



