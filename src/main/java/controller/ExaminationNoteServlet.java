package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.*;
import dal.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.Instant;

@WebServlet(urlPatterns = {"/examination-note", "/update-examination-note"})
public class ExaminationNoteServlet extends HttpServlet {
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    private final PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
    private final TreatmentDAO treatmentDAO = new TreatmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));

        Appointment appointment = appointmentDAO.select(appointmentId);
        Diagnosis diagnosis = diagnosisDAO.getByAppointmentId(appointmentId);
        Prescription prescription = prescriptionDAO.getByAppointmentId(appointmentId);
        Treatment treatment = treatmentDAO.getByAppointmentId(appointmentId);

        request.setAttribute("appointment", appointment);
        request.setAttribute("diagnosis", diagnosis);
        request.setAttribute("prescription", prescription);
        request.setAttribute("treatment", treatment);

        request.getRequestDispatcher("examination-note.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        String notes = request.getParameter("diagnosis_notes");
        String medicationDetails = request.getParameter("medication_details");
        String treatmentType = request.getParameter("treatment_type");
        String treatmentNotes = request.getParameter("treatment_notes");
        Timestamp now = Timestamp.from(Instant.now());

        // Diagnosis
        Diagnosis d = diagnosisDAO.getByAppointmentId(appointmentId);
        if (d == null) {
            diagnosisDAO.insert(Diagnosis.builder()
                    .appointmentId(appointmentId)
                    .notes(notes)
                    .createdAt(now)
                    .build());
        } else {
            d.setNotes(notes);
            d.setCreatedAt(now);
            diagnosisDAO.update(d);
        }

        // Prescription
        Prescription p = prescriptionDAO.getByAppointmentId(appointmentId);
        if (p == null) {
            prescriptionDAO.insert(Prescription.builder()
                    .appointmentId(appointmentId)
                    .medicationDetails(medicationDetails)
                    .createdAt(now)
                    .build());
        } else {
            p.setMedicationDetails(medicationDetails);
            p.setCreatedAt(now);
            prescriptionDAO.update(p);
        }

        // Treatment
        Treatment t = treatmentDAO.getByAppointmentId(appointmentId);
        if (t == null) {
            treatmentDAO.insert(Treatment.builder()
                    .appointmentId(appointmentId)
                    .treatmentType(treatmentType)
                    .treatmentNotes(treatmentNotes)
                    .createdAt(now)
                    .build());
        } else {
            t.setTreatmentType(treatmentType);
            t.setTreatmentNotes(treatmentNotes);
            t.setCreatedAt(now);
            treatmentDAO.update(t);
        }

        // Update appointment status to Completed
        Appointment appointment = appointmentDAO.select(appointmentId);
        if (appointment != null && !"Completed".equalsIgnoreCase(appointment.getStatus())) {
            appointment.setStatus("Completed");
            appointment.setUpdatedAt(now);
            appointmentDAO.update(appointment);
        }

        request.setAttribute("message", "Examination note updated successfully!");
        doGet(request, response); // Reuse doGet to reload updated data
    }
}
