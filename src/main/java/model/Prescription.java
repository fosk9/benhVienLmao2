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
public class Prescription {
    private int prescriptionId;
    private int appointmentId;
    private String medicationDetails;
    private Timestamp createdAt;
}
