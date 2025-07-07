package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.sql.Date;
import java.sql.Timestamp;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConsultationRegistration {
    private int registrationId;
    private String fullName;
    private String phone;
    private Date dob;
    private String consultationNeeds;
    private Timestamp createdAt;

}

