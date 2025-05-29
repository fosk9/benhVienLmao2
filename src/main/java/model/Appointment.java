package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Appointment {
    private int appointmentId;
    private int patientId;
    private int doctorId;
    private String appointmentType;
    private LocalDateTime appointmentDate;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

}