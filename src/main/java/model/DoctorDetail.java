package model;

import lombok.*;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DoctorDetail {
    private int doctorId;
    private String licenseNumber;
    private boolean specialist;
    private BigDecimal rating;
}
