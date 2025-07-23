package model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SystemItem {
    private int itemId;
    private String itemName;
    private String itemUrl;
    private Integer displayOrder;
    private String itemType;
}