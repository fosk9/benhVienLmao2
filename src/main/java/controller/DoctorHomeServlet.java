//package controller;
//
//import model.Appointment;
//import view.AppointmentDAO;
//import model.Employee;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//import java.sql.Connection;
//import java.util.List;
//
//@WebServlet("/doctor-home")
//public class DoctorHomeServlet extends HttpServlet {
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
//        Object acc = session.getAttribute("account");
//        String role = (String) session.getAttribute("login-as");
//
//        if (acc == null || !(acc instanceof Employee) || ((Employee) acc).getRoleId() != 1) {
//            response.sendRedirect("Login.jsp");
//            return;
//        }
//
//        Employee doctor = (Employee) acc;
//
//        try(Connection conn = new SimpleDBContext() {}.getConn()){
//            AppointmentDAO dao = new AppointmentDAO(conn);
//            List<Appointment> list = dao.getAppointmentsByDoctorId(doctor.getEmployeeId());
//            request.setAttribute("doctor", doctor);
//            request.setAttribute("appointments", list);
//            request.getRequestDispatcher("Doctor_View/DoctorHome.jsp").forward(request, response);
//        }catch (Exception e){
//            e.printStackTrace();
//            response.sendRedirect("error.jsp");
//        }
//
//    }
//}
