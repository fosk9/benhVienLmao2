package model;

import lombok.*;

import java.sql.Date;
import java.sql.Timestamp;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DoctorScheduleSummary {
    private int doctorId;
    private String doctorName;
    private String doctorEmail;
    private int workingDaysThisMonth;
    private String statusToday;
}
