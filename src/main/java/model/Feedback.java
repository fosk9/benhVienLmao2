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
public class Feedback {
    private int feedbackId;
    private int employeeId;
    private int patientId;
    private int rating;
    private String comments;
    private Timestamp createdAt;
}
