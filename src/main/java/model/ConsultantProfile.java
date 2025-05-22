package model;

import lombok.*;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ConsultantProfile {
    private int consultantId;
    private String fullName;
    private LocalDate dob;
    private String gender;
    private String email;
    private String phone;
    private String expertiseArea;
    private String degree;

    private User user;
}
