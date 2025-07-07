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
public class Diagnosis {
    private int diagnosisId;
    private int appointmentId;
    private String notes;
    private Timestamp createdAt;
}