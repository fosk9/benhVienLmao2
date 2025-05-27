package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;
import view.AppointmentDAO;

import java.io.IOException;

@WebServlet("/change-status")
public class DoctorChangeStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // không tạo mới nếu chưa có
        Object acc = (session != null) ? session.getAttribute("account") : null;

        if (acc == null || !(acc instanceof Employee) || ((Employee) acc).getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        String appointmentIdStr = request.getParameter("appointmentId");
        String newStatus = request.getParameter("status");

        if (appointmentIdStr == null || newStatus == null || appointmentIdStr.isEmpty() || newStatus.isEmpty()) {
            String referer = request.getHeader("referer");
            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/doctor-home");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            AppointmentDAO dao = new AppointmentDAO();

            boolean success = dao.updateStatus(appointmentId, newStatus);

            String referer = request.getHeader("referer");
            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/doctor-home");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/doctor-home");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}

