package model;

import lombok.Data;

@Data
public class PageContent {
    private int contentId;
    private String pageName;
    private String contentKey;
    private String contentValue;
    private boolean isActive;
}