package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;
import model.Patient;

import java.io.IOException;
import java.util.Random;

@WebServlet(name = "ResendOtpServlet", urlPatterns = {"/resend-otp"})
public class ResendOtpServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if user has registration session (patient or employee)
        Patient tempPatient = (Patient) session.getAttribute("tempPatient");
        Employee tempEmployee = (Employee) session.getAttribute("tempEmployee");

        if (tempPatient == null && tempEmployee == null) {
            // No one to resend OTP for
            response.sendRedirect("otp-verification.jsp?msg=session_expired");
            return;
        }

        // Generate new 6-digit OTP
        String newOtp = String.format("%06d", new Random().nextInt(999999));
        session.setAttribute("otp", newOtp);
        session.setAttribute("otpGeneratedTime", System.currentTimeMillis());

        // Send email
        String toEmail;
        String fullName;

        if (tempPatient != null) {
            toEmail = tempPatient.getEmail();
            fullName = tempPatient.getFullName();
        } else {
            toEmail = tempEmployee.getEmail();
            fullName = tempEmployee.getFullName();
        }

        String subject = "Your new OTP Code";
        String content = "Hello " + fullName + ",\n\n"
                + "Here is your new OTP code: " + newOtp + "\n\n"
                + "This code is valid for 5 minutes.\n"
                + "If you didn't request this, please ignore it.\n\n"
                + "Hospital System";

        SendingEmail sender = new SendingEmail();
        sender.sendEmail(toEmail, subject, content);

        response.sendRedirect("otp-verification.jsp?msg=resend_success");
    }
}
