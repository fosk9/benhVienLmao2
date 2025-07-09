package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Employee {
    private int employeeId;
    private String username;
    private String passwordHash;
    private String fullName;
    private Date dob;
    private String gender;
    private String email;
    private String phone;
    private int roleId;
    private String employeeAvaUrl; // Nullable, can be empty string
    private Integer accStatus; // 1: active, 0: inactive
}
