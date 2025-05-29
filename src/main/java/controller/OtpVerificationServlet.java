package controller;
import jakarta.servlet.ServletException;
import view.EmployeeDAO;
import view.PatientDAO;
import model.Employee;
import model.Patient;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "OtpVerificationServlet", urlPatterns = {"/verify-otp"})
public class OtpVerificationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userInput = request.getParameter("otp");
        HttpSession session = request.getSession();
        String correctOtp = (String) session.getAttribute("otp");

        if (correctOtp != null && correctOtp.equalsIgnoreCase(userInput)) {
            response.sendRedirect("reset-password.jsp");
        } else {
            request.setAttribute("error", "Mã OTP không chính xác!");
            request.getRequestDispatcher("otp-verification.jsp").forward(request, response);
        }
    }
}
