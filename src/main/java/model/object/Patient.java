package model.object;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Patient {
    private int patientId;
    private String fullName;
    private String dob;
    private String gender;
    private String email;
    private String phone;
    private String address;
    private String insuranceNumber;
    private String emergencyContact;
}