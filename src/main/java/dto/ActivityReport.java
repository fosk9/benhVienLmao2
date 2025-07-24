package dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;
import java.sql.Date;

@Data
@AllArgsConstructor
public class ActivityReport {
    private Date createdAt;
    private Date updatedAt;
    private String serviceName;
    private String doctorName;
    private String patientName;
    private BigDecimal totalAmount;
    private int doctorId;
    private int patientId;

}
