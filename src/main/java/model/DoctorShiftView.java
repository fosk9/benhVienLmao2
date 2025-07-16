package model;

import lombok.*;

import java.sql.Date;
import java.sql.Timestamp;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DoctorShiftView {
    private int shiftId;

    private int doctorId;
    private String doctorName;
    private String doctorEmail;

    private Date shiftDate;
    private String timeSlot;
    private String status;

    private Integer managerId;
    private Timestamp requestedAt;
    private Timestamp approvedAt;

    // ⬇️ Thêm 2 trường mới
    private int workingDaysThisMonth;
    private String statusToday;
}
