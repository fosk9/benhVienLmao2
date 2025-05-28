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

        String search = request.getParameter("search");
        String gender = request.getParameter("gender");
        String sortBy = request.getParameter("sortBy");
        String sortDir = request.getParameter("sortDir");

        PatientDAO patientDAO = new PatientDAO();
        List<Patient> patients;

        boolean hasFilter = (search != null && !search.isEmpty()) ||
                (gender != null && !gender.isEmpty()) ||
                (sortBy != null && !sortBy.isEmpty());

        if (hasFilter) {
            patients = patientDAO.searchFilterSort(search, gender, sortBy, sortDir);
        } else {
            patients = patientDAO.select();
        }

        request.setAttribute("patients", patients);
        request.setAttribute("search", search);
        request.setAttribute("gender", gender);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortDir", sortDir);

        request.getRequestDispatcher("patient-list.jsp").forward(request, response);
    }

}
