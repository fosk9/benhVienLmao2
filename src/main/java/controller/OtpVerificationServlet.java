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
            Patient tempPatient = (Patient) session.getAttribute("tempPatient");
            if (tempPatient != null) {
                PatientDAO patientDAO = new PatientDAO();
                int patientId = patientDAO.insert(tempPatient); // Insert patient into DB
                session.removeAttribute("tempPatient");
                session.removeAttribute("otp");

                // Set patientId in session to simulate login
//                session.setAttribute("patientId", patientId);

                // Check if there's appointment form data to restore
                if (session.getAttribute("appointmentFormData") != null) {
                    response.sendRedirect("book-appointment");
                } else {
                    response.sendRedirect("login.jsp?msg=register_success");
                }
                return;
            }

            // Trường hợp dùng cho quên mật khẩu
            response.sendRedirect("reset-password.jsp");
        } else {
            request.setAttribute("error", "Mã OTP không chính xác!");
            request.getRequestDispatcher("otp-verification.jsp").forward(request, response);
        }
    }
}