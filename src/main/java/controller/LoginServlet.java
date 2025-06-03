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

        if (password == null || !password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^\\w\\s]).{8,}$")) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.");
            // Gửi lại dữ liệu đã nhập về JSP để hiển thị lại
            request.setAttribute("username", username);
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if ("Patient".equals(loginAs)) {
            PatientDAO patientDAO = new PatientDAO();
            Patient patient = patientDAO.login(username, password);
            if (patient != null) {
                session.setAttribute("username", username);
                session.setAttribute("patientId", patient.getPatientId());
                session.setAttribute("role", "Patient"); // Hardcoded role for patients
                session.setAttribute("account", patient);
                session.setAttribute("login-as", "patient");
                response.sendRedirect(request.getContextPath() + "/pactHome");
                return;
            } else {
                request.setAttribute("username", username);
                request.setAttribute("password", password);
                request.setAttribute("error", "Tài khoản hoặc mật khẩu không đúng");
            }
        } else if ("Employee".equals(loginAs)) {
            EmployeeDAO employeeDAO = new EmployeeDAO();
            Employee employee = employeeDAO.login(username, password);
            if (employee != null) {
                session.setAttribute("account", employee);
                session.setAttribute("username", username);
                session.setAttribute("role", employee.getRoleId());

                if (employee.getRoleId() == 1) {
                    response.sendRedirect(request.getContextPath() + "/doctor-home");
                } else {
                    response.sendRedirect(request.getContextPath() + "/index.html");
                }
                return;
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

