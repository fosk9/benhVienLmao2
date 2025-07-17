package model;

import lombok.*;

import java.sql.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Comment {
    private int commentId;
    private int blogId;
    private int patientId;
    private String content;
    private Date date;

    // Optional: Patient name (nếu JOIN bảng Patient sau này)
    private String patientName;
}
