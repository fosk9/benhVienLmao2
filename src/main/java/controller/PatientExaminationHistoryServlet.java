package controller;

import dto.ExaminationHistoryDTO;
import validation.InputSanitizer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;
import dal.*;

import java.io.IOException;
import java.util.List;

@WebServlet({"/patient-examination-history", "/patient-examination-details"})
public class PatientExaminationHistoryServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    private final PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
    private final TreatmentDAO treatmentDAO = new TreatmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

        if (uri.endsWith("/patient-examination-history")) {
            handleListPage(req, resp);
        } else if (uri.endsWith("/patient-examination-details")) {
            handleDetailPage(req, resp);
        }
    }

    private void handleListPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        int patientId = -1;

        if (session != null) {
            Object account = session.getAttribute("account");
            if (account instanceof Patient) {
                patientId = ((Patient) account).getPatientId();
            }
        }

// Nếu là employee thì buộc phải có param
        if (patientId == -1) {
            try {
                patientId = Integer.parseInt(req.getParameter("patientId"));
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid patient ID");
                return;
            }
        }

        String search = InputSanitizer.cleanSearchQuery(req.getParameter("search"));
        String sortBy = req.getParameter("sortBy");
        String sortDir = req.getParameter("sortDir");

        int page = 1;
        int recordsPerPage = 5;

        try {
            String pageParam = req.getParameter("page");
            if (pageParam != null) page = Integer.parseInt(pageParam);
        } catch (NumberFormatException ignored) {
        }

        try {
            String rpp = req.getParameter("recordsPerPage");
            if (rpp != null) recordsPerPage = Integer.parseInt(rpp);
        } catch (NumberFormatException ignored) {
        }

        List<ExaminationHistoryDTO> list = appointmentDAO.searchAndSortCompletedByPatient(
                patientId, search, sortBy, sortDir, page, recordsPerPage
        );
        int totalRecords = appointmentDAO.countSearchCompletedByPatient(patientId, search);
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        req.setAttribute("examinations", list);
        req.setAttribute("search", search);
        req.setAttribute("sortBy", sortBy);
        req.setAttribute("sortDir", sortDir);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("recordsPerPage", recordsPerPage);
        req.setAttribute("patientId", patientId);

        req.getRequestDispatcher("patient-examination-history.jsp").forward(req, resp);
    }

    private void handleDetailPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("appointmentId");
        if (idParam == null) {
            resp.sendRedirect(req.getContextPath() + "/patient-examination-history");
            return;
        }

        int appointmentId = Integer.parseInt(idParam);
        Appointment appointment = appointmentDAO.select(appointmentId);
        if (appointment == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Appointment not found.");
            return;
        }

        PatientDAO patientDAO = new PatientDAO();
        AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();
        EmployeeDAO employeeDAO = new EmployeeDAO(); // mới thêm

        Patient patient = patientDAO.select(appointment.getPatientId());
        AppointmentType appointmentType = appointmentTypeDAO.select(appointment.getAppointmentTypeId());

        Employee doctor = null;
        if (appointment.getDoctorId() != 0) {
            doctor = employeeDAO.select(appointment.getDoctorId());
        }

        List<Diagnosis> diagnoses = diagnosisDAO.getListByAppointmentId(appointmentId);
        List<Prescription> prescriptions = prescriptionDAO.getListByAppointmentId(appointmentId);
        List<Treatment> treatments = treatmentDAO.getListByAppointmentId(appointmentId);

        req.setAttribute("appointment", appointment);
        req.setAttribute("patient", patient);
        req.setAttribute("doctor", doctor); // mới thêm
        req.setAttribute("appointmentType", appointmentType);
        req.setAttribute("diagnoses", diagnoses);
        req.setAttribute("prescriptions", prescriptions);
        req.setAttribute("treatments", treatments);

        req.getRequestDispatcher("patient-examination-detail.jsp").forward(req, resp);
    }

}
