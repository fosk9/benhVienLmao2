package model.object;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    private int userId;
    private String username;
    private String email;
    private String passwordHash;
    private String loginAs; // 'Employee' / 'Patient'

}
