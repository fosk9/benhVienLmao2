package model;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AdminProfile {
    private int adminId;
    private String fullName;
    private String email;
    private String phone;
    private String note;

    private User user;
}
