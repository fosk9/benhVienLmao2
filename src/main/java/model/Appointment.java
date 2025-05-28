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
public class Appointment {
    private int appointmentId;
    private int patientId;
    private int doctorId;
    private String appointmentType;
    private Date appointmentDate; // chỉ ngày
    private String shift; // Sáng/Chiều/Tối
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
}
