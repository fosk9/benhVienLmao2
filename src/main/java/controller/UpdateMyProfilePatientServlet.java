package controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import model.Patient;
import service.CloudinaryService;
import validation.PatientValidator;
import dal.PatientDAO;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
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

            List<String> errors = new ArrayList<>();
            Date dob = null;

            // Validate từng trường
            if (!PatientValidator.isValidFullName(fullName)) {
                errors.add("Invalid full name.");
            }

            try {
                dob = Date.valueOf(dobStr);
                if (!PatientValidator.isValidDob(dob)) {
                    errors.add("Invalid date of birth.");
                }
            } catch (Exception ex) {
                errors.add("Invalid date of birth.");
            }

            if (!PatientValidator.isValidGender(gender)) {
                errors.add("Invalid gender.");
            }

            if (!PatientValidator.isValidPhone(phone)) {
                errors.add("Invalid phone number.");
            }

            if (!PatientValidator.isValidAddress(address)) {
                errors.add("Invalid address.");
            }

            if (!PatientValidator.isValidInsuranceNumber(insuranceNumber)) {
                errors.add("Invalid insurance number.");
            }

            if (!PatientValidator.isValidEmergencyContact(emergencyContact)) {
                errors.add("Invalid emergency contact.(Only numbers allowed)");
            }

            // Nếu có lỗi thì trả về form với dữ liệu nhập lại và danh sách lỗi
            if (!errors.isEmpty()) {
                Patient inputPatient = Patient.builder()
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

                request.setAttribute("patient", inputPatient);
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);
                return;
            }

            // Nếu không có lỗi thì cập nhật
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
            List<String> errors = new ArrayList<>();
            errors.add("An unexpected error occurred. Please try again.");
            request.setAttribute("errors", errors);
            request.setAttribute("patient", oldPatient);
            request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);
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
