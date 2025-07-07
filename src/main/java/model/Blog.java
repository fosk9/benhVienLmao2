package model;

import lombok.*;
import java.sql.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Blog {
    private int blogId;
    private String blogName;
    private String blogSubContent;
    private String content;
    private String blogImg;
    private String author;
    private Date date;
    private int categoryId;
    private String categoryName; // Join từ bảng Category
    private int commentCount; // thêm thuộc tính này
}
