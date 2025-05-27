package controller;

import model.Appointment;
import model.Employee;
import view.AppointmentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/view-detail")
public class DoctorViewDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object acc = (session != null) ? session.getAttribute("account") : null;

        if (acc == null || !(acc instanceof Employee)) {
            response.sendRedirect("Login.jsp");
            return;
        }

        Employee doctor = (Employee) acc;

        if (doctor.getRoleId() != 1) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr == null || !appointmentIdStr.matches("\\d+")) {
            response.sendRedirect("doctor-home");
            return;
        }

        int appointmentId = Integer.parseInt(appointmentIdStr);

        try {
            AppointmentDAO dao = new AppointmentDAO();
            Appointment appointment = dao.getAppointmentDetailById(appointmentId);

            if (appointment == null) {
                response.sendRedirect("doctor-home");
                return;
            }

            request.setAttribute("appointment", appointment);
            request.getRequestDispatcher("doctor-view-detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
