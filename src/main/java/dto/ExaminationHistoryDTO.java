package dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExaminationHistoryDTO {
    private int appointmentId;
    private Date appointmentDate;
    private String timeSlot;
    private String appointmentTypeName;
    private String patientName;
    private String status;
}
