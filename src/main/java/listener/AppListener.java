package listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import model.LogSystem;
import view.LogSystemDAO;

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
        LogSystem logSystem = LogSystem.builder()
                .action("Application started")
                .logLevel("INFO")
                .createdAt(new Timestamp(System.currentTimeMillis()))
                .build();
        logSystemDAO.insert(logSystem);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Application stop.");
        LogSystem logSystem = LogSystem.builder()
                .action("Application stopped")
                .logLevel("INFO")
                .createdAt(new Timestamp(System.currentTimeMillis()))
                .build();
        logSystemDAO.insert(logSystem);
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        System.out.println("Session created: " + se.getSession().getId());
        LogSystem logSystem = LogSystem.builder()
                .action("Session created: " + se.getSession().getId())
                .logLevel("INFO")
                .createdAt(new Timestamp(System.currentTimeMillis()))
                .build();
        logSystemDAO.insert(logSystem);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        System.out.println("Session destroyed: " + se.getSession().getId());
        LogSystem logSystem = LogSystem.builder()
                .action("Session destroyed: " + se.getSession().getId())
                .logLevel("INFO")
                .createdAt(new Timestamp(System.currentTimeMillis()))
                .build();
        logSystemDAO.insert(logSystem);
    }
}
