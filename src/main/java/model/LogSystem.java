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
public class LogSystem {
    private int logId;
    private Integer employeeId;
    private Integer patientId;
    private String userName;
    private String roleName;
    private String action;
    private String logLevel;
    private Timestamp createdAt;
}
