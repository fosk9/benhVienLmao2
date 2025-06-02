package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;
import model.Specialization;
import view.EmployeeDAO;
import view.SpecializationDAO;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/DoctorList")
public class DoctorListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        String gender = request.getParameter("gender");
        String specializationParam = request.getParameter("specialization");
        String sortBy = request.getParameter("sortBy");
        String sortDir = request.getParameter("sortDir");

        int page = 1;
        int recordsPerPage = 5;
        int specializationId = 0;

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

        try {
            if (specializationParam != null && !specializationParam.isEmpty()) {
                specializationId = Integer.parseInt(specializationParam);
            }
        } catch (NumberFormatException e) {
            specializationId = 0;
        }

        EmployeeDAO employeeDAO = new EmployeeDAO();
        SpecializationDAO specializationDAO = new SpecializationDAO();

        // Phân trang, filter, sort cho bác sĩ
        List<Employee> doctors = employeeDAO.searchFilterSortDoctors(
                search, gender, specializationId, sortBy, sortDir, page, recordsPerPage);
        int totalRecords = employeeDAO.countFilteredDoctors(search, gender, specializationId);

        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        List<Specialization> specializations = specializationDAO.select();

        request.setAttribute("doctors", doctors);
        request.setAttribute("specializations", specializations);

        request.setAttribute("search", search);
        request.setAttribute("gender", gender);
        request.setAttribute("specialization", specializationId);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortDir", sortDir);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("recordsPerPage", recordsPerPage);

        request.getRequestDispatcher("doctor-list.jsp").forward(request, response);
    }
}


