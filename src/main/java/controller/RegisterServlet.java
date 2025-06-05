package controller;

import jakarta.servlet.ServletException;
import model.Patient;
import view.PatientDAO;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Date;
import java.util.Random;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private PatientDAO patientDAO;

    @Override
    public void init() {
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("full_name");
        String dobStr = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String insuranceNumber = request.getParameter("insurance_number");
        String emergencyContact = request.getParameter("emergency_contact");

        // Xử lý: xóa khoảng trắng thừa, chuẩn hóa viết hoa chữ cái đầu
        if (fullName != null) {
            fullName = fullName.trim().replaceAll("\\s+", " "); // loại bỏ khoảng trắng thừa

            // Viết hoa chữ cái đầu mỗi từ (nếu muốn)
            String[] parts = fullName.split(" ");
            for (int i = 0; i < parts.length; i++) {
                parts[i] = parts[i].substring(0, 1).toUpperCase() + parts[i].substring(1).toLowerCase();
            }
            fullName = String.join(" ", parts);
        }


        Date dob = null;
        if (dobStr != null && !dobStr.isEmpty()) {
            try {
                dob = Date.valueOf(dobStr);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Ngày sinh không hợp lệ! Vui lòng nhập lại.");
                // Gửi lại dữ liệu đã nhập về JSP để hiển thị lại
                request.setAttribute("username", username);
                request.setAttribute("fullName", fullName);
                request.setAttribute("dob", dob);
                request.setAttribute("gender", gender);
                request.setAttribute("phone", phone);
                request.setAttribute("address", address);
                request.setAttribute("insurance_number", insuranceNumber);
                request.setAttribute("emergency_contact", emergencyContact);
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
        }

        if (password == null || !password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^\\w\\s]).{8,}$")) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.");
            // Gửi lại dữ liệu đã nhập về JSP để hiển thị lại
            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("dob", dob);
            request.setAttribute("gender", gender);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.setAttribute("insurance_number", insuranceNumber);
            request.setAttribute("emergency_contact", emergencyContact);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (fullName == null || !fullName.trim().matches("^[a-zA-ZÀ-ỹ\\s]+$")) {
            request.setAttribute("error", "Họ và tên chỉ được chứa chữ cái và khoảng trắng.");

            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("dob", dob);
            request.setAttribute("gender", gender);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.setAttribute("insurance_number", insuranceNumber);
            request.setAttribute("emergency_contact", emergencyContact);

            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }


        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            request.setAttribute("error", "Email không hợp lệ.");
            // Gửi lại dữ liệu đã nhập về JSP để hiển thị lại
            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("dob", dob);
            request.setAttribute("gender", gender);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.setAttribute("insurance_number", insuranceNumber);
            request.setAttribute("emergency_contact", emergencyContact);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (phone == null || !phone.matches("^(0[0-9]{9,10})$")) {
            request.setAttribute("error", "Số điện thoại không hợp lệ (bắt đầu bằng 0, 10-11 số).");
            // Gửi lại dữ liệu đã nhập về JSP để hiển thị lại
            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("dob", dob);
            request.setAttribute("gender", gender);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.setAttribute("insurance_number", insuranceNumber);
            request.setAttribute("emergency_contact", emergencyContact);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (emergencyContact == null || emergencyContact.matches(phone) || !emergencyContact.matches("^(0[0-9]{9,10})$")) {
            request.setAttribute("error", "Số điện thoại người liên hệ khẩn cấp không hợp lệ.");
            // Gửi lại dữ liệu đã nhập về JSP để hiển thị lại
            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("dob", dob);
            request.setAttribute("gender", gender);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.setAttribute("insurance_number", insuranceNumber);
            request.setAttribute("emergency_contact", emergencyContact);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 2. Check trùng username, email, phone
        if (patientDAO.getPatientByUsername(username) != null) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại. Vui lòng chọn tên khác.");
            // Gửi lại dữ liệu đã nhập về JSP để hiển thị lại
            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("dob", dob);
            request.setAttribute("gender", gender);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.setAttribute("insurance_number", insuranceNumber);
            request.setAttribute("emergency_contact", emergencyContact);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        Patient tempPatient  = Patient.builder()
                .username(username)
                .passwordHash(password)  // Tạm thời chưa hash
                .fullName(fullName)
                .dob(dob)
                .gender(gender)
                .email(email)
                .phone(phone)
                .address(address)
                .insuranceNumber(insuranceNumber)
                .emergencyContact(emergencyContact)
                .build();

        String otp = generateOTP(6);
        HttpSession session = request.getSession();
        session.setAttribute("tempPatient", tempPatient);
        session.setAttribute("otp", otp);

        // Gửi email
        SendingEmail emailSender = new SendingEmail();
        try {
            emailSender.sendEmail(email, "HRMS - Mã xác thực OTP", "Mã OTP của bạn là: " + otp);
        } catch (Exception e) {
            request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Điều hướng tới trang nhập OTP
        response.sendRedirect("otp-verification.jsp?msg=otp_sent");
    }

    private String generateOTP(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        Random rand = new Random();
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < length; i++) {
            otp.append(chars.charAt(rand.nextInt(chars.length())));
        }
        return otp.toString();
    }
}

