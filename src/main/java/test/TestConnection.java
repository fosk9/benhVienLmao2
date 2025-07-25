package test;

import dal.DBContext;

import java.sql.Connection;
import java.sql.SQLException;

public class TestConnection {
    public static void main(String[] args) {
        // Tạo DBContext ẩn danh để test kết nối (vì DBContext là abstract)
        DBContext<Object> dbContext = new DBContext<Object>() {
            @Override
            public java.util.List<Object> select() {
                return null;
            }

            @Override
            public Object select(int... id) {
                return null;
            }

            @Override
            public int insert(Object obj) {
                return 0;
            }

            @Override
            public int update(Object obj) {
                return 0;
            }

            @Override
            public int delete(int... id) {
                return 0;
            }
        };

        try (Connection conn = dbContext.getConn()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ Database connection successful!");
            } else {
                System.out.println("❌ Failed to establish connection.");
            }
        } catch (SQLException e) {
            System.out.println("❌ SQL Exception occurred:");
            e.printStackTrace();
        }
    }
}
