package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;
import model.Patient;
import dal.EmployeeDAO;
import dal.PatientDAO;

import java.io.IOException;
import java.util.Random;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot"})
public class ForgotPasswordServlet extends HttpServlet {
    private PatientDAO patientDAO;
    private EmployeeDAO employeeDAO;

    @Override
    public void init() {
        patientDAO = new PatientDAO();
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String userType = request.getParameter("user_type"); // "patient" hoặc "employee"

        if (username == null || userType == null || username.isEmpty() || userType.isEmpty()) {
            request.setAttribute("error", "Please fill in all required fields.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        String email = null;
        String fullName = null;

        if (userType.equalsIgnoreCase("patient")) {
            Patient patient = patientDAO.getPatientByUsername(username);
            if (patient != null && patient.getEmail() != null && !patient.getEmail().isEmpty()) {
                email = patient.getEmail();
                fullName = patient.getFullName();
            }
        } else if (userType.equalsIgnoreCase("employee")) {
            Employee employee = employeeDAO.getEmployeeByUsername(username);
            if (employee != null && employee.getEmail() != null && !employee.getEmail().isEmpty()) {
                email = employee.getEmail();
                fullName = employee.getFullName();
            }
        } else {
            request.setAttribute("error", "Invalid user type.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        if (email == null) {
            request.setAttribute("error", "Account not found or email is missing.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        // ✅ Tạo OTP
        String otp = generateOTP(6);

        // ✅ Lưu OTP, thời gian tạo, username và user_type vào session
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("username", username);
        session.setAttribute("user_type", userType);
        session.setAttribute("otpGeneratedTime", System.currentTimeMillis());
        session.setAttribute("forgotEmail", email); // Dòng quan trọng để OTP xử lý đúng


        // ✅ Gửi email
        SendingEmail emailSender = new SendingEmail();
        try {
            String subject = "HRMS - Your OTP for Password Reset";
            String content = "Hello " + (fullName != null ? fullName : "") + ",\n\n"
                    + "Your OTP for password reset is: **" + otp + "**\n"
                    + "This code will expire in 5 minutes.\n\n"
                    + "If you did not request this, please ignore this email.\n\n"
                    + "Regards,\nHospital Management System";
            emailSender.sendEmail(email, subject, content);
        } catch (Exception e) {
            request.setAttribute("error", "Failed to send OTP email. Please try again.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        // ✅ Chuyển sang trang xác minh OTP
        response.sendRedirect("otp-verification.jsp");
    }

    private String generateOTP(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        Random rand = new Random();
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < length; i++) {
            otp.append(chars.charAt(rand.nextInt(chars.length())));
        }
        return otp.toString();
    }
}
