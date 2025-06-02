package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;
import model.Patient;
import view.EmployeeDAO;
import view.PatientDAO;

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
        String userType = request.getParameter("user_type"); // nhận từ dropdown

        if (username == null || userType == null || username.isEmpty() || userType.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        String email = null;

        if (userType.equalsIgnoreCase("patient")) {
            Patient patient = patientDAO.getPatientByUsername(username);
            if (patient != null && patient.getEmail() != null && !patient.getEmail().isEmpty()) {
                email = patient.getEmail();
            }
        } else if (userType.equalsIgnoreCase("employee")) {
            Employee employee = employeeDAO.getEmployeeByUsername(username);
            if (employee != null && employee.getEmail() != null && !employee.getEmail().isEmpty()) {
                email = employee.getEmail();
            }
        } else {
            request.setAttribute("error", "Loại người dùng không hợp lệ.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        if (email == null) {
            request.setAttribute("error", "Không tìm thấy tài khoản hoặc tài khoản chưa có email.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        // Tạo OTP
        String otp = generateOTP(8);

        // Lưu OTP, username và user_type vào session
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("username", username);
        session.setAttribute("user_type", userType);

        // Gửi email
        SendingEmail emailSender = new SendingEmail();
        try {
            emailSender.sendEmail(email, "HRMS - Mã xác thực OTP", "Mã OTP của bạn là: " + otp);
        } catch (Exception e) {
            request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        // Điều hướng tới trang nhập OTP
        response.sendRedirect("otp-verification.jsp");
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

