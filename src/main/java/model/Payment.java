package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data // Tự động tạo getters, setters, toString, equals, hashCode
@NoArgsConstructor // Tự động tạo constructor không đối số
@AllArgsConstructor // Tự động tạo constructor với tất cả các trường
@Builder // Tự động tạo builder pattern cho việc khởi tạo đối tượng
public class Payment {
    private int paymentId; // Primary key, auto-increment in DB
    private Integer appointmentId; // Có thể null nếu chưa liên kết được
    private BigDecimal amount; // Sử dụng BigDecimal cho độ chính xác cao khi xử lý tiền tệ
    private String method; // Ví dụ: "QR_CODE", "CARD", ...
    private String status; // Ví dụ: "PENDING", "PAID", "CANCELLED", "FAILED"
    private String payContent; // Mô tả thanh toán (vd: "#patientId_# appointmentId_")

    // Các trường từ PayOS API
    private String payosTransactionId; // transactionId từ PayOS
    private String payosOrderCode;     // orderCode từ PayOS (có thể trùng với orderCode của bạn)
    private String payosSignature;     // Chữ ký xác thực từ PayOS
    private String rawResponseJson;    // Lưu toàn bộ JSON response gốc từ PayOS cho giao dịch này

    private LocalDateTime createdAt;
    private LocalDateTime paidAt; // Thời điểm thanh toán thành công
}