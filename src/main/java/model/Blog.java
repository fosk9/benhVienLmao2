package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

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
    private Timestamp createdAt;
    private int typeId;
    private boolean selectedBanner;

    public int getId() {
        return this.blogId;
    }

    public String getSummary() {
        if (content == null) return "";
        return content.length() <= 150 ? content : content.substring(0, 150) + "...";
    }
}
