package model.object;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Result {
    private int resultId;
    private int testId;
    private String resultText;
    private String conclusion;
    private LocalDateTime createdAt;
}