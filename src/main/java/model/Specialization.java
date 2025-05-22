package model;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Specialization {
    private int specializationId;
    private String name;
}
