package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.PasswordUtils;
import view.EmployeeDAO;
import view.PatientDAO;

import java.io.IOException;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    private PatientDAO patientDAO;
    private EmployeeDAO employeeDAO;

    @Override
    public void init() {
        patientDAO = new PatientDAO();
        employeeDAO = new EmployeeDAO();
    }

    private static final String PASSWORD_REQUIREMENT_MSG =
            "Password must be at least 8 characters and include uppercase, lowercase, number, and special character.";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");
        HttpSession session = request.getSession();

        String username = (String) session.getAttribute("username");
        String userType = (String) session.getAttribute("user_type");

        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^\\w\\s]).{8,}$")) {
            request.setAttribute("error", PASSWORD_REQUIREMENT_MSG);
            request.setAttribute("password_hint", PASSWORD_REQUIREMENT_MSG); // để hiển thị lại ở JSP
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        if (username == null || userType == null) {
            request.setAttribute("error", "Session has expired or missing data. Please try again.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        // Hash password và cập nhật
        String hashedPassword = PasswordUtils.hashPassword(newPassword);
        int updated = 0;

        switch (userType.toLowerCase()) {
            case "patient":
                updated = patientDAO.updatePasswordByUsername(username, hashedPassword);
                break;
            case "employee":
                updated = employeeDAO.updatePasswordByUsername(username, hashedPassword);
                break;
            default:
                request.setAttribute("error", "Invalid user type.");
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
        }

        if (updated > 0) {
            session.removeAttribute("username");
            session.removeAttribute("otp");
            session.removeAttribute("user_type");
            request.setAttribute("success", "Your password has been successfully reset. Please log in.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Failed to update password. Please try again.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        }
    }

}

