package test;

import model.Employee;
import dal.EmployeeDAO;

import java.sql.Date;

public class EmployeeDAOTest {
    public static void main(String[] args) {
        EmployeeDAO dao = new EmployeeDAO();

        Employee emp = new Employee();
        emp.setEmployeeId(2); // ID phải tồn tại trong DB
        emp.setFullName("Dr. Nguyễn Văn A");
        emp.setEmail("doctorA@example.com");
        emp.setPhone("0912345678");
        emp.setGender("M");
        emp.setDob(Date.valueOf("1990-01-01"));
        emp.setRoleId(1); // Doctor
        emp.setAccStatus(1);
        emp.setEmployeeAvaUrl("assets/img/avatars/test-avatar.jpg"); // Đường dẫn giả lập

        boolean result = dao.updateEmployee(emp);

        if (result) {
            System.out.println("✅ Update thành công!");
        } else {
            System.out.println("❌ Update thất bại!");
        }
    }
}
