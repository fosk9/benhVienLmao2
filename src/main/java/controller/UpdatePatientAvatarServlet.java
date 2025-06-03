package controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Patient;
import view.PatientDAO;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

@WebServlet("/UpdatePatientAvatar")
@MultipartConfig
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
            InputStream avatarStream = avatarPart.getInputStream();
            String fileName = avatarPart.getSubmittedFileName();

            byte[] bytes = avatarStream.readAllBytes(); // Convert InputStream -> byte[]

            Map<String, Object> uploadParams = ObjectUtils.asMap(
                    "resource_type", "auto",
                    "public_id", "patient_avatar_" + patient.getPatientId() + "_" + System.currentTimeMillis(),
                    "overwrite", true
            );

            Map<String, Object> uploadResult = cloudinary.uploader().upload(bytes, uploadParams);

            String uploadedUrl = (String) uploadResult.get("secure_url");

            // Update DB
            patient.setPatientAvaUrl(uploadedUrl);
            PatientDAO dao = new PatientDAO();
            dao.update(patient);

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
