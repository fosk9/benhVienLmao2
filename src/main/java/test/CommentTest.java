package test;

import model.Comment;
import dal.CommentDAO;
import java.util.List;

public class CommentTest {

    public static void main(String[] args) {
        CommentDAO dao = new CommentDAO();

        // Test case 1: Kiểm tra với blogId hợp lệ, phân trang với offset và pageSize
        int blogIdToTest = 3;  // Đổi ID blog nếu cần
        int offset = 0;        // Offset cho phân trang (Ví dụ: trang 1 sẽ có offset = 0)
        int pageSize = 5;      // Số bình luận mỗi trang

        // Gọi phương thức lấy bình luận
        List<Comment> comments = dao.getCommentsByBlogId(blogIdToTest, offset, pageSize);

        // Kiểm tra số lượng bình luận và in thông tin
        System.out.println("Test Case 1: Tổng số comment trên trang: " + comments.size());
        for (Comment c : comments) {
            System.out.println("--------------");
            System.out.println("ID: " + c.getCommentId());
            System.out.println("Blog ID: " + c.getBlogId());
            System.out.println("Patient ID: " + c.getPatientId());
            System.out.println("Patient Name: " + c.getPatientName());
            System.out.println("Content: " + c.getContent());
            System.out.println("Date: " + c.getDate());
        }

        // Test case 2: Kiểm tra với blogId không tồn tại (Không có bình luận)
        int invalidBlogId = 9999;  // Blog ID không tồn tại trong cơ sở dữ liệu
        List<Comment> noComments = dao.getCommentsByBlogId(invalidBlogId, offset, pageSize);
        System.out.println("Test Case 2: Tổng số comment khi không có bình luận: " + noComments.size());

        // Kiểm tra không có bình luận nào được trả về
        if (noComments.isEmpty()) {
            System.out.println("Không có bình luận cho blog ID: " + invalidBlogId);
        }
    }
}
