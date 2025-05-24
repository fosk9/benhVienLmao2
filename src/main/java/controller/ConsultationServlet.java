package controller;

import model.Appointment;
import view.AppointmentDAO;
import model.Employee;
import view.SimpleDBContext;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/consultation")
public class ConsultationServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("account");

        try(Connection conn = new SimpleDBContext() {}.getConn()){
            AppointmentDAO dao = new AppointmentDAO(conn);
            List<Appointment> appointments = dao.getAppointmentsByDoctorId(employee.getEmployeeId());

            request.setAttribute("appointments", appointments);
            request.getRequestDispatcher("WEB-INF/ViewConsultation.jsp").forward(request, response);
        }catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
