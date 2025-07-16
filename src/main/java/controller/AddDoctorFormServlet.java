package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.DoctorDetail;
import model.Employee;
import util.HistoryLogger;
import view.DoctorDetailDAO;
import view.EmployeeDAO;

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
    private final DoctorDetailDAO doctorDetailsDAO = new DoctorDetailDAO();

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
        if (manager == null) {
            request.setAttribute("error", "You must be logged in as a manager to perform this action.");
            response.sendRedirect("login.jsp");
            return;
        }
        try {
            // Get parameters
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String dateOfBirth = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String licenseNumber = request.getParameter("licenseNumber");
            boolean isSpecialist = "true".equals(request.getParameter("specialist"));

            Part profileImagePart = request.getPart("profileImage");
            // Kiểm tra username trùng
            if (employeeDAO.isUsernameTaken(username)) {
                request.setAttribute("errorMessage", "Username đã tồn tại. Vui lòng chọn tên khác.");
                doGet(request, response); // Trả về lại form
                return;
            }

            // ==== Validation ====
            StringBuilder errors = new StringBuilder();

            // Xử lý: xóa khoảng trắng thừa, chuẩn hóa viết hoa chữ cái đầu
            if (fullName != null) {
                fullName = fullName.trim().replaceAll("\\s+", " "); // loại bỏ khoảng trắng thừa

                // Viết hoa chữ cái đầu mỗi từ (nếu muốn)
                String[] parts = fullName.split(" ");
                for (int i = 0; i < parts.length; i++) {
                    parts[i] = parts[i].substring(0, 1).toUpperCase() + parts[i].substring(1).toLowerCase();
                }
                fullName = String.join(" ", parts);
            }

            if (email == null || !Pattern.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$", email))
                errors.append("Invalid email format.<br>");

            if (phone == null || !Pattern.matches("^(0[0-9]{9,10})$", phone))
                errors.append("Phone number must be 9-15 digits.<br>");

            if (username == null || username.length() < 4)
                errors.append("Username must be at least 4 characters.<br>");

            if (password == null || !password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^\\w\\s]).{8,}$")) {
                errors.append("Password must be at least 8 characters, including uppercase, lowercase, numbers and special characters.");}

            Date dob = null;
            if (dateOfBirth != null && !dateOfBirth.isEmpty()) {
                dob = Date.valueOf(dateOfBirth);
                if (dob.toLocalDate().isAfter(LocalDate.now())) {
                    errors.append("Date of birth cannot be in the future.<br>");
                }
            }

            if (profileImagePart != null && profileImagePart.getSize() > 0) {
                long maxSize = 5 * 1024 * 1024;
                if (profileImagePart.getSize() > maxSize) {
                    errors.append("Image exceeds 5MB size limit.<br>");
                }

                String fileName = new File(profileImagePart.getSubmittedFileName()).getName().toLowerCase();
                if (!fileName.matches(".*\\.(jpg|jpeg|png|gif|webp)$")) {
                    errors.append("Image must be JPG, JPEG, PNG, GIF or WEBP format.<br>");
                }
            }


            // Nếu có lỗi → trả về form
            if (errors.length() > 0) {
                request.setAttribute("errorMessage", errors.toString());
                doGet(request, response);
                return;
            }

            LOGGER.info("[AddDoctorForm] Creating new doctor: " + fullName);

            String imagePath = null;
            if (profileImagePart != null && profileImagePart.getSize() > 0) {
                imagePath = saveImage(profileImagePart, request);
                LOGGER.info("Uploaded avatar: " + imagePath);
            }


            // role_id = 2 là doctor mặc định
            Employee employee = Employee.builder()
                    .fullName(fullName)
                    .email(email)
                    .phone(phone)
                    .dob(dob)
                    .gender(gender)
                    .username(username)
                    .passwordHash(password)
                    .roleId(2)
                    .accStatus(1)
                    .employeeAvaUrl(imagePath)
                    .build();

            int employeeId = employeeDAO.insertReturnId(employee);
            LOGGER.info("Created employee with ID: " + employeeId);

            DoctorDetail doctorDetail = DoctorDetail.builder()
                    .doctorId(employeeId)
                    .licenseNumber(licenseNumber)
                    .specialist(isSpecialist)
                    .build();

            doctorDetailsDAO.insert(doctorDetail);
            LOGGER.info("Created DoctorDetail for ID: " + employeeId);

            // ✅ Ghi log tạo mới
            if (manager != null) {
                HistoryLogger.log(
                        manager.getEmployeeId(),
                        manager.getFullName(),
                        employeeId,
                        fullName,
                        "Employees",
                        "Create Account" + username
                );
                LOGGER.info("ChangeHistory log added for created account ID=" + employeeId);
            }

            request.getSession().setAttribute("successMessage", "Account created successfully!");
            response.sendRedirect("add-doctor-form");

        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error creating doctor account", ex);
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
}
