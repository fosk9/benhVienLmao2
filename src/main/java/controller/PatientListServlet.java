package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Patient;
import view.PatientDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/PatientList")
public class PatientListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy danh sách tất cả bệnh nhân từ DAO
        PatientDAO patientDAO = new PatientDAO();
        List<Patient> patients = patientDAO.select();

        // Đưa danh sách vào request scope
        request.setAttribute("patients", patients);

        // Forward tới trang JSP
        request.getRequestDispatcher("patient-list.jsp").forward(request, response);
    }
}
