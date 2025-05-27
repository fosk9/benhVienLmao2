package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Appointment;
import model.Employee;
import view.AppointmentDAO;
import view.SimpleDBContext;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/history-examination")
public class HistoryExaminationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object acc = session.getAttribute("account");
        String role = (String) session.getAttribute("login-as");

        // Kiểm tra đăng nhập và quyền (bác sĩ = roleId 1)
        if (acc == null || !(acc instanceof Employee) || ((Employee) acc).getRoleId() != 1) {
            response.sendRedirect("Login.jsp");
            return;
        }

        Employee doctor = (Employee) acc;

        try (Connection conn = new SimpleDBContext() {}.getConn()) {
            AppointmentDAO dao = new AppointmentDAO(conn);

            // Gọi hàm lấy lịch sử khám đã hoàn thành theo doctorId
            List<Appointment> historyList = dao.getCompletedAppointmentsByDoctor(doctor.getEmployeeId());

            request.setAttribute("doctor", doctor);
            request.setAttribute("historyList", historyList);
            request.getRequestDispatcher("Doctor_View/HistoryExamination.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Lỗi tại HistoryExaminationServlet: " + e.toString());
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
