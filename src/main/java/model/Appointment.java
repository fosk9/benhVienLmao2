package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;
import java.sql.Timestamp;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Appointment {
    private int appointmentId;
    private int patientId;
    private int doctorId;
    private int appointmentTypeId; // appointmenttype_id
    private Date appointmentDate; // java.sql.Date
    private String timeSlot; // Morning, Afternoon, Evening
    private boolean requiresSpecialist;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    private Patient patient;
    private AppointmentType appointmentType;
    // ...remove insuranceNumber, patientFullName...
}
