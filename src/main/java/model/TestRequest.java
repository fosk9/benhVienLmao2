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
public class TestRequest {
    private int testId;
    private int appointmentId;
    private String testType;
    private String requestNotes;
    private Timestamp createdAt;
}
