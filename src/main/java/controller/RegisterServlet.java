package controller;

import jakarta.servlet.ServletException;
import model.Patient;
import view.PatientDAO;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private PatientDAO patientDAO;

    @Override
    public void init() {
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("full_name");
        String dobStr = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String insuranceNumber = request.getParameter("insurance_number");
        String emergencyContact = request.getParameter("emergency_contact");

        Date dob = null;
        if (dobStr != null && !dobStr.isEmpty()) {
            try {
                dob = Date.valueOf(dobStr);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Ngày sinh không hợp lệ! Vui lòng nhập lại.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
        }

        Patient patient = Patient.builder()
                .username(username)
                .passwordHash(password)  // Tạm thời chưa hash
                .fullName(fullName)
                .dob(dob)
                .gender(gender)
                .email(email)
                .phone(phone)
                .address(address)
                .insuranceNumber(insuranceNumber)
                .emergencyContact(emergencyContact)
                .build();
        int result = patientDAO.insert(patient);

        if (result > 0) {
            request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Username might already exist or there was a DB error.");
        }

        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}
