package controller;

import view.AppointmentDAO;
import model.Employee;
import view.SimpleDBContext;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/doctor-home")
public class DoctorHomeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Employee doctor = (Employee) session.getAttribute("acount");

        try(Connection conn = new SimpleDBContext() {}.getConn()){
            AppointmentDAO dao = new AppointmentDAO(conn);
            int[] stats = dao.getTodayStatsByDoctorId(doctor.getEmployeeId());

            request.setAttribute("stats", stats);
            request.setAttribute("doctor", doctor);
            request.getRequestDispatcher("WEB-INF/DoctorHome.jsp").forward(request, response);
        }catch (Exception e){
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
