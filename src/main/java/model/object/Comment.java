package model.object;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Comment {
    private int commentId;
    private String content;
    private LocalDate date;
    private int blogId;
    private int patientId;
}