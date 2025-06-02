package controller;

import java.io.*;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Patient;
import view.PatientDAO;


@WebServlet(name = "DeletePatientServlet", urlPatterns = {"/DeletePatient"})
public class DeletePatientServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int patientId = Integer.parseInt(request.getParameter("id"));
            PatientDAO dao = new PatientDAO();

            int rows = dao.delete(patientId);
            List<Patient> list = dao.select(); // lấy lại danh sách

            if (rows > 0) {
                request.setAttribute("message", "Patient deleted successfully.");
            } else {
                request.setAttribute("message", "Patient deletion failed.");
            }

            request.setAttribute("patients", list);
            request.getRequestDispatcher("patient-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Patient not found.");
        }
    }
}