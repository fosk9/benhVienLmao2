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
     * timeSlot: one of "Morning", "Afternoon", "Evening", "Night"
     */
    private String timeSlot;
    private String status;
}
