package test;

import model.EmployeeWithStatus;
import view.EmployeeDAO;

import java.util.List;

public class EmployeeDAOTest {
    public static void main(String[] args) {
        EmployeeDAO dao = new EmployeeDAO();

        // Test không filter
        System.out.println("=== TEST: Không filter ===");
        List<EmployeeWithStatus> all = dao.getEmployeesWithStatus(null, null, 0, 20);
        for (EmployeeWithStatus e : all) {
            System.out.println("👤 " + e.getEmployee().getFullName() +
                    " | Status: " + e.getStatusToday() +
                    " | Role: " + e.getEmployee().getRoleId());
        }

        // Test filter theo keyword
        System.out.println("\n=== TEST: Filter keyword = 'Nguyen' ===");
        List<EmployeeWithStatus> keyword = dao.getEmployeesWithStatus("Dr", null, 0, 5);
        for (EmployeeWithStatus e : keyword) {
            System.out.println("👤 " + e.getEmployee().getFullName() +
                    " | Status: " + e.getStatusToday());
        }

        // Test filter theo status
        System.out.println("\n=== TEST: Filter status = 'Working' ===");
        List<EmployeeWithStatus> working = dao.getEmployeesWithStatus(null, "Working", 0, 5);
        for (EmployeeWithStatus e : working) {
            System.out.println("✅ " + e.getEmployee().getFullName() + " đang làm việc.");
        }

        // Test kết hợp filter
        System.out.println("\n=== TEST: keyword = 'Le', status = 'OnLeave' ===");
        List<EmployeeWithStatus> combined = dao.getEmployeesWithStatus("Dr", "OnLeave", 0, 5);
        for (EmployeeWithStatus e : combined) {
            System.out.println("🟡 " + e.getEmployee().getFullName() + " đang nghỉ phép.");
        }

        // Test không có kết quả
        System.out.println("\n=== TEST: keyword = 'Không tồn tại' ===");
        List<EmployeeWithStatus> none = dao.getEmployeesWithStatus("Không tồn tại", null, 0, 5);
        if (none.isEmpty()) {
            System.out.println("⚠️ Không có nhân viên nào được tìm thấy.");
        } else {
            System.out.println("❌ Test sai: vẫn có kết quả.");
        }
    }
}
