package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Patient;
import validation.InputSanitizer;
import view.PatientDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/PatientList")
public class PatientListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        search = InputSanitizer.cleanSearchQuery(search);
        String gender = request.getParameter("gender");
        String sortBy = request.getParameter("sortBy");
        String sortDir = request.getParameter("sortDir");

        int page = 1;
        int recordsPerPage = 5;

        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        try {
            String rppParam = request.getParameter("recordsPerPage");
            if (rppParam != null && !rppParam.isEmpty()) {
                recordsPerPage = Integer.parseInt(rppParam);
            }
        } catch (NumberFormatException e) {
            recordsPerPage = 5;
        }

        PatientDAO patientDAO = new PatientDAO();
        List<Patient> patients;
        int totalRecords;

        boolean hasFilter = (search != null && !search.isEmpty()) ||
                (gender != null && !gender.isEmpty()) ||
                (sortBy != null && !sortBy.isEmpty());

        if (hasFilter) {
            patients = patientDAO.searchFilterSort(search, gender, sortBy, sortDir, page, recordsPerPage);
            totalRecords = patientDAO.countFiltered(search, gender);
        } else {
            patients = patientDAO.select(page, recordsPerPage);
            totalRecords = patientDAO.countAll();
        }

        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        request.setAttribute("patients", patients);
        request.setAttribute("search", search);
        request.setAttribute("gender", gender);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortDir", sortDir);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("recordsPerPage", recordsPerPage);

        request.getRequestDispatcher("patient-list.jsp").forward(request, response);
    }
}

