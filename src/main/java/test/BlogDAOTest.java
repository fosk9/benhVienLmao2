package test;

import model.Blog;
import model.Category;
import view.BlogDAO;

import java.sql.Date;
import java.util.List;

public class BlogDAOTest {

    public static void main(String[] args) {
        BlogDAO blogDAO = new BlogDAO();

        testSelectAll(blogDAO);
        testSearchBlogsByName(blogDAO);
        testInsertUpdateDelete(blogDAO);
        testGetPaginatedBlogs(blogDAO);
        testGetBlogsByCategory(blogDAO);
        testGetTotalBlogsCount(blogDAO);
        testGetTotalBlogsCountByCategory(blogDAO);
        testGetCategoriesWithBlogCount(blogDAO);
        testGetRecentBlogs(blogDAO);
        testSelectById(blogDAO);
    }

    private static void testSelectAll(BlogDAO blogDAO) {
        System.out.println("== Test select() ==");
        List<Blog> blogs = blogDAO.select();
        for (Blog blog : blogs) {
            System.out.println(blog);
        }
        System.out.println("Tổng số blog: " + blogs.size());
        System.out.println("-----------------------------");
    }

    private static void testSearchBlogsByName(BlogDAO blogDAO) {
        System.out.println("== Test searchBlogsByName() ==");
        String searchKeyword = "C";
        List<Blog> results = blogDAO.searchBlogsByName(searchKeyword, 0, 5);
        for (Blog blog : results) {
            System.out.println(blog);
        }
        System.out.println("Tổng số blog tìm được: " + results.size());
        System.out.println("-----------------------------");
    }

    private static void testInsertUpdateDelete(BlogDAO blogDAO) {
        System.out.println("== Test insert(), update(), delete() ==");
        Blog blog = new Blog();
        blog.setBlogName("Test Blog");
        blog.setBlogSubContent("Test Sub Content");
        blog.setContent("Test Content");
        blog.setBlogImg("test.jpg");
        blog.setAuthor("Tester");
        blog.setDate(new Date(System.currentTimeMillis()));
        blog.setCategoryId(1);

        int insertResult = blogDAO.insert(blog);
        System.out.println("Insert result: " + insertResult);

        // Lấy blog vừa insert (giả sử blog_id tự tăng lớn nhất)
        List<Blog> blogs = blogDAO.searchBlogsByName("Test Blog", 0, 1);
        if (!blogs.isEmpty()) {
            Blog insertedBlog = blogs.get(0);
            insertedBlog.setBlogName("Test Blog Updated");
            int updateResult = blogDAO.update(insertedBlog);
            System.out.println("Update result: " + updateResult);

            int deleteResult = blogDAO.delete(insertedBlog.getBlogId());
            System.out.println("Delete result: " + deleteResult);
        }
        System.out.println("-----------------------------");
    }

    private static void testGetPaginatedBlogs(BlogDAO blogDAO) {
        System.out.println("== Test getPaginatedBlogs() ==");
        List<Blog> blogs = blogDAO.getPaginatedBlogs(0, 3);
        for (Blog blog : blogs) {
            System.out.println(blog);
        }
        System.out.println("-----------------------------");
    }

    private static void testGetBlogsByCategory(BlogDAO blogDAO) {
        System.out.println("== Test getBlogsByCategory() ==");
        List<Blog> blogs = blogDAO.getBlogsByCategory(1, 0, 3);
        for (Blog blog : blogs) {
            System.out.println(blog);
        }
        System.out.println("-----------------------------");
    }

    private static void testGetTotalBlogsCount(BlogDAO blogDAO) {
        System.out.println("== Test getTotalBlogsCount() ==");
        int total = blogDAO.getTotalBlogsCount();
        System.out.println("Tổng số blog: " + total);

        System.out.println("== Test getTotalBlogsCount(String) ==");
        int totalByKeyword = blogDAO.getTotalBlogsCount("C");
        System.out.println("Tổng số blog theo từ khóa 'C': " + totalByKeyword);
        System.out.println("-----------------------------");
    }

    private static void testGetTotalBlogsCountByCategory(BlogDAO blogDAO) {
        System.out.println("== Test getTotalBlogsCountByCategory() ==");
        int total = blogDAO.getTotalBlogsCountByCategory(1);
        System.out.println("Tổng số blog của categoryId=1: " + total);
        System.out.println("-----------------------------");
    }

    private static void testGetCategoriesWithBlogCount(BlogDAO blogDAO) {
        System.out.println("== Test getCategoriesWithBlogCount() ==");
        List<Category> categories = blogDAO.getCategoriesWithBlogCount();
        for (Category c : categories) {
            System.out.println("Category: " + c.getCategoryName() + ", Count: " + c.getBlogCount());
        }
        System.out.println("-----------------------------");
    }

    private static void testGetRecentBlogs(BlogDAO blogDAO) {
        System.out.println("== Test getRecentBlogs() ==");
        List<Blog> blogs = blogDAO.getRecentBlogs();
        for (Blog blog : blogs) {
            System.out.println(blog);
        }
        System.out.println("-----------------------------");
    }

    private static void testSelectById(BlogDAO blogDAO) {
        System.out.println("== Test select(int... id) ==");
        Blog blog = blogDAO.select(1);
        if (blog != null) {
            System.out.println(blog);
        } else {
            System.out.println("Không tìm thấy blog với id=1");
        }
        System.out.println("-----------------------------");
    }
}
