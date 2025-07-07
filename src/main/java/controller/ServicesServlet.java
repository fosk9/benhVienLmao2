package controller;

import view.PatientDAO;
import view.SystemItemDAO;
import model.Patient;
import model.SystemItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Servlet handling the patient's home page, displaying services and navigation.
 */
@WebServlet("/pactHome")
public class ServicesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String username = (String) session.getAttribute("username");
        PatientDAO patientDAO = new PatientDAO();
        Patient patient = patientDAO.getPatientByUsername(username);

        // Fetch navigation items for patient role (role_id = 5)
        SystemItemDAO systemItemDAO = new SystemItemDAO();
        List<SystemItem> systemItems = systemItemDAO.getActiveItemsByRoleAndType(5, "Navigation");

        if (patient != null) {
            session.setAttribute("patientId", patient.getPatientId());
            request.setAttribute("patient", patient);
            request.setAttribute("systemItems", systemItems);
            request.getRequestDispatcher("/Pact/services.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}