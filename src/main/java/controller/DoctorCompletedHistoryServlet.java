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

@WebServlet("/completed-history")
public class DoctorCompletedHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        HttpSession session = request.getSession(false);
        Object acc = (session != null) ? session.getAttribute("account") : null;

        if (acc == null || !(acc instanceof Employee) || ((Employee) acc).getRoleId() != 1) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Set up the header navigation items
        HeaderController headerController = new HeaderController();
        request.setAttribute("systemItems", headerController.getNavigationItems(1, "Navigation"));
        Employee doctor = (Employee) acc;

        try {
            AppointmentDAO dao = new AppointmentDAO();
            List<Appointment> completedList = dao.getCompletedAppointmentsByDoctor(doctor.getEmployeeId());

            request.setAttribute("doctor", doctor);
            request.setAttribute("completedAppointments", completedList);

            request.getRequestDispatcher("doctor-completed-history.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
