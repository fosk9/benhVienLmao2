package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;
import model.Patient;
import view.AppointmentDAO;
import view.PatientDAO;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/create-appointment")
public class CreateAppointmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object acc = (session != null) ? session.getAttribute("account") : null;

        if (acc == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        Employee doctor = (Employee) acc;

        if (doctor.getRoleId() != 1) {
            response.sendRedirect("Login.jsp");
            return;
        }

        try (Connection conn = new SimpleDBContext() {
        }.getConn()) {
            AppointmentDAO dao = new AppointmentDAO(conn);
            PatientDAO pdao = new PatientDAO();
            List<Patient> patients = pdao.getPatientsByDoctorId(doctor.getEmployeeId());

            request.setAttribute("patients", patients);
            request.getRequestDispatcher("Doctor_View/CreateAppointment.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Employee doctor = (session != null) ? (Employee) session.getAttribute("account") : null;

        if (doctor == null || doctor.getRoleId() != 1) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String patientIdStr = request.getParameter("patientId");
        String status = request.getParameter("status");
        String dateStr = request.getParameter("appointmentDate");

        if (patientIdStr == null || status == null || dateStr == null) {
            response.sendRedirect("error.jsp");
            return;
        }

        try (Connection conn = new SimpleDBContext().getConn()) {
            int patientId = Integer.parseInt(patientIdStr);
            LocalDateTime appointmentDate = LocalDateTime.parse(dateStr, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));

            new AppointmentDAO(conn).createAppointment(patientId, doctor.getEmployeeId(), appointmentDate, status);

            // Redirect sang trang doctor-home (đảm bảo bạn có servlet hoặc URL xử lý này)
            response.sendRedirect(request.getContextPath() + "/doctor-home");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}


