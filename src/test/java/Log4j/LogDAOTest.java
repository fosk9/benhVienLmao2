package Log4j;

import model.Log;
import view.LogDAO;

public class LogDAOTest {
    public static void main(String[] args) {
        try {
            LogDAO logDAO = new LogDAO();
            Log log = new Log();
            log.setEmployeeId(5);
            log.setPatientId(null);
            log.setAction("Test log entry");
            log.setLogLevel("INFO");
            log.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));
            int rows = logDAO.insert(log);
            System.out.println("Rows inserted: " + rows);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}