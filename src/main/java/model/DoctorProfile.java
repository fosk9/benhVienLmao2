package model;

import lombok.*;

import java.sql.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DoctorProfile {
    private int doctorId;
    private String fullName;
    private Date dob;
    private String gender;
    private String email;
    private String phone;
    private String licenseNumber;
    private int specializationId;
    private String workSchedule;

    // Optional: reference
    private User user;
    private Specialization specialization;
}
