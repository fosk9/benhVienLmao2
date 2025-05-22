package model;

import lombok.*;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DoctorProfile {
    private int doctorId;
    private String fullName;
    private LocalDate dob;
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
