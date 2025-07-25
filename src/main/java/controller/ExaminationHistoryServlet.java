package controller;

import dto.ExaminationHistoryDTO;
import validation.InputSanitizer;
import view.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;

import java.io.IOException;
import java.util.List;

@WebServlet({"/examination-history", "/examination-history-details"})
public class ExaminationHistoryServlet extends HttpServlet {
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    private final PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
    private final TreatmentDAO treatmentDAO = new TreatmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.endsWith("/examination-history")) {
            handleListPage(req, resp);
        } else if (uri.endsWith("/examination-history-details")) {
            handleDetailPage(req, resp);
        }
    }

    private void handleListPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Employee doctor = (Employee) session.getAttribute("account");

        if (doctor == null || doctor.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int doctorId = doctor.getEmployeeId();

        // Lấy các tham số search, sort, filter
        String search = req.getParameter("search");
        search = InputSanitizer.cleanSearchQuery(search);
        String sortBy = req.getParameter("sortBy");
        String sortDir = req.getParameter("sortDir");

        int page = 1;
        int recordsPerPage = 5;

        try {
            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        try {
            String rppParam = req.getParameter("recordsPerPage");
            if (rppParam != null && !rppParam.isEmpty()) {
                recordsPerPage = Integer.parseInt(rppParam);
            }
        } catch (NumberFormatException e) {
            recordsPerPage = 5;
        }

        AppointmentDAO dao = new AppointmentDAO();

        // Lấy danh sách theo search/filter/sort
        List<ExaminationHistoryDTO> examinations = dao.searchAndSortCompletedByDoctor(
                doctorId, search, sortBy, sortDir, page, recordsPerPage
        );
        int totalRecords = dao.countSearchCompletedByDoctor(doctorId, search);
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        req.setAttribute("examinations", examinations);
        req.setAttribute("search", search);
        req.setAttribute("sortBy", sortBy);
        req.setAttribute("sortDir", sortDir);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("recordsPerPage", recordsPerPage);

        req.getRequestDispatcher("examination-history.jsp").forward(req, resp);
    }


    private void handleDetailPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int appointmentId = Integer.parseInt(req.getParameter("appointmentId"));

        Appointment appointment = appointmentDAO.select(appointmentId);
        if (appointment == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Appointment not found");
            return;
        }

        // Lấy các đối tượng liên quan
        PatientDAO patientDAO = new PatientDAO();
        AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();

        Patient patient = patientDAO.select(appointment.getPatientId());
        AppointmentType appointmentType = appointmentTypeDAO.select(appointment.getAppointmentTypeId());
        List<Diagnosis> diagnoses = diagnosisDAO.getListByAppointmentId(appointmentId);
        List<Prescription> prescriptions = prescriptionDAO.getListByAppointmentId(appointmentId);
        List<Treatment> treatments = treatmentDAO.getListByAppointmentId(appointmentId);

        // Set attribute
        req.setAttribute("appointment", appointment);
        req.setAttribute("patient", patient);
        req.setAttribute("appointmentType", appointmentType);
        req.setAttribute("diagnoses", diagnoses);
        req.setAttribute("prescriptions", prescriptions);
        req.setAttribute("treatments", treatments);

        req.getRequestDispatcher("examination-history-detail.jsp").forward(req, resp);
    }

}
