package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;
import model.Patient;
import util.PasswordUtils;
import view.EmployeeDAO;
import view.PatientDAO;

import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private static final String PASSWORD_REQUIREMENT_MSG =
            "Password must be at least 8 characters and include uppercase, lowercase, number, and special character.";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object account = session.getAttribute("account");
        String role = (String) session.getAttribute("login-as");

        if (account == null || role == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String oldPassword = request.getParameter("old-password");
        String newPassword = request.getParameter("new-password");
        String confirmPassword = request.getParameter("confirm-password");

        if (oldPassword == null || newPassword == null || confirmPassword == null) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New password and confirmation do not match.");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^\\w\\s]).{8,}$")) {
            request.setAttribute("error", PASSWORD_REQUIREMENT_MSG);
            request.setAttribute("password_hint", PASSWORD_REQUIREMENT_MSG);
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        String hashedOldPassword = PasswordUtils.hashPassword(oldPassword);
        String hashedNewPassword = PasswordUtils.hashPassword(newPassword);

        int isUpdated = 0;

        if ("patient".equalsIgnoreCase(role)) {
            Patient patient = (Patient) account;
            PatientDAO patientDAO = new PatientDAO();
            Patient loggedIn = patientDAO.login(patient.getUsername(), hashedOldPassword);
            if (loggedIn != null) {
                patient.setPasswordHash(hashedNewPassword);
                isUpdated = patientDAO.update(patient);
            } else {
                request.setAttribute("error", "Old password is incorrect.");
            }

        } else if ("employee".equalsIgnoreCase(role)) {
            Employee employee = (Employee) account;
            EmployeeDAO employeeDAO = new EmployeeDAO();
            Employee loggedIn = employeeDAO.login(employee.getUsername(), hashedOldPassword);
            if (loggedIn != null) {
                employee.setPasswordHash(hashedNewPassword);
                isUpdated = employeeDAO.update(employee);
            } else {
                request.setAttribute("error", "Old password is incorrect.");
            }
        }

        if (isUpdated > 0) {
            request.setAttribute("success", "Password changed successfully.");
        } else if (request.getAttribute("error") == null) {
            request.setAttribute("error", "Failed to change password. Please try again.");
        }

        request.getRequestDispatcher("change-password.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("change-password.jsp").forward(request, response);
    }
}
