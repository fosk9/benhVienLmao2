//package controller;
//
//import view.AppointmentDAO;
//import model.Employee;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//import java.sql.Connection;
//import java.sql.SQLException;
//
//@WebServlet("/change-status")
//public class ChangeStatusServlet extends HttpServlet {
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
//        Object acc = session.getAttribute("account");
//        String role = (String) session.getAttribute("login-as");
//
//        if (acc == null || !(acc instanceof Employee) || ((Employee) acc).getRoleId() != 1) {
//            response.sendRedirect("Login.jsp");
//            return;
//        }
//
//        String appointmentIdStr = request.getParameter("appointmentId");
//        String newStatus = request.getParameter("status");
//
//        if (appointmentIdStr == null || newStatus == null || appointmentIdStr.isEmpty() || newStatus.isEmpty()) {
//            response.sendRedirect(request.getHeader("referer")); // quay lại trang trước
//            return;
//        }
//
//        try (Connection conn = new SimpleDBContext() {}.getConn()) {
//            AppointmentDAO dao = new AppointmentDAO(conn);
//            int appointmentId = Integer.parseInt(appointmentIdStr);
//
//            boolean success = dao.updateStatus(appointmentId, newStatus);
//            // Bạn có thể lưu thông báo vào session hoặc request để hiển thị nếu cần
//
//            // Quay lại trang trước sau khi cập nhật
//            response.sendRedirect(request.getHeader("referer"));
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//            response.sendRedirect("error.jsp");
//        }
//    }
//}
