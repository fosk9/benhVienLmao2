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
public class Treatment {
    private int treatmentId;
    private int appointmentId;
    private String treatmentType;
    private String treatmentNotes;
    private Timestamp createdAt;
}
