package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;
import validation.EmployeeValidator;
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
            // ✅ Validate input data
            if (!EmployeeValidator.isValidFullName(fullName)) {
                request.setAttribute("message", "Invalid full name.");
                request.setAttribute("employee", oldEmployee);
                request.getRequestDispatcher("my-profile-employee.jsp").forward(request, response);
                return;
            }

            Date dob = null;
            try {
                dob = Date.valueOf(dobStr);
                if (!EmployeeValidator.isValidDob(dob)) {
                    throw new IllegalArgumentException();
                }
            } catch (Exception ex) {
                request.setAttribute("message", "Invalid date of birth.");
                request.setAttribute("employee", oldEmployee);
                request.getRequestDispatcher("my-profile-employee.jsp").forward(request, response);
                return;
            }

            if (!EmployeeValidator.isValidGender(gender)) {
                request.setAttribute("message", "Invalid gender.");
                request.setAttribute("employee", oldEmployee);
                request.getRequestDispatcher("my-profile-employee.jsp").forward(request, response);
                return;
            }

            if (!EmployeeValidator.isValidPhone(phone)) {
                request.setAttribute("message", "Invalid phone number.");
                request.setAttribute("employee", oldEmployee);
                request.getRequestDispatcher("my-profile-employee.jsp").forward(request, response);
                return;
            }

            // ✅ Valid Data -> Build updated Employee object
            Employee updatedEmployee = Employee.builder()
                    .employeeId(employeeId)
                    .username(oldEmployee.getUsername())
                    .passwordHash(oldEmployee.getPasswordHash())
                    .email(oldEmployee.getEmail())
                    .roleId(oldEmployee.getRoleId())
                    .employeeAvaUrl(oldEmployee.getEmployeeAvaUrl())
                    .fullName(fullName)
                    .dob(dob)
                    .gender(gender)
                    .phone(phone)
                    .build();

            // ✅ Update DB
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