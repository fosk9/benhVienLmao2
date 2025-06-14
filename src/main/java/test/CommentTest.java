package test;

import model.Comment;
import view.CommentDAO;

import java.util.List;

public class CommentTest {
    public static void main(String[] args) {
        CommentDAO dao = new CommentDAO();

        int blogIdToTest = 3; // 👈 Đổi ID blog nếu cần
        List<Comment> comments = dao.selectCommentsByBlogId(blogIdToTest);

        System.out.println("Tổng số comment: " + comments.size());
        for (Comment c : comments) {
            System.out.println("--------------");
            System.out.println("ID: " + c.getCommentId());
            System.out.println("Blog ID: " + c.getBlogId());
            System.out.println("Patient ID: " + c.getPatientId());
            System.out.println("Patient Name: " + c.getPatientName());
            System.out.println("Content: " + c.getContent());
            System.out.println("Date: " + c.getDate());
        }
    }
}

