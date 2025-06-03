package controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Employee;
import view.EmployeeDAO;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

@WebServlet("/UpdateEmployeeAvatar")
@MultipartConfig
public class UpdateEmployeeAvatarServlet extends HttpServlet {

    private Cloudinary cloudinary;

    @Override
    public void init() throws ServletException {
        cloudinary = CloudinaryService.getInstance();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String loginAs = (String) session.getAttribute("login-as");

        if (!"employee".equals(loginAs)) {
            response.sendRedirect("login.jsp");
            return;
        }

        Employee employee = (Employee) session.getAttribute("account");

        try {
            Part avatarPart = request.getPart("avatar");
            InputStream avatarStream = avatarPart.getInputStream();
            byte[] bytes = avatarStream.readAllBytes();

            Map<String, Object> uploadParams = ObjectUtils.asMap(
                    "resource_type", "auto",
                    "public_id", "employee_avatar_" + employee.getEmployeeId() + "_" + System.currentTimeMillis(),
                    "overwrite", true
            );

            Map<String, Object> uploadResult = cloudinary.uploader().upload(bytes, uploadParams);
            String uploadedUrl = (String) uploadResult.get("secure_url");

            // Update avatar URL
            employee.setEmployeeAvaUrl(uploadedUrl);
            EmployeeDAO dao = new EmployeeDAO();
            dao.update(employee);

            session.setAttribute("account", employee);
            request.setAttribute("employee", employee);
            request.setAttribute("message", "Avatar updated successfully!");
            request.getRequestDispatcher("my-profile-employee.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("employee", employee);
            request.setAttribute("message", "Failed to upload avatar.");
            request.getRequestDispatcher("my-profile-employee.jsp").forward(request, response);
        }
    }
}
