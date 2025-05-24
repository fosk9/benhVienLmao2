package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Payment {
    private int paymentId;
    private int appointmentId;
    private double amount;
    private String method;
    private String status;
    private LocalDateTime paymentDate;
}