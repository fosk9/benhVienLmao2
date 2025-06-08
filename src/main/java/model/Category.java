package model;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Category {
    private int categoryId;
    private String categoryName;
    private String description;
    private int blogCount;  // Thêm thuộc tính để lưu trữ số lượng bài viết trong danh mục

    // Setter để cập nhật số lượng bài viết trong danh mục
    public void setBlogCount(int blogCount) {
        this.blogCount = blogCount;
    }
}
