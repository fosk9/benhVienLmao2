package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DoctorShift {
    private int shiftId;
    private int doctorId;
    private LocalDate shiftDate;
    private String shiftTime;
    private String status;
}