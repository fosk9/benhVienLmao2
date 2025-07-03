package controller;

import view.AppointmentDAO;
import view.DoctorShiftDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Appointment;
import model.DoctorShift;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/unassigned-appointments", "/assign-appointment"})
public class AssignAppointmentServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final DoctorShiftDAO shiftDAO = new DoctorShiftDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        switch (path) {
            case "/unassigned-appointments":
                handleUnassignedAppointments(req, resp);
                break;
            case "/assign-appointment":
                handleAvailableDoctors(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleUnassignedAppointments(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Appointment> unassignedAppointments = appointmentDAO.getUnassignedAppointments();
        req.setAttribute("appointments", unassignedAppointments);
        req.getRequestDispatcher("unassigned-appointments.jsp").forward(req, resp);
    }

    private void handleAvailableDoctors(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int appointmentId = Integer.parseInt(req.getParameter("id"));
            Appointment appointment = appointmentDAO.select(appointmentId);

            if (appointment == null || appointment.getDoctorId() != 0) {
                req.setAttribute("error", "Invalid or already assigned appointment.");
                resp.sendRedirect(req.getContextPath() + "/unassigned-appointments");
                return;
            }

            List<DoctorShift> availableDoctors = shiftDAO.getDoctorsForSlot(appointment.getAppointmentDate(), appointment.getTimeSlot());
            req.setAttribute("appointment", appointment);
            req.setAttribute("availableDoctors", availableDoctors);
            req.getRequestDispatcher("assign-doctor.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/unassigned-appointments");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Gán doctor cho appointment
        try {
            int appointmentId = Integer.parseInt(req.getParameter("appointmentId"));
            int doctorId = Integer.parseInt(req.getParameter("doctorId"));

            appointmentDAO.assignDoctor(appointmentId, doctorId);
            resp.sendRedirect(req.getContextPath() + "/unassigned-appointments?success=1");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/unassigned-appointments?error=1");
        }
    }
}
