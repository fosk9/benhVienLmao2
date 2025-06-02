package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DoctorShift {
    private int shiftId;
    private int doctorId;
    private Date shiftDate;
    /**
     * shiftTime: one of "Morning", "Afternoon", "Night", "Midnight"
     */
    private String shiftTime;
    private String status;
}
