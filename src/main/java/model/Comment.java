package model;

import lombok.*;

import java.sql.Timestamp;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Comment {
    private int commentId;
    private String content;
    private Timestamp createdAt;
    private int blogId;
    private int patientId;
}
