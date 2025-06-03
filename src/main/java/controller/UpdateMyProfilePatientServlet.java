package controller;

import model.Patient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import view.PatientDAO;

import java.io.IOException;
import java.sql.Date;

@WebServlet(name = "UpdateMyProfilePatientServlet", urlPatterns = {"/UpdateMyProfilePatient"})
public class UpdateMyProfilePatientServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy dữ liệu từ form
        int patientId = Integer.parseInt(request.getParameter("patientId"));
        String fullName = request.getParameter("fullName");
        String dobStr = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String insuranceNumber = request.getParameter("insuranceNumber");
        String emergencyContact = request.getParameter("emergencyContact");

        // Lấy đối tượng cũ từ session
        HttpSession session = request.getSession();
        Patient oldPatient = (Patient) session.getAttribute("account");

        try {
            // Tạo đối tượng mới bằng builder
            Patient updatedPatient = Patient.builder()
                    .patientId(patientId)
                    .username(oldPatient.getUsername())
                    .passwordHash(oldPatient.getPasswordHash())
                    .email(oldPatient.getEmail())
                    .patientAvaUrl(oldPatient.getPatientAvaUrl())
                    .fullName(fullName)
                    .dob(Date.valueOf(dobStr))
                    .gender(gender)
                    .phone(phone)
                    .address(address)
                    .insuranceNumber(insuranceNumber)
                    .emergencyContact(emergencyContact)
                    .build();

            // Cập nhật vào DB
            PatientDAO dao = new PatientDAO();
            dao.update(updatedPatient);

            // Cập nhật lại session
            session.setAttribute("account", updatedPatient);

            // Forward lại với thông báo
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
