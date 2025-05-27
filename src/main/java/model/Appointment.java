package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Appointment {
    private int appointmentId;
    private int patientId;
    private int doctorId;
    private String appointmentType;
    private Date appointmentDate;
    private String status;
    private Date createdAt;
    private Date updatedAt;

    private String insuranceNumber;
    private String patientFullName;

    private Patient patient;

}