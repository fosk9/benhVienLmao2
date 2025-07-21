package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Log {
    private int logId;             // Unique ID for the log
    private Integer employeeId;    // ID of employee (null if patient or system)
    private Integer patientId;     // ID of patient (null if employee or system)
    private String userName;       // Full name of the user (employee or patient)
    private String roleName;       // Role name (e.g., Doctor, Patient)
    private String action;         // Description of the action
    private String logLevel;       // Log level (INFO, ERROR, WARN)
    private Timestamp createdAt; // Timestamp of when the log was created
}
