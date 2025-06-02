package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Appointment {
    private int appointmentId;
    private int patientId;
    private int doctorId;
    private String appointmentType;
    private Timestamp appointmentDate;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    private String insuranceNumber;
    private String patientFullName;

    private Patient patient;

}