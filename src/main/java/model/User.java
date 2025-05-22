package model;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    private int userId;
    private String username;
    private String passwordHash;
    private int roleId;

    // Optional: reference to Role object
    private Role role;
}
