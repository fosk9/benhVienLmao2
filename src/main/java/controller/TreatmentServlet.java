package controller;

import model.Treatment;
import util.HeaderController;
import view.TreatmentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/treatment/history")
public class TreatmentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String patientIdStr = request.getParameter("patientId");
        String appointmentIdStr = request.getParameter("appointmentId");
        String treatmentDate = request.getParameter("treatmentDate");
        String treatmentType = request.getParameter("treatmentType");
        // Set navigation items for the header
        HeaderController headerController = new HeaderController();
        request.setAttribute("systemItems", headerController.getNavigationItems(5, "Navigation"));
        TreatmentDAO dao = new TreatmentDAO();
        List<Treatment> treatments = null;
        try {
            if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                treatments = dao.getTreatmentsByAppointmentId(appointmentId);
            } else if (patientIdStr != null && !patientIdStr.isEmpty()) {
                int patientId = Integer.parseInt(patientIdStr);
                treatments = dao.getTreatmentsByPatientId(patientId);
            } else {
                treatments = dao.getAllTreatments();
            }
            // Filter by treatmentDate and treatmentType if provided
            if (treatments != null) {
                if (treatmentDate != null && !treatmentDate.isEmpty()) {
                    treatments.removeIf(t -> t.getCreatedAt() == null ||
                        !t.getCreatedAt().toLocalDateTime().toLocalDate().toString().equals(treatmentDate));
                }
                if (treatmentType != null && !treatmentType.isEmpty()) {
                    treatments.removeIf(t -> t.getTreatmentType() == null ||
                        !t.getTreatmentType().toLowerCase().contains(treatmentType.toLowerCase()));
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid ID or database error.");
        }
        if (treatments == null) treatments = java.util.Collections.emptyList();
        request.setAttribute("treatments", treatments);
        request.getRequestDispatcher("/Pact/treatment-history.jsp").forward(request, response);
    }
}
