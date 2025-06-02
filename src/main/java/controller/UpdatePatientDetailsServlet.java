package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Patient;
import view.PatientDAO;

import java.io.IOException;
import java.sql.Date;

@WebServlet(name = "UpdatePatientDetailsServlet", value = "/UpdatePatientDetails")
public class UpdatePatientDetailsServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            String username = request.getParameter("username");
            String passwordHash = request.getParameter("password_hash");
            String fullName = request.getParameter("fullName");
            String dobStr = request.getParameter("dob");
            Date dob = null;
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                dob = Date.valueOf(dobStr);
            }
            String gender = request.getParameter("gender");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String insuranceNumber = request.getParameter("insuranceNumber");
            String emergencyContact = request.getParameter("emergencyContact");
            String avatarUrl = request.getParameter("patient_ava_url");
            if (avatarUrl == null) avatarUrl = "";

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

            PatientDAO dao = new PatientDAO();
            int result = dao.update(patient);

            if (result > 0) {
                request.setAttribute("message", "Update patient successfully!");
            } else {
                request.setAttribute("message", "Failed to update patient.");
            }

            // Load danh sách để hiển thị lại
            request.setAttribute("patients", dao.select());
            request.getRequestDispatcher("patient-list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            request.setAttribute("patients", new PatientDAO().select());
            request.getRequestDispatcher("patient-list.jsp").forward(request, response);
        }
    }
}

