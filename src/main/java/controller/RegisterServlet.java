package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Patient;
import util.PasswordUtils;
import view.PatientDAO;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.Random;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private PatientDAO patientDAO;

    @Override
    public void init() {
        patientDAO = new PatientDAO();
    }

    private void setRegisterAttributes(HttpServletRequest request,
                                       String fullName,
                                       Date dob,
                                       String gender,
                                       String email,
                                       String phone,
                                       String address,
                                       String insuranceNumber,
                                       String emergencyContact) {
        request.setAttribute("fullName", fullName);
        request.setAttribute("dob", dob);
        request.setAttribute("gender", gender);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
        request.setAttribute("insurance_number", insuranceNumber);
        request.setAttribute("emergency_contact", emergencyContact);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("full_name");
        String dobStr = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String insuranceNumber = request.getParameter("insurance_number");
        String emergencyContact = request.getParameter("emergency_contact");

        // Chuẩn hóa tên
        if (fullName != null) {
            fullName = fullName.trim().replaceAll("\\s+", " ");
            String[] parts = fullName.split(" ");
            for (int i = 0; i < parts.length; i++) {
                parts[i] = parts[i].substring(0, 1).toUpperCase() + parts[i].substring(1).toLowerCase();
            }
            fullName = String.join(" ", parts);
        }

        Date dob = null;
        if (dobStr != null && !dobStr.isEmpty()) {
            try {
                dob = Date.valueOf(dobStr);
                // Kiểm tra nếu ngày sinh lớn hơn ngày hiện tại
                Date today = Date.valueOf(LocalDate.now());
                if (dob.after(today)) {
                    request.setAttribute("error", "Date of birth cannot be in the future.");
                    setRegisterAttributes(request, fullName, null, gender, email, phone, address, insuranceNumber, emergencyContact);
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Invalid date of birth format.");
                setRegisterAttributes(request, fullName, null, gender, email, phone, address, insuranceNumber, emergencyContact);
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
        }


        // Validate input
        if (fullName == null || !fullName.matches("^[a-zA-ZÀ-ỹ\\s]+$")) {
            request.setAttribute("error", "Full name must contain only letters.");
            setRegisterAttributes(request, fullName, dob, gender, email, phone, address, insuranceNumber, emergencyContact);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            request.setAttribute("error", "Invalid email address.");
            setRegisterAttributes(request, fullName, dob, gender, email, phone, address, insuranceNumber, emergencyContact);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (phone == null || !phone.matches("^(0[0-9]{9,10})$")) {
            request.setAttribute("error", "Invalid phone number.");
            setRegisterAttributes(request, fullName, dob, gender, email, phone, address, insuranceNumber, emergencyContact);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (emergencyContact == null || emergencyContact.equals(phone)
                || !emergencyContact.matches("^(0[0-9]{9,10})$")) {
            request.setAttribute("error", "Invalid emergency contact number.");
            setRegisterAttributes(request, fullName, dob, gender, email, phone, address, insuranceNumber, emergencyContact);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Check trùng email hoặc số điện thoại
        if (patientDAO.getPatientByEmailOrPhone(email, phone) != null) {
            request.setAttribute("error", "Email or phone already registered.");
            setRegisterAttributes(request, fullName, dob, gender, email, phone, address, insuranceNumber, emergencyContact);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Tự sinh username và password
        String username = email.split("@")[0];
        while (patientDAO.isUsernameTaken(username)) {
            username += (int) (Math.random() * 1000);
        }
        String rawPassword = generateRandomPassword(10); // sinh random strong password
        String hashedPassword = PasswordUtils.hashPassword(rawPassword);

        Patient tempPatient = Patient.builder()
                .username(username)
                .passwordHash(hashedPassword)
                .fullName(fullName)
                .dob(dob)
                .gender(gender)
                .email(email)
                .phone(phone)
                .address(address)
                .insuranceNumber(insuranceNumber)
                .emergencyContact(emergencyContact)
                .patientAvaUrl(null) // Không upload ảnh đại diện trong đăng ký
                .accStatus(1)
                .build();

        String otp = generateOTP(6);
        HttpSession session = request.getSession();
        session.setAttribute("tempPatient", tempPatient);
        session.setAttribute("otp", otp);
        session.setAttribute("otpGeneratedTime", System.currentTimeMillis()); // thời điểm tạo OTP
        session.setAttribute("generatedPassword", rawPassword); // để gửi email sau

        // Gửi OTP qua email
        SendingEmail emailSender = new SendingEmail();
        try {
            emailSender.sendEmail(email, "HRMS - OTP Verification", "Your OTP is: " + otp);
        } catch (Exception e) {
            request.setAttribute("error", "Failed to send email. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Chuyển tới trang xác minh OTP
        response.sendRedirect("otp-verification.jsp?msg=otp_sent");
    }

    private String generateOTP(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        Random rand = new Random();
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < length; i++) {
            otp.append(chars.charAt(rand.nextInt(chars.length())));
        }
        return otp.toString();
    }


    private String generateRandomPassword(int length) {
        if (length < 8) length = 8;

        String upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String lower = "abcdefghijklmnopqrstuvwxyz";
        String digits = "0123456789";
        String special = "@#$%!&*?";
        String all = upper + lower + digits + special;

        Random rand = new Random();
        StringBuilder pw = new StringBuilder();

        // Bắt buộc có ít nhất 1 mỗi loại
        pw.append(upper.charAt(rand.nextInt(upper.length())));
        pw.append(lower.charAt(rand.nextInt(lower.length())));
        pw.append(digits.charAt(rand.nextInt(digits.length())));
        pw.append(special.charAt(rand.nextInt(special.length())));

        // Thêm ngẫu nhiên các ký tự còn lại
        for (int i = 4; i < length; i++) {
            pw.append(all.charAt(rand.nextInt(all.length())));
        }

        // Shuffle chuỗi để tránh predictable pattern
        char[] passwordChars = pw.toString().toCharArray();
        for (int i = passwordChars.length - 1; i > 0; i--) {
            int j = rand.nextInt(i + 1);
            char tmp = passwordChars[i];
            passwordChars[i] = passwordChars[j];
            passwordChars[j] = tmp;
        }

        return new String(passwordChars);
    }
}
