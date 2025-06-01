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

        Date dob = null;
        if (dobStr != null && !dobStr.isEmpty()) {
            try {
                dob = Date.valueOf(dobStr);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Ngày sinh không hợp lệ! Vui lòng nhập lại.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
        }

        // 2. Check trùng username, email, phone
        if (patientDAO.getPatientByUsername(username) != null) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại. Vui lòng chọn tên khác.");
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