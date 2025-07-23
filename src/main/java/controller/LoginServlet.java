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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String rawPassword = request.getParameter("password");
        String loginAs = request.getParameter("login-as");

        HttpSession session = request.getSession();
        String hashedPassword = PasswordUtils.hashPassword(rawPassword);

        if ("Patient".equalsIgnoreCase(loginAs)) {
            PatientDAO patientDAO = new PatientDAO();
            Patient patient = patientDAO.login(username, hashedPassword);

            // Nếu login thất bại, thử lại bằng raw password
            if (patient == null) {
                patient = patientDAO.login(username, rawPassword);
                if (patient != null) {
                    // Cập nhật mật khẩu đã hash vào DB
                    patient.setPasswordHash(hashedPassword);
                    patientDAO.update(patient);
                }
            }

            if (patient != null && patient.getAccStatus() != null && patient.getAccStatus() == 1) {
                session.setAttribute("username", username);
                session.setAttribute("patientId", patient.getPatientId());
                session.setAttribute("role", "Patient");
                session.setAttribute("account", patient);
                session.setAttribute("login-as", "patient");
                response.sendRedirect(request.getContextPath() + "/pactHome");
                return;
            } else {
                request.setAttribute("error", patient == null
                        ? "Incorrect username or password."
                        : "Your account has been deactivated. Please contact support.");
            }

        } else if ("Employee".equalsIgnoreCase(loginAs)) {
            EmployeeDAO employeeDAO = new EmployeeDAO();
            Employee employee = employeeDAO.login(username, hashedPassword);

            // Nếu login thất bại, thử lại bằng raw password
            if (employee == null) {
                employee = employeeDAO.login(username, rawPassword);
                if (employee != null) {
                    employee.setPasswordHash(hashedPassword);
                    employeeDAO.update(employee);
                }
            }

            if (employee != null && employee.getAccStatus() != null && employee.getAccStatus() == 1) {
                session.setAttribute("username", username);
                session.setAttribute("account", employee);
                session.setAttribute("role", employee.getRoleId());
                session.setAttribute("login-as", "employee");

                switch (employee.getRoleId()) {
                    case 1:
                        response.sendRedirect(request.getContextPath() + "/doctor-home");
                        return;
                    case 2:
                        response.sendRedirect(request.getContextPath() + "/receptionist-dashboard");
                        return;
                    case 3:
                        response.sendRedirect(request.getContextPath() + "/admin-dashboard");
                        return;
                    case 4:
                        response.sendRedirect(request.getContextPath() + "/manager-dashboard");
                        return;
                    default:
                        response.sendRedirect(request.getContextPath() + "/index.html");
                        return;
                }

            } else {
                request.setAttribute("error", employee == null
                        ? "Incorrect username or password."
                        : "Your account has been deactivated. Please contact support.");
            }

        } else {
            request.setAttribute("error", "Invalid account type selected.");
        }

        // Trường hợp login thất bại
        request.setAttribute("username", username);
        request.setAttribute("password", rawPassword);
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
