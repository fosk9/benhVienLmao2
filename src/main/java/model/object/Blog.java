package model.object;

import java.time.LocalDate;

public class Blog {
    private int blogId;
    private String blogName;
    private String content;
    private String image;
    private String author;
    private LocalDate date;
    private int typeId;
    private boolean selectedBanner;

    public Blog() {
    }

    public Blog(int blogId, String blogName, String content, String image,
                String author, LocalDate date, int typeId, boolean selectedBanner) {
        this.blogId = blogId;
        this.blogName = blogName;
        this.content = content;
        this.image = image;
        this.author = author;
        this.date = date;
        this.typeId = typeId;
        this.selectedBanner = selectedBanner;
    }

    public int getBlogId() {
        return blogId;
    }

    public void setBlogId(int blogId) {
        this.blogId = blogId;
    }

    public String getBlogName() {
        return blogName;
    }

    public void setBlogName(String blogName) {
        this.blogName = blogName;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public boolean isSelectedBanner() {
        return selectedBanner;
    }

    public void setSelectedBanner(boolean selectedBanner) {
        this.selectedBanner = selectedBanner;
    }

    public int getId() {
        return this.blogId;
    }

    public String getSummary() {
        if (content == null) return "";
        return content.length() <= 150 ? content : content.substring(0, 150) + "...";
    }
}