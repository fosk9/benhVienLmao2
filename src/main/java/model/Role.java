package model;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Role {
    private int roleId;
    private String roleName;
}