package model;

import lombok.Data;

@Data
public class SystemItem {
    private int itemId;
    private String itemName;
    private String itemUrl;
    private Integer displayOrder;
    private String itemType;
}
