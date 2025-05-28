package model;

import lombok.*;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Comment {
    private int commentId;
    private String content;
    private LocalDate date;
    private int blogId;
    private int patientId;
}
