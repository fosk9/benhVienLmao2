package controller;

import view.AppointmentDAO;
import view.EmployeeDAO;
import view.AppointmentTypeDAO;
import view.PatientDAO;
import model.Appointment;
import model.Employee;
import model.AppointmentType;
import model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.util.logging.Logger;

@WebServlet({"/appointments", "/appointments/edit", "/appointments/delete", "/appointments/details"})
public class AppointmentsServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AppointmentsServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String path = request.getServletPath();
        AppointmentDAO appointmentDAO = new AppointmentDAO();

        if ("/appointments/details".equals(path)) {
            int appointmentId;
            try {
                appointmentId = Integer.parseInt(request.getParameter("id"));
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid appointment ID: " + request.getParameter("id"));
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            if (appointment == null) {
                LOGGER.warning("Appointment not found for ID: " + appointmentId);
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Check if user is logged in
            if (session != null && session.getAttribute("patientId") != null) {
                int patientId = (int) session.getAttribute("patientId");
                if (appointment.getPatientId() == patientId) {
                    // Logged-in user: proceed with details
                    loadAppointmentDetails(request, appointment);
                    request.getRequestDispatcher("/Pact/appointment-details.jsp").forward(request, response);
                } else {
                    LOGGER.warning("Unauthorized access attempt by patientId: " + patientId + " for appointmentId: " + appointmentId);
                    response.sendRedirect(request.getContextPath() + "/login");
                }
            } else {
                // Non-logged-in user: validate email
                String email = session != null ? (String) session.getAttribute("bookingEmail") : null;
                if (email == null) {
                    LOGGER.warning("No email found in session for non-logged-in access to appointmentId: " + appointmentId);
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                PatientDAO patientDAO = new PatientDAO();
                Patient patient = patientDAO.getPatientById(appointment.getPatientId());
                if (patient != null && email.equalsIgnoreCase(patient.getEmail())) {
                    // Email matches: proceed with details
                    loadAppointmentDetails(request, appointment);
                    request.getRequestDispatcher("/Pact/appointment-details.jsp").forward(request, response);
                } else {
                    LOGGER.warning("Email mismatch or patient not found for appointmentId: " + appointmentId + ", email: " + email);
                    response.sendRedirect(request.getContextPath() + "/login");
                }
            }
        } else {
            // Other paths require login
            if (session == null || session.getAttribute("patientId") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            int patientId = (int) session.getAttribute("patientId");

            if ("/appointments".equals(path)) {
                List<Appointment> appointments = appointmentDAO.getAppointmentsByPatientId(patientId);
                AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();
                for (Appointment appointment : appointments) {
                    AppointmentType type = appointmentTypeDAO.select(appointment.getAppointmentTypeId());
                    appointment.setAppointmentType(type);
                }
                request.setAttribute("appointments", appointments);
                request.getRequestDispatcher("/Pact/appointments.jsp").forward(request, response);
            } else if ("/appointments/edit".equals(path)) {
                int appointmentId = Integer.parseInt(request.getParameter("id"));
                Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
                if (appointment != null && appointment.getPatientId() == patientId) {
                    AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();
                    List<AppointmentType> appointmentTypes = appointmentTypeDAO.select();
                    request.setAttribute("appointment", appointment);
                    request.setAttribute("appointmentTypes", appointmentTypes);
                    request.getRequestDispatcher("/Pact/edit-appointment.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/appointments");
                }
            } else if ("/appointments/delete".equals(path)) {
                int appointmentId = Integer.parseInt(request.getParameter("id"));
                Appointment appointment = appointmentDAO.select(appointmentId);
                if (appointment != null && appointment.getPatientId() == patientId) {
                    appointmentDAO.delete(appointmentId);
                }
                response.sendRedirect(request.getContextPath() + "/appointments");
            }
        }
    }

    private void loadAppointmentDetails(HttpServletRequest request, Appointment appointment) {
        AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();
        AppointmentType type = appointmentTypeDAO.select(appointment.getAppointmentTypeId());
        appointment.setAppointmentType(type);
        if ("Confirmed".equals(appointment.getStatus()) && appointment.getDoctorId() != 0) {
            EmployeeDAO employeeDAO = new EmployeeDAO();
            Employee doctor = employeeDAO.select(appointment.getDoctorId());
            if (doctor != null) {
                request.setAttribute("doctor", doctor);
            }
        }
        request.setAttribute("appointment", appointment);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("patientId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int patientId = (int) session.getAttribute("patientId");
        String path = request.getServletPath();

        if ("/appointments/edit".equals(path)) {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String appointmentDateStr = request.getParameter("appointmentDate");
            String appointmentTypeIdStr = request.getParameter("appointmentTypeId");
            String timeSlot = request.getParameter("timeSlot");
            boolean requiresSpecialist = "on".equals(request.getParameter("requiresSpecialist"));

            try {
                if (appointmentDateStr == null || appointmentDateStr.isEmpty()) {
                    throw new IllegalArgumentException("Date is empty");
                }
                java.sql.Date appointmentDate = java.sql.Date.valueOf(appointmentDateStr);

                if (appointmentTypeIdStr == null || appointmentTypeIdStr.isEmpty()) {
                    throw new IllegalArgumentException("Appointment type is empty");
                }
                int appointmentTypeId = Integer.parseInt(appointmentTypeIdStr);

                if (timeSlot == null || timeSlot.isEmpty()) {
                    throw new IllegalArgumentException("Time slot is empty");
                }

                AppointmentDAO appointmentDAO = new AppointmentDAO();
                Appointment appointment = appointmentDAO.select(appointmentId);
                if (appointment != null && appointment.getPatientId() == patientId) {
                    appointment.setAppointmentDate(appointmentDate);
                    appointment.setAppointmentTypeId(appointmentTypeId);
                    appointment.setTimeSlot(timeSlot);
                    appointment.setRequiresSpecialist(requiresSpecialist);
                    appointment.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
                    appointmentDAO.update(appointment);
                }
                response.sendRedirect(request.getContextPath() + "/appointments");
            } catch (Exception e) {
                LOGGER.severe("Error updating appointment: " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/error");
            }
        }
    }
}