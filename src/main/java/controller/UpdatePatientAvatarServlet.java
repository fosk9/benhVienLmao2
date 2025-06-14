package controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Patient;
import view.PatientDAO;

import java.io.IOException;
import java.util.Map;

@WebServlet("/UpdatePatientAvatar")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,        // 1MB: file sẽ được lưu tạm vào disk nếu vượt ngưỡng này
        maxFileSize = 5 * 1024 * 1024,          // Giới hạn: 5MB cho mỗi file
        maxRequestSize = 10 * 1024 * 1024       // Tổng dung lượng tất cả request parts: 10MB
)

public class UpdatePatientAvatarServlet extends HttpServlet {

    private Cloudinary cloudinary;

    @Override
    public void init() throws ServletException {
        cloudinary = CloudinaryService.getInstance(); // Lấy Cloudinary từ service
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String loginAs = (String) session.getAttribute("login-as");

        if (!"patient".equals(loginAs)) {
            response.sendRedirect("login.jsp");
            return;
        }

        Patient patient = (Patient) session.getAttribute("account");

        try {
            Part avatarPart = request.getPart("avatar");

            // 1. Check content type
            String contentType = avatarPart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                request.setAttribute("message", "Only image files are allowed.");
                request.setAttribute("patient", patient);
                request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);
                return;
            }

            // 2. Check file size <= 2MB
            long fileSize = avatarPart.getSize();
            if (fileSize > 5 * 1024 * 1024) {
                request.setAttribute("message", "Avatar file must be under 5MB.");
                request.setAttribute("patient", patient);
                request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);
                return;
            }

            // 3. Read file bytes
            byte[] bytes = avatarPart.getInputStream().readAllBytes();

            // 4. Upload to Cloudinary
            Map<String, Object> uploadParams = ObjectUtils.asMap(
                    "resource_type", "auto",
                    "public_id", "patient_avatar_" + patient.getPatientId(),
                    "overwrite", true
            );
            Map<String, Object> uploadResult = cloudinary.uploader().upload(bytes, uploadParams);
            String uploadedUrl = (String) uploadResult.get("secure_url");

            // 5. Update DB
            patient.setPatientAvaUrl(uploadedUrl);
            new PatientDAO().update(patient);

            session.setAttribute("account", patient);
            request.setAttribute("patient", patient);
            request.setAttribute("message", "Avatar updated successfully!");
            request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("patient", patient);
            request.setAttribute("message", "Failed to upload avatar.");
            request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);
        }
    }
}
