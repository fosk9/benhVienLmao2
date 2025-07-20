package test;

import model.Employee;
import view.EmployeeDAO;

import java.sql.Date;

public class EmployeeDAOTest {

    public static void main(String[] args) {
        EmployeeDAO employeeDAO = new EmployeeDAO();

        // Tạo đối tượng Employee mẫu
        Employee employee = Employee.builder()
                .fullName("Test User")
                .email("testuser@example.com")
                .phone("0909123456")
                .dob(Date.valueOf("1995-01-01"))
                .gender("M")
                .username("testuser123")
                .passwordHash("testpassword") // Lưu ý: chưa mã hóa
                .roleId(2) // Ví dụ: 2 là Assistant
                .accStatus(1)
                .employeeAvaUrl("assets/img/blog/test-avatar.png")
                .build();

        int insertedId = employeeDAO.insertReturnId(employee);

        if (insertedId > 0) {
            System.out.println("✅ INSERT thành công với ID: " + insertedId);
        } else {
            System.err.println("❌ INSERT thất bại, ID trả về = " + insertedId);
        }
    }
}
