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
public class Diagnosis {
    private int diagnosisId;
    private int appointmentId;
    private String notes;
    private LocalDateTime createdAt;
}