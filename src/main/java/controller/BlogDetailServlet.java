package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Blog;
import model.Comment;
import model.Category;
import view.BlogDAO;
import view.CommentDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/blog-detail")
public class BlogDetailServlet extends HttpServlet {

    private final BlogDAO blogDAO = new BlogDAO();
    private final CommentDAO commentDAO = new CommentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy tham số id từ request
        String idParam = request.getParameter("id");

        // Kiểm tra tham số id hợp lệ (phải là số dương)
        if (idParam == null || !idParam.matches("\\d+")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid blog ID");
            return;
        }

        int blogId = Integer.parseInt(idParam);

        // Lấy blog theo id
        Blog blog = blogDAO.select(blogId);

        // Kiểm tra nếu blog không tồn tại
        if (blog == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Blog not found");
            return;
        }

        // Lấy danh sách bình luận của bài viết
        List<Comment> comments = commentDAO.selectByBlogId(blogId);

        // Lấy danh mục và bài viết gần nhất để hiển thị trong blog-sidebar
        List<Category> categories = blogDAO.getCategoriesWithBlogCount();
        List<Blog> recentBlogs = blogDAO.getRecentBlogs();

        // Đưa các dữ liệu vào request để truyền đến JSP
        request.setAttribute("blog", blog);
        request.setAttribute("comments", comments);
        request.setAttribute("categories", categories);
        request.setAttribute("recentBlogs", recentBlogs);

        // Chuyển tiếp đến trang blog-detail.jsp
        request.getRequestDispatcher("/blog-detail.jsp").forward(request, response);
    }
}
