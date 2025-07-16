package util;

import model.ChangeHistory;
import view.ChangeHistoryDAO;

import java.util.Date;

public class HistoryLogger {
    public static void log(int managerId, String managerName,
                           int targetId, String targetName,
                           String source, String action) {
        ChangeHistory history = ChangeHistory.builder()
                .managerId(managerId)
                .managerName(managerName)
                .targetUserId(targetId)
                .targetUserName(targetName)
                .targetSource(source)
                .action(action)
                .changeTime(new Date())
                .build();
        new ChangeHistoryDAO().insert(history);
        System.out.println("[LOG] " + managerName + " -> " + action + " -> " + targetName);
    }
}
