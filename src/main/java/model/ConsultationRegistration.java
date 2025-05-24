package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConsultationRegistration {
    private int registrationId;
    private String fullName;
    private String phone;
    private LocalDate dob;
    private String consultationNeeds;
    private LocalDateTime createdAt;
}