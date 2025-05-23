package model.object;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DoctorShift {
    private int shiftId;
    private int doctorId;
    private LocalDate shiftDate;
    private String shiftTime;
    private String status;
}