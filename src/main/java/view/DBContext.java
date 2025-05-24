package view;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;

public abstract class DBContext<E> {

    private final String url;
    private final String user;
    private final String pass;

    public DBContext() {
        this("jdbc:sqlserver://localhost:1433;databaseName=benhvienlmao;encrypt=false",
                "sa", "123");
    }

    public DBContext(String url, String user, String pass) {
        this.url = url;
        this.user = user;
        this.pass = pass;
    }

    /**
     * Opens and returns a new connection to the database.
     */
    public Connection getConn() throws SQLException {
        try {
            // Load the driver (optional since JDBC 4.0, but kept here for clarity)
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException ex) {
            ex.printStackTrace();
        }
        // Open a new connection every time getConn() is called
        return DriverManager.getConnection(url, user, pass);
    }

    /**
     * Closes the provided connection to the database.
     */
    public void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("Connection closed.");
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    // Abstract methods for CRUD operations
    public abstract List<E> select();

    public abstract E select(int... id);

    public abstract int insert(E obj);

    public abstract int update(E obj);

    public abstract int delete(int... id);

    // Check connectione
    public static void main(String[] args) {
        try {
            DBContext<?> db = new DBContext<Object>() {
                @Override
                public List<Object> select() { return null; }

                @Override
                public Object select(int... id) { return null; }

                @Override
                public int insert(Object obj) { return 0; }

                @Override
                public int update(Object obj) { return 0; }

                @Override
                public int delete(int... id) { return 0; }
            };

            Connection conn = db.getConn();
            if (conn != null && !conn.isClosed()) {
                System.out.println("KẾT NỐI DATABASE THÀNH CÔNG!");
                db.closeConnection(conn);
            } else {
                System.out.println("KHÔNG KẾT NỐI ĐƯỢC DATABASE!");
            }
        } catch (Exception e) {
            System.out.println("LỖI KẾT NỐI: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

