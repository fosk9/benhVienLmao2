package model.object;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DoctorDetail {
    private int doctorId;
    private String licenseNumber;
    private String workSchedule;
    private double rating;
}