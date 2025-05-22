package model;

import lombok.*;

import java.sql.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConsultantProfile {
    private int consultantId;
    private String fullName;
    private Date dob;
    private String gender;
    private String email;
    private String phone;
    private String expertiseArea;
    private String degree;
}
