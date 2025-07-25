package controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import model.Employee;
import service.CloudinaryService;
import validation.EmployeeValidator;
import dal.EmployeeDAO;

import java.io.IOException;
import java.sql.Date;
import java.util.Map;

@WebServlet(name = "UpdateMyProfileEmployeeServlet", urlPatterns = {
        "/UpdateMyProfileEmployee",
        "/UpdateEmployeeAvatar"
})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class UpdateMyProfileEmployeeServlet extends HttpServlet {

    private Cloudinary cloudinary;

    @Override
    public void init() throws ServletException {
        cloudinary = CloudinaryService.getInstance();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath(); // Lấy đường dẫn để phân biệt
        HttpSession session = request.getSession();
        String loginAs = (String) session.getAttribute("login-as");

        if (!"employee".equals(loginAs)) {
            response.sendRedirect("login.jsp");
            return;
        }

        Employee employee = (Employee) session.getAttribute("account");

        switch (servletPath) {
            case "/UpdateMyProfileEmployee":
                handleUpdateInfo(request, response, session, employee);
                break;
            case "/UpdateEmployeeAvatar":
                handleUpdateAvatar(request, response, session, employee);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleUpdateInfo(HttpServletRequest request, HttpServletResponse response,
                                  HttpSession session, Employee oldEmployee)
            throws ServletException, IOException {
        try {
            int employeeId = Integer.parseInt(request.getParameter("employeeId"));
            String fullName = request.getParameter("fullName");
            String dobStr = request.getParameter("dob");
            String gender = request.getParameter("gender");
            String phone = request.getParameter("phone");

            // Validate
            if (!EmployeeValidator.isValidFullName(fullName)) {
                showError(request, response, oldEmployee, "Invalid full name.");
                return;
            }

            Date dob;
            try {
                dob = Date.valueOf(dobStr);
                if (!EmployeeValidator.isValidDob(dob)) throw new IllegalArgumentException();
            } catch (Exception ex) {
                showError(request, response, oldEmployee, "Invalid date of birth.");
                return;
            }

            if (!EmployeeValidator.isValidGender(gender)) {
                showError(request, response, oldEmployee, "Invalid gender.");
                return;
            }

            if (!EmployeeValidator.isValidPhone(phone)) {
                showError(request, response, oldEmployee, "Invalid phone number.");
                return;
            }

            // Build updated object
            Employee updated = Employee.builder()
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

            new EmployeeDAO().update(updated);
            session.setAttribute("account", updated);
            request.setAttribute("employee", updated);
            request.setAttribute("message", "Your profile has been updated successfully.");
            request.getRequestDispatcher("my-profile-employee.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            showError(request, response, oldEmployee, "An error occurred while updating your profile.");
        }
    }

    private void handleUpdateAvatar(HttpServletRequest request, HttpServletResponse response,
                                    HttpSession session, Employee employee)
            throws ServletException, IOException {
        try {
            Part avatarPart = request.getPart("avatar");

            String contentType = avatarPart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                showError(request, response, employee, "Only image files are allowed.");
                return;
            }

            long fileSize = avatarPart.getSize();
            if (fileSize > 5 * 1024 * 1024) {
                showError(request, response, employee, "Avatar file must be under 5MB.");
                return;
            }

            byte[] bytes = avatarPart.getInputStream().readAllBytes();
            Map<String, Object> uploadParams = ObjectUtils.asMap(
                    "resource_type", "auto",
                    "public_id", "employee_avatar_" + employee.getEmployeeId(),
                    "overwrite", true
            );
            Map<String, Object> uploadResult = cloudinary.uploader().upload(bytes, uploadParams);
            String uploadedUrl = (String) uploadResult.get("secure_url");

            employee.setEmployeeAvaUrl(uploadedUrl);
            new EmployeeDAO().update(employee);
            session.setAttribute("account", employee);

            request.setAttribute("employee", employee);
            request.setAttribute("message", "Avatar updated successfully!");
            request.getRequestDispatcher("my-profile-employee.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            showError(request, response, employee, "Failed to upload avatar.");
        }
    }

    private void showError(HttpServletRequest request, HttpServletResponse response,
                           Employee employee, String message)
            throws ServletException, IOException {
        request.setAttribute("employee", employee);
        request.setAttribute("message", message);
        request.getRequestDispatcher("my-profile-employee.jsp").forward(request, response);
    }
}
