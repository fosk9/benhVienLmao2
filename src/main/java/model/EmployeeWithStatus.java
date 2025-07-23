package model;

import lombok.*;
import java.io.Serializable;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EmployeeWithStatus implements Serializable {
    private Employee employee;      // Thông tin nhân viên
    private String statusToday;     // Trạng thái hôm nay: Working / OnLeave / Inactive
}
