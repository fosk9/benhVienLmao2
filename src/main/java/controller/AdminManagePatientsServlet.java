package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Patient;
import view.PatientDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/managePatients")
@MultipartConfig
public class AdminManagePatientsServlet extends HttpServlet {
    private final PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "add":
                showAddForm(req, resp);
                break;
            case "edit":
                showEditForm(req, resp);
                break;
            case "delete":
                deletePatient(req, resp);
                break;
            default:
                listPatients(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("add".equals(action)) {
            addPatient(req, resp);
        } else if ("edit".equals(action)) {
            editPatient(req, resp);
        } else {
            doGet(req, resp);
        }
    }

    private void listPatients(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int page = 1, pageSize = 10;
        try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignored) {}
        String search = req.getParameter("searchName");
        String email = req.getParameter("searchEmail");
        String username = req.getParameter("searchUsername");
        String gender = req.getParameter("searchGender");

        // Only search by name, email, username, gender
        List<Patient> patients = patientDAO.searchFilterSort(
            search, gender, null, null, page, pageSize
        );
        int total = patientDAO.countFiltered(search, gender);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        req.setAttribute("users", patients);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.getRequestDispatcher("/admin/manage-pateints/list.jsp").forward(req, resp);
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/admin/manage-pateints/add.jsp").forward(req, resp);
    }

    private void addPatient(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String gender = req.getParameter("gender");
        String address = req.getParameter("address");
        String insuranceNumber = req.getParameter("insuranceNumber");
        String emergencyContact = req.getParameter("emergencyContact");
        String avaUrl = handleAvatarUpload(req, null);

        Patient patient = Patient.builder()
                .fullName(fullName)
                .username(username)
                .passwordHash(password)
                .email(email)
                .phone(phone)
                .gender(gender)
                .address(address)
                .insuranceNumber(insuranceNumber)
                .emergencyContact(emergencyContact)
                .patientAvaUrl(avaUrl)
                .build();
        patientDAO.insert(patient);

        resp.sendRedirect(req.getContextPath() + "/admin/managePatients?action=list");
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Patient patient = patientDAO.select(id);
        req.setAttribute("user", patient);
        req.getRequestDispatcher("/admin/manage-pateints/edit.jsp").forward(req, resp);
    }

    private void editPatient(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String fullName = req.getParameter("fullName");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String gender = req.getParameter("gender");
        String address = req.getParameter("address");
        String insuranceNumber = req.getParameter("insuranceNumber");
        String emergencyContact = req.getParameter("emergencyContact");
        String existingAvaUrl = req.getParameter("existingAvaUrl");
        String avaUrl = handleAvatarUpload(req, existingAvaUrl);

        Patient old = patientDAO.select(id);
        Patient patient = Patient.builder()
                .patientId(id)
                .fullName(fullName)
                .username(username)
                .passwordHash(password == null || password.isEmpty() ? old.getPasswordHash() : password)
                .email(email)
                .phone(phone)
                .gender(gender)
                .address(address)
                .insuranceNumber(insuranceNumber)
                .emergencyContact(emergencyContact)
                .patientAvaUrl(avaUrl)
                .build();
        patientDAO.update(patient);

        resp.sendRedirect(req.getContextPath() + "/admin/managePatients?action=list");
    }

    private void deletePatient(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        patientDAO.delete(id);
        resp.sendRedirect(req.getContextPath() + "/admin/managePatients?action=list");
    }

    private String handleAvatarUpload(HttpServletRequest req, String existingAvaUrl) throws IOException, ServletException {
        Part filePart = req.getPart("patientAvaUrl");
        if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().isEmpty()) {
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String uploadPath = req.getServletContext().getRealPath("/") + "uploads/avatars";
            java.io.File uploadDir = new java.io.File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            String filePath = uploadPath + java.io.File.separator + fileName;
            filePart.write(filePath);
            return "uploads/avatars/" + fileName;
        }
        return existingAvaUrl != null ? existingAvaUrl : "";
    }
}
