package websocket;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

// WebSocket endpoint for real-time log updates
@ServerEndpoint("/ws/logs")
public class LogWebSocket {
    private static final Logger logger = LogManager.getLogger(LogWebSocket.class);
    private static final Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());

    // Called when a client connects
    @OnOpen
    public void onOpen(Session session) {
        sessions.add(session);
        logger.info("WebSocket client connected: {}", session.getId());
    }

    // Called when a client disconnects
    @OnClose
    public void onClose(Session session) {
        sessions.remove(session);
        logger.info("WebSocket client disconnected: {}", session.getId());
    }

    // Notify all connected clients of a new log
    public static void notifyNewLog() {
        synchronized (sessions) {
            for (Session session : sessions) {
                try {
                    if (session.isOpen()) {
                        session.getBasicRemote().sendText("new_log");
                        logger.debug("Notified client {} of new log", session.getId());
                    }
                } catch (IOException e) {
                    logger.error("Error notifying client {}", session.getId(), e);
                }
            }
        }
    }
}