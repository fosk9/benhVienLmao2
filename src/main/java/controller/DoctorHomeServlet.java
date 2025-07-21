package controller;

import model.Appointment;
import model.Employee;
import util.HeaderController;
import view.AppointmentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/doctor-home")
public class DoctorHomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object acc = (session != null) ? session.getAttribute("account") : null;

        // Set up the header navigation items
        HeaderController headerController = new HeaderController();
        request.setAttribute("systemItems", headerController.getNavigationItems(1, "Navigation"));

        if (acc == null || !(acc instanceof Employee) || ((Employee) acc).getRoleId() != 1) {

            response.sendRedirect("login.jsp");
            response.sendRedirect("Login.jsp");
            return;
        }

        Employee doctor = (Employee) acc;

        try {
            AppointmentDAO dao = new AppointmentDAO();
            List<Appointment> list = dao.getAppointmentsByDoctorId(doctor.getEmployeeId());

            request.setAttribute("doctor", doctor);
            request.setAttribute("appointments", list);
            request.getRequestDispatcher("doctor-home.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
