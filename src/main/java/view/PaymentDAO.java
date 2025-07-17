package view;

import model.Payment;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal; // Import BigDecimal

public class PaymentDAO extends DBContext<Payment> {
    // Constructor (giữ nguyên)
    public PaymentDAO() {
        super();
    }

    // Phương thức đã có
    public int createPayment(Payment payment) {
        // Updated to include PayOS specific fields and use BigDecimal
        String sql = "INSERT INTO Payments (appointment_id, amount, method, status, pay_content, payos_transaction_id, payos_order_code, payos_signature, raw_response_json, created_at, paid_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setObject(1, payment.getAppointmentId()); // appointment_id có thể null
                ps.setBigDecimal(2, payment.getAmount());
                ps.setString(3, payment.getMethod());
                ps.setString(4, payment.getStatus());
                ps.setString(5, payment.getPayContent());
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
        } finally {
            closeConnection(conn);
        }
        return -1;
    }

    // Phương thức đã có
    public List<Payment> getAllPayments() {
        return getFilteredPayments(null, null, null, null, null, null, 1, Integer.MAX_VALUE);
    }

    // Phương thức đã có (hoặc tương tự)
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

    // NEW METHOD: Lấy Payment theo payosTransactionId
    public Payment getPaymentByPayosTransactionId(String payosTransactionId) {
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

    // NEW METHOD: Lấy danh sách thanh toán có lọc và phân trang (giữ nguyên)
    public List<Payment> getFilteredPayments(
            Integer paymentId, Integer appointmentId, String method, String status,
            LocalDateTime createdAtFrom, LocalDateTime createdAtTo,
            int currentPage, int pageSize) {
        List<Payment> list = new ArrayList<>();
        Connection conn = null;
        StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM Payments WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (paymentId != null) {
            sqlBuilder.append(" AND payment_id = ?");
            params.add(paymentId);
        }
        if (appointmentId != null) {
            sqlBuilder.append(" AND appointment_id = ?");
            params.add(appointmentId);
        }
        if (method != null && !method.trim().isEmpty()) {
            sqlBuilder.append(" AND method LIKE ?");
            params.add("%" + method + "%");
        }
        if (status != null && !status.trim().isEmpty() && !"All".equalsIgnoreCase(status)) {
            sqlBuilder.append(" AND status = ?");
            params.add(status);
        }
        if (createdAtFrom != null) {
            sqlBuilder.append(" AND created_at >= ?");
            params.add(Timestamp.valueOf(createdAtFrom));
        }
        if (createdAtTo != null) {
            sqlBuilder.append(" AND created_at <= ?");
            params.add(Timestamp.valueOf(createdAtTo));
        }

        sqlBuilder.append(" ORDER BY created_at DESC");
        sqlBuilder.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((currentPage - 1) * pageSize);
        params.add(pageSize);

        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    ps.setObject(i + 1, params.get(i));
                }
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

    // NEW METHOD: Đếm tổng số bản ghi có lọc (giữ nguyên)
    public int countFilteredPayments(
            Integer paymentId, Integer appointmentId, String method, String status,
            LocalDateTime createdAtFrom, LocalDateTime createdAtTo) {
        Connection conn = null;
        StringBuilder sqlBuilder = new StringBuilder("SELECT COUNT(*) FROM Payments WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (paymentId != null) {
            sqlBuilder.append(" AND payment_id = ?");
            params.add(paymentId);
        }
        if (appointmentId != null) {
            sqlBuilder.append(" AND appointment_id = ?");
            params.add(appointmentId);
        }
        if (method != null && !method.trim().isEmpty()) {
            sqlBuilder.append(" AND method LIKE ?");
            params.add("%" + method + "%");
        }
        if (status != null && !status.trim().isEmpty() && !"All".equalsIgnoreCase(status)) {
            sqlBuilder.append(" AND status = ?");
            params.add(status);
        }
        if (createdAtFrom != null) {
            sqlBuilder.append(" AND created_at >= ?");
            params.add(Timestamp.valueOf(createdAtFrom));
        }
        if (createdAtTo != null) {
            sqlBuilder.append(" AND created_at <= ?");
            params.add(Timestamp.valueOf(createdAtTo));
        }

        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    ps.setObject(i + 1, params.get(i));
                }
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return 0;
    }


    // Map ResultSet to Payment (ĐÃ CẬP NHẬT để đọc các trường PayOS)
    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        return Payment.builder()
                .paymentId(rs.getInt("payment_id"))
                .appointmentId(rs.getObject("appointment_id", Integer.class)) // Đọc Integer có thể null
                .amount(rs.getBigDecimal("amount"))
                .method(rs.getString("method"))
                .status(rs.getString("status"))
                .payContent(rs.getString("pay_content"))
                .payosTransactionId(rs.getString("payos_transaction_id"))
                .payosOrderCode(rs.getString("payos_order_code"))
                .payosSignature(rs.getString("payos_signature"))
                .rawResponseJson(rs.getString("raw_response_json"))
                .createdAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null)
                .paidAt(rs.getTimestamp("paid_at") != null ? rs.getTimestamp("paid_at").toLocalDateTime() : null)
                .build();
    }

    // Cập nhật phương thức update (ĐÃ CẬP NHẬT)
    @Override
    public int update(Payment obj) {
        String sql = "UPDATE Payments SET " +
                "appointment_id = ?, amount = ?, method = ?, status = ?, pay_content = ?, " +
                "payos_transaction_id = ?, payos_order_code = ?, payos_signature = ?, raw_response_json = ?, " +
                "created_at = ?, paid_at = ? " +
                "WHERE payment_id = ?"; // Cập nhật theo paymentId

        // Nếu paymentId chưa được set (có thể là trường hợp dùng payosTransactionId để update)
        // thì cần thêm logic để tìm paymentId trước hoặc update theo payosTransactionId
        if (obj.getPaymentId() == 0 && obj.getPayosTransactionId() != null) {
            Payment existingPayment = getPaymentByPayosTransactionId(obj.getPayosTransactionId());
            if (existingPayment != null) {
                obj.setPaymentId(existingPayment.getPaymentId()); // Set paymentId cho đối tượng cần update
            } else {
                return 0; // Không tìm thấy để cập nhật
            }
        }

        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setObject(1, obj.getAppointmentId());
                ps.setBigDecimal(2, obj.getAmount());
                ps.setString(3, obj.getMethod());
                ps.setString(4, obj.getStatus());
                ps.setString(5, obj.getPayContent());
                ps.setString(6, obj.getPayosTransactionId());
                ps.setString(7, obj.getPayosOrderCode());
                ps.setString(8, obj.getPayosSignature());
                ps.setString(9, obj.getRawResponseJson());
                ps.setTimestamp(10, obj.getCreatedAt() != null ? Timestamp.valueOf(obj.getCreatedAt()) : null);
                ps.setTimestamp(11, obj.getPaidAt() != null ? Timestamp.valueOf(obj.getPaidAt()) : null);
                ps.setInt(12, obj.getPaymentId()); // Where clause

                return ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return 0;
    }

    // NEW METHOD: insertOrUpdate
    public int insertOrUpdate(Payment payment) {
        Payment existingPayment = getPaymentByPayosTransactionId(payment.getPayosTransactionId());

        if (existingPayment != null) {
            // Update existing record
            // Cập nhật các trường cần thiết từ 'payment' mới vào 'existingPayment'
            existingPayment.setAppointmentId(payment.getAppointmentId() != null ? payment.getAppointmentId() : existingPayment.getAppointmentId());
            existingPayment.setAmount(payment.getAmount() != null ? payment.getAmount() : existingPayment.getAmount());
            existingPayment.setMethod(payment.getMethod() != null ? payment.getMethod() : existingPayment.getMethod());
            existingPayment.setStatus(payment.getStatus() != null ? payment.getStatus() : existingPayment.getStatus());
            existingPayment.setPayContent(payment.getPayContent() != null ? payment.getPayContent() : existingPayment.getPayContent());
            existingPayment.setPayosOrderCode(payment.getPayosOrderCode() != null ? payment.getPayosOrderCode() : existingPayment.getPayosOrderCode());
            existingPayment.setPayosSignature(payment.getPayosSignature() != null ? payment.getPayosSignature() : existingPayment.getPayosSignature());
            existingPayment.setRawResponseJson(payment.getRawResponseJson() != null ? payment.getRawResponseJson() : existingPayment.getRawResponseJson());
            existingPayment.setCreatedAt(payment.getCreatedAt() != null ? payment.getCreatedAt() : existingPayment.getCreatedAt());
            existingPayment.setPaidAt(payment.getPaidAt() != null ? payment.getPaidAt() : existingPayment.getPaidAt());

            System.out.println("Updating existing payment: " + existingPayment.getPaymentId());
            return update(existingPayment);
        } else {
            // Insert new record
            System.out.println("Inserting new payment for transaction ID: " + payment.getPayosTransactionId());
            return createPayment(payment); // Gọi phương thức createPayment đã có
        }
    }


    // Implement abstract methods from DBContext (giữ nguyên hoặc cập nhật nếu cần)
    @Override
    public List<Payment> select() {
        return getAllPayments();
    }

    @Override
    public Payment select(int... id) {
        if (id.length < 1) return null;
        return null; // Cần implement logic nếu muốn dùng select(int...id) cho payment_id
    }

    @Override
    public int insert(Payment obj) {
        return createPayment(obj);
    }

    @Override
    public int delete(int... id) {
        // Implement delete logic if needed
        return 0; // Hoặc ném UnsupportedOperationException
    }
}