package dal;

import model.Payment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO extends DBContext<Payment> {
    // Create a new payment
    public int createPayment(Payment payment) {
        String sql = "INSERT INTO Payments (appointment_id, amount, method, status, pay_content, created_at, paid_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, payment.getAppointmentId());
                ps.setDouble(2, payment.getAmount());
                ps.setString(3, payment.getMethod());
                ps.setString(4, payment.getStatus());
                ps.setString(5, payment.getPayContent());
                ps.setTimestamp(6, payment.getCreatedAt() == null ? new Timestamp(System.currentTimeMillis()) : Timestamp.valueOf(payment.getCreatedAt()));
                if (payment.getPaidAt() != null) {
                    ps.setTimestamp(7, Timestamp.valueOf(payment.getPaidAt()));
                } else {
                    ps.setNull(7, Types.TIMESTAMP);
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

    // Get payment by appointmentId
    public Payment getPaymentByAppointmentId(int appointmentId) {
        String sql = "SELECT * FROM Payments WHERE appointment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, appointmentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return mapResultSetToPayment(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return null;
    }

    // Update payment status
    public boolean updateStatus(int paymentId, String status) {
        String sql = "UPDATE Payments SET status = ? WHERE payment_id = ?";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, status);
                ps.setInt(2, paymentId);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return false;
    }

    // Cancel payment by appointmentId
    public boolean cancelPaymentByAppointmentId(int appointmentId) {
        String sql = "UPDATE Payments SET status = 'Cancel' WHERE appointment_id = ? AND status = 'Pending'";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, appointmentId);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return false;
    }

    // Get all payments (for admin)
    public List<Payment> getAllPayments() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM Payments ORDER BY created_at DESC";
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToPayment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    // Get payments by a list of appointmentIds
    public List<Payment> getPaymentsByAppointmentIds(List<Integer> appointmentIds) {
        if (appointmentIds == null || appointmentIds.isEmpty()) return new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Payments WHERE appointment_id IN (");
        for (int i = 0; i < appointmentIds.size(); i++) {
            sql.append("?");
            if (i < appointmentIds.size() - 1) sql.append(",");
        }
        sql.append(") ORDER BY created_at DESC");
        List<Payment> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = getConn();
            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                for (int i = 0; i < appointmentIds.size(); i++) {
                    ps.setInt(i + 1, appointmentIds.get(i));
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

    // Map ResultSet to Payment
    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        return Payment.builder()
                .paymentId(rs.getInt("payment_id"))
                .appointmentId(rs.getInt("appointment_id"))
                .amount(rs.getDouble("amount"))
                .method(rs.getString("method"))
                .status(rs.getString("status"))
                .payContent(rs.getString("pay_content"))
                .createdAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null)
                .paidAt(rs.getTimestamp("paid_at") != null ? rs.getTimestamp("paid_at").toLocalDateTime() : null)
                .build();
    }

    // Implement abstract methods from DBContext (not used)
    @Override
    public List<Payment> select() { return getAllPayments(); }
    @Override
    public Payment select(int... id) {
        if (id.length < 1) return null;
        return getPaymentByAppointmentId(id[0]);
    }
    @Override
    public int insert(Payment obj) { return createPayment(obj); }
    @Override
    public int update(Payment obj) { return 0; }
    @Override
    public int delete(int... id) { return 0; }
}
