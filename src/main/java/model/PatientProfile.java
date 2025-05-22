package model;

import lombok.*;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PatientProfile {
    private int patientId;
    private String fullName;
    private LocalDate dob;
    private String gender;
    private String email;
    private String phone;
    private String address;
    private String insuranceNumber;
    private String emergencyContact;

    // Optional: reference to User
    private User user;
}
