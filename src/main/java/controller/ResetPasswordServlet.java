package controller;

import jakarta.servlet.ServletException;
import view.EmployeeDAO;
import view.PatientDAO;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {
    private PatientDAO patientDAO;
    private EmployeeDAO employeeDAO;

    @Override
    public void init() {
        patientDAO = new PatientDAO();
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String newPassword = request.getParameter("new_password");
        HttpSession session = request.getSession();

        String username = (String) session.getAttribute("username");
        String userType = (String) session.getAttribute("user_type"); // Giá trị từ dropdown: "patient" hoặc "employee"

        if (username == null || userType == null) {
            request.setAttribute("error", "Session hết hạn hoặc dữ liệu không đầy đủ. Vui lòng thử lại.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        int updated = 0;

        switch (userType.toLowerCase()) {
            case "patient":
                updated = patientDAO.updatePasswordByUsername(username, newPassword);
                break;
            case "employee":
                updated = employeeDAO.updatePasswordByUsername(username, newPassword);
                break;
            default:
                request.setAttribute("error", "Loại người dùng không hợp lệ.");
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
        }

        if (updated > 0) {
            session.removeAttribute("username");
            session.removeAttribute("otp");
            session.removeAttribute("user_type");
            request.setAttribute("success", "Đổi mật khẩu thành công. Hãy đăng nhập lại.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Cập nhật mật khẩu thất bại.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        }
    }
}

