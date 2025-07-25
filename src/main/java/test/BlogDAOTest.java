package test;

import model.Blog;
import model.Comment;
import dal.BlogDAO;
import dal.CommentDAO;

import java.sql.Date;
import java.util.List;

public class BlogDAOTest {

    public static void main(String[] args) {
        BlogDAO blogDAO = new BlogDAO();
        CommentDAO commentDAO = new CommentDAO();

        // Kiểm tra phương thức delete
        testDelete(blogDAO, commentDAO);
    }

    private static void testDelete(BlogDAO blogDAO, CommentDAO commentDAO) {
        System.out.println("== Test delete() ==");

        // Bước 1: Chèn một bài blog mới vào cơ sở dữ liệu để thử xóa
        Blog blog = new Blog();
        blog.setBlogName("Test Blog for Deletion");
        blog.setBlogSubContent("This blog is for testing delete.");
        blog.setContent("Content for delete test");
        blog.setBlogImg("test.jpg");
        blog.setAuthor("Tester");
        blog.setDate(new Date(System.currentTimeMillis()));
        blog.setCategoryId(1);

        // Chèn bài viết mới
        int insertResult = blogDAO.insert(blog);
        System.out.println("Insert result: " + insertResult);

        // Lấy blog vừa insert (giả sử blog_id tự tăng lớn nhất)
        List<Blog> blogs = blogDAO.searchBlogsByName("Test Blog for Deletion", 0, 1);
        if (!blogs.isEmpty()) {
            Blog insertedBlog = blogs.get(0);
            int blogIdToDelete = insertedBlog.getBlogId();

            // Bước 2: Chèn comment liên quan đến blog này
            Comment comment = new Comment();
            comment.setBlogId(blogIdToDelete);
            comment.setPatientId(1); // Giả sử patient_id là 1
            comment.setContent("Test Comment for Deletion");
            comment.setDate(new Date(System.currentTimeMillis()));
            int commentResult = commentDAO.insert(comment);
            System.out.println("Insert comment result: " + commentResult);

            // Bước 3: Kiểm tra trước khi xóa
            System.out.println("Before Delete:");
            List<Comment> commentsBeforeDelete = commentDAO.selectCommentsByBlogId(blogIdToDelete);
            System.out.println("Comments before delete: " + commentsBeforeDelete.size());

            // Bước 4: Thực hiện xóa
            int deleteResult = blogDAO.delete(blogIdToDelete);
            System.out.println("Delete result: " + deleteResult);

            // Bước 5: Kiểm tra sau khi xóa
            System.out.println("After Delete:");
            Blog blogAfterDelete = blogDAO.select(blogIdToDelete);
            if (blogAfterDelete == null) {
                System.out.println("Blog đã bị xóa thành công.");
            } else {
                System.out.println("Blog chưa bị xóa.");
            }

            List<Comment> commentsAfterDelete = commentDAO.selectCommentsByBlogId(blogIdToDelete);
            System.out.println("Comments after delete: " + commentsAfterDelete.size());
        } else {
            System.out.println("Không tìm thấy blog cần xóa.");
        }

        System.out.println("-----------------------------");
    }
}
