package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Patient;
import view.PatientDAO;

import java.io.IOException;

@WebServlet("/patient-details")
public class PatientDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                PatientDAO dao = new PatientDAO();
                Patient patient = dao.select(id);

                if (patient != null) {
                    request.setAttribute("patient", patient);
                } else {
                    request.setAttribute("error", "Patient not found.");
                }

            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid patient ID.");
            }
        } else {
            request.setAttribute("error", "Patient ID is required.");
        }

        request.getRequestDispatcher("patient-details.jsp").forward(request, response);
    }
}

