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
import java.sql.Timestamp;

@WebServlet("/book-appointment")
public class BookAppointmentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        if (type != null) {
            request.setAttribute("appointmentType", type);
        }
        request.getRequestDispatcher("/Pact/book-appointment.jsp").forward(request, response);
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
        String appointmentDateTimeStr = request.getParameter("appointmentDateTime");

        try {
            if (appointmentDateTimeStr == null || appointmentDateTimeStr.isEmpty()) {
                throw new IllegalArgumentException("DateTime is empty");
            }
            Timestamp appointmentDateTime = Timestamp.valueOf(appointmentDateTimeStr.replace("T", " ") + ":00");
            Timestamp now = new Timestamp(System.currentTimeMillis());

            Appointment appointment = Appointment.builder()
                    .patientId(patientId)
                    .appointmentType(appointmentType)
                    .appointmentDate(appointmentDateTime)
                    .status("Pending")
                    .createdAt(now)
                    .updatedAt(now)
                    .build();

            AppointmentDAO appointmentDAO = new AppointmentDAO();
            int result = appointmentDAO.insert(appointment);
            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/appointments");
            } else {
                throw new Exception("Insert failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error");
        }
    }
}
