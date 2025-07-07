package test;

import model.AppointmentType;
import view.AppointmentTypeDAO;

import java.math.BigDecimal;
import java.util.List;

public class AppointmentTypeDAOTest {
    public static void main(String[] args) {
        AppointmentTypeDAO dao = new AppointmentTypeDAO();

        // Insert test
        AppointmentType type = AppointmentType.builder()
                .typeName("Test Type")
                .description("Test Description")
                .price(new BigDecimal("123.45"))
                .build();
        int insertResult = dao.insert(type);
        System.out.println("Insert result: " + insertResult);

        // Select all test
        List<AppointmentType> types = dao.select();
        System.out.println("All types:");
        for (AppointmentType t : types) {
            System.out.println(t);
        }

        // Select by id test (get last inserted)
        AppointmentType lastType = types.get(types.size() - 1);
        AppointmentType selected = dao.select(lastType.getAppointmentTypeId());
        System.out.println("Selected by id: " + selected);

        // Update test
        lastType.setDescription("Updated Description");
        int updateResult = dao.update(lastType);
        System.out.println("Update result: " + updateResult);

        // Delete test
        int deleteResult = dao.delete(lastType.getAppointmentTypeId());
        System.out.println("Delete result: " + deleteResult);
    }
}
