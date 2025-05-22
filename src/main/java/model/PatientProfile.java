package model;

import lombok.*;

import java.sql.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PatientProfile {
    private int patientId;
    private String fullName;
    private Date dob;
    private String gender;
    private String email;
    private String phone;
    private String address;
    private String insuranceNumber;
    private String emergencyContact;
}
