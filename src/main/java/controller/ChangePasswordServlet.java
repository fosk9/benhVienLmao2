package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;
import model.Patient;
import view.EmployeeDAO;
import view.PatientDAO;

import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object account = session.getAttribute("account");
        String role = (String) session.getAttribute("login-as");

        if (account == null || role == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String oldPassword = request.getParameter("old-password");
        String newPassword = request.getParameter("new-password");
        String confirmPassword = request.getParameter("confirm-password");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu mới không khớp với xác nhận.");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        int isUpdated = 0;

        if ("patient".equalsIgnoreCase(role)) {
            Patient patient = (Patient) account;
            PatientDAO patientDAO = new PatientDAO();
            Patient loggedIn = patientDAO.login(patient.getUsername(), oldPassword);
            if (loggedIn != null) {
                patient.setPasswordHash(newPassword);
                isUpdated = patientDAO.update(patient);
            } else {
                request.setAttribute("error", "Mật khẩu cũ không đúng.");
            }

        } else if ("employee".equalsIgnoreCase(role)) {
            Employee employee = (Employee) account;
            EmployeeDAO employeeDAO = new EmployeeDAO();
            Employee loggedIn = employeeDAO.login(employee.getUsername(), oldPassword);
            if (loggedIn != null) {
                employee.setPasswordHash(newPassword);
                isUpdated = employeeDAO.update(employee);
            } else {
                request.setAttribute("error", "Mật khẩu cũ không đúng.");
            }
        }

        if (isUpdated > 0) {
            request.setAttribute("success", "Đổi mật khẩu thành công!");
        } else if (request.getAttribute("error") == null) {
            request.setAttribute("error", "Đổi mật khẩu thất bại. Vui lòng thử lại.");
        }

        request.getRequestDispatcher("change-password.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("change-password.jsp").forward(request, response);
    }
}
