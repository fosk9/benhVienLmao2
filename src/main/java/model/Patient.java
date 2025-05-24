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
public class Patient {
    private int patientId;
    private String username;
    private String passwordHash;
    private String fullName;
    private LocalDate dob;
    private String gender;
    private String email;
    private String phone;
    private String address;
    private String insuranceNumber;
    private String emergencyContact;
}