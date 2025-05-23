package model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EmployeeHistory {
    private int historyId;
    private int employeeId;
    private int roleId;
    private LocalDate date;
}