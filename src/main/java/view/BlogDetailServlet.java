package view;
import view.BlogDAO;
import view.Blog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/blog_details")
public class BlogDetailServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String blogIdStr = request.getParameter("bid");
        int blogId = Integer.parseInt(blogIdStr);

        BlogDAO dao = new BlogDAO();
        Blog blog = dao.getBlogById(blogId);

        request.setAttribute("blog", blog);
        request.getRequestDispatcher("blog_details.jsp").forward(request, response);
    }
}