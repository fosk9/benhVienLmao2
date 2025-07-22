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

import java.io.*;
import java.sql.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "EditStaffServlet", urlPatterns = {"/staff-edit"})
@MultipartConfig
public class EditStaffServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(EditStaffServlet.class.getName());

    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final DoctorDetailDAO doctorDetailsDAO = new DoctorDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Employee emp = employeeDAO.getEmployeeById(id);
            DoctorDetail doctor = (emp.getRoleId() == 1) ? doctorDetailsDAO.getByEmployeeId(id) : null;

            request.setAttribute("employee", emp);
            request.setAttribute("doctorDetails", doctor);
            request.getRequestDispatcher("/Manager/edit-staff-detail.jsp").forward(request, response);

        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "❌ Error while loading GET /staff-edit", ex);
            request.getSession().setAttribute("errorMessage", "Unable to load staff data.");
            response.sendRedirect("manager-dashboard");
        }
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
            int id = Integer.parseInt(request.getParameter("employeeId"));
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");
            Date dob = Date.valueOf(request.getParameter("dob"));
            int accStatus = Integer.parseInt(request.getParameter("accStatus"));
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            String currentAvatar = request.getParameter("currentAvatar"); // Ảnh hiện tại

            Part imagePart = request.getPart("avatarFile");
            String avatarUrl = saveImage(imagePart);

            // ✅ Nếu không upload ảnh mới thì giữ ảnh cũ
            if (avatarUrl == null || avatarUrl.isEmpty()) {
                avatarUrl = currentAvatar;
            }

            Employee emp = new Employee();
            emp.setEmployeeId(id);
            emp.setFullName(fullName);
            emp.setEmail(email);
            emp.setPhone(phone);
            emp.setGender(gender);
            emp.setDob(dob);
            emp.setAccStatus(accStatus);
            emp.setRoleId(roleId);
            emp.setEmployeeAvaUrl(avatarUrl); // luôn set, không if

            boolean updatedEmp = employeeDAO.updateEmployee(emp);
            if (updatedEmp) {
                HistoryLogger.log(
                        manager.getEmployeeId(),
                        manager.getFullName(),
                        id,
                        fullName,
                        "Employee",
                        "Update Profile " + fullName
                );
            } else {
                LOGGER.warning("⚠️ Failed to update Employee ID " + id);
            }

            if (roleId == 1) {
                String license = request.getParameter("licenseNumber");
                boolean isSpecialist = "true".equals(request.getParameter("isSpecialist"));

                DoctorDetail doc = new DoctorDetail();
                doc.setDoctorId(id);
                doc.setLicenseNumber(license);
                doc.setSpecialist(isSpecialist);

                boolean updatedDoc = doctorDetailsDAO.updateDoctorDetails(doc);
                if (updatedDoc) {
                    LOGGER.info("✅ Doctor details updated for ID " + id);
                    HistoryLogger.log(
                            manager.getEmployeeId(),
                            manager.getFullName(),
                            id,
                            fullName,
                            "DoctorDetail",
                            "Update Doctor Info"
                    );
                } else {
                    LOGGER.warning( "⚠️ Failed to update DoctorDetail for ID " + id);
                }
            }

            LOGGER.info("✅ Staff update completed for ID " + id);
            response.sendRedirect("staff-detail?id=" + id);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Error during POST /staff-edit", e);

            try {
                // Restore input data
                Employee emp = new Employee();
                emp.setEmployeeId(Integer.parseInt(request.getParameter("employeeId")));
                emp.setFullName(request.getParameter("fullName"));
                emp.setEmail(request.getParameter("email"));
                emp.setPhone(request.getParameter("phone"));
                emp.setGender(request.getParameter("gender"));

                try {
                    emp.setDob(Date.valueOf(request.getParameter("dob")));
                } catch (Exception ex) {
                    emp.setDob(null);
                }

                try {
                    emp.setAccStatus(Integer.parseInt(request.getParameter("accStatus")));
                } catch (Exception ex) {
                    emp.setAccStatus(1);
                }

                try {
                    emp.setRoleId(Integer.parseInt(request.getParameter("roleId")));
                } catch (Exception ex) {
                    emp.setRoleId(2);
                }

                DoctorDetail doctor = null;
                if ("1".equals(request.getParameter("roleId"))) {
                    doctor = new DoctorDetail();
                    doctor.setDoctorId(emp.getEmployeeId());
                    doctor.setLicenseNumber(request.getParameter("licenseNumber"));
                    doctor.setSpecialist("true".equals(request.getParameter("isSpecialist")));
                }

                request.setAttribute("employee", emp);
                request.setAttribute("doctorDetails", doctor);
                request.setAttribute("errorMessage", "An error occurred while processing the form. Please check the input and try again.");

                request.getRequestDispatcher("/Manager/edit-staff-detail.jsp").forward(request, response);

            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "❌ Failed to forward to form after error", ex);
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "A critical error occurred.");
            }
        }
    }

    private String saveImage(Part imagePart) throws IOException {
        if (imagePart == null || imagePart.getSize() == 0) return null;

        long maxSize = 5 * 1024 * 1024;
        if (imagePart.getSize() > maxSize) {
            throw new IOException("❌ Image exceeds maximum size of 5MB.");
        }

        String fileName = new File(imagePart.getSubmittedFileName()).getName();
        String lowerFileName = fileName.toLowerCase();

        if (!(lowerFileName.endsWith(".jpg") || lowerFileName.endsWith(".jpeg") ||
                lowerFileName.endsWith(".png") || lowerFileName.endsWith(".gif") ||
                lowerFileName.endsWith(".webp"))) {
            throw new IOException("❌ Invalid image file type (only JPG, JPEG, PNG, GIF, WEBP supported).");
        }

        String uploadPath = getServletContext().getRealPath("/assets/img/avatars");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String newFileName = System.currentTimeMillis() + "_" + fileName;
        File file = new File(uploadDir, newFileName);
        imagePart.write(file.getAbsolutePath());

        LOGGER.info("🖼️ Image saved successfully: " + newFileName);
        return "assets/img/avatars/" + newFileName;
    }
}
