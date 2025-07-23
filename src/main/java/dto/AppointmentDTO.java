package dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AppointmentDTO {
    private int appointmentId;
    private Date appointmentDate;
    private String timeSlot;
    private String status;
    private String patientName;
    private String appointmentType;
}
