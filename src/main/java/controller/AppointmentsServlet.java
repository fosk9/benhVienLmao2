package controller;

import view.AppointmentDAO;
import view.EmployeeDAO;
import view.SpecializationDAO;
import model.Appointment;
import model.Employee;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
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
                request.setAttribute("appointment", appointment);
                request.getRequestDispatcher("/Pact/edit-appointment.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/appointments");
            }
        } else if ("/appointments/details".equals(path)) {
            int appointmentId = Integer.parseInt(request.getParameter("id"));
            Appointment appointment = appointmentDAO.select(appointmentId);
            if (appointment != null && appointment.getPatientId() == patientId) {
                if ("Confirmed".equals(appointment.getStatus()) && appointment.getDoctorId() != 0) {
                    EmployeeDAO employeeDAO = new EmployeeDAO();
                    Employee doctor = employeeDAO.select(appointment.getDoctorId());
                    if (doctor != null) {
                        request.setAttribute("doctor", doctor);
                        if (doctor.getSpecializationId() != null) {
                            SpecializationDAO specializationDAO = new SpecializationDAO();
                            String specialization = specializationDAO.getSpecializationName(doctor.getSpecializationId());
                            request.setAttribute("doctorSpecialization", specialization != null ? specialization : "N/A");
                        } else {
                            request.setAttribute("doctorSpecialization", "N/A");
                        }
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
            String appointmentDateTimeStr = request.getParameter("appointmentDateTime");
            String appointmentType = request.getParameter("appointmentType");

            try {
                if (appointmentDateTimeStr == null || appointmentDateTimeStr.isEmpty()) {
                    throw new IllegalArgumentException("DateTime is empty");
                }
                // Đảm bảo đúng định dạng yyyy-MM-ddTHH:mm
                String tsStr = appointmentDateTimeStr.contains("T") ? appointmentDateTimeStr.replace("T", " ") + ":00" : appointmentDateTimeStr;
                Timestamp appointmentDateTime = Timestamp.valueOf(tsStr);

                AppointmentDAO appointmentDAO = new AppointmentDAO();
                Appointment appointment = appointmentDAO.select(appointmentId);
                if (appointment != null && appointment.getPatientId() == patientId) {
                    appointment.setAppointmentDate(appointmentDateTime);
                    appointment.setAppointmentType(appointmentType);
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
