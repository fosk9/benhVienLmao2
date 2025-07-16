package test;

import model.ChangeHistory;
import view.ChangeHistoryDAO;

import java.util.Date;
import java.util.List;

public class TestChangeHistoryDAO {
    public static void main(String[] args) {
        ChangeHistoryDAO dao = new ChangeHistoryDAO();

        // 🟢 1. Insert sample record
        ChangeHistory history = ChangeHistory.builder()
                .managerId(101)
                .managerName("Nguyen Van A")
                .targetUserId(202)
                .targetUserName("Le Thi B")
                .targetSource("Employee")
                .action("Update Role")
                .changeTime(new Date()) // current time
                .build();

        int inserted = dao.insert(history);
        System.out.println("Inserted: " + inserted);

        // 🟢 2. Select all
        List<ChangeHistory> allLogs = dao.select();
        System.out.println("Total Records: " + allLogs.size());
        for (ChangeHistory ch : allLogs) {
            System.out.printf("ID: %d | Manager: %s | Target: %s | Action: %s | Time: %s\n",
                    ch.getChangeId(), ch.getManagerName(), ch.getTargetUserName(), ch.getAction(), ch.getChangeTime());
        }

        // 🟢 3. Select by ID
        if (!allLogs.isEmpty()) {
            int id = allLogs.get(0).getChangeId();
            ChangeHistory one = dao.select(id);
            System.out.println("\nSelected by ID: " + id);
            System.out.println(one);
        }

        // 🟢 4. Count All
        System.out.println("\nTotal Changes: " + dao.countAll());

        // 🟢 5. Count Today
        System.out.println("Today's Changes: " + dao.countToday());

        // 🟢 6. Count Last 24h
        System.out.println("Changes in last 24h: " + dao.countLast24h());

        // 🟢 7. Count Filtered
        int countFiltered = dao.countFiltered("Nguyen", "employee", "Update Role", null, null);
        System.out.println("Filtered Count (Nguyen, employee, Update Role): " + countFiltered);

        // 🟢 8. Select Filtered
        List<ChangeHistory> filtered = dao.selectFiltered(0, 10, "Nguyen", "employee", "Update Role", null, null);
        System.out.println("Filtered Records:");
        for (ChangeHistory f : filtered) {
            System.out.println(f);
        }

        // 🟢 9. Delete last inserted
        if (!allLogs.isEmpty()) {
            int delId = allLogs.get(0).getChangeId();
            int deleted = dao.delete(delId);
            System.out.println("Deleted record ID " + delId + ": " + (deleted > 0 ? "Success" : "Fail"));
        }
    }
}
