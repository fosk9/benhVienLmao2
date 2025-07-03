package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Role;
import model.User;
import view.UserDAO;
import view.RoleDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/update-user-role")
public class UpdateUserRoleController extends HttpServlet {
    private UserDAO userDAO;
    private RoleDAO roleDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        roleDAO = new RoleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Params từ form
        String keyword = request.getParameter("keyword");
        String roleFilter = request.getParameter("role");
        String statusFilter = request.getParameter("status");

        int currentPage = 1;
        int recordsPerPage = 5;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException ignored) {
                currentPage = 1;
            }
        }
        int offset = (currentPage - 1) * recordsPerPage;

        // Chuẩn hóa keyword
        if (keyword != null) keyword = keyword.trim().replaceAll("\\s+", " ").toLowerCase();

        // Validate roleFilter
        if (roleFilter != null) roleFilter = roleFilter.trim().toLowerCase();
        if (roleFilter != null && roleFilter.isEmpty()) roleFilter = null;

        // Validate statusFilter
        Integer statusInt = null;
        if (statusFilter != null) {
            statusFilter = statusFilter.trim();
            if (!statusFilter.isEmpty()) {
                try {
                    statusInt = Integer.parseInt(statusFilter);
                } catch (NumberFormatException e) {
                    statusInt = null;
                }
            }
        }

        // Logger
        System.out.println("[UpdateUserRoleController][GET] keyword=" + keyword + ", role=" + roleFilter + ", status=" + statusInt + ", page=" + currentPage);

        List<User> userList;
        int totalUsers;

        try {
            if (keyword != null && !keyword.isEmpty() && roleFilter != null && !roleFilter.isEmpty() && statusInt != null) {
                // Cả 3 điều kiện
                userList = userDAO.searchByKeywordRoleStatus(keyword, roleFilter, statusInt, offset, recordsPerPage);
                totalUsers = userDAO.countByKeywordRoleStatus(keyword, roleFilter, statusInt);

            } else if (keyword != null && !keyword.isEmpty() && roleFilter != null && !roleFilter.isEmpty()) {
                // keyword + role
                userList = userDAO.searchByKeywordAndRole(keyword, roleFilter, offset, recordsPerPage);
                totalUsers = userDAO.countByKeywordAndRole(keyword, roleFilter);

            } else if (keyword != null && !keyword.isEmpty() && statusInt != null) {
                // keyword + status
                userList = userDAO.searchByKeywordAndStatus(keyword, statusInt, offset, recordsPerPage);
                totalUsers = userDAO.countByKeywordAndStatus(keyword, statusInt);

            } else if (roleFilter != null && !roleFilter.isEmpty() && statusInt != null) {
                // role + status
                userList = userDAO.searchByRoleAndStatus(roleFilter, statusInt, offset, recordsPerPage);
                totalUsers = userDAO.countByRoleAndStatus(roleFilter, statusInt);

            } else if (keyword != null && !keyword.isEmpty()) {
                // chỉ keyword
                userList = userDAO.searchByKeyword(keyword, offset, recordsPerPage);
                totalUsers = userDAO.countByKeyword(keyword);

            } else if (roleFilter != null && !roleFilter.isEmpty()) {
                // chỉ role
                userList = userDAO.searchByRole(roleFilter, offset, recordsPerPage);
                totalUsers = userDAO.countByRole(roleFilter);

            } else if (statusInt != null) {
                // chỉ status
                userList = userDAO.searchByStatus(statusInt, offset, recordsPerPage);
                totalUsers = userDAO.countByStatus(statusInt);

            } else {
                // không có gì
                userList = userDAO.selectPagedUsers(offset, recordsPerPage);
                totalUsers = userDAO.countAllUsers();
            }
        } catch (Exception e) {
            e.printStackTrace();
            userList = userDAO.selectPagedUsers(0, recordsPerPage);
            totalUsers = userDAO.countAllUsers();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi truy vấn dữ liệu.");
        }


        List<Role> roles = roleDAO.select();
        int totalPages = (int) Math.ceil(totalUsers * 1.0 / recordsPerPage);

        request.setAttribute("keyword", keyword);
        request.setAttribute("role", roleFilter);
        request.setAttribute("status", statusFilter);

        request.setAttribute("userList", userList);
        request.setAttribute("allRoles", roles);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalDoctors", userDAO.countEmployeeByRole("Doctor"));
        request.setAttribute("totalReceptionists", userDAO.countEmployeeByRole("Receptionist"));
        request.setAttribute("totalPatients", userDAO.countPatients());

        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);

        request.getRequestDispatcher("Admin/update-user-role.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Logger
        System.out.println("[UpdateUserRoleController][POST] action=" + action);

        // Trường hợp xóa tài khoản
        if (action != null && action.startsWith("delete_")) {
            try {
                int id = Integer.parseInt(action.substring("delete_".length()));
                User user = userDAO.getUserById(id);

                if (user != null) {
                    if ("employee".equalsIgnoreCase(user.getSource())) {
                        userDAO.deleteEmployee(id);
                    } else if ("patient".equalsIgnoreCase(user.getSource())) {
                        userDAO.deletePatient(id);
                    }
                    request.getSession().setAttribute("successMessage", "Đã xóa tài khoản " + user.getFullName());
                } else {
                    request.getSession().setAttribute("errorMessage", "Không tìm thấy người dùng để xóa.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("errorMessage", "Lỗi khi xóa tài khoản.");
            }

            response.sendRedirect("update-user-role");
            return;
        }

        // Trường hợp cập nhật role hoặc status
        if (action != null && action.startsWith("update_")) {
            try {
                int id = Integer.parseInt(action.substring("update_".length()));
                User user = userDAO.getUserById(id);

                String roleParam = "newRole_" + id;
                String statusParam = "newStatus_" + id;
                String roleName = request.getParameter(roleParam);
                String statusStr = request.getParameter(statusParam);

                System.out.println("[UpdateUserRoleController][POST] update id=" + id + ", role=" + roleName + ", status=" + statusStr);

                if (user != null) {
                    if ("employee".equalsIgnoreCase(user.getSource()) && roleName != null) {
                        int roleId = roleDAO.getRoleIdByName(roleName);
                        userDAO.updateEmployeeRole(id, roleId);
                    }

                    if (statusStr != null) {
                        int accStatus = Integer.parseInt(statusStr);
                        userDAO.updateAccStatus(id, accStatus, user.getSource());
                    }

                    request.getSession().setAttribute("successMessage", "Cập nhật thành công cho " + user.getFullName());
                } else {
                    request.getSession().setAttribute("errorMessage", "Không tìm thấy người dùng để cập nhật.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("errorMessage", "Lỗi khi cập nhật tài khoản.");
            }

            response.sendRedirect("update-user-role");
            return;
        }

        // Nếu không có action hợp lệ
        request.getSession().setAttribute("errorMessage", "Yêu cầu không hợp lệ.");
        response.sendRedirect("update-user-role");
    }

}