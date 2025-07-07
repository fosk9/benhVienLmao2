package controller;

import validation.DoctorDetailsValidator;
import validation.EmployeeValidator;
import view.DoctorDetailDAO;
import view.EmployeeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.DoctorDetail;
import model.Employee;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

@WebServlet(urlPatterns = {"/doctor-details", "/update-doctor-details", "/delete-doctor"})
public class DoctorDetailsServlet extends HttpServlet {

    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final DoctorDetailDAO doctorDetailDao = new DoctorDetailDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        int id = Integer.parseInt(req.getParameter("id"));

        switch (path) {
            case "/doctor-details":
                Employee doctor = employeeDAO.select(id);
                DoctorDetail doctorDetail = doctorDetailDao.select(id);

                req.setAttribute("doctor", doctor);
                req.setAttribute("doctorDetail", doctorDetail);
                req.getRequestDispatcher("doctor-details.jsp").forward(req, resp);
                break;
//
//            case "/delete-doctor":
//                doctorDetailDao.delete(id); // Xóa cả DoctorDetails
//                employeeDAO.delete(id); // Xóa từ Employees
//                resp.sendRedirect(req.getContextPath() + "/DoctorList?message=Doctor deleted successfully");
//                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        int id = Integer.parseInt(req.getParameter("employeeId"));
        Map<String, String> fieldErrors = new HashMap<>();

        // Lấy input
        String username = req.getParameter("username");
        String passwordHash = req.getParameter("passwordHash");
        String fullName = req.getParameter("fullName");
        String dobRaw = req.getParameter("dob");
        String gender = req.getParameter("gender");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String employeeAvaUrl = req.getParameter("employeeAvaUrl");
        String licenseNumber = req.getParameter("licenseNumber");
        String ratingRaw = req.getParameter("rating");
        boolean isSpecialist = "on".equals(req.getParameter("isSpecialist"));

        // Parse ngày và rating
        java.sql.Date dob = null;
        BigDecimal rating = null;

        try {
            rating = new BigDecimal(ratingRaw);
        } catch (Exception e) {
            fieldErrors.put("rating", "Invalid rating format");
        }

        try {
            dob = java.sql.Date.valueOf(dobRaw);
        } catch (Exception e) {
            fieldErrors.put("dob", "Invalid date of birth");
        }

        // Validate từng field
        if (!EmployeeValidator.isValidFullName(fullName)) {
            fieldErrors.put("fullName", "Invalid full name");
        }
        if (dob != null && !EmployeeValidator.isValidDob(dob)) {
            fieldErrors.put("dob", "Date of birth must be in the past and after 1900");
        }
        if (!EmployeeValidator.isValidPhone(phone)) {
            fieldErrors.put("phone", "Invalid phone number");
        }
        if (!DoctorDetailsValidator.isValidLicenseNumber(licenseNumber)) {
            fieldErrors.put("licenseNumber", "License number must not be empty and max 100 characters");
        }

        // Nếu có lỗi, forward về lại form cùng dữ liệu
        if (!fieldErrors.isEmpty()) {
            Employee doctor = Employee.builder()
                    .employeeId(id)
                    .username(username)
                    .passwordHash(passwordHash)
                    .fullName(fullName)
                    .dob(dob)
                    .gender(gender)
                    .email(email)
                    .phone(phone)
                    .roleId(Integer.parseInt(req.getParameter("roleId")))
                    .employeeAvaUrl(employeeAvaUrl)
                    .build();

            DoctorDetail detail = DoctorDetail.builder()
                    .doctorId(id)
                    .licenseNumber(licenseNumber)
                    .specialist(isSpecialist)
                    .rating(rating)
                    .build();

            req.setAttribute("doctor", doctor);
            req.setAttribute("doctorDetail", detail);
            req.setAttribute("fieldErrors", fieldErrors);
            req.setAttribute("message", "Please fix the errors below");
            req.getRequestDispatcher("doctor-details.jsp").forward(req, resp);
            return;
        }

        // Nếu hợp lệ, cập nhật DB
        Employee doctor = Employee.builder()
                .employeeId(id)
                .username(username)
                .passwordHash(passwordHash)
                .fullName(fullName)
                .dob(dob)
                .gender(gender)
                .email(email)
                .phone(phone)
                .roleId(Integer.parseInt(req.getParameter("roleId")))
                .employeeAvaUrl(employeeAvaUrl)
                .build();

        DoctorDetail detail = DoctorDetail.builder()
                .doctorId(id)
                .licenseNumber(licenseNumber)
                .specialist(isSpecialist)
                .rating(rating)
                .build();

        employeeDAO.update(doctor);
        doctorDetailDao.update(detail);

        req.setAttribute("doctor", doctor);
        req.setAttribute("doctorDetail", detail);
        req.setAttribute("message", "Doctor updated successfully");
        req.getRequestDispatcher("doctor-details.jsp").forward(req, resp);
    }


}
