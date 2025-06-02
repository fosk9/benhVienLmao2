package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Patient;
import model.Employee;

import java.io.IOException;

@WebServlet("/MyProfile")
public class MyProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null || session.getAttribute("login-as") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String loginAs = (String) session.getAttribute("login-as");

        if ("patient".equals(loginAs)) {
            Patient patient = (Patient) session.getAttribute("account");
            request.setAttribute("patient", patient);
            request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);

        } else if ("employee".equals(loginAs)) {
            Employee employee = (Employee) session.getAttribute("account");
            request.setAttribute("employee", employee);
            request.getRequestDispatcher("my-profile-employee.jsp").forward(request, response);

        } else {
            response.sendRedirect("login.jsp");
        }
    }
}