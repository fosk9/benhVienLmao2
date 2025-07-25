package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;
import model.EmployeeHistory;
import model.Role;
import dal.EmployeeDAO;
import dal.EmployeeHistoryDAO;
import dal.RoleDAO;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/manageEmployees")
@MultipartConfig
public class AdminManageEmployeesServlet extends HttpServlet {
    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final RoleDAO roleDAO = new RoleDAO();
    private final EmployeeHistoryDAO historyDAO = new EmployeeHistoryDAO();

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
            case "history":
                showHistory(req, resp);
                break;
            case "delete":
                deleteEmployee(req, resp);
                break;
            default:
                listEmployees(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("add".equals(action)) {
            addEmployee(req, resp);
        } else if ("edit".equals(action)) {
            editEmployee(req, resp);
        } else {
            doGet(req, resp);
        }
    }

    private void listEmployees(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int page = 1, pageSize = 10;
        try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignored) {}
        String searchName = req.getParameter("searchName");
        String searchEmail = req.getParameter("searchEmail");
        String searchUsername = req.getParameter("searchUsername");
        String searchRoleId = req.getParameter("searchRoleId");

        List<Employee> employees = employeeDAO.searchFilterSort(searchName, searchEmail, searchUsername, searchRoleId, page, pageSize);
        int total = employeeDAO.countFiltered(searchName, searchEmail, searchUsername, searchRoleId);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        List<Role> roles = roleDAO.select();
        req.setAttribute("users", employees);
        req.setAttribute("roles", roles);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.getRequestDispatcher("/admin/manage-employees/list.jsp").forward(req, resp);
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Role> roles = roleDAO.select();
        req.setAttribute("roles", roles);
        req.getRequestDispatcher("/admin/manage-employees/add.jsp").forward(req, resp);
    }

    private void addEmployee(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        int roleId = Integer.parseInt(req.getParameter("roleId"));
        String avaUrl = handleAvatarUpload(req, null);

        Employee emp = Employee.builder()
                .fullName(fullName)
                .username(username)
                .passwordHash(password)
                .email(email)
                .phone(phone)
                .roleId(roleId)
                .employeeAvaUrl(avaUrl)
                .build();
        employeeDAO.insert(emp);

        // Insert history
        Employee inserted = employeeDAO.getEmployeeByUsername(username);
        if (inserted != null) {
            historyDAO.insertHistory(inserted.getEmployeeId(), roleId, new Date(System.currentTimeMillis()));
        }

        resp.sendRedirect(req.getContextPath() + "/admin/manageEmployees?action=list");
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Employee employee = employeeDAO.select(id);
        List<Role> roles = roleDAO.select();
        req.setAttribute("user", employee);
        req.setAttribute("roles", roles);
        req.getRequestDispatcher("/admin/manage-employees/edit.jsp").forward(req, resp);
    }

    private void editEmployee(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String fullName = req.getParameter("fullName");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        int roleId = Integer.parseInt(req.getParameter("roleId"));
        String existingAvaUrl = req.getParameter("existingAvaUrl");
        String avaUrl = handleAvatarUpload(req, existingAvaUrl);

        Employee old = employeeDAO.select(id);
        Employee emp = Employee.builder()
                .employeeId(id)
                .fullName(fullName)
                .username(username)
                .passwordHash(password == null || password.isEmpty() ? old.getPasswordHash() : password)
                .email(email)
                .phone(phone)
                .roleId(roleId)
                .employeeAvaUrl(avaUrl)
                .build();
        employeeDAO.update(emp);

        // Insert history if role changed
        if (old.getRoleId() != roleId) {
            historyDAO.insertHistory(id, roleId, new Date(System.currentTimeMillis()));
        }

        resp.sendRedirect(req.getContextPath() + "/admin/manageEmployees?action=list");
    }

    private void deleteEmployee(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        employeeDAO.delete(id);
        historyDAO.deleteHistoryByEmployeeId(id);
        resp.sendRedirect(req.getContextPath() + "/admin/manageEmployees?action=list");
    }

    private void showHistory(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        List<EmployeeHistory> history = historyDAO.getHistoryByEmployeeId(id);
        Employee employee = employeeDAO.select(id);
        List<Role> roles = roleDAO.select();
        req.setAttribute("history", history);
        req.setAttribute("user", employee);
        req.setAttribute("roles", roles);
        req.getRequestDispatcher("/admin/manage-employees/history.jsp").forward(req, resp);
    }

    private String handleAvatarUpload(HttpServletRequest req, String existingAvaUrl) throws IOException, ServletException {
        Part filePart = req.getPart("employeeAvaUrl");
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
