package model.DAO;

import model.object.Invoice;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {
    // Find invoice by ID
    public Invoice findById(int invoiceId) throws SQLException {
        String sql = "SELECT * FROM Invoices WHERE invoice_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, invoiceId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Invoice(
                            rs.getInt("invoice_id"),
                            rs.getInt("diagnosis_id"),
                            rs.getDouble("amount"),
                            rs.getString("status"),
                            rs.getObject("payment_date", LocalDateTime.class)
                    );
                }
            }
        }
        return null;
    }

    // Find all invoices
    public List<Invoice> findAll() throws SQLException {
        List<Invoice> invoices = new ArrayList<>();
        String sql = "SELECT * FROM Invoices";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                invoices.add(new Invoice(
                        rs.getInt("invoice_id"),
                        rs.getInt("diagnosis_id"),
                        rs.getDouble("amount"),
                        rs.getString("status"),
                        rs.getObject("payment_date", LocalDateTime.class)
                ));
            }
        }
        return invoices;
    }

    // Save new invoice
    public void save(Invoice invoice) throws SQLException {
        String sql = "INSERT INTO Invoices (diagnosis_id, amount, status, payment_date) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, invoice.getDiagnosisId());
            stmt.setDouble(2, invoice.getAmount());
            stmt.setString(3, invoice.getStatus());
            stmt.setObject(4, invoice.getPaymentDate());
            stmt.executeUpdate();
        }
    }

    // Update existing invoice
    public void update(Invoice invoice) throws SQLException {
        String sql = "UPDATE Invoices SET diagnosis_id = ?, amount = ?, status = ?, payment_date = ? WHERE invoice_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, invoice.getDiagnosisId());
            stmt.setDouble(2, invoice.getAmount());
            stmt.setString(3, invoice.getStatus());
            stmt.setObject(4, invoice.getPaymentDate());
            stmt.setInt(5, invoice.getInvoiceId());
            stmt.executeUpdate();
        }
    }

    // Delete invoice
    public void delete(int invoiceId) throws SQLException {
        String sql = "DELETE FROM Invoices WHERE invoice_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, invoiceId);
            stmt.executeUpdate();
        }
    }
}