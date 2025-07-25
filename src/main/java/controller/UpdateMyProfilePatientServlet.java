package controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import model.Patient;
import service.CloudinaryService;
import validation.PatientValidator;
import view.PatientDAO;

import java.io.IOException;
import java.sql.Date;
import java.util.Map;

@WebServlet(name = "UpdateMyProfilePatientServlet", urlPatterns = {
        "/UpdateMyProfilePatient",
        "/UpdatePatientAvatar"
})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,        // 1MB
        maxFileSize = 5 * 1024 * 1024,          // 5MB/file
        maxRequestSize = 10 * 1024 * 1024       // 10MB tổng
)
public class UpdateMyProfilePatientServlet extends HttpServlet {

    private Cloudinary cloudinary;

    @Override
    public void init() throws ServletException {
        cloudinary = CloudinaryService.getInstance();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath();
        HttpSession session = request.getSession();
        String loginAs = (String) session.getAttribute("login-as");

        if (!"patient".equals(loginAs)) {
            response.sendRedirect("login.jsp");
            return;
        }

        Patient patient = (Patient) session.getAttribute("account");

        switch (servletPath) {
            case "/UpdateMyProfilePatient":
                handleProfileUpdate(request, response, session, patient);
                break;
            case "/UpdatePatientAvatar":
                handleAvatarUpdate(request, response, session, patient);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response,
                                     HttpSession session, Patient oldPatient)
            throws ServletException, IOException {

        try {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            String fullName = request.getParameter("fullName");
            String dobStr = request.getParameter("dob");
            String gender = request.getParameter("gender");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String insuranceNumber = request.getParameter("insuranceNumber");
            String emergencyContact = request.getParameter("emergencyContact");

            // Validate
            if (!PatientValidator.isValidFullName(fullName)) {
                sendError("Invalid full name.", request, response, oldPatient);
                return;
            }

            Date dob;
            try {
                dob = Date.valueOf(dobStr);
                if (!PatientValidator.isValidDob(dob)) throw new IllegalArgumentException();
            } catch (Exception ex) {
                sendError("Invalid date of birth.", request, response, oldPatient);
                return;
            }

            if (!PatientValidator.isValidGender(gender)) {
                sendError("Invalid gender.", request, response, oldPatient);
                return;
            }

            if (!PatientValidator.isValidPhone(phone)) {
                sendError("Invalid phone number.", request, response, oldPatient);
                return;
            }

            if (!PatientValidator.isValidAddress(address)) {
                sendError("Invalid address.", request, response, oldPatient);
                return;
            }

            if (!PatientValidator.isValidInsuranceNumber(insuranceNumber)) {
                sendError("Invalid insurance number.", request, response, oldPatient);
                return;
            }

            if (!PatientValidator.isValidEmergencyContact(emergencyContact)) {
                sendError("Invalid emergency contact.", request, response, oldPatient);
                return;
            }

            // Build updated object
            Patient updated = Patient.builder()
                    .patientId(patientId)
                    .username(oldPatient.getUsername())
                    .passwordHash(oldPatient.getPasswordHash())
                    .email(oldPatient.getEmail())
                    .patientAvaUrl(oldPatient.getPatientAvaUrl())
                    .fullName(fullName)
                    .dob(dob)
                    .gender(gender)
                    .phone(phone)
                    .address(address)
                    .insuranceNumber(insuranceNumber)
                    .emergencyContact(emergencyContact)
                    .build();

            new PatientDAO().update(updated);
            session.setAttribute("account", updated);

            request.setAttribute("patient", updated);
            request.setAttribute("message", "Your profile has been updated successfully.");
            request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            sendError("An error occurred while updating your profile.", request, response, oldPatient);
        }
    }

    private void handleAvatarUpdate(HttpServletRequest request, HttpServletResponse response,
                                    HttpSession session, Patient patient)
            throws ServletException, IOException {
        try {
            Part avatarPart = request.getPart("avatar");

            String contentType = avatarPart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                sendError("Only image files are allowed.", request, response, patient);
                return;
            }

            long fileSize = avatarPart.getSize();
            if (fileSize > 5 * 1024 * 1024) {
                sendError("Avatar file must be under 5MB.", request, response, patient);
                return;
            }

            byte[] bytes = avatarPart.getInputStream().readAllBytes();
            Map<String, Object> uploadParams = ObjectUtils.asMap(
                    "resource_type", "auto",
                    "public_id", "patient_avatar_" + patient.getPatientId(),
                    "overwrite", true
            );
            Map<String, Object> uploadResult = cloudinary.uploader().upload(bytes, uploadParams);
            String uploadedUrl = (String) uploadResult.get("secure_url");

            patient.setPatientAvaUrl(uploadedUrl);
            new PatientDAO().update(patient);
            session.setAttribute("account", patient);

            request.setAttribute("patient", patient);
            request.setAttribute("message", "Avatar updated successfully!");
            request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            sendError("Failed to upload avatar.", request, response, patient);
        }
    }

    private void sendError(String message, HttpServletRequest request,
                           HttpServletResponse response, Patient patient)
            throws ServletException, IOException {
        request.setAttribute("patient", patient);
        request.setAttribute("message", message);
        request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);
    }
}
