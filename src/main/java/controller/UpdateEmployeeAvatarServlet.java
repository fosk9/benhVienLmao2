package controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Employee;
import view.EmployeeDAO;

import java.io.IOException;
import java.util.Map;

@WebServlet("/UpdateEmployeeAvatar")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,        // 1MB: file sẽ được lưu tạm vào disk nếu vượt ngưỡng này
        maxFileSize = 5 * 1024 * 1024,          // Giới hạn: 5MB cho mỗi file
        maxRequestSize = 10 * 1024 * 1024       // Tổng dung lượng tất cả request parts: 10MB
)

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

            // 1. Validate content type
            String contentType = avatarPart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                request.setAttribute("message", "Only image files are allowed.");
                request.setAttribute("employee", employee);
                request.getRequestDispatcher("my-profile-employee.jsp").forward(request, response);
                return;
            }

            // 2. Validate file size
            long fileSize = avatarPart.getSize();
            if (fileSize > 5 * 1024 * 1024) {
                request.setAttribute("message", "Avatar file must be under 5MB.");
                request.setAttribute("employee", employee);
                request.getRequestDispatcher("my-profile-employee.jsp").forward(request, response);
                return;
            }

            // 3. Upload to Cloudinary
            byte[] bytes = avatarPart.getInputStream().readAllBytes();
            Map<String, Object> uploadParams = ObjectUtils.asMap(
                    "resource_type", "auto",
                    "public_id", "employee_avatar_" + employee.getEmployeeId(),
                    "overwrite", true
            );
            Map<String, Object> uploadResult = cloudinary.uploader().upload(bytes, uploadParams);
            String uploadedUrl = (String) uploadResult.get("secure_url");

            // 4. Update DB
            employee.setEmployeeAvaUrl(uploadedUrl);
            new EmployeeDAO().update(employee);
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
