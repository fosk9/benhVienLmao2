package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;
import view.EmployeeDAO;

import java.io.IOException;
import java.sql.Date;

@WebServlet(name = "UpdateMyProfileEmployeeServlet", urlPatterns = {"/UpdateMyProfileEmployee"})
public class UpdateMyProfileEmployeeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        String fullName = request.getParameter("fullName");
        String dobStr = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");

        HttpSession session = request.getSession();
        Employee oldEmployee = (Employee) session.getAttribute("account");

        try {
            Employee updatedEmployee = Employee.builder()
                    .employeeId(employeeId)
                    .username(oldEmployee.getUsername())
                    .passwordHash(oldEmployee.getPasswordHash())
                    .email(oldEmployee.getEmail())
                    .roleId(oldEmployee.getRoleId())
                    .employeeAvaUrl(oldEmployee.getEmployeeAvaUrl())
                    .fullName(fullName)
                    .dob(Date.valueOf(dobStr))
                    .gender(gender)
                    .phone(phone)
                    .build();

            EmployeeDAO dao = new EmployeeDAO();
            dao.update(updatedEmployee);

            session.setAttribute("account", updatedEmployee);
            request.setAttribute("employee", updatedEmployee);
            request.setAttribute("message", "Your profile has been updated successfully.");
            request.getRequestDispatcher("my-profile-employee.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("employee", oldEmployee);
            request.setAttribute("message", "An error occurred while updating your profile.");
            request.getRequestDispatcher("my-profile-employee.jsp").forward(request, response);
        }
    }
}
