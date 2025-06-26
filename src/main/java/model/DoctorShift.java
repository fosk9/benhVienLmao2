package model;

import lombok.*;

import java.sql.Date;
import java.sql.Timestamp;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DoctorShift {
    private int shiftId;
    private int doctorId;
    private Date shiftDate;
    private String timeSlot;
    private String status;
    private Integer managerId;
    private Timestamp requestedAt;
    private Timestamp approvedAt;
}
