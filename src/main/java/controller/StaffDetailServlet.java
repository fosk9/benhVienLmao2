package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DoctorDetail;
import model.Employee;
import view.DoctorDetailDAO;
import view.EmployeeDAO;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/staff-detail")
public class StaffDetailServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;
    private DoctorDetailDAO doctorDetailDAO;

    private static final Logger LOGGER = Logger.getLogger(StaffDetailServlet.class.getName());

    @Override
    public void init() throws ServletException {
        employeeDAO = new EmployeeDAO();
        doctorDetailDAO = new DoctorDetailDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");
        LOGGER.info("Received request for staff-detail with id = " + idRaw);

        if (idRaw == null || idRaw.trim().isEmpty()) {
            String error = "Missing staff ID.";
            LOGGER.warning(error);
            request.getSession().setAttribute("errorMessage", error);
            response.sendRedirect("manager-dashboard");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idRaw);
        } catch (NumberFormatException ex) {
            String error = "Invalid staff ID format: " + idRaw;
            LOGGER.warning(error);
            request.getSession().setAttribute("errorMessage", error);
            response.sendRedirect("manager-dashboard");
            return;
        }

        Employee employee = employeeDAO.getEmployeeById(id);

        if (employee == null) {
            String error = "Staff not found with ID: " + id;
            LOGGER.warning(error);
            request.getSession().setAttribute("errorMessage", error);
            response.sendRedirect("manager-dashboard");
            return;
        }

        LOGGER.info("Staff found: " + employee.getFullName());
        request.setAttribute("employee", employee);

        // Nếu là doctor thì lấy thêm thông tin chuyên môn
        if (employee.getRoleId() == 1) { // 1 = Doctor
            DoctorDetail doctorDetail = doctorDetailDAO.getByEmployeeId(id);
            if (doctorDetail != null) {
                request.setAttribute("doctorDetails", doctorDetail);
            } else {
                LOGGER.warning("No doctor details found for employee id: " + id);
            }
        }

        request.getRequestDispatcher("/Manager/view-detail-staff.jsp").forward(request, response);
    }
}
