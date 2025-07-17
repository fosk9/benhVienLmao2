package scheduler;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import model.Payment;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import service.PayOSApiClient;
import view.PaymentDAO;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Component // Đánh dấu là Spring Component để được Spring quản lý
public class PayOSPollingScheduler {

    private final PayOSApiClient payOSApiClient;
    private final PaymentDAO paymentDAO;
    private final ObjectMapper objectMapper;

    // Sử dụng Dependency Injection của Spring để tự động inject các bean
    public PayOSPollingScheduler(PayOSApiClient payOSApiClient, PaymentDAO paymentDAO) {
        this.payOSApiClient = payOSApiClient;
        this.paymentDAO = paymentDAO;
        this.objectMapper = new ObjectMapper()
                .registerModule(new JavaTimeModule()) // Hỗ trợ xử lý LocalDateTime
                .configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false); // Không chuyển đổi ngày tháng thành timestamp
    }

    /**
     * Tác vụ được lên lịch để kiểm tra lịch sử thanh toán từ PayOS.
     * Chạy mỗi 5 phút (300000 ms).
     */
    @Scheduled(fixedRate = 300000) // 300000 milliseconds = 5 minutes
    public void pollPayOSTransactions() {
        System.out.println("Starting PayOS transaction polling at: " + LocalDateTime.now());

        // Lấy dữ liệu cho hôm nay và hôm qua để bắt các giao dịch mới nhất
        LocalDate today = LocalDate.now();
        LocalDate yesterday = today.minusDays(1);

        String jsonResponse = payOSApiClient.getTransactionHistory(yesterday, today);

        if (jsonResponse == null || jsonResponse.isEmpty()) {
            System.out.println("No transaction history received from PayOS API or an error occurred.");
            return;
        }

        try {
            JsonNode rootNode = objectMapper.readTree(jsonResponse);
            String responseCode = rootNode.path("code").asText();

            if ("00".equals(responseCode)) { // Giả định "00" là mã thành công từ PayOS
                JsonNode dataNode = rootNode.path("data");

                if (dataNode.isArray()) {
                    for (JsonNode transactionNode : dataNode) {
                        processAndSaveTransaction(transactionNode);
                    }
                } else if (dataNode.isObject()) { // Nếu API trả về 1 đối tượng duy nhất (ví dụ: get by transactionId)
                    processAndSaveTransaction(dataNode);
                } else {
                    System.err.println("PayOS API 'data' field is not an array or object: " + dataNode.getNodeType());
                }
            } else {
                System.err.println("PayOS API returned an error. Code: " + responseCode + ", Desc: " + rootNode.path("desc").asText());
            }
        } catch (Exception e) {
            System.err.println("Error parsing PayOS JSON response or saving to DB: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("Finished PayOS transaction polling.");
    }

    private void processAndSaveTransaction(JsonNode transactionNode) {
        try {
            Payment payment = new Payment();
            payment.setPayosTransactionId(transactionNode.path("transactionId").asText());
            payment.setPayosOrderCode(transactionNode.path("orderCode").asText());

            // Xử lý Amount: PayOS trả về long, chuyển đổi sang BigDecimal
            payment.setAmount(new BigDecimal(transactionNode.path("amount").asLong()));

            payment.setStatus(transactionNode.path("status").asText());
            payment.setMethod(transactionNode.path("paymentMethod").asText());
            payment.setPayContent(transactionNode.path("description").asText()); // Hoặc trường tương ứng như `content`

            // Kiểm tra và lấy signature nếu có
            if (transactionNode.has("signature")) {
                payment.setPayosSignature(transactionNode.path("signature").asText());
            }

            payment.setRawResponseJson(transactionNode.toString()); // Lưu toàn bộ JSON gốc của giao dịch này

            // Thời gian tạo và thanh toán (kiểm tra null trước khi parse)
            // Giả định PayOS trả về định dạng ISO (YYYY-MM-DDTHH:mm:ssZ hoặc YYYY-MM-DDTHH:mm:ss)
            if (transactionNode.has("createdAt") && !transactionNode.path("createdAt").isNull()) {
                payment.setCreatedAt(LocalDateTime.parse(transactionNode.path("createdAt").asText(), DateTimeFormatter.ISO_DATE_TIME));
            } else {
                payment.setCreatedAt(LocalDateTime.now()); // Fallback nếu PayOS không cung cấp created_at
            }

            if (transactionNode.has("paidAt") && !transactionNode.path("paidAt").isNull()) {
                payment.setPaidAt(LocalDateTime.parse(transactionNode.path("paidAt").asText(), DateTimeFormatter.ISO_DATE_TIME));
            }

            // TODO: Gắn appointment_id.
            // Đây là phần quan trọng nhất: bạn cần logic để liên kết `payosOrderCode` (hoặc `payContent`)
            // với `appointment_id` trong database của bạn.
            // Ví dụ: Bạn có thể cần một AppointmentDAO để tìm appointment_id dựa trên orderCode.
            // Integer relatedAppointmentId = yourAppointmentDAO.getAppointmentIdByOrderCode(payment.getPayosOrderCode());
            // payment.setAppointmentId(relatedAppointmentId);
            // Nếu bạn không thể tìm thấy, có thể để null hoặc xử lý theo nghiệp vụ của bạn.

            paymentDAO.insertOrUpdate(payment); // Lưu hoặc cập nhật vào database
        } catch (Exception e) {
            System.err.println("Error processing single transaction: " + transactionNode.toString() + " - " + e.getMessage());
            e.printStackTrace();
        }
    }
}