package test;

import model.Category;
import view.BlogDAO;

import java.util.List;

public class BlogDAOTest {

    public static void main(String[] args) {
        // Tạo đối tượng BlogDAO để gọi phương thức getCategoriesWithBlogCount
        BlogDAO blogDAO = new BlogDAO();

        // Test phương thức getCategoriesWithBlogCount
        System.out.println("== Danh sách các danh mục == ");
        List<Category> categories = blogDAO.getCategoriesWithBlogCount();

        if (categories.isEmpty()) {
            System.out.println("Không có danh mục nào.");
        } else {
            for (Category category : categories) {
                System.out.println("ID: " + category.getCategoryId());
                System.out.println("Tên danh mục: " + category.getCategoryName());
                System.out.println("Số lượng bài viết: " + category.getBlogCount());
                System.out.println("-----------------------------");
            }
        }
    }
}
