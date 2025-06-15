package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Patient;
import validation.PatientValidator;
import view.PatientDAO;

import java.io.IOException;
import java.sql.Date;

@WebServlet(name = "UpdatePatientDetailsServlet", value = "/UpdatePatientDetails")
public class UpdatePatientDetailsServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        PatientDAO dao = new PatientDAO();
        try {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            String username = request.getParameter("username");
            String passwordHash = request.getParameter("password_hash");
            String fullName = request.getParameter("fullName");
            String dobStr = request.getParameter("dob");
            String gender = request.getParameter("gender");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String insuranceNumber = request.getParameter("insuranceNumber");
            String emergencyContact = request.getParameter("emergencyContact");
            String avatarUrl = request.getParameter("patient_ava_url");
            if (avatarUrl == null) avatarUrl = "";

            Patient oldPatient = dao.select(patientId);
            request.setAttribute("patient", oldPatient);

            Date dob = null;
            try {
                if (dobStr != null && !dobStr.trim().isEmpty()) {
                    dob = Date.valueOf(dobStr);
                    if (!PatientValidator.isValidDob(dob)) throw new IllegalArgumentException();
                }
            } catch (Exception e) {
                request.setAttribute("message", "Invalid date of birth.");
                request.getRequestDispatcher("patient-details.jsp").forward(request, response);
                return;
            }

            // ✅ Validate input fields
            if (!PatientValidator.isValidFullName(fullName)) {
                request.setAttribute("message", "Invalid full name.");
            } else if (!PatientValidator.isValidGender(gender)) {
                request.setAttribute("message", "Invalid gender.");
            } else if (!PatientValidator.isValidPhone(phone)) {
                request.setAttribute("message", "Invalid phone number.");
            } else if (!PatientValidator.isValidAddress(address)) {
                request.setAttribute("message", "Invalid address.");
            } else if (!PatientValidator.isValidInsuranceNumber(insuranceNumber)) {
                request.setAttribute("message", "Invalid insurance number.");
            } else if (!PatientValidator.isValidEmergencyContact(emergencyContact)) {
                request.setAttribute("message", "Invalid emergency contact.");
            } else {
                // ✅ Create a new Patient object with the provided details
                Patient patient = Patient.builder()
                        .patientId(patientId)
                        .username(username)
                        .passwordHash(passwordHash)
                        .fullName(fullName)
                        .dob(dob)
                        .gender(gender)
                        .email(email)
                        .phone(phone)
                        .address(address)
                        .insuranceNumber(insuranceNumber)
                        .emergencyContact(emergencyContact)
                        .patientAvaUrl(avatarUrl)
                        .build();

                int result = dao.update(patient);

                if (result > 0) {
                    request.setAttribute("message", "Update patient successfully!");
                    request.setAttribute("patient", patient);
                } else {
                    request.setAttribute("message", "Failed to update patient.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
        }

        request.getRequestDispatcher("patient-details.jsp").forward(request, response);
    }
}
