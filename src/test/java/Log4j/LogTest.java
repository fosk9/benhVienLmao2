package Log4j;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.ThreadContext;

import java.sql.Connection;
import java.sql.DriverManager;

public class LogTest {
    private static final Logger logger = LogManager.getLogger(LogTest.class);

    public static void main(String[] args) {
        try (Connection conn = DriverManager.getConnection(
                "jdbc:sqlserver://localhost:1433;databaseName=benhvienlmao;encrypt=false", "sa", "123")) {
            System.out.println("Connection successful: " + conn);
        } catch (Exception e) {
            e.printStackTrace();
        }
        ThreadContext.put("employee_id", "5");
        ThreadContext.put("patient_id", null);
        logger.info("Test log entry");
        ThreadContext.clearMap();
    }
}
