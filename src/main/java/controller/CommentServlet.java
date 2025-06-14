//package controller;
//
//import view.CommentDAO;
//import model.Comment;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//import java.time.LocalDate;
//import java.sql.Timestamp;
//
//@WebServlet(name = "CommentServlet", urlPatterns = {"/add-comment"})
//public class CommentServlet extends HttpServlet {
//    private CommentDAO commentDAO;
//
//    @Override
//    public void init() throws ServletException {
//        commentDAO = new CommentDAO();
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String content = request.getParameter("content");
//        int blogId = Integer.parseInt(request.getParameter("blogId"));
//        int patientId = Integer.parseInt(request.getParameter("patientId")); // giả định đã có session login
//
//        Comment comment = new Comment();
//        comment.setContent(content);
//        comment.setBlogId(blogId);
//        comment.setPatientId(patientId);
//        comment.setCreatedAt(new Timestamp(System.currentTimeMillis()));
//
//        commentDAO.insert(comment);
//        response.sendRedirect("blog-detail?id=" + blogId);
//    }
//}
