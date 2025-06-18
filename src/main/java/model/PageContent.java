package model;

import lombok.Data;

@Data
public class PageContent {
    private int contentId;         // Unique identifier for content
    private String pageName;       // Name of the page (e.g., 'index')
    private String contentKey;     // Key for content (e.g., 'slider1_caption')
    private String contentValue;   // Actual content value
    private boolean isActive;      // Status of content (active/inactive)
    private String imageUrl;       // URL for slider background image
    private String videoUrl;       // URL for video link
    private String buttonUrl;      // URL for button link
    private String buttonText;     // Text for button
}