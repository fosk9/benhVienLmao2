package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "logout", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy session hiện tại (không tạo mới)
        HttpSession session = request.getSession(false);

        // Nếu session tồn tại, xóa rõ ràng các attribute đã được set ở LoginServlet
        if (session != null) {
            session.removeAttribute("username");
            session.removeAttribute("account");
            session.removeAttribute("patientId");
            session.removeAttribute("role");
            session.removeAttribute("login-as");

            session.invalidate(); // Hủy session
        }

        // Chuyển hướng người dùng đến trang login thông qua servlet
        response.sendRedirect(request.getContextPath() + "/login");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
