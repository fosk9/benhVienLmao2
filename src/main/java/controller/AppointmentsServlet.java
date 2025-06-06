package controller;

import view.AppointmentDAO;
import view.EmployeeDAO;
import view.AppointmentTypeDAO;
import model.Appointment;
import model.Employee;
import model.AppointmentType;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.sql.Date;
import java.util.List;

@WebServlet({"/appointments", "/appointments/edit", "/appointments/delete", "/appointments/details"})
public class AppointmentsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("patientId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int patientId = (int) session.getAttribute("patientId");
        String path = request.getServletPath();
        AppointmentDAO appointmentDAO = new AppointmentDAO();

        if ("/appointments".equals(path)) {
            List<Appointment> appointments = appointmentDAO.getAppointmentsByPatientId(patientId);
            request.setAttribute("appointments", appointments);
            request.getRequestDispatcher("/Pact/appointments.jsp").forward(request, response);
        } else if ("/appointments/edit".equals(path)) {
            int appointmentId = Integer.parseInt(request.getParameter("id"));
            Appointment appointment = appointmentDAO.select(appointmentId);
            if (appointment != null && appointment.getPatientId() == patientId) {
                AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();
                AppointmentType type = appointmentTypeDAO.select(appointment.getAppointmentTypeId());
                appointment.setAppointmentType(type);
                request.setAttribute("appointment", appointment);
                request.getRequestDispatcher("/Pact/edit-appointment.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/appointments");
            }
        } else if ("/appointments/details".equals(path)) {
            int appointmentId = Integer.parseInt(request.getParameter("id"));
            Appointment appointment = appointmentDAO.select(appointmentId);
            if (appointment != null && appointment.getPatientId() == patientId) {
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
                request.getRequestDispatcher("/Pact/appointment-details.jsp").forward(request, response);
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
                    appointment.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
                    appointmentDAO.update(appointment);
                }
                response.sendRedirect(request.getContextPath() + "/appointments");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/error");
            }
        }
    }
}
