

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
                session.setAttribute("account", patient);
                session.setAttribute("login-as", "patient");
                response.sendRedirect("index.html");
                return;
            } else {
                request.setAttribute("username", username);
                request.setAttribute("password", password);
                request.setAttribute("error", "Invalid patient credentials!");
            }
        } else if ("Employee".equals(loginAs)) {
            EmployeeDAO employeeDAO = new EmployeeDAO();
            Employee employee = employeeDAO.login(username, password);
            if (employee != null) {
                session.setAttribute("account", employee);
                if (employee.getRoleId() == 1) {
                    session.setAttribute("login-as", "Doctor");
                    response.sendRedirect(request.getContextPath() + "/doctor-home");
                } else {
                    session.setAttribute("login-as", "Employee");
                    response.sendRedirect("index.html");
                }
                return;
            }
        } else {
            request.setAttribute("username", username);
            request.setAttribute("password", password);
            request.setAttribute("error", "Invalid login role selected!");
        }
        request.setAttribute("username", username);
        request.setAttribute("password", password);
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }
}
