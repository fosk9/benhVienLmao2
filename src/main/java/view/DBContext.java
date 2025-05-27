package view;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBContext {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=benhvienlmao;encrypt=false";
    private static final String USER = "sa"; // Replace with your SQL Server username
    private static final String PASSWORD = "sa"; // Replace with your SQL Server password

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void main(String[] args) {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            // Test connection
            conn = getConnection();
            System.out.println("Connection to benhvienlmao database successful!");

            // Execute a simple query to verify database access
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT 1 AS test");
            if (rs.next()) {
                System.out.println("Query executed successfully. Result: " + rs.getInt("test"));
            }
        } catch (SQLException e) {
            System.err.println("Database connection failed!");
            System.err.println("SQL Error: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }
}