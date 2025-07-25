package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;
import util.PasswordUtils;
import dal.DoctorDetailDAO;
import dal.EmployeeDAO;

import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;

@WebServlet(name = "AddDoctorFormServlet", urlPatterns = {"/add-doctor-form"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AddDoctorFormServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AddDoctorFormServlet.class.getName());

    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final DoctorDetailDAO doctorDetailDAO = new DoctorDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("Manager/add-doctor-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        Employee manager = (Employee) request.getSession().getAttribute("account");
        if (manager == null || manager.getRoleId() != 4) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Lấy dữ liệu từ form
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String dateOfBirth = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");
            int role = Integer.parseInt(request.getParameter("roleId")); // 1 là doctor


            Part profileImagePart = request.getPart("profileImage");

            // Validation
            StringBuilder errors = new StringBuilder();
            if (email == null || !Pattern.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$", email))
                errors.append("Invalid email format.<br>");
            if (phone == null || !Pattern.matches("^(0[0-9]{9,10})$", phone))
                errors.append("Invalid phone number.<br>");

            Date dob = null;
            if (dateOfBirth != null && !dateOfBirth.isEmpty()) {
                dob = Date.valueOf(dateOfBirth);
                if (dob.toLocalDate().isAfter(LocalDate.now())) {
                    errors.append("Date of birth cannot be in the future.<br>");
                }
            }

            if (errors.length() > 0) {
                request.setAttribute("errorMessage", errors.toString());
                doGet(request, response);
                return;
            }

            // Sinh username và password
            String username = email.split("@")[0];
            while (employeeDAO.isUsernameTaken(username)) {
                username += (int) (Math.random() * 1000);
            }

            String rawPassword = generateRandomPassword(10); // lưu để gửi email
            String hashedPassword = PasswordUtils.hashPassword(rawPassword); // lưu DB


            // Upload ảnh
            String imagePath = null;
            if (profileImagePart != null && profileImagePart.getSize() > 0) {
                imagePath = saveImage(profileImagePart, request);
            }

            // Tạo đối tượng Employee tạm thời (chưa insert DB)
            Employee employee = Employee.builder()
                    .fullName(fullName)
                    .email(email)
                    .phone(phone)
                    .dob(dob)
                    .gender(gender)
                    .username(username)
                    .passwordHash(hashedPassword)
                    .roleId(role)
                    .accStatus(1)
                    .employeeAvaUrl(imagePath)
                    .build();

            // Sinh OTP
            String otp = generateOTP();

            // Lưu session tạm
            HttpSession session = request.getSession();
            session.setAttribute("tempEmployee", employee);
            session.setAttribute("generatedPassword", rawPassword); // để gửi mail sau
            session.setAttribute("otp", otp);
            session.setAttribute("account", manager);

            if (role == 1) {
                String licenseNumber = request.getParameter("licenseNumber");
                boolean isSpecialist = "true".equals(request.getParameter("specialist"));
                session.setAttribute("licenseNumber", licenseNumber);
                session.setAttribute("isSpecialist", isSpecialist);
                session.setAttribute("isDoctor", true);
            } else {
                session.setAttribute("isDoctor", false);
            }

            // Gửi email OTP
            SendingEmail sender = new SendingEmail();
            sender.sendEmail(email, "Mã OTP xác minh tài khoản", "Mã OTP của bạn là: " + otp + "\nVui lòng không chia sẻ với ai.");

            // Chuyển tới trang nhập OTP
            response.sendRedirect("otp-verification.jsp");

        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error during account preparation", ex);
            request.setAttribute("errorMessage", "An unexpected error occurred.");
            doGet(request, response);
        }
    }


    private String saveImage(Part imagePart, HttpServletRequest request) throws IOException {
        if (imagePart == null || imagePart.getSize() == 0) return null;

        String fileName = new File(imagePart.getSubmittedFileName()).getName();
        String uploadPath = request.getServletContext().getRealPath("/assets/img/blog");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String newFileName = System.currentTimeMillis() + "_" + fileName;
        File file = new File(uploadDir, newFileName);
        imagePart.write(file.getAbsolutePath());

        return "assets/img/blog/" + newFileName;
    }
    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int index = (int) (Math.random() * chars.length());
            sb.append(chars.charAt(index));
        }
        return sb.toString();
    }

    public String generateOTP() {
        int otp = 100000 + (int)(Math.random() * 900000); // từ 100000 đến 999999
        return String.valueOf(otp);
    }

}
