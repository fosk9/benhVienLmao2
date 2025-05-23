package model.object;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Employee {
    private int employeeId;
    private String fullName;
    private String dob; // Consider java.time.LocalDate for better date handling
    private String gender;
    private String email;
    private String phone;
    private int roleId;
}