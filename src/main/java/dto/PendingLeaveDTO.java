package dto;

import lombok.*;

import java.sql.Date;
import java.sql.Timestamp;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PendingLeaveDTO {
    private int shiftId;
    private String doctorName;
    private Date shiftDate;
    private String timeSlot;
    private Timestamp requestedAt;
    private String status;
}
