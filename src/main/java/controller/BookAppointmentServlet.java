package controller;

import view.AppointmentDAO;
import model.Appointment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/book-appointment")
public class BookAppointmentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        if (type != null) {
            request.setAttribute("appointmentType", type);
        }
        request.getRequestDispatcher("/WEB-INF/Pact/book-appointment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("patientId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int patientId = (int) session.getAttribute("patientId");
        String appointmentType = request.getParameter("appointmentType");
        String appointmentDateStr = request.getParameter("appointmentDate");

        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime appointmentDate = LocalDateTime.parse(appointmentDateStr, formatter);

            Appointment appointment = Appointment.builder()
                    .patientId(patientId)
                    .appointmentType(appointmentType)
                    .appointmentDate(appointmentDate)
                    .status("Pending")
                    .build();

            AppointmentDAO appointmentDAO = new AppointmentDAO();
            appointmentDAO.createAppointment(appointment);
            response.sendRedirect(request.getContextPath() + "/appointments");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error");
        }
    }
}