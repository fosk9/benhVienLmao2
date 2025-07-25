package listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import model.LogSystem;
import dal.LogSystemDAO;

import java.sql.Timestamp;

/**
 * Listener ghi log mỗi khi ứng dụng hoặc session thay đổi.
 */
@WebListener
public class AppListener implements ServletContextListener, HttpSessionListener {

    LogSystemDAO logSystemDAO = new LogSystemDAO();

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Application started.");

        LogSystem log = LogSystem.builder()
                .action("Application started")
                .logLevel("INFO") // Application start = INFO
                .createdAt(new Timestamp(System.currentTimeMillis()))
                .build();

        insertLog(log);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Application stopped.");

        LogSystem log = LogSystem.builder()
                .action("Application stopped")
                .logLevel("WARN") // Application stop = WARN
                .createdAt(new Timestamp(System.currentTimeMillis()))
                .build();

        insertLog(log);
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        String sessionId = se.getSession().getId();
        System.out.println("Session created: " + sessionId);

        LogSystem log = LogSystem.builder()
                .action("Session created: " + sessionId)
                .logLevel("DEBUG") // Session created = DEBUG
                .createdAt(new Timestamp(System.currentTimeMillis()))
                .build();

        insertLog(log);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        String sessionId = se.getSession().getId();
        System.out.println("Session destroyed: " + sessionId);

        LogSystem log = LogSystem.builder()
                .action("Session destroyed: " + sessionId)
                .logLevel("ERROR") // Session destroyed = ERROR
                .createdAt(new Timestamp(System.currentTimeMillis()))
                .build();

        insertLog(log);
    }

    /**
     * Insert log + print to console for tracking.
     */
    private void insertLog(LogSystem log) {
        logSystemDAO.insert(log);
        System.out.println("[LOG] [" + log.getLogLevel() + "] " + log.getAction());
    }
}
