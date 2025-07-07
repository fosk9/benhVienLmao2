package controller;

import model.Patient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import validation.PatientValidator;
import view.PatientDAO;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet(name = "UpdateMyProfilePatientServlet", urlPatterns = {"/UpdateMyProfilePatient"})
public class UpdateMyProfilePatientServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get parameters from the request
        int patientId = Integer.parseInt(request.getParameter("patientId"));
        String fullName = request.getParameter("fullName");
        String dobStr = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String insuranceNumber = request.getParameter("insuranceNumber");
        String emergencyContact = request.getParameter("emergencyContact");

        HttpSession session = request.getSession();
        Patient oldPatient = (Patient) session.getAttribute("account");

        try {
            // ✅ Validate input data
            if (!PatientValidator.isValidFullName(fullName)) {
                request.setAttribute("message", "Invalid full name.");
                request.setAttribute("patient", oldPatient);
                request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);
                return;
            }

            Date dob = null;
            try {
                dob = Date.valueOf(dobStr);
                if (!PatientValidator.isValidDob(dob)) {
                    throw new IllegalArgumentException();
                }
            } catch (Exception ex) {
                request.setAttribute("message", "Invalid date of birth.");
                request.setAttribute("patient", oldPatient);
                request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);
                return;
            }

            if (!PatientValidator.isValidGender(gender)) {
                request.setAttribute("message", "Invalid gender.");
                request.setAttribute("patient", oldPatient);
                request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);
                return;
            }

            if (!PatientValidator.isValidPhone(phone)) {
                request.setAttribute("message", "Invalid phone number.");
                request.setAttribute("patient", oldPatient);
                request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);
                return;
            }

            if (!PatientValidator.isValidAddress(address)) {
                request.setAttribute("message", "Invalid address.");
                request.setAttribute("patient", oldPatient);
                request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);
                return;
            }

            if (!PatientValidator.isValidInsuranceNumber(insuranceNumber)) {
                request.setAttribute("message", "Invalid insurance number.");
                request.setAttribute("patient", oldPatient);
                request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);
                return;
            }

            if (!PatientValidator.isValidEmergencyContact(emergencyContact)) {
                request.setAttribute("message", "Invalid emergency contact.");
                request.setAttribute("patient", oldPatient);
                request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);
                return;
            }

            // ✅ Build updated Patient object
            Patient updatedPatient = Patient.builder()
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

            // ✅ Update DB
            PatientDAO dao = new PatientDAO();
            dao.update(updatedPatient);

            // ✅ Update session
            session.setAttribute("account", updatedPatient);

            // ✅ Forward to JSP with success message
            request.setAttribute("patient", updatedPatient);
            request.setAttribute("message", "Your profile has been updated successfully.");
            request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("patient", oldPatient);
            request.setAttribute("message", "An error occurred while updating your profile.");
            request.getRequestDispatcher("my-profile-patient.jsp").forward(request, response);
        }
    }
}
