package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Employee;
import model.Role;
import model.User;
import util.HistoryLogger;
import dal.UserDAO;
import dal.RoleDAO;

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
        int totalUsers = userDAO.countAllUsers(); // Tổng user toàn hệ thống
        int totalUsersByFilter;

        try {
            if (keyword != null && !keyword.isEmpty() && roleFilter != null && !roleFilter.isEmpty() && statusInt != null) {
                // Cả 3 điều kiện
                userList = userDAO.searchByKeywordRoleStatus(keyword, roleFilter, statusInt, offset, recordsPerPage);
                totalUsersByFilter = userDAO.countByKeywordRoleStatus(keyword, roleFilter, statusInt);

            } else if (keyword != null && !keyword.isEmpty() && roleFilter != null && !roleFilter.isEmpty()) {
                // keyword + role
                userList = userDAO.searchByKeywordAndRole(keyword, roleFilter, offset, recordsPerPage);
                totalUsersByFilter = userDAO.countByKeywordAndRole(keyword, roleFilter);

            } else if (keyword != null && !keyword.isEmpty() && statusInt != null) {
                // keyword + status
                userList = userDAO.searchByKeywordAndStatus(keyword, statusInt, offset, recordsPerPage);
                totalUsersByFilter = userDAO.countByKeywordAndStatus(keyword, statusInt);

            } else if (roleFilter != null && !roleFilter.isEmpty() && statusInt != null) {
                // role + status
                userList = userDAO.searchByRoleAndStatus(roleFilter, statusInt, offset, recordsPerPage);
                totalUsersByFilter = userDAO.countByRoleAndStatus(roleFilter, statusInt);

            } else if (keyword != null && !keyword.isEmpty()) {
                // chỉ keyword
                userList = userDAO.searchByKeyword(keyword, offset, recordsPerPage);
                totalUsersByFilter = userDAO.countByKeyword(keyword);

            } else if (roleFilter != null && !roleFilter.isEmpty()) {
                // chỉ role
                userList = userDAO.searchByRole(roleFilter, offset, recordsPerPage);
                totalUsersByFilter = userDAO.countByRole(roleFilter);

            } else if (statusInt != null) {
                // chỉ status
                userList = userDAO.searchByStatus(statusInt, offset, recordsPerPage);
                totalUsersByFilter = userDAO.countByStatus(statusInt);

            } else {
                // không có gì
                userList = userDAO.selectPagedUsers(offset, recordsPerPage);
                totalUsersByFilter = totalUsers;
            }
        } catch (Exception e) {
            e.printStackTrace();
            userList = userDAO.selectPagedUsers(0, recordsPerPage);
            totalUsersByFilter = totalUsers;
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi truy vấn dữ liệu.");
        }

        List<Role> roles = roleDAO.select();
        int totalPages = (int) Math.ceil(totalUsersByFilter * 1.0 / recordsPerPage);

        request.setAttribute("keyword", keyword);
        request.setAttribute("role", roleFilter);
        request.setAttribute("status", statusFilter);

        request.setAttribute("userList", userList);
        request.setAttribute("allRoles", roles);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalUsersByFilter", totalUsersByFilter);
        request.setAttribute("totalDoctors", userDAO.countEmployeeByRole("Doctor"));
        request.setAttribute("totalReceptionists", userDAO.countEmployeeByRole("Receptionist"));
        request.setAttribute("totalPatients", userDAO.countPatients());

        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);

        request.getRequestDispatcher("Manager/update-user-role.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Logger
        System.out.println("[UpdateUserRoleController][POST] action=" + action);
        // ✅ Check quyền: chỉ cho phép Employee (Manager) thực hiện
        Employee manager = (Employee) request.getSession().getAttribute("account");
        if (manager == null || manager.getRoleId() != 4) {
            request.setAttribute("error", "You must be logged in as a manager to perform this action.");
            response.sendRedirect("login.jsp");
            return;
        }

        if (action != null && action.startsWith("delete_")) {
            int id = Integer.parseInt(action.substring("delete_".length()));
            String source = request.getParameter("source_" + id); // Lấy từ JSP
            System.out.println("[UpdateUserRoleController][POST] delete ID=" + id + ", source=" + source);

            try {
                User user = userDAO.getUserByIdAndSource(id, source);
                if (user == null) {
                    request.getSession().setAttribute("errorMessage", "Tài khoản không tồn tại.");
                    response.sendRedirect("update-user-role");
                    return;
                }

                boolean deleted = false;
                if ("employee".equalsIgnoreCase(source)) {
                    deleted = userDAO.deleteEmployee(id);
                } else if ("patient".equalsIgnoreCase(source)) {
                    deleted = userDAO.deletePatient(id);
                }

                if (deleted) {
                    // ✅ Ghi log nếu xóa thành công
                    HistoryLogger.log(
                            manager.getEmployeeId(),
                            manager.getFullName(),
                            id,
                            user.getFullName(),
                            source,
                            "Delete Account"
                    );
                    request.getSession().setAttribute("successMessage", "Đã xóa tài khoản: " + user.getFullName());
                } else {
                    request.getSession().setAttribute("errorMessage", "Không thể xóa tài khoản này do đang được sử dụng.");
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("errorMessage", "Đã xảy ra lỗi khi xóa tài khoản.");
            }

            response.sendRedirect("update-user-role");
            return;
        }
        // ✅ Xử lý cập nhật role và status
        if (action != null && action.startsWith("update_")) {
            try {
                int id = Integer.parseInt(action.substring("update_".length()));

                String roleParam = "newRole_" + id;
                String statusParam = "newStatus_" + id;
                String sourceParam = request.getParameter("source_" + id);

                String roleName = request.getParameter(roleParam);
                String statusStr = request.getParameter(statusParam);
                User user = userDAO.getUserByIdAndSource(id, sourceParam);
                System.out.println("[UpdateUserRoleController][POST] update ID=" + id + ", source=" + sourceParam + ", role=" + roleName + ", status=" + statusStr);

                if ("employee".equalsIgnoreCase(sourceParam) && roleName != null) {
                    String currentRole = user.getRoleName(); // Role hiện tại
                    System.out.println("[Debug] currentRole = '" + currentRole + "', roleName = '" + roleName + "'");
                    if (!roleName.equalsIgnoreCase(currentRole)) {
                        int roleId = roleDAO.getRoleIdByName(roleName);
                        userDAO.updateEmployeeRole(id, roleId);
                        // Ghi log nếu role thay đổi
                            HistoryLogger.log(
                                    manager.getEmployeeId(),
                                    manager.getFullName(),
                                    id,
                                    user.getFullName(),
                                    sourceParam,
                                    "Update Role" + " to " + roleName
                            );
                    }
                }


                if (statusStr != null) {
                    int accStatus = Integer.parseInt(statusStr);
                    int currentStatus = user.getAccStatus(); // Trạng thái hiện tại

                    if (currentStatus != accStatus) {
                        userDAO.updateAccStatus(id, accStatus, sourceParam);
                        // Ghi log nếu trạng thái thay đổi
                        HistoryLogger.log(
                                manager.getEmployeeId(),
                                manager.getFullName(),
                                id,
                                user.getFullName(),
                                sourceParam,
                                accStatus == 1 ? "Activate Account" : "Deactivate Account"
                        );
                    }
                }

                request.getSession().setAttribute("successMessage", "Update Successed for " + user.getFullName());
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("errorMessage", "Error updating user role or status.");
            }

            response.sendRedirect("update-user-role");
            return;
        }

        request.getSession().setAttribute("errorMessage", "Yêu cầu không hợp lệ.");
        response.sendRedirect("update-user-role");
    }
}