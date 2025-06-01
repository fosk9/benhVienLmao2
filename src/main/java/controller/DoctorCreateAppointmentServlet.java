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

    private final SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm"); // phù hợp với input datetime-local

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object acc = (session != null) ? session.getAttribute("account") : null;

        if (acc == null || !(acc instanceof Employee) || ((Employee) acc).getRoleId() != 1) {
            response.sendRedirect("Login.jsp");
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
            response.sendRedirect("Login.jsp");
            return;
        }

        Employee doctor = (Employee) acc;

        String patientIdStr = request.getParameter("patientId");
        String appointmentType = request.getParameter("appointmentType");
        String appointmentDateStr = request.getParameter("appointmentDate");
        String status = request.getParameter("status");

        if (patientIdStr == null || appointmentType == null || appointmentDateStr == null || status == null
                || patientIdStr.isEmpty() || appointmentType.isEmpty() || appointmentDateStr.isEmpty() || status.isEmpty()) {
            request.setAttribute("error", "Please fill in all required fields.");
            request.getRequestDispatcher("doctor-create-appointment.jsp").forward(request, response);
            return;
        }

        int patientId;
        try {
            patientId = Integer.parseInt(patientIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid patient ID.");
            request.getRequestDispatcher("doctor-create-appointment.jsp").forward(request, response);
            return;
        }

        Date parsedDate;
        try {
            parsedDate = dateTimeFormat.parse(appointmentDateStr);
        } catch (ParseException e) {
            request.setAttribute("error", "Invalid date/time format.");
            request.getRequestDispatcher("doctor-create-appointment.jsp").forward(request, response);
            return;
        }

        java.sql.Date appointmentDate = new java.sql.Date(parsedDate.getTime());
        Appointment appointment = Appointment.builder()
                .patientId(patientId)
                .doctorId(doctor.getEmployeeId())
                .appointmentType(appointmentType)
                .appointmentDate(appointmentDate)
                .status(status)
                .createdAt(new java.sql.Date(System.currentTimeMillis()))
                .updatedAt(new java.sql.Date(System.currentTimeMillis()))
                .build();

        AppointmentDAO dao = new AppointmentDAO();
        int result = dao.insert(appointment);

        if (result > 0) {
            response.sendRedirect(request.getContextPath() + "/doctor-home");
        } else {
            request.setAttribute("error", "Failed to create appointment. Please try again.");
            request.getRequestDispatcher("doctor-create-appointment.jsp").forward(request, response);
        }
    }
}
