package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AppointmentType {
    private int appointmentTypeId; // appointmenttype_id
    private String typeName;
    private String description;
    private BigDecimal price;
}
