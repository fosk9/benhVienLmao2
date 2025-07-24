package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.DoctorDetail;
import model.Employee;
import model.Patient;
import util.HistoryLogger;
import view.DoctorDetailDAO;
import view.EmployeeDAO;
import view.PatientDAO;

import java.io.IOException;

@WebServlet(name = "OtpVerificationServlet", urlPatterns = {"/verify-otp"})
public class OtpVerificationServlet extends HttpServlet {

    private final PatientDAO patientDAO = new PatientDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final DoctorDetailDAO doctorDetailDAO = new DoctorDetailDAO();

    private static final long OTP_TIMEOUT = 5 * 60 * 1000; // 5 phút

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String inputOtp = request.getParameter("otp");
        String correctOtp = (String) session.getAttribute("otp");
        Long otpTime = (Long) session.getAttribute("otpGeneratedTime");

        // ✅ Check OTP timeout
        if (otpTime == null || System.currentTimeMillis() - otpTime > OTP_TIMEOUT) {
            request.setAttribute("error", "OTP has expired. Please request a new one.");
            request.setAttribute("allowResend", true);
            request.getRequestDispatcher("otp-verification.jsp").forward(request, response);
            return;
        }

        // ✅ Check đúng OTP
        if (correctOtp != null && correctOtp.equals(inputOtp)) {

            // === CASE 1: PATIENT REGISTER ===
            Patient tempPatient = (Patient) session.getAttribute("tempPatient");
            if (tempPatient != null) {
                int id = patientDAO.insert(tempPatient);
                String rawPassword = (String) session.getAttribute("generatedPassword");

                if (id == 0) {
                    request.setAttribute("error", "Failed to create account. Please try again.");
                    request.getRequestDispatcher("otp-verification.jsp").forward(request, response);
                    return;
                }

                try {
                    new SendingEmail().sendEmail(tempPatient.getEmail(),
                            "Your Patient Account is Ready",
                            "Hello " + tempPatient.getFullName() + ",\n\n"
                                    + "Your patient account has been created successfully.\n"
                                    + "Username: " + tempPatient.getUsername() + "\n"
                                    + "Password: " + rawPassword + "\n\n"
                                    + "Please log in and change your password.\n\n"
                                    + "Regards,\nHRMS Team");
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Failed to send confirmation email. Please try again.");
                    request.getRequestDispatcher("otp-verification.jsp").forward(request, response);
                    return;
                }

                clearOtpSession(session);

                if (session.getAttribute("appointmentFormData") != null) {
                    response.sendRedirect("book-appointment");
                } else {
                    response.sendRedirect("login.jsp?msg=register_success");
                }
                return;
            }

            // === CASE 2: EMPLOYEE REGISTER ===
            Employee tempEmployee = (Employee) session.getAttribute("tempEmployee");
            if (tempEmployee != null) {
                int empId = employeeDAO.insertReturnId(tempEmployee);

                if (Boolean.TRUE.equals(session.getAttribute("isDoctor"))) {
                    DoctorDetail detail = DoctorDetail.builder()
                            .doctorId(empId)
                            .licenseNumber((String) session.getAttribute("licenseNumber"))
                            .specialist(Boolean.TRUE.equals(session.getAttribute("isSpecialist")))
                            .build();
                    doctorDetailDAO.insert(detail);
                }

                String rawPassword = (String) session.getAttribute("generatedPassword");

                try {
                    new SendingEmail().sendEmail(tempEmployee.getEmail(),
                            "Your Hospital Staff Account",
                            "Hello " + tempEmployee.getFullName() + ",\n\n"
                                    + "Your hospital account has been created.\n"
                                    + "Username: " + tempEmployee.getEmail() + "\n"
                                    + "Password: " + rawPassword + "\n\n"
                                    + "Please log in and change your password after first login.\n\n"
                                    + "Regards,\nHR Department");
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Failed to send confirmation email. Please try again.");
                    request.getRequestDispatcher("otp-verification.jsp").forward(request, response);
                    return;
                }

                Employee manager = (Employee) session.getAttribute("account");
                if (manager != null) {
                    HistoryLogger.log(
                            manager.getEmployeeId(),
                            manager.getFullName(),
                            empId,
                            tempEmployee.getFullName(),
                            "Employee",
                            "Created staff account: " + tempEmployee.getEmail()
                    );
                }

                clearOtpSession(session);
                response.sendRedirect("add-doctor-form?msg=created");
                return;
            }

            // === CASE 3: FORGOT PASSWORD ===
            if (session.getAttribute("forgotEmail") != null) {
                clearOtpSession(session);
                response.sendRedirect("reset-password.jsp");
                return;
            }

            // === CASE 4: EMPLOYEE INFO UPDATE ===
            Employee pendingUpdate = (Employee) session.getAttribute("pendingUpdateEmployee");
            DoctorDetail pendingDoc = (DoctorDetail) session.getAttribute("pendingUpdateDoctor");
            if (pendingUpdate != null) {
                boolean success = employeeDAO.updateEmployee(pendingUpdate);
                if (success) {
                    if (pendingDoc != null) {
                        doctorDetailDAO.updateDoctorDetails(pendingDoc);
                        session.removeAttribute("pendingUpdateDoctor");
                    }
                    Employee manager = (Employee) session.getAttribute("account");
                    HistoryLogger.log(
                            manager.getEmployeeId(),
                            manager.getFullName(),
                            pendingUpdate.getEmployeeId(),
                            pendingUpdate.getFullName(),
                            "Employee",
                            "Confirmed update for staff: " + pendingUpdate.getFullName()
                    );
                    clearOtpSession(session);
                    response.sendRedirect("staff-detail?id=" + pendingUpdate.getEmployeeId() + "&msg=update_confirmed");
                } else {
                    request.setAttribute("error", "Failed to update employee info after OTP.");
                    request.getRequestDispatcher("otp-verification.jsp").forward(request, response);
                }
                return;
            }

            // === Default fallback ===
            clearOtpSession(session);
            response.sendRedirect("login.jsp");

        } else {
            request.setAttribute("error", "Incorrect OTP code!");
            request.getRequestDispatcher("otp-verification.jsp").forward(request, response);
        }
    }

    private void clearOtpSession(HttpSession session) {
        session.removeAttribute("otp");
        session.removeAttribute("otpGeneratedTime");

        // Register
        session.removeAttribute("generatedPassword");
        session.removeAttribute("tempPatient");
        session.removeAttribute("tempEmployee");
        session.removeAttribute("licenseNumber");
        session.removeAttribute("isDoctor");
        session.removeAttribute("isSpecialist");

        // Forgot Password
        session.removeAttribute("forgotEmail");

        // Update
        session.removeAttribute("pendingUpdateEmployee");
        session.removeAttribute("pendingUpdateDoctor");
    }
}
