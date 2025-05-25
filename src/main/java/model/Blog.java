package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Blog {
    private int blogId;
    private String blogName;
    private String content;
    private String image;
    private String author;
    private LocalDate date;
    private byte typeId;
    private byte selectedBanner;
}