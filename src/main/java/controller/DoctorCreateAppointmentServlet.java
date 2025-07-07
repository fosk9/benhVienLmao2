package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Appointment;
import model.Employee;
import model.Patient;
import view.AppointmentDAO;
import view.PatientDAO;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/create-appointment")
public class DoctorCreateAppointmentServlet extends HttpServlet {

    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); // phù hợp với input date

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object acc = (session != null) ? session.getAttribute("account") : null;

        if (acc == null || !(acc instanceof Employee) || ((Employee) acc).getRoleId() != 1) {
            response.sendRedirect("login.jsp");
            return;
        }

        Employee doctor = (Employee) acc;

        try {
            PatientDAO pdao = new PatientDAO();
            List<Patient> patients = pdao.getPatientsByDoctorId(doctor.getEmployeeId());
            request.setAttribute("patients", patients);
            request.getRequestDispatcher("doctor-create-appointment.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object acc = (session != null) ? session.getAttribute("account") : null;

        if (acc == null || !(acc instanceof Employee) || ((Employee) acc).getRoleId() != 1) {
            response.sendRedirect("login.jsp");
            return;
        }

        Employee doctor = (Employee) acc;

        String patientIdStr = request.getParameter("patientId");
        String appointmentTypeIdStr = request.getParameter("appointmentTypeId");
        String appointmentDateStr = request.getParameter("appointmentDate");
        String timeSlot = request.getParameter("timeSlot");
        String status = request.getParameter("status");
        String requiresSpecialistStr = request.getParameter("requiresSpecialist");

        if (patientIdStr == null || appointmentTypeIdStr == null || appointmentDateStr == null || timeSlot == null || status == null
                || patientIdStr.isEmpty() || appointmentTypeIdStr.isEmpty() || appointmentDateStr.isEmpty() || timeSlot.isEmpty() || status.isEmpty()) {
            request.setAttribute("error", "Please fill in all required fields.");
            request.getRequestDispatcher("doctor-create-appointment.jsp").forward(request, response);
            return;
        }

        int patientId;
        int appointmentTypeId;
        boolean requiresSpecialist = false;
        try {
            patientId = Integer.parseInt(patientIdStr);
            appointmentTypeId = Integer.parseInt(appointmentTypeIdStr);
            if (requiresSpecialistStr != null) {
                requiresSpecialist = Boolean.parseBoolean(requiresSpecialistStr);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input.");
            request.getRequestDispatcher("doctor-create-appointment.jsp").forward(request, response);
            return;
        }

        Date parsedDate;
        try {
            parsedDate = dateFormat.parse(appointmentDateStr);
        } catch (ParseException e) {
            request.setAttribute("error", "Invalid date format.");
            request.getRequestDispatcher("doctor-create-appointment.jsp").forward(request, response);
            return;
        }

        java.sql.Date appointmentDate = new java.sql.Date(parsedDate.getTime());
        Appointment appointment = Appointment.builder()
                .patientId(patientId)
                .doctorId(doctor.getEmployeeId())
                .appointmentTypeId(appointmentTypeId)
                .appointmentDate(appointmentDate)
                .timeSlot(timeSlot)
                .requiresSpecialist(requiresSpecialist)
                .status(status)
                .createdAt(new java.sql.Timestamp(System.currentTimeMillis()))
                .updatedAt(new java.sql.Timestamp(System.currentTimeMillis()))
                .build();

        AppointmentDAO dao = new AppointmentDAO();
        int result = dao.doctorInsert(appointment);

        if (result > 0) {
            response.sendRedirect(request.getContextPath() + "/doctor-home");
        } else {
            request.setAttribute("error", "Failed to create appointment. Please try again.");
            request.getRequestDispatcher("doctor-create-appointment.jsp").forward(request, response);
        }
    }
}
