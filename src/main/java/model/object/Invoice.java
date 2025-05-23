package model.object;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Invoice {
    private int invoiceId;
    private int diagnosisId;
    private double amount;
    private String status;
    private LocalDateTime paymentDate;
}