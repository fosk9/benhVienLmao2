package controller;

import jakarta.servlet.ServletException;
import view.EmployeeDAO;
import view.PatientDAO;
import model.Employee;
import model.Patient;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String loginAs = request.getParameter("login-as");

        HttpSession session = request.getSession();

        if ("Patient".equals(loginAs)) {
            PatientDAO patientDAO = new PatientDAO();
            Patient patient = patientDAO.login(username, password);
            if (patient != null) {
                // Kiểm tra trạng thái tài khoản
                if (patient.getAccStatus() != null && patient.getAccStatus() == 1) {
                    session.setAttribute("username", username);

                    session.setAttribute("patientId", patient.getPatientId());
                    session.setAttribute("role", "Patient");
                    session.setAttribute("account", patient);
                    session.setAttribute("login-as", "patient");
                    response.sendRedirect(request.getContextPath() + "/pactHome");
                    return;
                } else {
                    request.setAttribute("username", username);
                    request.setAttribute("password", password);
                    request.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
                }
            } else {
                request.setAttribute("username", username);
                request.setAttribute("password", password);
                request.setAttribute("error", "Tài khoản hoặc mật khẩu không đúng");
            }
        } else if ("Employee".equals(loginAs)) {
            EmployeeDAO employeeDAO = new EmployeeDAO();
            Employee employee = employeeDAO.login(username, password);
            if (employee != null) {
                // Kiểm tra trạng thái tài khoản
                if (employee.getAccStatus() != null && employee.getAccStatus() == 1) {
                    session.setAttribute("account", employee);
                    session.setAttribute("username", username);
                    session.setAttribute("role", employee.getRoleId());
                    session.setAttribute("login-as", "employee");

                    int roleId = employee.getRoleId();
                    switch (roleId) {
                        case 1:
                            response.sendRedirect(request.getContextPath() + "/doctor-home");
                            break;
                        case 2:
                            response.sendRedirect(request.getContextPath() + "/receptionist-dashboard");
                            break;
                        case 3:
                            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
                            break;
                        case 4:
                            response.sendRedirect(request.getContextPath() + "/manager-dashboard");
                            break;
                        default:
                            response.sendRedirect(request.getContextPath() + "/index.html");
                            break;
                    }
                    return;
                } else {
                    request.setAttribute("username", username);
                    request.setAttribute("password", password);
                    request.setAttribute("error", "Your account is inactive.");
                }
            } else {
                request.setAttribute("username", username);
                request.setAttribute("password", password);
                request.setAttribute("error", "Tài khoản hoặc mật khẩu không đúng");
            }
        } else {
            request.setAttribute("username", username);
            request.setAttribute("password", password);
            request.setAttribute("error", "Invalid login role selected!");
        }
        request.setAttribute("username", username);
        request.setAttribute("password", password);
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
