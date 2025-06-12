//package controller;
//
//import model.Appointment;
//import model.Employee;
//import model.Patient;
//import view.AppointmentDAO;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/update-detail")
//public class DoctorUpdate extends HttpServlet {
//    // Hàm xử lý cập nhật thông tin cuộc hẹn
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession(false); // không tạo mới nếu chưa có
//        Object acc = (session != null) ? session.getAttribute("account") : null;
//
//        if (acc == null || !(acc instanceof Employee) || ((Employee) acc).getRoleId() != 1) {
//            response.sendRedirect(request.getContextPath() + "/login.jsp");
//            return;
//        }
//
//        String appointmentIdStr = request.getParameter("appointmentId");
//        String newAppointmentType = request.getParameter("appointmentType");
//
//        if (appointmentIdStr == null || newAppointmentType == null || appointmentIdStr.isEmpty() || newAppointmentType.isEmpty()) {
//            String referer = request.getHeader("referer");
//            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/doctor-home");
//            return;
//        }
//
//        try {
//            int appointmentId = Integer.parseInt(appointmentIdStr);
//            AppointmentDAO dao = new AppointmentDAO();
//
//            boolean success = dao.updateAppointmentType(appointmentId, newAppointmentType); // Sử dụng hàm updateAppointmentType
//
//            String referer = request.getHeader("referer");
//            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/doctor-home");
//
//        } catch (NumberFormatException e) {
//            response.sendRedirect(request.getContextPath() + "/doctor-home");
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendRedirect(request.getContextPath() + "/error.jsp");
//        }
//    }
//}
