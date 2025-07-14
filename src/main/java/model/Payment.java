package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Payment {
    private int paymentId;
    private Integer appointmentId; // Use Integer for nullable foreign key
    private BigDecimal amount;
    private String method;
    private String status;
    private String payContent;
    private String payosTransactionId;
    private String payosOrderCode;
    private String payosSignature;
    private String rawResponseJson;
    private LocalDateTime createdAt;
    private LocalDateTime paidAt;
}