package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;
import util.HeaderController;
import validation.InputSanitizer;
import view.EmployeeDAO;
import view.SpecializationDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/DoctorList")
public class DoctorListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
// Set navigation items for the header
        HeaderController headerController = new HeaderController();
        request.setAttribute("systemItems", headerController.getNavigationItems(1, "Navigation"));
        String search = request.getParameter("search");
        search = InputSanitizer.cleanSearchQuery(search);
        String gender = request.getParameter("gender");
        String specializationParam = request.getParameter("specialization");
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

        EmployeeDAO employeeDAO = new EmployeeDAO();
        SpecializationDAO specializationDAO = new SpecializationDAO();

        // Phân trang, filter, sort cho bác sĩ
        List<Employee> doctors = employeeDAO.searchFilterSortDoctors(
                search, gender, sortBy, sortDir, page, recordsPerPage);
        int totalRecords = employeeDAO.countFilteredDoctors(search, gender);

        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);


        request.setAttribute("doctors", doctors);
        request.setAttribute("search", search);
        request.setAttribute("gender", gender);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortDir", sortDir);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("recordsPerPage", recordsPerPage);

        request.getRequestDispatcher("doctor-list.jsp").forward(request, response);
    }
}


