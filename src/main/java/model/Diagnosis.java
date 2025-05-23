package model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Diagnosis {
    private int diagnosisId;
    private int appointmentId;
    private String notes;
    private LocalDateTime createdAt;
}