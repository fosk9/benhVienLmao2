package view;

import model.Payment;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class PaymentDAO extends DBContext<Payment> {

    // Create a new payment
    // Cập nhật phương thức createPayment để bao gồm các trường PayOS mới
    public int createPayment(Payment payment) {
        String sql = "INSERT INTO Payments (appointment_id, amount, method, status, pay_content, " +
                "payos_transaction_id, payos_order_code, payos_signature, raw_response_json, created_at, paid_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                // Sử dụng setInt cho Integer có thể null
                if (payment.getAppointmentId() != null) {
                    ps.setInt(1, payment.getAppointmentId());
                } else {
                    ps.setNull(1, Types.INTEGER);
                }
                ps.setBigDecimal(2, payment.getAmount()); // Sử dụng setBigDecimal
                ps.setString(3, payment.getMethod());
                ps.setString(4, payment.getStatus());
                ps.setString(5, payment.getPayContent());

                // Các trường mới của PayOS
                ps.setString(6, payment.getPayosTransactionId());
                ps.setString(7, payment.getPayosOrderCode());
                ps.setString(8, payment.getPayosSignature());
                ps.setString(9, payment.getRawResponseJson());

                ps.setTimestamp(10, payment.getCreatedAt() == null ? new Timestamp(System.currentTimeMillis()) : Timestamp.valueOf(payment.getCreatedAt()));
                if (payment.getPaidAt() != null) {
                    ps.setTimestamp(11, Timestamp.valueOf(payment.getPaidAt()));
                } else {
                    ps.setNull(11, Types.TIMESTAMP);
                }

                int affected = ps.executeUpdate();
                if (affected == 0) return -1;
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error creating payment: " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return -1;
    }

    // Update an existing payment
    // Cập nhật phương thức updatePayment để bao gồm các trường PayOS mới
    public int updatePayment(Payment payment) {
        String sql = "UPDATE Payments SET appointment_id = ?, amount = ?, method = ?, status = ?, pay_content = ?, " +
                "payos_transaction_id = ?, payos_order_code = ?, payos_signature = ?, raw_response_json = ?, " +
                "created_at = ?, paid_at = ? WHERE payment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                if (payment.getAppointmentId() != null) {
                    ps.setInt(1, payment.getAppointmentId());
                } else {
                    ps.setNull(1, Types.INTEGER);
                }
                ps.setBigDecimal(2, payment.getAmount());
                ps.setString(3, payment.getMethod());
                ps.setString(4, payment.getStatus());
                ps.setString(5, payment.getPayContent());

                // Các trường mới của PayOS
                ps.setString(6, payment.getPayosTransactionId());
                ps.setString(7, payment.getPayosOrderCode());
                ps.setString(8, payment.getPayosSignature());
                ps.setString(9, payment.getRawResponseJson());

                ps.setTimestamp(10, payment.getCreatedAt() == null ? new Timestamp(System.currentTimeMillis()) : Timestamp.valueOf(payment.getCreatedAt()));
                if (payment.getPaidAt() != null) {
                    ps.setTimestamp(11, Timestamp.valueOf(payment.getPaidAt()));
                } else {
                    ps.setNull(11, Types.TIMESTAMP);
                }
                ps.setInt(12, payment.getPaymentId()); // Where clause

                return ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error updating payment: " + e.getMessage());
        } finally {
            closeConnection(conn);
        }
        return 0;
    }

    // Get all payments
    public List<Payment> getAllPayments() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM Payments";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        list.add(mapResultSetToPayment(rs));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    // Get payment by appointment ID (keep existing method)
    public Payment getPaymentByAppointmentId(int appointmentId) {
        String sql = "SELECT * FROM Payments WHERE appointment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, appointmentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapResultSetToPayment(rs);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return null;
    }

    // NEW: Get payment by PayOS Transaction ID
    public Payment getPaymentByPayOSTransactionId(String payosTransactionId) {
        String sql = "SELECT * FROM Payments WHERE payos_transaction_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, payosTransactionId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapResultSetToPayment(rs);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return null;
    }

    // NEW: Get payment by PayOS Order Code (Nếu order_code của bạn là duy nhất và dùng để tìm kiếm)
    public Payment getPaymentByPayOSOrderCode(String payosOrderCode) {
        String sql = "SELECT * FROM Payments WHERE payos_order_code = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, payosOrderCode);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapResultSetToPayment(rs);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return null;
    }


    // NEW: Insert or Update Payment based on payosTransactionId
    public int insertOrUpdate(Payment payment) {
        // Log để biết đang xử lý transaction nào
        System.out.println("Processing payment with PayOS Transaction ID: " + payment.getPayosTransactionId());

        Payment existingPayment = getPaymentByPayOSTransactionId(payment.getPayosTransactionId());

        if (existingPayment != null) {
            // Nếu đã tồn tại, cập nhật
            payment.setPaymentId(existingPayment.getPaymentId()); // Đảm bảo ID đúng để cập nhật
            System.out.println("Updating existing payment ID: " + existingPayment.getPaymentId());
            return updatePayment(payment);
        } else {
            // Nếu chưa tồn tại, tạo mới
            System.out.println("Creating new payment for transaction ID: " + payment.getPayosTransactionId());
            return createPayment(payment);
        }
    }

    // Map ResultSet to Payment
    // Cập nhật mapResultSetToPayment để đọc các trường PayOS mới
    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        return Payment.builder()
                .paymentId(rs.getInt("payment_id"))
                .appointmentId(rs.getObject("appointment_id", Integer.class)) // Handle nullable Integer
                .amount(rs.getBigDecimal("amount")) // Lấy BigDecimal
                .method(rs.getString("method"))
                .status(rs.getString("status"))
                .payContent(rs.getString("pay_content"))
                .payosTransactionId(rs.getString("payos_transaction_id")) // NEW
                .payosOrderCode(rs.getString("payos_order_code"))         // NEW
                .payosSignature(rs.getString("payos_signature"))         // NEW
                .rawResponseJson(rs.getString("raw_response_json"))       // NEW
                .createdAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null)
                .paidAt(rs.getTimestamp("paid_at") != null ? rs.getTimestamp("paid_at").toLocalDateTime() : null)
                .build();
    }

    // Implement abstract methods from DBContext
    @Override
    public List<Payment> select() { return getAllPayments(); }
    @Override
    public Payment select(int... id) {
        if (id.length < 1) return null;
        return getPaymentByAppointmentId(id[0]); // Hoặc getPaymentById nếu bạn muốn tìm bằng payment_id
    }
    @Override
    public int insert(Payment obj) { return createPayment(obj); }
    @Override
    public int update(Payment obj) { return updatePayment(obj); }
    @Override
    public int delete(int... id) {
        if (id == null || id.length == 0) return 0;
        String sql = "DELETE FROM Payments WHERE payment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id[0]);
                return ps.executeUpdate();
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            return 0;
        } finally {
            closeConnection(conn);
        }
    }
}