package model;

import lombok.Data;
import java.util.List;

@Data
public class SystemItem {
    private int itemId;
    private String itemName;
    private String itemUrl;
    private String imageUrl;
    private boolean isActive;
    private Integer displayOrder;
    private Integer parentItemId;
    private String itemType;
    private List<SystemItem> subItems;
}
