package model;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {
    private int userID;
    private String fullName;
    private String email;
    private String phone;
    private String roleName;
    private String source; // employee / patient
    private int accStatus;
    private Date createdAt;
}
